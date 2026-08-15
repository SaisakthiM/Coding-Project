#include <cstdio>
#include <stdint.h>

int cpu_status() {
    FILE *fpt;
    fpt = fopen("/proc/cpuinfo", "r");
    if (fpt == NULL) {
        printf("Error: Could not open file.\n");
        return 1;
    }
    printf("========================================\n");
    printf(" CPU INFORMATION\n");
    printf("========================================\n");
    int text;
    while ((text = fgetc(fpt)) != EOF)
        printf("%c", text);
    fclose(fpt);
    printf("========================================\n");
    return 0;
}