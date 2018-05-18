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
