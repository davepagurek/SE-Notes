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
  - Algorithm: best fit vs next fit
  - buddy system: creates smaller and smaller blocks to fit things in


## Relocation
- A process may switch memory locations

### Addresses
- Logical: reference to a memory location independent of current assignment of data. Translation must be made to physical
- Relative: Address expressed as a location relative to some point
  - Uses base register, bounds register, adder, comparator
- Physical: absolute address

## External fragmentation
### Paging
- partition memory into small equal fixed sized chunks. Divide each process into the same sized chunks
- Chunks of a process are pages, chunks of memory are frames
- OS maintains a page table for each process
  - contains frame location for each page in process
  - memory address is a **page number and offset**
- Logical to physical is still done by hardware
  - logical address: page, offset
  - physical address: frame, offset
  - The memory address is now a 16 bit logical address: 6 bit page, 10 bit offset
    - The page part goes through the page table lookup, and then the offset gets added
- Program divided into **segments**
  - all segments do not have to be the same length
  - max segment length exists
  - since segments are not wqual, segmentation is similar to dynamic partitioning
    - programs can have more segments but only one partition
      - e.g. 4 bit segment, 12 bit offset
      - Segment goes through process segment table (has length and base), offset then added


# Virtual Memory
- Create your memory on demand
  - Onreads, load memory from disk
  - when unused, write to disk
- Runtime address translation (paging/segmentation) enables noncontiguous memory layouts
