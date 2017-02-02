# Threads

## Relationship with Processes
Processes **own resources**, so processes include a virtual address space to hold the process image

Processes have to be **scheduled and execute**, and may be interleaved with other processes.

We use **threads** to execute within a process and use the resources of a process.
- Dispatching referred to as threads. They have:
  - basically everything but resource ownership
  - execution state (running, ready, etc)
  - saved context when not running
  - has execution stack
  - per-thread static storage for local variables
  - access to process resources
- Resource ownership referred to as a process
  - virtual address space to hold the process image
  - protected access to processors, other processes, files, IO

## Benefits of Threads
- threads are faster to make because you can skip resource allocation
- less time to terminate than a process, no memory area to deallocate
- less time to switch between two threads in the same process because they share the same process heap
- Good for separating foreground/background work
- Good for async processing

## Behaviour
- Suspending a process suspends all threads of the process
- termination of a process terminates all threads of the process
- States for threads:
  - spawn (spand another thread)
  - block
  - unblock
  - finish (deallocate register context and stack)

### User-level threads
- all thread management done by application
- if the kernel is not aware of existence of threads, it can't assign threads to multiple processors
- less switching overhead
- scheduling is app specific
- can run on any OS

### Kernel-level threads
- OS calls are blocking only the thread
- can schedule threads simultaneously on multiple processors

## Microkernels
- Small OS core
- contains only essential functions for OS
- these are now subsystems (in user mode) instead of OS things:
  - device drivers
  - file systems
  - virtual memory manager
  - windowing system
  - security services
- crashing a module doesn't crash the kernel


# Concurrency
## Requirements
- Multiple applications and multiprogramming
- structured applications: applications can be a set of concurrent processes
- OS structure: OS is a set of processes or threads

### Terms
- **critical section**: section of code that requires access to shared resources, may not be executed while another process is in a corresponding section of code
- **deadlock**: situation where two or more processes are unable to proceed because each is waiting for another
- **livelock**: both continuously change their state in response ot another process without actually doing useful work
- **mutual exclusion**: rewuirement that no two processes can be in the critical section at once
- **race condition**: the result depends on relative timing of multiple concurrent processes
- **starvation**: runnable process overlooked indefinitely by the scheduler

### OS Concerns
- keep track of processes
- allocate and deallocate resources:
  - processor time
  - memory
  - files
  - IO devices
- protect data resources


### Interaction among processes
1. Processes are unwaware of each other
2. Processes are indirectly aware of each other
3. Processes are directly aware of each other

#### Mechanisms for mutual exclusion
- Software: Dekker's algorithm
- Hardware
  - special instructions
    - performed in a single instruction cycle
    - access to memory location is blocked for any other instructions
  - disable interrupts as a means for mutual exclusion on a uniprocessor system
    - dispatcher is triggered by an interrupt, so if interrupts are enabled, the process won't switch
    - special machine instructions
      - atomic, will not be preempted
      - performed in single instruction cycle
      - access to memory it blocked for any other instructions
      - e.g. `exchange`, `testset`


## Advanced mechanisms
### Semaphores
A concurrency control mechanism based on special variable for signalling. If a process is waiting for a signal, it is suspended until the signal is sent.
- semaphore variable has an integer value
- wait operation decrements semaphore value
- signal operation increments the value
- **anyone can call `semWait()` or `semSignal`**, unlike mutexes, where only the process with the lock can release the lock
- no way to know if `semWait()` will block or not
- `semSignal()` may wake up a process, but you won't know whether or not it does
- They block when the value is $\leq 0$


### Monitors
- Software module
- local data variables are accessible only by the monitor (shared data in the monitor is safe)
- process enters by invoking one of its procedures (controlled entry)
- Only one process can be executing in the monitor at a time (mutex)
- Uses condition variables for signalling
- unused signals are lost
- `synchronized` keyword in Java


#### Mesa monitors
- signalling doesn't cause the thread to lose occupancy of the monitor
- nonblocking condition variables

#### Message passing
- Enforce mutual exclusion
- Exchange information
- `send(destination, message)`
- `receive(source, message)`
- Sender and receiver may or may not be blocking
- blocking send and receive: both blocked until mesage delivered (rendez-vous)
- Nonblocking send, blocking receive: sender continues on, receiver is blocked until the requiested message arrives
- Nonblocking send, nonblocking receive: neither party is required to wait
- Direct addressing
  - send primitive includes identifier for the destination process
  - receive primitive could know ahead of time from which process a message is expected
  - receive primitive could use a source param to return a value when the receive operation has been performed
- Indirect addressing
  - messages sent to shared data structure consisting of queues called **mailboxes**
  - one prcess sends message to mailbox, other picks up message from mailbox


### Reader/Writer Problem
- Any number of readers can read a file
- Only one writer can write at a time
- IF a writer is writing, no one can read


# Deadlock
- permanent blocking of processes that either compete for resources or communicate with each other
- no efficient solution in general case
- involve conflicting needs for resources
