# Processes

- Inter-process communication in Linux is costly because it requires context switching from user to kernel space and back
- Threads in the same process communicate through shared memory
  - Implemented by running threads in kernel-space **lightweight processes** with shared resources

## Multi-threaded servers
- Often follows a **dispatcher/worker** pattern

## Virtualization
- e.g. running in a VM like the Java Runtime Environment or a virtual machine monitor (VMM)
- VMM benefits:
  - live migration allows load balancing and proactive maintenance
  - VM replication improves availability and fault tolerance

## Server clusters
Typically in three tiers:
1. Logic switch
2. Application/compute servers
3. Distribute file/database systems
