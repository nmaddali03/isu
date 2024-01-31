#ifdef USER_LOG
enum procstate { UNUSED, USED, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };
struct proc* p;
#endif

#define SCHED_LOG_SIZE 128

struct logentry {
    int pid; // process id
    enum procstate fromstate;
    enum procstate tostate;
    int time; // time in ticks 
};

extern int logproc(struct proc* p, enum procstate fromstate, enum procstate tostate);
extern struct logentry schedlog[SCHED_LOG_SIZE];
extern int schedlognext;
