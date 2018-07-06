# Link layer

- Hosts and routers are **nodes**
- **links** are communication channels that connect adjacent nodes along communication paths
  - wired, wireless, LAN
- layer 2 packet is a **frame**
- services
  - framing, link access
    - encapsulate data in frame, add header and trailer
    - channel access if shared medium
    - MAC addresses used in frame headers to identify source, dest (different than IP)
      - hardcoded in network card
  - reliable delivery between adjacent nodes
  - flow control
  - error detection
  - error correction
  - half-duplex, full-duplex

## Error detection
- EDC: Error detection and correction bits (redundancy)
- Error detection not 100% reliable
- larger EDC field yields better detection and correction
- Parity checking
  - Single bit: detect single bit errors (odd: # of ones is odd in frame; even: number of ones is even in frame)
  - 2D bit parity: Add a row and column that does single bit checking on the row/column index.
- Cyclic redundancy check
  - View data bits, $D$ as a binary number
  - choose $r+1$ bit pattern (generator), $G$
  - goal: choose $r$ CRC bits, $R$, such that:
    - $\langle D, R\rangle$ exactly divisible by $G \mod 2$
    - receiver knows $G$, divides $\langle D,R\rangle$ by $G$. If nonzero remainder, error is detected
    - can detect all burst errors less than $r+1$ bits
  - used in ethernet, wifi, ATM

## Multiple access links, protocols
- point-to-point links
  - PPP for dial-up access
  - Don't need multiple access protocol
- broadcast links (shared wire or medium)
  - old fashioned Ethernet
  - upstream HFC
  - 802.11 wireless LAN

Multiple access protocol organizes who talks first, and how to recover from a collision (multiple talking at once)

- **Given:** broadcast channel of rate $R$ bps
- **Desiderata:**
  1. when one node wants to transmit, it can send at rate $R$
  2. If $M$ nodes want to transmit, they all can transmit on average $R/M$
  3. Fully decentralized: no node to coordinate transmissions, no synchronization of clocks, slots
  4. simple

### Channel partitioning
- divide channel into pieces (time slots, frequency, etc)
- each piece gives exclusive use to a node

#### TDMA: time division multiple access
- access to channel in "rounds"
- each station gets fixed length slow in each round
- unused slots go idle
- fair, collision-free
- waste of bandwidth, unnecessary waiting

#### FDMA: frequency division multiple access
- channel spectrum divided into frequency bands
- each station assigned fixed frequency band
- unused transmission time in frequency bands goes idle
- collision-free, fair
- waste of bandwidth

#### CDMA: code division multiple access
- each user is allocated a unique code to transmit

### Random access
- has collisions
- can recover from collisions
- when node has a packet to send:
  - transmit at rate $R$
  - no coordination among nodes
- If multiple transmit at once, collisions happen and retransmits are needed
- random access specifies how to detect collisions and how to recover

#### Slotted ALOHA
- assumes:
  - all frames same size
  - time divided into equal slots
  - nodes transmit at beginning of time slots
  - nodes are synchronized
- operation:
  - when node obtains frame, it transmits in the next slot
  - if no collision, not can send new frame in next slot
  - otherwise, node retransmits frame in each subsequent time slot with probability $p$ until success
- pros:
  - single active node can take full channel rate
  - highly decentralized
  - simple
- cons
  - collisions, wasting slots
  - idle slots
  - nodes can detect collision in less time to retransmit packet
  - clock synchronization needed
- efficiency
  - assume $N$ nodes with many frames to send, each transmits in slot with probability $p$
  - probability of success is: $\underbrace{p}_\text{probability one transmits}\underbrace{(1-p)^{N-1}}_\text{probability no others are transmitting}$
  - probability that any node has a success is $Np(1-p)^{N-1}$
  - max efficiency: find $p^*$ that maximizes the previous probability
  - $p^* = \frac{1}{e} = 0.37$
  - At best, channel used for useful transmissions 37% of the time

#### Unslotted ALOHA
- same as before but without waiting for synchronization (transmit immediately)
- collision probability increases
- $P(success) = P(node transmits) P(no other node transmits in [t_0-1, t_0]) P(no other node transmits in [t_0, t_0+1])$
- $P(success) = p(1-p)^{N-1}(1-p)^{N-1} = p(1-p)^{2(N-1)}$
- Maximum probability is $\frac{1}{2e} = 0.18$

#### CSMA: carrier sense multiple access
- listen before transmit
- if channel sensed idle, transmit entire frame
- if channel is busy, defer transmission
- collisions can still occur because of propagation delay (one node has started transmitting but others haven't seen it yet)

#### CSMA/CD (collision detection)
- collision detected within short time
- colliding transmissions aborted
- detection
  - easy in wired LANs: measure signal strength
  - difficult in wireless LANs: received signal strength overwhelmed by local transmission strength

Algorithm:
1. NIC receives datagram from network layer, encapsulates in frame
2. NIC senses channel. If busy, wait until free. Then, transmit
3. If NIC transmits entire frame without detecting collision, NIC is done with frame.
4. If a collision is detected, abort immediately, send jam signal
5. After aborting, NIC enters binary (exponential) backoff
  - after $m$th collision, NIC chooses $K$ at random from $\{0, 1, 2, ..., 2^m-1\}$
  - wait $512K$ bit times. Return to step 2
  - longer backoff interval with more collisions
  - reset $m$ after a successful transmission

- Medium sensing done for 96 bit-times
- jamming signal length is 48 bits. Creates just enough energy on the line for collision detection
- efficiency
  - $T_{prop}$ is max prop delay between two nodes in LAN
  - $t_{trans}$ is time to transmit max size frame
  - efficiency = $\frac{1}{1 + 5t_{prop} / t_{trans}}$
  - can go to 1 as $t_prop \rightarrow 0$ or $t_{trans} \rightarrow \infty$
  - better than ALOHA

### taking turns
- channel partitioning MAC protocols
  - share channel efficiently and fairly at high load
  - inefficient at low load
- random access MAC protocols
  - efficient at low load
  - high load has collision overhead

#### Polling
- master node invites slave nodes to transmit in turn
- used with dumb slave devices
- no collisions, no empty slots
- concerns
  - polling overhead
  - latency
  - single point of failure at the master

#### Token passing
- control token passed from one node to the next sequentially
- token message
- concerns:
  - token overhead
  - latency
  - single point of failure (token)

#### DOCSIS: data over cable service interface spec
- FDM over upstream, downstream frequency channels
- TDL upstream: some slots assigned, some have contention
  - downstream MAP frame: assigns upstream slots
  - request for upstream slots (and data) transmitted random access (binary backoff) in selected slots
