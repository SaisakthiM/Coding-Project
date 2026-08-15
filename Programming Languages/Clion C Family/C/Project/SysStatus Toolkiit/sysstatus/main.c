#include "files/files.h"
#include "directories/directories.h"
#include "processes/processes.h"
#include "devices/devices.h"
#include "cpu/cpu.h"
#include "memory/memory.h"
#include "disk/disk.h"
#include "uptime/uptime.h"
#include "battery/battery.h"
#include <stdio.h>
#include <string.h>

void print_help() {
    printf("========================================\n");
    printf(" SYSSTATUS - Usage\n");
    printf("========================================\n");
    printf("  directory                  List current directory\n");
    printf("  directory <path>           List given directory\n");
    printf("  files <file>               Print file contents\n");
    printf("  files print <file>         Print file contents\n");
    printf("  files metadata <file>      Print file metadata\n");
    printf("  devices                    List devices in /dev\n");
    printf("  process                    List running processes\n");
    printf("  process status <pid>       Show status for a process\n");
    printf("  cpu                        Show CPU information\n");
    printf("  memory                     Show memory information\n");
    printf("  disk                       Show disk usage for '/'\n");
    printf("  disk <path>                Show disk usage for a given path\n");
    printf("  uptime                     Show system uptime\n");
    printf("  battery                    Show battery status\n");
    printf("  help                       Show this help message\n");
    printf("========================================\n");
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        print_help();
        return 1;
    }
    else if (!strcmp(argv[1], "help")) {
        print_help();
    }
    else if (!strcmp(argv[1], "directory") && argv[2] == NULL) {
        list_current_dir();
    }
    else if (!strcmp(argv[1], "directory") && argv[2] != NULL) {
        list_given_dir(argv[2]);
    }
    else if (!strcmp(argv[1], "files") && argv[2] == NULL) {
        printf("Error: 'files' requires a filename.\n\n");
        print_help();
        return 1;
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
    else if (!strcmp(argv[1], "process") && argv[2] == NULL) {
        list_process();
    }
    else if (!strcmp(argv[1], "process") && !strcmp(argv[2], "status") && argv[3] != NULL) {
        proc_status(argv[3]);
    }
    else if (!strcmp(argv[1], "cpu")) {
        cpu_status();
    }
    else if (!strcmp(argv[1], "memory")) {
        memory_status();
    }
    else if (!strcmp(argv[1], "uptime")) {
        uptime();
    }
    else if (!strcmp(argv[1], "battery")) {
        battery_status();
    }
    else if (!strcmp(argv[1], "disk") && argv[2] == NULL) {
        disk_usage();
    }
    else if (!strcmp(argv[1], "disk") && argv[2] != NULL) {
        location_usage(argv[2]);
    }
    else {
        printf("Error: unrecognized command '%s'.\n\n", argv[1]);
        print_help();
        return 1;
    }
    return 0;
}