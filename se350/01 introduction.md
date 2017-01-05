# What is an OS?
- Originally, hardware is expensive, people are cheap
  - Goal: maximize hardware usage
- Now, we have cheap hardware, people are expensive
  - Optimize for making things easier to use for people
  - Provides a common way of doing things / interface

An OS is a standardized abstraction: a VM implemented on the underlying machine

What do you need in a computer?
- One or more CPUs
- memory
- I/O modules
- timer(s)
- interrupt controller
- system bus connecting them

## Registers
### User-visible registers
- Enable programmer to minimize references to memory
- available to all programs
- depends on computer architecture
- maybe be referenced by machine language
- Usually controlled by the compiler
- Two types:
  - **Data registers:** stores data (results from calculations, etc)
  - **Address registers:** points to memory
    - Indexed addressing (Add an index to a base value to get an effective address)
    - Segmented pointer (when memory is divided into segments, memory is referenced with a segment + offset)
    - Stack pointer

### Control and status registers
- Invisible to the user on most architectures
- used by processor to control operating of computer
- Used by privileged OS routines to control execution

### Condition codes and Flags
- Part of Program Status Word (PSW)
- Bits set by processor hardware as a result of operations
- e.g. positive, negative, zero, overflow as results of arithmetic
- Conditional branching uses this
- Only implicitly accessible on most architectures


## Instruction execution
Simple:
1. Processor fetches from memory
2. Processor executes
3. Goto 1

Reality:
- Pipeline
- Very Long Instruction Word
- superscalar architectures

### Instruction Register
- Fetched instruction put in IR
- action category dictated by instruction


## Interrupts
- Most IO devices are slower than processor by a LOT
  - Processor must pause to wait
- Interrupts help improve processor utilization
- Changes normal processor sequence
- types:
  - program (condition that occurs as a result of an instruction execution, e.g. division by zero)
  - timer (from timer in processor)
  - IO (from IO controller)
  - hardware failure (e.g. power failure)


### New processor flow
- Processor checks for interrupts
- If interrupt:
  - suspend program execution (store snapshot)
  - execute interrupt handler routine
  - resume execution (restore snapshot)

This is a simplified version, does not account for nested interrupts, interrupt priorities, counting interrupts, etc

### Direct Memory Access (DMA)
- allows hardware subsystems to access RAM without going through the CPU
- transfers block of memory directly to device

## Memory Hierarchy
Traversing heirarchy:
- Decreasing cost per bit
- increasing capacity
- increasing access time
- decreasing frequency of access

### Cache memory
- typically invisible to OS
- Processor accesses memory at least once per instruction cycle
- Executing is limited by memory cycle time
  - hint: figure out what flash wait states are for your project MCU
- Use locality for small, fast memory
  - memory accesses close in time typically are close in space
- Caches contain a copy of a portion of main memory
- Processor first checks cache, and if not found, block is read into cache
- Has a replacement algorithm (e.g. least recently used, least frequently used, etc)
- Has a write policy (e.g. write back, write through)


### Symmetric Multiprocessing (SMP)
- Processors share:
  - same main memory
  - access to IO
- connected by bus
- integrated operating system provides interaction between processors and their programs
