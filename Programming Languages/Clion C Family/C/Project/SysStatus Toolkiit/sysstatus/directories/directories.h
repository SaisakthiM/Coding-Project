#include <dirent.h>
#include <stdio.h>

void list_current_dir() {
    DIR *dpt;
    dpt = opendir(".");
    struct dirent *entry;
    while (1) {
        entry = readdir(dpt);
        if (entry == NULL) {
            break;
        }
        printf("%s\n", entry->d_name);
    }
    closedir(dpt);
}

void list_given_dir(char *location) {
    DIR *dpt;
    dpt = opendir(location);
    struct dirent *entry;
    while (1) {
        entry = readdir(dpt);
        if (entry == NULL) {
            break;
        }
        printf("%s\n", entry->d_name);
    }
    closedir(dpt);
}

