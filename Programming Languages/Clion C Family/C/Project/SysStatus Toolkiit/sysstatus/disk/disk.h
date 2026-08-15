#include <assert.h>
#include <cstdio>
#include <sys/statvfs.h>

int disk_usage() {
    struct statvfs data;

    // Check statistics for the root file system
    if (statvfs("/", &data) != 0) {
        perror("statvfs error");
        return 1;
    }

    // Mathematical breakdown of disk metrics
    unsigned long long total_space = (unsigned long long)data.f_blocks * data.f_frsize;
    unsigned long long free_space  = (unsigned long long)data.f_bfree * data.f_frsize;
    unsigned long long avail_space = (unsigned long long)data.f_bavail * data.f_frsize;

    printf("========================================\n");
    printf(" DISK USAGE: /\n");
    printf("========================================\n");
    printf("Max filename length: %lu bytes\n", data.f_namemax);
    printf("Total Space:         %llu bytes (%.2f GB)\n", total_space, (double)total_space / (1024*1024*1024));
    printf("System Free Space:   %llu bytes (%.2f GB)\n", free_space, (double)free_space / (1024*1024*1024));
    printf("User Available:      %llu bytes (%.2f GB)\n", avail_space, (double)avail_space / (1024*1024*1024));
    printf("========================================\n");

    return 0;
}

int location_usage(char *location) {
    struct statvfs data;

    // Check statistics for the root file system
    if (statvfs(location, &data) != 0) {
        perror("statvfs error");
        return 1;
    }

    // Mathematical breakdown of disk metrics
    unsigned long long total_space = (unsigned long long)data.f_blocks * data.f_frsize;
    unsigned long long free_space  = (unsigned long long)data.f_bfree * data.f_frsize;
    unsigned long long avail_space = (unsigned long long)data.f_bavail * data.f_frsize;

    printf("========================================\n");
    printf(" DISK USAGE: %s\n", location);
    printf("========================================\n");
    printf("Max filename length: %lu bytes\n", data.f_namemax);
    printf("Total Space:         %llu bytes (%.2f GB)\n", total_space, (double)total_space / (1024*1024*1024));
    printf("System Free Space:   %llu bytes (%.2f GB)\n", free_space, (double)free_space / (1024*1024*1024));
    printf("User Available:      %llu bytes (%.2f GB)\n", avail_space, (double)avail_space / (1024*1024*1024));
    printf("========================================\n");

    return 0;
}