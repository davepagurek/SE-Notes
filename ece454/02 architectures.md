# Architectures

- Component: modular unit with an interface
- Connector: mediates communication between components
- Software architecture: organization of components
- System architecture: instantiation of software architecture on real machines
- Autonomic system: adapts to environment by monitoring behaviour and adapting

Styles:
- Layered
  - communicating between layers takes one round trip (two message delays to send and receive)
- Object-based
  - e.g. Java remote method invocation (RMI)
- data-centred
- event-based
  - e.g. pub sub

## Multi-tiered architectures
Logical layers need to be mapped onto physical tiers. In a two tiered system (client/server), you can decide which parts to put on which tier.

### Horizontal vs Vertical distribution
- Vertical: logical layers of a system are separate physical tiers. (e.g. separate machines for application server, database)
- Horizontal: one logical layer is split across multiple machines (e.g. hash partitioned data sets, known as sharding)
