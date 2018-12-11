#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"

#define NUMOFCHILDS 10

int main(int argc, char const *argv[])
{
    int pid;

    ticketlockinit();
    
    pid = fork();
    for (int i=0; i<NUMOFCHILDS; i++)
    {
        if(pid > 0) pid =  fork();
    }
    if (pid < 0)
    {
        write(2, "fork error!\n", 12);
    }
    else if (pid == 0)
    {
        write(1, "child", 5);
        write(1, &pid, 1);
        write(1, "adding to shared number...\n", 46);
        ticketlocktest();
    }
    else 
    {
        for (int i=0; i<NUMOFCHILDS; i++)
        {
            wait();
        }
        write(1, "program finished!\n", 18);
    }
    return 0;
}
