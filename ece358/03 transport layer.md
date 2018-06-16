# Transport layer

## Services

- Provide logical communication between app processes running on different hosts
- Transport protocols run on end systems
  - Send side: messages broken into segments, passed to network layer
  - Receive side: reassembles segments into messages, passes to the app layer
- More than one transport protocol available
- Network layer provides logical communication between *hosts*, transport layer adds logical communication between *processes*

IP protocols:
- Reliable, in-order delivery: TCP
  - Congestion control (network itself not overloaded)
  - Flow control (receiver not overloaded)
- Unreliable, unordered delivery: UDP
- Services not available: bandwidth/delay guarantees

Multiplexing
- Multiplexing at sender: handle data from multiple sockets, add transport header
- Demultiplexing at receiver: use header info to deliver received segments to correct socket
  - Host receives IP datagrams
  - each datagram has one segment, which has source and destination IP & socket number
  - UDP only differentiates segments based on port number
  - TCP differentiates segments based on IP and port

UDP checksum
- If the receiver calculates the checksum and it doesn't match the checksum in the header, there was an error
- Checksum: 1's complement: Add the two 16-bit integers. If there is a carry, add it to the first bit. Invert the bits for the checksum.

## Reliable Data Transfer

### Stop-and-wait
- Reliable Data Transfer (RDT) protocol
- Sender application calls `rdt_send()`, which make calls to `udt_send()`
  - `udt_send` is unreliable data transfer, used internally by RDT
- Recipient calls `rdt_rcv()` called when packed arrives on the receive side of the channel, which calls `deliver_data()` to hand it off to the application
- Uses checksum for error detection
- Adds ACKs when received correctly
- Adds NAKs when received with an error
- ACKs and NAKs can be corrupted, too. We add a **sequence number** to each packet.
  - If an ACK or NAK is corrupted, we treat it like it was a NAK
  - If the receiver actually had sent an ACK, it will see that it got sent the same packet again, and can ignore it and send an ACK
  - Sequence number can just be 0 or 1, alternating between them
  - ACK is actually ACK of the current sequence number, and NAK is just an ACK for the other sequence number
- Packet loss is possible: use a timer. If a response hasn't been received by the time the timer runs out, resend.
  - This is an example of an **Automatic Repeat Request** (ARQ) protocol

#### Performance
- Not good
- Utilization: $U_{sender} = \frac{L/R}{RTT + L/R}$
- $D_{trans} = \frac{L}{R}$
- $L/R$ is the time spend sending actual useful information, but then we also have to wait for a round trip to receive an ACK
- Do it better with **pipelined protocols**

### Go-back-$N$
- Sender can have up to $N$ packets in pipeline
- Receiver only sends cumulative ACK
- doesn't ACK a packet i there's a gap
- sender has timer for oldest un-acked packet
  - when timer expires, ALL are resent

### Selective Repeat
- Sender can have up to $N$ un-acked packets in the pipeline
- receiver sends individual ack for each packet
- sender maintains timer for each un-acked packet
  - When timer expires, retransmit only that un-acked packet

#### Performance (assuming no errors)

Say $T_x$ and $R_x$ have agreed on a window size $W$, and $L$ is the frame size. Then, if $t_T$ is the total elapsed time to send a data frame and receive a corresponding ack, then the sender will send:
- $W$ frames if $\frac{WL}{C} \le t_T$, or
- if $\frac{WL}{C} \gt t_T$, the "link" will be full and the number of sent frames will be $\frac{t_T}{t_I}$, where $t_I$ is the time to transmit one frame
  - $t_I = \frac{L}{C}$
  - Utilization = $\min\left(1, \frac{W \frac{L}{C}}{t_T}\right)$
- Best case performance happens when the first ack is received while still sending packets, so we are sending packets all the time.

Maximum window size:
$$W_{max} = \frac{t_I}{t_t} = \frac{\underbrace{\frac{L}{C} + RTT}_\text{period of time considered}}{\underbrace{\frac{L}{C}}_\text{transmission time of one segment}}$$

Throughput = utilization $*$ link rate

## TCP
- **connection-oriented**: sender and receiver have to handshake to initialize parameters, but not circuit switching because intermediate nodes don't keep state
- **point-to-point**: one sender, one receiver
- **reliable, in-order byte stream**: no message boundaries
- **full duplex data**: bi-directional data flow in same connection, MSS: maximum segment size
- **pipelined**: TCP congestion and flow control set window size
- **flow controlled**: sender will not overwhelm receiver

### Segment structure
<table>
<tr><th colspan=4>width: 32 bits</th></tr>
<tr><td colspan=3>Source port #</td><td>Dest port #</td></tr>
<tr><td colspan=4>Sequence number</td></tr>
<tr><td colspan=4>acknowledgement number</td></tr>
<tr><td>head len</td><td>not used</td><td>`U A P R S F`</td><td>receive window</td></tr>
<tr><td colspan=3>checksum</td><td>Urg data pointer</td></tr>
<tr><td colspan=4>options (variable length)</td></tr>
<tr><td colspan=4>application data (variable length)</td></tr>
</table>

- URG: urgent data (usually not used)
- Ack: declares the acked # as valid
- PSH: push data now (usually not used)
- RST, SYN, FIN: connection establish (Setup, teardown commands)
- sequence numbers: byte stream "number" of first byte in segment's data
- acknowledgements:
  - sequence number of next byte expected from other side
  - cumulative ACK
  - Can ack while sending other data

### Estimating round trip time
- What to set the timeout value to?
- Longer than RTT, but RTT varies
- If it's too short, premature timeout happens, and there can be unnecessary retransmissions
- if it's too long, it reacts slowly when packets are lost

Round trip time estimate
- `SampleRTT`: measured time from segment transmission until ACK receipt, ignoring retransmissions
- `EstimatedRTT` $= (1 - \alpha) *$ `EstimatedRTT` $+ \alpha *$ `SampleRTT`
  - Exponential weighted moving average (EWMA)
  - influence of past sample decreases exponentially fast. Recent sample better reflects current congestion in the network
  - Typical $\alpha$: 0.25
- Timeout interval: `EstimatedRTT` + safety margin
  - Large variation in estimation yields a larger safety margin
  - $DevRTT = (1-\beta)*DevRTT + \beta * |SampleRTT-EstimatedRTT|$
  - Typically, $\beta=0.25$
  - $TimeoutInterval = EstimatedRTT + 4*DevRTT$

### RDT
- Pipelined segments
- cumulative acks
- single retransmission timer
- retransmissions retriggered by timeout events, duplicate acks

#### Sender events
Initialization:
- `nextSeqNum = InitialSeqNum`
- `SendBase = InitialSeqNum`

1. Data received from app
  - Create segment with sequence number
  - sequence number is byte stream number of first data byte in segment
    - `NExtSeqNum = NextSeqNum + length(data)`
  - start timer if not already running (timer is for oldest unacked segment) with interval `TimeOutInterval`
2. Timeout
  - Retransmit segment that caused timeout
  - Restart timer
3. Ack received
  - If ack acknowledges previously unacked segments, update what is known to be acked, start timer if there are still unacked segments

Fast retransmission
- time out period is often long: delay before resending lost packet
- detect lost segments via duplicate ACKs
  - sender often sends many segments back to back
  - if a segment is lost, there will likely be many duplicate ACKs
- If sender receives 3 duplicate acks (the fourth ack for that same piece of data), resend unacked segment with smallest sequence number

### Flow control
- receiver "Advertises" free buffer space by including `rwnd` (receiver window) value in TCP header of receiver-to-sender segments
  - `RcvBuffer` size set via socket operations (Default 4096 bytes)
  - many OS autoadjust `RcvBuffer`
- sender limits amount of unacked data to receiver's `rwnd` value (16 bits, so max value is $2^{16}-1$)
- guarantees receive buffer will not overflow

### Connection management
Handshake:
- agree to establish connection
- agree on connection params

Simple 2-way handshake won't work:
- variable delays
- retransmitted messages due to loss
- message reordering
- can't "see" other side

Use a **3-way handshake** instead:
- Establish connection
  - client and server start in listening state
  - Client sends  a request to connect via TCP with `SYN = 1` (synchronized) set in the header, with a random initial sequence number
  - Server chooses another random sequence number, and then sends a TCP `SYNACK` (`SYN = 1`, `ACK = 1`), acknowledging the `SYN`
  - Client receives the SYNACK, knowing the server is live. Sends an ACK to acknowledge the SYNACK was received, plus maybe additional data.
  - Server receives the ack, so it knows the client is live
- close connection
  - Client sends `FIN = 1`, with sequence number $x$
  - Server replies with `ACK = 1`, `ACKNUM` = $x + 1$
  - Client waits for server to close
  - Server sends `FIN = 1`, random sequence number $y$
  - Client replies with `ACK = 1`, `ACKNUM` = $y + 1$
  - Client waits for $2*$ max segment lifetime as a safeguard

### Congestion Control
- Congestion is when there are too many sources sending data too fast for the **network** to handle
- Problems due to congestion:
  - Queueing delays as the packet arrival rate reaches the link cap (output link capacity is $R$, so maximum per-connection throughput is $\frac{R}{n}$ where there are $n$ "customers" on the link)
  - Packets can be lost when the router buffers are full and packets are dropped. Sender only resends if the packet is known to be lost.
  - Sender times out prematurely and sends two copies of a packet, both of which get delivered
  - more routers between source and destination means more wasted resources

**TCP protocol**
- Sender increases transmission rate (window size), probing for usable bandwidth, until loss occurs
  - **additive increase**: increase `cwnd` by 1 MSS (maximum segment size) for every acknowledged segment until loss detected
  - **multiplicative decrease**: decrease `cwnd` in half after loss
  - Sender limits transmission: `LastByteSend - LastByteAcked <= min(cwnd, rwnd)`
  - `rwnd` is usually very large at the receiver
- Slow Start
  - When connection begins, increase rate exponentially until first loss event
    - Initially `cwnd` is 1 MSS
    - double `cwnd` every RTT
    - Done by incrementing `cwnd` for every ACK received
  - Initial rate is slow but ramps up exponentially fast
- Dealing with packet loss
  - Loss indicated by timeout:
    - `cwnd` set to 1 MSS
    - window then grows exponentially (as in slow start) to threshold, then grows exponentially
  - Loss indicated by 3 duplicate ACKs: TCP Reno
    - dup ACKs indicate network capable of delivering some segments
    - `cwnd` is cut in half window then grows linearly
  - TCP Tahoe (older version) always sets cwnd to 1 (timeout or 3 duplicate acks)
  - when `cwnd` gets to one half of its value before timeout, switch from exponential to linear
  - Above `ssthresh`, growth is linear; below, it is exponential
  - on a loss event, `ssthresh` is set to one half of `cwnd` just before the loss event
- Avg throughput = $\frac{3}{4}\frac{W}{RTT}$
