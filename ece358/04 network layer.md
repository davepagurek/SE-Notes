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
