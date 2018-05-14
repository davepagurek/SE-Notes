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
  - each has source and destination IP
