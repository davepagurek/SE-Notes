# Network Applications
Write programs that:
- run on different end systems
- communicate over network
- no need to write software for network core devices

Architectures
- client/server
- peer-to-peer

## Client-server
Server
- always on
- static IP

Clients
- communicated with server
- intermittently connected
- dynamic IP
- doesn't directly communicate with other clients

## Peer-to-peer
- no always-on server
- arbitrary end systems can directly communicate
- all peers intermittently connected, can change IP

## Processes communicating
- **Process**: program running on host
- within a host, two processes communicate using inter process communication, defined by the OS
- processes on different hosts communicate by exchanging messages
- Processes send and receive messages to/from its unique socket
- to receive messages, processes must have an identifier, a unique 32-bit IP address

Application layer protocol
- types of messages (request, response)
- message syntax
- message semantics
- rules for when and how processes send and respond

What transport service is needed?
- data integrity: must be reliable, or is some loss acceptable?
- timing: does it need low latency?
- throughput: does it need a minimum amount or can it be elastic?
- security: encryption, data integrity, etc

### TCP
Transmission Control Protocol
- reliable transport
- flow control: sender won't overwhelm receiver
- congestion control
- Does not provide timing, throughput, security guarantees
- Connection-oriented: requires setup
- Adding security: use SSL
  - provides encrypted TCP connection
  - endpoint authentication
  - resides in the application layer, using SSL libraries that talk to TCP
  - cleartext passwords sent into socket traverse the internet encrypted

### UDP
User Datagram Protocol
- Unreliable data transfer
- does not provide flow control, congestion control, timing, throughput, security, or connection setup
- Faster than TCP, no overhead
