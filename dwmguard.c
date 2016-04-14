/*
 *  dwmguard.c
 *  author: Aleksei Kozadaev (2016)
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

#define DWM     "/usr/local/bin/dwm"

int
main(void)
{
    int running = 1, status;
    pid_t pid;

    while (running > 0) {
        pid = fork();
        switch(pid) {
            case 0:
                execl(DWM, DWM, NULL);
                perror("execv");
                exit(1);
            case -1:
                perror("fork");
                exit(1);
            default:
                if (wait(&status) < 0) {
                    perror("wait");
                    exit(1);
                }
                if (WIFEXITED(status)) {
                    running = (WEXITSTATUS(status) != 0);
                } else if (WIFSIGNALED(status)) {
                    printf("process %d killed: signal %d\n", pid,
                           WTERMSIG(status));
                    exit(WTERMSIG(status));
                }
                break;
        }
    }

    return EXIT_SUCCESS;
}
