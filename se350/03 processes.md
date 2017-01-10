# Processes
## Requirements
- Use multiple process for max processor utilization
    - uniprocessor: interleave execution of procs
    - multiprocessor: interleave and parallel execution
- allocate resources to process
- support communication between processes
- support user creation of processes
- OS provides a "virtual machine" to processes for the resources they are allowed to access

## Managing Processes
- A process is a unit of activity with:
    - execution of a sequence of instructions (program)
    - current state
    - associated set of system instructions
- Has properties:
    - Identifier (PID)
    - State (e.g. running state: what memory regions are assigned, files opened, user name, etc)
    - Priority, relative to other processes
    - Memory pointers
    - context data (registers, PSW, program counter)
    - IO status info
    - accounting information
        - amount of processor time, time limits, threads
        - try `top` and `ulimit`
- Process Control Block (PCB)
    - The data structure that contains one description of one process
    - created and managed by OS
    - allows support for multiple processes
    - e.g.
```C
typedef rom const struct _rom_desc_tsk {
    unsigned char prioinit;
    unsigned char *stackAddr;
    void (*addr_ROM)(void);
    unsigned char tskstate;
    unsigned char tskid;
    unsigned int stksize;
} rom_desc_tsk;

 /****************************************
  * -------------- task VM ---------------
  *****************************************/
  rom_desc_tsk rom_desc_task_vm = {
    TASK_VM_PRIO,
    _stack_vm,
    TASK_VM,
    READY,
    TASK_VM_ID,
    sizeof(_stack_vm)
};
```
- trace of the process
    - sequence of instructions for a process
    - dispatcher switches the processor from one to another
    - dispatcher invokes scheduler which decides which process to switch to
    - not running processes are in a queue


### Spawning
- Sources
    - New batch job
    - interactive logon
    - from OS to provide service
    - Parent process explicitly creates a child process
        - check this with `ps --forest` and `pstree`

### Termination
- Sources
    - noral completion
    - time limit exceeded (`ulimit`)
    - memory unavailable
    - bounds violation
    - protection error
    - arithmetic error
    - time overrun
    - IO failure
    - invalid instruction
    - privileged instruction
    - data misuse
    - operator OS intervention
    - parent termination
    - parent request
- can do a core dump

### Queueing
- A process can be either **running** or **not running** state, dispatcher switches between
- Processes must wait ing some sort of queue (priority queue) until it's their turn
- simple queueing is inefficient
    - some processes are ready to execute
    - some are blocked
- with a single queue: dispatcher must scan list to find process not running, ready, and in queue the longest
- multiple queues: make a queue for ready processes and another for busy ones
  - We now have five states:
    - Running
    - Ready
    - Blocked/Waiting
    - New (ready to enter system)
    - Exit (a halted or aborted process)
