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

### Required algorithms
- fetch policy
- replacement policy
- placement policy
- cleaning policy
- load control

#### Fetch Policy
- determines when apage is brought into memory
- demand paging only brings pages into main memory when a reference is made to the location on the page
  - many page faults when process first started
- prepaging brings in more pages than needed
  - more efficient to bring in pages that rely contiguously on the disk

#### Placement Policy
- Determines where in real memory a process piece is to reside
- important in a segmentation system (you need to try to minimize fragmentation)
- paging/segmentation hardware performs address translation

#### Replacement
- which should be replaced
- should try to remove the page least likely to be referenced in the near future
- most policies predict future behaviour based on past behaviour
- policy concepts
  - how many page frames allocated to each active process? (Fixed, variable)
  - local vs global scope for replacing page frames in main memory
  - which of the candidate pages is picked?
- frame locking
  - restricts placement policy
  - if locked, may not be replaced
  - used in kernel, key control structures, io buffers, time critical elements
  - associate a lock bit to each frame
- algorithms
  - Optimal
    - selects the page for removal for which the time to the next reference is the longest
    - impossible to know future events though
  - Least Recently Used
    - nearly as good as optimal
    - replaces the page that has not been referenced for the longest time
    - need to store access time for every page
  - First in first out
    - page that has been in memory the longest is replaced
    - old pages assumed to not be referenced soon
    - pages removed in round robin style
    - simple to implement
  - Clock policy (approximates LRU)
    - Adds additional bit called the **use bit**
    - when a page is first loaded, set the bit to 1
    - when the page is referenced, set the bit to 1
    - when it is time to replace a page, first frame with 0 removed
    - in each replacement, each 1 is reset to a 0
  - Page buffering
    - implements a cache for memory pages
    - replaced page is added to one of two lists:
      - free, if page has not been modified
      - modified, if it has
    - OS can revive these if space becomes available
    - supports bursty block writes of IO
- Resident Set: pages of a process in memory
  - smaller the amount, the more processes
  - too small means high page fault rate
  - too large means no real gain
  - size
    - fixed allocation: gives process fixed number of pages. when a fault occurs, one of the pages of that process must be replaced
      - decide ahead of time the amount of allocation to give a process (hard)
      - if allocation too small, high fault rate
      - if too large, too few programs in main memory, processor is idle
    - variable allocation: number of pages varies over lifetime of process
      - global scope
        - easiest to implement
        - OS keeps list of free frames
        - free frame is added to resident set of process when a page fault occurs
        - if no free frame, replaces anyone
      - local scope
        - easiest to implement, used frequently in OSes
        - OS has list of free frames. Free frame added to resident set when a page fault occurs
        - If no frame is free, replaces anyone
        - risk: process can suffer reduction of resident set size
- Working set: set of pages of the process that have been referenced in the last $t$ time units
  - Using the working set:
    - monitor the working set of each process
    - remove pages from resident set but not working set (least recently used)
    - process may only execute if its working set is in main memory
  - Problems
    - past doesn't always predict the future
    - impractical
    - optimal window size is unknown and varies: observe page fault frequency to figure out best values
  - Cleaning policy
    - demand cleaning: page written out only when selected for repalcement. Requires two page transfers per fault
    - pre-cleaning: pages written out in batches. Bursty IO in favor of possibly unnecessary writes
    - page buffering:
      - pages in two lists, modified and unmodified
      - pages in modified list are periodically written out in batches
      - unmodified are either reclaimed if refrenced again or lost when frame is assigned to another page
- Load control
  - determines number of processes in resident set in main memory
  - too few processes means many occasions when all processes blocked. lots of time spent swapping
  - too many processes leads to thrashing
  - process suspension
    - lowest priority
    - faulting process: doesn't have resident set in memory anyway
    - last process activated: least likely to have working set resident
    - process with smallest resident set: requires least future effort to load
    - largest process: obtains most free frames by suspending

