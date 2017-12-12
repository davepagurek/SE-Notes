# Exam Review

## Dependency injection
- Adheres to principles of programming to interfaces and not implementations.

## Cloud computing
Characteristics
- On-demand service
- Broad network access
- Resource pooling
- Rapid elasticity (easily add/remove resources)
- Measured service (Metered storage, processing, bandwidth, etc)

Benefits
- Agility
- Scalability
- Cost
- Reliability
- Security

Technologies enabling this
- Virtualization
  - Emulation (e.g. QEMO), simulates partial hardware
  - Paravirtualization (e.g. Xen), software interface to VM
  - Full (e.g. VMWare), complete simulation of hardware
  - Network (e.g. VPNs), abstract and virtualize networks
- APIs
  - REST

What people look for in cloud security
- Confidentiality
- Integrity
- Authenticity
- Anonymity
- Privacy

## Static Analysis
Optional type checking (annotations in Java)
- Adds type qualifiers into code (e.g. `@Immutable`, `@Nullable`)
- Compiler checks additional properties, guaranteeing additional behaviours
- Uses: String typing (e.g. regex format), command injection vulnerabilities

Formalizations
- Stronger guarantees
- Less practical to implement

e.g. dealing with null
- Make variables non null by default, making the dangerous case explicit
- One null check might not be enough if a method's side effects change state, so we can introduce annotations like `@Pure`, `@Deterministic`, `@SideEffectFree` to know when we have to re-check

Typesystems need:
- Qualifier hierarchy
- Type introduction rules (make types for expressions)
- Type rules (define checker specific errors)
- Flow refinement (better types than the programmer wrote)
