# Introduction

## Distributed systems
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
- cincurrency
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
