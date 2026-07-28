#include <stdio.h>
#include <dirent.h>
#include <ctype.h>

int list_process() {
    DIR *dpt;
    dpt = opendir("/proc");
    if (dpt == NULL) {
        printf("Cannot Open the processes");
        return 1;
    }
    struct dirent *entry;
    while (1) {
        entry = readdir(dpt);
        if (entry == NULL) {
            break;
        }
        if (isdigit(entry->d_name[0])) {
            printf("PID: %s\n", entry->d_name);
        }
    }
    closedir(dpt);
    return 0;
}

int proc_status(const char *pid){
    char path[256];
    snprintf(path, sizeof(path), "/proc/%s/status", pid);
    FILE *fpt = fopen(path, "r");
    if (fpt == NULL) {
        perror(path);
        return 1;
    }
    int ch;
    while ((ch = fgetc(fpt)) != EOF)
        putchar(ch);
    fclose(fpt);
    return 0;
}