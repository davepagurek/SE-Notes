# Uniprocessor Scheduling
## Priority Queueing
- scheduler will always choose higher priority processes over lower priority ones
- use multiple ready queues to represent multiple leverls of priority
- lower priority may be starved

## Multiprogramming
- nonpreemptive: once a process is in the running state, it continues until it terminates or gets blocked
- preemptive: current process may be interrupted and moved to ready state by OS. allows for better service since no one can monopolize the processor for too long
- cooperative

### First-come-first-served
- Non-preemptive
- each process joins the ready queue
- when the current process finishes, the oldest one in the queue is picked to run next
- short process may have to wait a long time before execution
- favors CPU-bound processes


### Round Robin (Time Slicing)
- Uses clock-based preemption
- Clock interrupt is generated at periodic intervals
- when interrupt occurs, the currently running process is put in the ready queue and next job is selected
- quantum size should be around the same size as the typical time of what they do between calls (e.g. UI)

### Shortest process next
- non preemptive
- process with shortest expected processing time is selected next based on estimation
- shorter porcesses jump ahead of larger ones
- predicatability of longer processes is reduced
- if estimation isn't correct, the OS can abort the process
- possible starvation of larger processe
- limitation: knowing service time


### Shortest Remaining Time
- preemptive version of SPN policy
- Must estimate processing time
- starvation of long processes still

### Highest Response Ratio Next
- Choose next process with greatest ratio of time spent waiting to how much time the system will spend executing
- accounts for aging to prevent starvation

### Feedback-based
penalize jobs that run longer
each time you are preemptive you go into a lower and lower priority queue

### Fair Share
- schedules processes as groups so if something spawns a bunch of processes, it doesnt get better treatement in the scheduler
