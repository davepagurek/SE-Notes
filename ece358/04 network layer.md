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

Decentralized switching
- given datagram destination, look up output port using forwarding table in input port memory (match plus action)
- goal: complete input port processing at "line speed"
- queueing: if datagrams arrive faster than can be outputted, queue them up
