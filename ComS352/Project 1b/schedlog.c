#include "types.h"
#include "param.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"
#include "schedlog.h"

struct logentry schedlog[SCHED_LOG_SIZE];
int schedlognext = 0;

int logproc(struct proc* p, enum procstate fromstate, enum procstate tostate) {
    if (schedlognext == SCHED_LOG_SIZE) {
        return -1; // log is full, return with error code
    }
    struct logentry* l = &schedlog[schedlognext];
    l->pid = p->pid;
    l->fromstate = fromstate;
    l->tostate = tostate;
    l->time = ticks;
    schedlognext++;
    return 0;
}
