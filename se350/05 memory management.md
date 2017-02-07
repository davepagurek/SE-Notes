# Memory Management
Responsible for dividing memory to accomodate multiple processes

## Relocation
- Programmer doesn't know where the pmemory will be placed when executed
- While program is executing, it may be swapped to disk and returned to memory in a new location
- Memory references must be translated in the code to actual physical memory address

## Requirement
- PCB
- Program
- Data, referenced by program
- Stack

### Protection
- Shouldnt be able to reference memory locations from another process without permission
- Impossible to check the absolute address at compile time

### Logical organization
- programs written in modules
- modules can be written and compiled independently
- different degrees of protection given to modules (read only, execute only)
- share modules among processes

## Strategies
- Equal sized partitions
- Fixed partitioning
- Dynamic partitioning: assign resources dynamically when asked
  - Problem: you get gaps and holes in memory when processes terminate
