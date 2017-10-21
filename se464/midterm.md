# Midterm Review

## Architectural Styles
### Layered
- Divide architecture into layers
- Each layer serves an API for the layers above it to consume

#### Client-server
- Clients are a layer, server is a layer
- Use remote procedure call to communicate

### Data Flow
#### Batch sequential
- Data flows outputted from one program is inputted into another program, in order

#### Pipe and Filter
- Components are filters; connections are pipes
- No shared state

### Shared memory
#### Blackboard
- Shared data structure is the "blackboard", all components operate on it

#### Rule-based
- Interface: either add a fact/rule to the database, or run a query on the database

### Interpreter
- Commands are entered, which are interpreted and executed and update the interpreter state

### Implicit invocation
- Involve registering a listener for when an event occurs
- Event emitters are unaware of who they are publishing to

#### Pub-Sub
- There are different streams from a source for different kinds of data that listeners can subscribe to

#### Event-based
- Listeners register to handle events from a source, where events can be of different types

### Peer-to-peer
- State and behaviour are shared across peers
- Communication/synchronization occurs over the network

## Modelling
- How to evaluate modelling approaches:
  - What is the scope/purpose?
  - What basic elements are being modelled?
  - Does it help determine the architectural style?
  - Does it model static or dynamic aspects?
  - Does it model non-functional or functional aspects?
  - How ambiguous or accurate or precise is it?
  - What viewpoints are supported?
  - Are viewpoints consistent with each other?

### UML
- Types we need to know:
  - Static structure
    - <a href="http://www.uml-diagrams.org/component-diagrams.html">Component diagrams</a>
    - <a href="http://www.uml-diagrams.org/deployment-diagrams.html">Deployment diagrams</a>
    - <a href="http://www.uml-diagrams.org/class.html">Class diagrams</a>
  - Dynamic behaviour
    - <a href="http://www.uml-diagrams.org/sequence-diagrams.html">Sequence diagrams</a>
    - <a href="http://www.uml-diagrams.org/use-case-diagrams.html">Use case diagrams</a>
    - <a href="http://www.uml-diagrams.org/state-machine-diagrams.html">State machine diagrams</a>

### 4+1 architectural view
- Describes a system from the points of view of different stakeholders
- 4 views:
  - **Development view**: From a programmer's point of view, the classes involved
  - **Logical view**: Functionality provided to end users
  - **Physical view**: Engineer's point of view of the interacting components doing the tasks
  - **Process view**: Explains the dynamic parts of the system and the system's behaviour (what logic does it follow?)
- +1 view:
  - **Scenarios**: explaining how the system works for various user case studies

## Security
### Principles
- **Least privilege**: give each component as little knowledge as you can to have it work
- **Fail-safe defaults**: default to no access unless explicitly given
- **Economy of mechanism**: keep security mechanisms simple
- **Complete mediation**: Do an access check for every request, in case a cached permission becomes out of date
- **Open design**: do not rely on secrecy to make your system secure
- **Separation of privilege**: create distinct tiers of privilege for different parties so one can't abuse extra privileges
- **Least common mechanism**: Try to have as few as possible types of parties communicating using the same mechanisms because it is easier to stay secure when tailoring a communication mechanism for one use case than trying to handle a bunch at once
- **Psychological acceptability**: security should not make the system harder to use, because then it's easier for users to skip it or do it wrong
- **Defense in depth**: have multiple layers of security mechanisms so it's harder to breach your system

### Access control methods
- **Discretionary**: determine access based on the identity of the requestor. There may be a table mapping users to the permissions they have (such as ability to write to a database)
- **Mandatory**: Use policies to determine access. For example, given a security level for each user, use logic to figure out which level should be able to have access (e.g. if a file is in directory $x$, only users in security class $y$ and above should be able to see it)

### Trust issues
- **Impersonation**: A malicious user impersonates a trusted user
- **Fraud**: A malicious user does not do what they agreed to do (e.g. not shipping a product after receiving payment)
- **Misrepresentation**: Spreading false information about a party
- **Collusion**: Using multiple malicious users to shift trust toward/away from someone to give the appearance of being the majority opinion
- **Addition of unknowns**: When a new user is added to the system and everyone is unsure if they can be trusted and the new user is unsure of they can trust everyone

## Design
### Principles

#### STUPID
- Avoid:
  - singleton
  - tight coupling
  - untestable
  - premature optimization
  - indescriptive naming
  - duplication

#### SOLID
- Aim for:
  - Single responsibility
  - open for extension, closed for modification
  - (Liskov) If $S$ is a subtype of $T$, then you should be able to pass an $S$ anywhere a $T$ is accepted without breaking the correctness of the program
    - Method **arguments** on the subtype need to be **as specific or less specific** than the supertype: the arguments for the method in $S$ $\supseteq$ the arguments allowed for $T$
    - Method **return codes** on the subtype need to be **as specific or more specific** than the supertype: the return value for the method in $S$ $\subseteq$ the return value for $T$
    - The only **exceptions** that can be thrown in $S$ are **as specific or more specific** than in the supertype: the exceptions in $S$ $\subseteq$ the exceptions in $T$
  - Interface segregation: only show key methods, do not support methods irrelevant to behaviour
  - Dependency inversion: high level things shouldn't depend on low level ones (e.g. try to depend on an interface instead of a concrete class)

#### Low level principles
- Encapsulate what varies
- Program to interfaces, not implementations
- favour composition over inheritance
- strive for loose coupling
  - Kinds of coupling, from tight to loose:
    - Content: modules depend on the inner workings of each other
    - Global: data is shared globally, can be changed by anything
    - Control: one module controls the flow of another by passing in things like flags
    - Data: common data is shared, e.g. through parameters
    - Message: any kind of communication happens through messages
    - None: no communication

### Patterns

#### Factory
#### Adapter
#### Interpreter
#### Template method
#### Abstract factory
#### Builder
#### Prototype
#### Singleton
#### Adapter
#### Bridge
#### Composite
#### Decorator
#### Façade
#### Flyweight
#### Proxy
#### Chain of responsibility
#### Command
#### Iterator
#### Mediator
#### Memento
#### Observer
#### State
#### Strategy
#### Visitor
