# Intro

## Internet
- Hardware
  - Billions of devices: **hosts** or **end systems**
  - Devices are connected with **communication links** (e.g. Fibre, with a transmission rate called **bandwidth** in bits per second)
  - **Packet switches** forward packets (chunks of data) with **routers** and **switches**
- Software
  - **protocols**: controls sending and receiving of messages (TCP, IP, HTTP, etc)
  - **standards**:
    - RFC (request for comments)
    - IETF (internet engineering task force)
- Infrastructure
  - Provides services to applications (web, VoIP, email, etc)
  - Provides programming interface to apps

Network edge:
- hosts: clients and servers
- servers are often in data centers

Access networks, physical media: wired, wireless communication links

## Network core
- Interconnected routers
- network of networks

**Frequency division multiplexing**: different channels transmitted in different frequencies

**HFC**: hybrid fibre coax
- 30Mbps down, 2Mbps up
- Shared line for neighbourhood, not a direct connection like in DSL

### Circuit switching
- Frequency division: each user gets a frequency band
  - Bit rate not evenly divided since not all frequencies have the same capacity
- Time division: rate per time slot is frames per second times the number of bits in one time slot
  - e.g. 1 frame per second, 24 slots, 1.536 Mbps wire
  - $rate = \frac{1.536 Mbps}{24} = 64 Kbps$
  - Time to transmit a 640 Kb file: $\frac{640Kb}{64 Kbps} = 10s$

### Packet switching
- Allows more users to use the network than circuit switching
- Has queueing delay

e.g. 1Mbps link, each user has 100Kbps when active, but only active 10% of the time
- Circuit switching can only use 10 users
- Packet switching: with 35 users, probability &gt; 10 active at the same time is less than 0.0004:

Probability that 11 or more users or more are sending is equal to 1 - the probability that 10 users are sending
$$\begin{align}
1 - P(\text{10 users sending}) &= 1 - \sum_{n = 0}^{10} {\binom{35}{n} 0.1^n (1-0.1)^{35 - n}}\\
&= 0.0004\\
\end{align}$$

- Packet switching is good for data that comes in bursts (resource sharing, no call setup)
- Packet delay and loss possible. Protocols needed for reliable data transfer, congestion control
- Bandwidth guarantees are needed for audio/video apps to provide circuit-like behaviour. Still an unsolved problem.

### Internet structure
- Bottom: access ISPs
- Above that are by regional ISPs
- Above that are some Internet Exchange Points
- Above that are Tier 1 ISPs and content providers (e.g. Google)

## Network loss and delays
- Packets queue in router buffers
- Loss and delays occur when packet arrival rate exceeds output link capacity
- Packets wait for their turn to be transmitted

$$d_{nodal} = d_{proc} + d_{queue} + d_{trans} + d_{prop}$$
- $d_{proc}$: nodal processing
  - check for bit errors
  - determine output link
  - typically less than milliseconds
- $d_{queue}$: queueing delay
  - Time waiting for output link
  - Depends on congestion
- $d_{trans}$: transmission delay
  - Delay from receiving start of packet to receiving end of packet
  - Depends on packet length and bitrate
  - $L$: packet length
  - $R$: bandwidth
  - $d_{trans} = \frac{L}{R}$
- $d_{prop}$: propagation delay
  - Delay from sending start of packet to receiving start of packet
  - $d$: length of physical link
  - $s$: propagation speed in medium
  - $d_{prop} = \frac{d}{s}$

### Queueing delay
Given a packet length of $L$ bits, an $R$ bps link, and an average arrival rate $a$, we define **traffic utilization** or **traffic intensity**:
$$\text{Traffic intensity} = \frac{\underbrace{La}_\text{rate of arriving bits}}{\underbrace{R}_\text{rate of outgoing bits}}$$
- $La/R \approx 0$: avg queueing delay is small
- $La/R \rightarrow 1$: avg queueing delay is large
- $La/R \gt 1$: avg delay is infinite because more work arrives than can be serviced

`traceroute` provides delay measurement from source to router, for each router along the path to the destination. Can be used to find routers that are congested

**Throughput** is the rate (bits/time) at which bits are transferred between sender and receiver
- Instantaneous throughput is the rate at a given point in time
- Average is over a long period of time
- The link with the smallest rate will always be the bottleneck for throughput
- Throughput is always the minimum rate along the link

## Layers
Each later represents a service

Internet protocol stack:
- application: supports network applications (e.g. FTP, SMTP, HTTP)
- transport: Process to process data transfer (TCP, UDP)
- network: routing from source to destination (IP, routing protocols)
- link: data transfer between network elements (Ethernet, 802.111 (wifi), PPP)
- physical: bits "on the wire"

OSI model:
- application
- **presentation**: allow applications to interpret meaning of data (e.g. encryption, compression)
- **session**: synchronization, checkpointing, recovery of data exchange
- transport
- network
- link
- physical

**Encapsulation** means taking something from another layer, adding a header, and passing it on (not directly modifying data from the previous layer, just extending it)
- The full, extended message is called a datagram
- Removing of headers is decapsulation

## Security
- virus: self replication by receiving and executing
- worm: self replicating by passively receiving and getting itself executed
- spyware: records info and uploads
- botnet: a network of similarly infected hosts
- packet sniffing: promiscuous network interface reads/records all broadcasted packets
- IP spoofing: send a message claiming to be from another address
