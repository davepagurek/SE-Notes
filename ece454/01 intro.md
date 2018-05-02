# Introduction

## Distributed system theory
What are they?
- Appear as a single coherent system
- Communicate and coordinate actions with message passing

Why?
- Resource sharing saves money
- Integrating multiple systems can simplify business processes
- A centralized system may not be powerful or dependable enough to solve a given problem
- In some scenarios, users are mobile and distributed around the world

Distributed systems are usually used as **middleware**: a layer of software separating applications from underlying systems. Used for communication, transactions, service composition, reliability, etc

Goals:
- support resource sharing
- make distribution transparent
- open
- scalable

Things we want to hide when distributing resources:
- access
- location
- migration
- relocation
- replication
- concurrency
- failure

Openness
- Interoperability
- Composability
- Extension
- Separation of policy from mechanism

Scalability expands along these axes:
- size
- geography
- administration

### Hiding latencies
- Batch messages
- Partition data or computation
- Replication
  - e.g. use distributed memory cache to speed up web apps

### Bad assumptions
- Network is reliable
- Network is secure
- Network is homogeneous
- Topology does not change
- Latency is zero
- Bandwidth is infinite
- Transport cost is zero
- There is one administrator

### Types of distributed systems
- web sites and web services
- high performance computing
- cluster computing
- cloud and grid computing
- transaction processing
- enterprise application integration
- distributed pervasive systems / IoT
- sensor networks

### Shared memory vs message passing
Shared memory:
- communication uses shared variables
- usually a cleaner abstraction, but limited to what can fit on one computer
- often called "parallel computing"

Message passing
- Processes communicate with messages over a network
- More scalable, but now has to explicitly deal with messages
- often called "distributed computing"

## Cluster computing systems
These systems distribute CPU or IO intensive jobs across multiple servers (e.g. Hadoop)
