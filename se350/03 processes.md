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
  - We now have five states, and at least one queue for each state:
    - Running
    - Ready
    - Blocked/Waiting
      - Make a queue for each type of event you can be blocked on so that you don't have to iterate through each blocked process to see which to remove from the queue
    - New (ready to enter system)
    - Exit (a halted or aborted process)
      - So that we can dispose of resources in bulk if we want
  - We can split blocked and ready into suspended and not suspended states so that suspended processes can be written to disk to free up RAM

### Resource management
- Things the OS needs to know about process resource management
  - allocation of main memory processes
  - allocation of secondary memory processes
  - protection attrs for shared memory regions
  - info needed for virtual memory
  - IO tables
    - IO device available or assigned
    - location in main memory used as source/dest of io transfer
  - File tables
    - existence of files
    - location on secondary memory
    - status
    - attributes (e.g. `rwxr-r-`)
  - Process table
    - where process is located in memory
    - attributes in process image
    - program
    - data
    - stack
    - process control block
      - identifiers
        - numeric identifiers that may be stored with proceess control block include
        - id: unique key for the process
        - id for parent process
        - user id
        - this is defined by `pid_t`
      - process state info
        - user-visible registers
          - user-visible register is one that may be referenced with the machine language the processor executes while in user mode.
          - might be as low as only 1 working register
        - control and status registers
          - a variety of processor regsiters to control operation, including:
            - program counter: address of next instruction to fetch
            - condition codes: result of most recent arithmetic or logical op
            - status info: includes interrupt enabled/disabled flags, execution mode
        - processor state info
        - stack pointers
        - process control info
          - meta info for handling processes
          - scheduling and state info
          - linked list for child processes
          - linked list for same priority processes
          - linked list for "cohort" processes
        - importance
        - interprocess communication
          - flags, signals, messages which may be associated with communication between two independent processes
        - process privileges
          - types of instructions that can be executed
        - memory management
          - pointers to segment/page tables for virtual memory assignment
        - resource ownership and utilization
          - resources controlled by process, such as opened files
        - contents of processor registers
        - Program Status Word
        - current mode of execution
          - user mode: less trusted
          - system mode: more privileged


### Process creation
1. Assign unique PID
2. Allocate space
3. Initialize PCB
4. Set up appropriate links (e.g. add new process to linked list for scheduling queue)
5. Create and expand other data structures, e.g. accounting file

### When to switch processes
- clock interrupt
- IO interrupt
- memory fault
- trap (used for debugging)
- supervisor call


#### Steps to switch
1. Save context of processor (PC and other registers)
2. Update PCB of the process currently running
3. Move PCB to appropriate queue: ready, blocked, ready/suspend
4. Seect another process to execute

#### Change of Process State
- update PCB of selected process
- update memory management structures
- restore context of selected process

