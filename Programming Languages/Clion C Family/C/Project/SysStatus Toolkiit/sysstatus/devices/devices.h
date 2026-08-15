
#include <dirent.h>
#include <filesystem>
#include <stdio.h>
#include <sys/stat.h>

void list_devices() {
    DIR *dpt;
    dpt = opendir("/dev/");
    printf("========================================\n");
    printf(" DEVICES: /dev\n");
    printf("========================================\n");
    struct dirent *entry;
    while (1) {
        entry = readdir(dpt);
        if (entry == NULL) {
            break;
        }
        char path[256];
        snprintf(path, sizeof(path), "/dev/%s", entry->d_name);
        struct stat info;
        if (stat(path, &info) == -1) {
            perror(path);
            continue;
        }
        if (S_ISCHR(info.st_mode))
            printf("  [CHAR]  %s\n", entry->d_name);

        else if (S_ISBLK(info.st_mode))
            printf("  [BLOCK] %s\n", entry->d_name);

        else if (S_ISDIR(info.st_mode))
            printf("  [DIR]   %s\n", entry->d_name);

        else if (S_ISLNK(info.st_mode))
            printf("  [LINK]  %s\n", entry->d_name);
    }
    closedir(dpt);
    printf("========================================\n");
}