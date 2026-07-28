#include "files/files.h"
#include "directories/directories.h"
#include "processes/processes.h"
#include "devices/devices.h"
#include <stdio.h>
#include <string.h>

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage...\n");
        return 1;
    }
    else if (!strcmp(argv[1], "directory") && argv[2] == NULL) {
        list_current_dir();
    }
    else if (!strcmp(argv[1], "directory") && argv[2] != NULL) {
        list_given_dir(argv[2]);
    }
    else if (!strcmp(argv[1], "files") && argv[2] != NULL) {
        if (!strcmp(argv[1], "files") && !strcmp(argv[2], "metadata") && argv[3] != NULL) 
            file_metadata(argv[3]);
        else if (!strcmp(argv[1], "files") && !strcmp(argv[2], "print") && argv[3] != NULL) 
            print_file(argv[3]);
        else 
            print_file(argv[2]);
    }
    else if (!strcmp(argv[1], "devices") && argv[2] == NULL) {
        list_devices();
    }
    else if (!strcmp(argv[1], "files") && !strcmp(argv[2], "metadata") && argv[3] != NULL) {
        file_metadata(argv[3]);
    }
    else if (!strcmp(argv[1], "process") && argv[2] == NULL) {
        list_process();
    }
    else if (!strcmp(argv[1], "process") && !strcmp(argv[2], "status") && argv[3] != NULL) {
        proc_status(argv[3]);
    }
}