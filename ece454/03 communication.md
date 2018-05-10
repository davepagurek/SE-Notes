# Communication

A middleware layer sits between the transport layer and the application layer (we start to depart from the OSI model here.)

## Remote Procedure Calls
These work similar to normal procedure calls, but over the network. The arguments that would be pushed to the stack in a conventional procedure call get sent in a message over the network.
- **Client stub** translates the call to a protocol message
  - The client stub is a normal class with normal messages that hide the fact that networking happens
  - Inside the client stub, the method's arguments are translated to a message (using **marshalling**) and sent
- Message is received and processed at the server by a **server stub**
- Server stub sends the return value to the client as another protocol message
- Marshalling takes into account different representations of values on different architectures
- Can be **synchronous** or **asynchronous**
  - In synchronous RPCs, the client waits for the return value
  - In asynchronous, the client continues executing. A second RCP can be issued by the server to return the response
- Messages are **transient**, so they don't persist anywhere
- Used mostly for two-way communication
- Middleware linked into client and server, no extra infrastructure needed

## Message queueing model
- **Persisted communication**, messages are their own entities independent of client/server connections
- Messages are ordered and persisted in a queue until they are consumed
- Queue primitives:
  - **Put**: append a message
  - **Get**: wait until the queue is not empty and then remove the first message
  - **Poll**: check if the queue has a message, and remove/return one if it does, but do nothing otherwise. This will never block
  - **Notify**: install a handler to be called when a message is put into the queue
- This has looser temporal coupling than RPCs, because you don't need both the consumer and producer connected at the same time to be able to communicate
- Similar to pub/sub. Both are examples of **message-oriented middleware.**
- Used mostly for one way communication where a response is not always expected
- Middleware needs to be a separate component

## Apache Thrift
Software stack:
- Server
  - Receives incoming connections
  - single threaded, event driven
- Processor
  - reads and writes IO streams
  - compiler generated
- Protocol
  - encodes and decodes data
  - JSON, compact, etc
- Transport
  - reads/writes to network
  - raw TCP, HTTP, etc

### Defining services in the IDL
```
namespace java example1

exception IllegalArgument {
  1: string message;
}

service MathService {
  double sqrt(1:double num) throws (1: IllegalArgument ia)
}
```
