#include <cstdio>
#include <stdint.h>

int memory_status() {
    FILE *fpt;
    fpt = fopen("/proc/meminfo", "r");
    if (fpt == NULL) {
        printf("Error: Could not open file.\n");
        return 1;
    }
    printf("========================================\n");
    printf(" MEMORY INFORMATION\n");
    printf("========================================\n");
    int text;
    while ((text = fgetc(fpt)) != EOF)
        printf("%c", text);
    fclose(fpt);
    printf("========================================\n");
    return 0;
}