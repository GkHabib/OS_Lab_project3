#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

extern void print_invoked_syscalls(uint pid);
int
sys_invoked_syscalls(void)
{
  int pid;
  argint(0, &pid);
  print_invoked_syscalls(pid);
  return 0;
}

extern void my_sort_syscalls(uint pid);
int
sys_sort_syscalls(void)
{
  int pid;
  argint(0, &pid);
  my_sort_syscalls(pid);
  return 0;
}

extern void my_get_count(uint pid, uint sysnum);
int
sys_get_count(void)
{
  int pid;
  argint(0, &pid);
  int num;
  argint(1, &num);
  my_get_count(pid, num);
  return 0;
}

extern void my_log_syscalls(void);
int
sys_log_syscalls(void)
{
  my_log_syscalls();
  return 0;
}

extern void my_ticketlockinit(void);
int
sys_ticketlockinit(void)
{
  my_ticketlockinit();
  return 0;
}

extern void my_ticketlocktest(void);
int
sys_ticketlocktest(void)
{
  my_ticketlocktest();
  return 0;
}

