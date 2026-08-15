#include <dirent.h>
#include <stdio.h>

void list_current_dir() {
    DIR *dpt;
    dpt = opendir(".");
    if (dpt == NULL) {
        perror(".");
        return;
    }
    printf("========================================\n");
    printf(" DIRECTORY LISTING: .\n");
    printf("========================================\n");
    struct dirent *entry;
    while (1) {
        entry = readdir(dpt);
        if (entry == NULL) {
            break;
        }
        printf("  - %s\n", entry->d_name);
    }
    closedir(dpt);
    printf("========================================\n");
}

void list_given_dir(char *location) {
    DIR *dpt;
    dpt = opendir(location);
    if (dpt == NULL) {
        perror(location);
        return;
    }
    printf("========================================\n");
    printf(" DIRECTORY LISTING: %s\n", location);
    printf("========================================\n");
    struct dirent *entry;
    while (1) {
        entry = readdir(dpt);
        if (entry == NULL) {
            break;
        }
        printf("  - %s\n", entry->d_name);
    }
    closedir(dpt);
    printf("========================================\n");
}

