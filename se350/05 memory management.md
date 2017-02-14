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
  - Programs can no longer directly access memory
  - A program can run successfully without loading the whole program into memory at once

## How it works
At any given time, we need to know:
- Next instruction to execute
- Next data to be accessed

When a program is executing, run the program until it tries to read or execute something not in ram (this is called a **page fault**). Then, block the process, read in the data, and resume the process. The **residence set** is the part of the program that is in memory.

### Performance
- lazy loading is a win
- but disk loads in batches is faster

### Functionality
- Can juggle more processes at once
- Process can extend a system's RAM size



## Replacement
- **Thrashing**: Constantly throwing out and reloading memory
- **Principle of locality**: stuff you need in the future is close to the stuf you needed in the past

## Support
- Hardware must support paging and segmentation
- OS must support putting pages on desk and reloading them from disk
- Now, virtual addresses have a page number and an offset
- The page table has entries with:
  - **Present** flag (is it currently loaded?)
  - **Modified** flag (has the page been modified since it has been loaded from disk)
  - other control bits
  - frame number
- You can put the page table in memory so it grows, but then you can get two page faults per memory request sometimes


## Inverted Page Tables
- Inverted means index on frame number, not virtual address
- inverted tables grow with the size of physical memory
- each virtual memory reference can cause two physical memory accesses
  - one to fetch page table entry
  - one to fetch data
- When a system is too slow, add caches with a **Translation Lookaside Buffer**
  - For normal operations, being in the TLB implies that the block is in main memory
  - the only time it might not be is in the function that moves memory from one spot to another
- smaller page size
  - less amount of internal fragmentation (less memory wasted in last page)
  - more pages required per process
  - more pages per process means larger page tables
  - larger page tables means large portion of page tables in virtual memory
  - more tlb entries and therefore more tlb misses
- larger page size
  - secondary memory is designed to efficiently transfer large blocks of data so a large page size is better
  - after a certain point, larger pages correlates with lower page fault rate

### Segmentation
allows programmer to view memory as consisting of multiple address spaces or segments
- advantages
  - simplifies handling of growing data structures (put whole structure into one segment)
  - allows programs to be altered and recompiled independently
  - sharing data amongst processes by sharing a segment
  - protect segments to have memory protection
- segment tables
  - starting address corresponding segment in main memory
  - each entry contains length of segment
  - bit is needed to determine if the segment is already in main memory
  - another bit needed to determine if the segment has been modified since being loaded
- paging transparent to programmer, segmentation is visible
- elements
  - 1 process
  - 1 segment table per process
  - 1 page table per segment
