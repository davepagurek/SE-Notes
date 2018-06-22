# Network Layer

### Overview
- Sending side, chunks segments into datagrams
- Receiving side, delivers segments to transport layer
- Key functions:
  - **Forwarding**: move packets from router's input to appropriate output router (getting packet through single interchange)
  - **Routing**: determine route taken by packets from source to destination (planning packet route from source to destination)
- Connection setup
  - Before sending datagrams, two hosts and intervening routers establish virtual connection
  - Distinction between network and transport:
    - **network**: between two hosts (may involve intervening routers)
    - **transport**: between two processes
- Services, per datagram
  - guaranteed delivery
  - guaranteed delivery with less than 40 msec delay
- Services for a flow of datagrams
  - in order delivery
  - guaranteed minimum bandwidth
  - restrictions on inter-packet spacing

## Connection, connectionless service
- **datagram** network provides network layer **connectionless** service
- **virtual circuit** network provides network layer **connection** service
- analogous to TCP/UDP connection-oriented/connectionless transport layer services, but:
  - **service**: host-to-host
  - **no choice**: network provides one or the other
  - **implementation**: in network core

### Virtual Circuit
- source-to-destination path behaves like a phone circuit
- call setup, teardown for each call before data can flow
- each packet carries VC identifier, not destination host address
- every router on source-to-destination path has state for each passing connection
- link, router resources (bandwidth and buffers) may be allocated to VC
  - dedicated resources gives predictable service

### Datagram network
- no call setup at network layer
- no state about connections in routers
- packets forwarded using destination host address
- forwarding table has ranges of addresses instead of individual addresses
  - Longest prefix matching: looks for forwarding table entry for a destination address that has the longest matching address prefix

## Router architecture
- Input, output ports
- Switching fabric
  - forwards data
  - Transfer packet from input buffer to output buffer
  - switching rate: rate at which packets can transfer from input to output
    - often measured as multiple of i/o line rate
    - $n$ inputs: switching rate $n$ times line rate is desirable
  - types: memory, bus, crossbar
- routing processor
  - Runs routing algorithms and protocols
- Has line termination, link layer protocol receiver, lookup forwarding and queueing

### Input port functions
Decentralized switching
- given datagram destination, look up output port using forwarding table in input port memory (match plus action)
- goal: complete input port processing at "line speed"
- queueing: if datagrams arrive faster than can be outputted, queue them up

Switching factors
- transfer packet from input buffer to appropriate output buffer
- Switching via memory
  - Traditional computers with switching under direct control of CPU
  - packet copied to system's memory
  - spreed limited by memory bandwidth (2 bus crossings per datagram)
- Switching via bus
  - datagram from input port memory to output port memory via shared bus
  - bus contention: switching speed limited by bandwidth
  - 32 Gbps: sufficient for access and enterprise routers
- Switching via interconnection network
  - Overcome bus bandwidth limitation
  - banyan networks, crossbar, other interconnection nets initially developed to connect processors in multiprocessors
  - fragments datagram into fixed cell lengths, switch cells through fabric
  - switches 60 Gbps through the interconnection network

### Output port functions
- Same as input ports but in opposite order
- buffering required for datagrams that arrive faster from fabric than transmission rate
- scheduling discipline chooses among queued datagrams for transmission
- Avg buffering equal to typical RTT (e.g. 250 msec) times link capacity $C$
  - e.g. $C$ = 10 Gbps, link is 2.5 Gbit buffer
  - Recent recommendation: with $N$ flows, buffering is equal to $\frac{RTT \cdot C}{\sqrt{N}}$

### Queueing
- input queueing happens when transmission rate of input is faster than fabric rate
- **Head-of-the-line (HOL) blocking**: queued datagram at front of queue prevents other in queue from moving forward

## Internet Protocol
- IP has addressing conventions, datagram format, and packet handling conventions
- ICMP (Internet Control Message Protocol) is for error reporting and router signalling

### Datagram format
<table>
<tr><th colspan=5>32 bits</th></tr>
<tr><td>version</td><td>head len</td><td>type of service</td><td colspan=2>length</td></tr>
<tr><td colspan=3>16-bit identifier</td><td>flags</td><td>fragment offset</td></tr>
<tr><td colspan=2>time to live</td><td>upper layer</td><td colspan=2>header checksum</td></tr>
<tr><td colspan=5>32 bit source IP address</td></tr>
<tr><td colspan=5>32 bit destination IP address</td></tr>
<tr><td colspan=5>options, if any</td></tr>
<tr><td colspan=5>data (variable lenfth, typically a TCP or UDP segment)</td></tr>
</table>

- Time to live is the max number of remaining hops, decremented at each router
- Overhead: 20 bytes of TCP header + 20 bytes of IP header = 40 bytes, plus app layer overhead

### Fragmentation, reassembly
- network links have maximum transfer size MTU: largest possible link level frame
  - different link types have different MTUs
- large IP datagram becomes divided ("fragmented") within network
  - one datagram becomes several
  - reassembled only at final destination
  - IP header bits used to identify, order related fragments
- Have length, ID, frag flag, offset
  - fragments are specified in units of 8 byte offsets
  - fragflag = 0 implies that it is the last one, so when received, the datagram can be reassembled

### IP Addressing
- 32 bit identifier for host, router interface
- interface: connection between router/host and physical link
  - routers typically have multiple interfaces
  - host typically has one or two interfaces (e.g. wired ethernet, wireless 802.11)
- IP addresses associated with each interface

#### Subnets
- A subnet includes device interfaces with same subnet part of IP address
  - can physically reach other without a router
- Address
  - Subnet part: high order bits
  - Host part: low order bits
- subnet mask: e.g. `/24` at end of address means that the most significant 24 bits are the fixed subnet part, and the rest are the host part.
  - Class A: /8
  - Class B: /16
  - Class C: /24

#### CIDR
- Classless InterDomain Routing
- Subnet portion of address can be arbitrary length
- format: `a.b.c.d/x`, where `x` is the number of bits in the subnet portion
- All ones in the host part is used for broadcast
- All zeros is used for network identification

Getting an IP address
- hard-coded sometimes
- DHCP

#### DHCP
- Goal is to allow any computer to automatically get an IP address
- leases an address, can be renewed
- allows reuse of addresses (only holds while connected)
- host broadcasts DHCP discover message
- DHCP server responds with DHCP offer
- host requests IP address with DHCP request msg
- DHCP server replies with DHCP acknowledgement
- Port 67 reserved for DHCP server, Port 68 reserved for incoming DHCP client
- Server uses broadcast to reply because the client doesn't have an address yet
- After receiving a reply from the server, the client knows the server's address, and can reply directly to the server

- How servers pick IPs
  - network gets allocated a portion of its provider ISP's address space
  - ISP gets block from ICANN: Internet Corporation for Assigned Names and Numbers

#### Hierarchical Routing
- "send me anything with addresses beginning (e.g.) 200.23.16.0/20"
- Gets progressively more specific

#### NAT: Network Address Translation
- All datagrams *leaving* local network have the same single source NAT IP address, assigned by ISP, different source port numbers
- Datagrams with source or destination in this network have 10.0.0/24 address for sources, destination
- Outside IP address can change without affecting local IP addresses and vice versa (e.g. changing an ISP)
- Router has NAT translation table from WAN side address to LAN side address
- Talking to computers on another local network:
  - manual configuration
  - IGD
  - both connect to relay

### ICMP: Internet Control Message Protocol
- used by hosts and routers to communicate network-level information
- ICMP message: type, code, plus first 8 bytes of datagram causing error

Traceroute
- Send series of UDP segments to destination
  - First has TTL=1, second with TTL=2, etc
  - unlikely port number
- When nth set of datagrams arrives to nth router:
  - router discards datagrams
  - sends source ICMP message for TTL expired (Type 11, code 0)
  - ICMP messages include name of router and IP address
- When ICMP messages arrive, source records RTTs
- Stops when:
  - UDP segment eventually arrives at destination host
  - destination returns ICMP "port unreachable" (type 3, code 3), because it arrived, but can't do anything with the port specified
  - source stops

### IPv6
- 32-bit address space completely allocated
- In IPv6, there is a fixed 40 byte header, with no fragmentation allowed

#### Header
<table>
<tr><td>ver</td><td>pri</td><td colspan=3>flow label</td></tr>
<tr><td colspan=3>payload len</td><td>next hdr</td><td>hop limit</td></tr>
<tr><td colspan=5>source address (128 bits)</td></tr>
<tr><td colspan=5>destination address (128 bits)</td></tr>
<tr><td colspan=5>data</td></tr>
</table>

- No checksum
- No options field, but is allowed outside of header, indicated by "next header" field
- ICMPv6
  - additional types like "packet too big"

#### Transition from IPv4
- not all routers can be upgraded simultaneously
- **Tunneling**: IPv6 datagram carried as a payload in IPv4 datagram among IPv4 routers

## Routing algorithms
### Graph abstraction
A graph $G = (N, E)$. $c(x, x')$ is the cost of the link $(x, x')$.

Question: **what is the least cost path from the source to the destination?**
- global:
  - all routers have complete info on topology
  - "link state" algorithms
- decentralized
  - router knows physically connected neighbours, link costs to neughbours
  - iterative process of computation, exchange of info with neighbours
  - "distance vector" algorithms
- static
  - routes change slowly over time
- dynamic
  - routes change more quickly
  - periodic update
  - in response to link cost changes

### Link State
- e.g. Dijkstra's algorithm
- $c(x, x')$ edge weights
- $D(v)$ current value of cost path from source to dest $v$
- $p(v)$: predecessor
- $N'$ set of routers who we know the least cost path for

### Distance vector
Bellman-Ford equation (DP)
Let $d_x(y) :=$ cost of least cost path from $x$ to $y$
Then, $d_x(y) = \min\{c(x,v) + d_v(y)\}$

- $D_x(y)$ is the estimate of least cost from $x$ to $y$
- $x$ maintains the distance vector $D_x = [D_x(y): y \in N]$
- For each node $x$ it knows the distance to each of its neighbours
- From time to time, each node sends its own distance bector estimate to neghbours
- when $x$ receives new DV estimate from neighbour, it updates its own DV using B-F equation:
  - $D_x(y) \leftarrow \min_v\{x(x,v) + D_v(y)\} \quad \forall y \in N$
- poisoned reverse:
  - if Z routes through Y to get to X:
    - X tells Y its distance to X is infinite
- message complexity
  - LS: with n nodes, E links, $O(nE)$
  - DV: exchange between neighbours only. Convergence time varies
- Speed of convergence
  - LS: $O(n^2)$, requires $O(nE)$ messages. May have oscillations
  - DV: convergence time varies. May be routing loops, count-to-infinity problem
- Robustness
  - LS: node can advertise incorrect link cost, each node computes only its own table
  - DV: DV node can advertise incorrect path cost
  - each node's table is used by others so the error propagates through the network

### Hierarchical Routing
- aggregate routers into regions, "autonomous systems"
- routers in same AS run same routing protocol
  - intra-AS routing protocol
  - routers in different AS can run different intra-AS routing protocols
- gateway router:
  - at edge of its own AS
  - has link to router in another AS
- forwarding table configured by both intra- and inter-AS routing algorithms

Inter-AS tasks
- Router in AS1 receives datagram destined for outside AS1
- AS1 must learn which dests are reachable through AS2, and which through AS3
- AS1 must propagate this reachability info to all routers in AS1
- Use internal routing to find shortest path to exit nodes in AS1, add those to forwarding table
- At output nodes, the connecting nodes in other ASes give info to AS1 that they can both reach the final destination
  - Hot potato routing: pick closest one to forward to that will still get to the destination

## Internet Intra-AS Routing
- AKA **interior gateway protocols (IGP)**

### RIP: Routing Information Protocol
- included in BSD-UNIX since 1982
- distance vector algorithm
  - distance metric: number of hops (up to 15 max), each link has cost 1
  - DVs exchanged with neighbours every 30 seconds in response message (this is **advertisement**)
  - each advertisement: list of up to 25 destination subnets and the hops to get there
- Link failure
  - If no advertisement heard after 180s, neighbour/link declared dead
  - routes via neighbour invalidated
  - new advertisements sent to neighbours
  - neighbours in turn send out new advertisements
  - poison reverse used to stop infinite loops: max 16 hops
- RIP routing tables managed by application level process called `routed`
  - Advertisements sent as UDP packets

### OSPF: Open Shortest Path First
- uses link state
  - topology map at each node, route computation using Dijkstra's
- advertisement carries one entry per neighbour
  - broadcast link state every 30 minutes even if there is no change
- advertisements flooded to entire AS
  - carried in OSPF messages directly over IP, not TCP or UDP
- IS-IS routing protocol is nearly identical to OSPF
- Adds security: messages authenticated
- multiple same-cost paths allowed (compared to only one in RIP)
- for each link, multiple cost metrics for different types of service (e.g. satellite link cost set to "low" for best effort ToS, high for real time ToS)
- integrated uni- and multi-cast support: Multicast OSPF (MOSPF) uses same topology data base as OSPF
- hierarchical OSPF in large domains

### BGP: Border Gateway Protocol
- the de facto inter-domain routing protocol
- BGP provides each AS as a means to:
  - eBGP: (external) obtain subnet reachability information form neighbour ASes
  - iBGP: (internal) propagate reachability info to all AS-internal routers
  - determine good routes to other networks based on reachability info and policy
- Allows subnet to advertise its existence on internet
- Messages, sent over TCP:
  - **OPEN**: opens TCP connection to peer and authenticates sender
  - **UPDATE**: advertises new path or withdraws old
  - **KEEPALIVE**: keeps connection open in apsence of UPDATEs, also ACKs OPEN request
  - **NOTIFICATION**: reports errors in previous msg, also used to close connections
- BGP session: two BGP peers echange BGP messages:
  - advertising paths to different destination network prefices ("path vector" protocol)
  - exchanged over semi permanent TCP connections
- Advertised prefix includes BGP attributes:
  - **AS-PATH**: contains ASes through which prefix advertisement has passed
  - **NEXT-HOP**: indicates internal-AS router to next-hop AS
- Route selection
  - local preference value attribute: policy decision
  - shortest AS-PATH
  - closest NEXT-HOP router
  - additional criteria
