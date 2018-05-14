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

### Web and HTTP
- Web is made of objects
- Web page consists of a base HTML file object which references other objects
- Each object is addressable by a URL (Uniform Resource Locator)
- Client: e.g. browser
- Server: web server sends objects in response to requests
- Stateless: server maintains no information about past client requests
- Uses TCP
- Connection types
  - Non persistent
    - At most one object sent over TCP connection, which is then closed
    - 2 RTT + transmission time
  - Persistent
    - Multiple objects sent over single TCP connection between client and server
    - RTT + 1 transmission time per object
- HTTP/1.0:
  - GET
  - POST
  - HEAD (gets header only, no response)
- HTTP/1.1:
  - PUT
  - DELETE
- Conditional GET: don't send obhect if cache has up-to-date version
  - Send `If-modified0since: <date>` in header
  - Server can send a `304 not modified` if the cache is valid

### DNS
- Provides mapping between address and name
- Distributed database implemented by hierarchy of many name servers
- Hosts resolve name (application layer protocol)
- Services
  - Hostname to IP translation
  - Host aliasing
  - Mail server aliasing
  - Load distribution
- Local DNS: acts as a local DNS cache, acting as a proxy
- Caching
  - Once a nameserver learns a mapping, it caches it
  - Caches time out after some time (TTL)
  - Cached entries may be out of date: won't fully propagate changes until TTL
- DNS records:
  - Format: `(name, value, type, ttl)`
  - A: name is a hostname, value is an IP address
  - NS: name is a domain (e.g. foo.com), value is hostname of authoritative name server for the domain
  - CNAME: name is an alias for some real name, value is the real (canonical) name
  - MX: value is the name of the mailserver associated with the name

Query and reply have the same format:

<table>
<tr><th>2 bytes</th><th>2 bytes</th></tr>
<tr><td>identification</td><td>flags</td></tr>
<tr><td># authority RRs</td><td># additional RRs</td></tr>
<tr><td colspan=2>questions (variably number of questions)</td></tr>
<tr><td colspan=2>answers (variable number of RRs)</td></tr>
<tr><td colspan=2>authority (variable number of RRs)</td></tr>
<tr><td colspan=2>additional info (variable number of RRs)</td></tr>
</table>

