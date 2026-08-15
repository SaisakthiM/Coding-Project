#include <cstdio>
#include <stdint.h>

int uptime() {
    FILE *fpt;
    fpt = fopen("/proc/uptime", "r");
    if (fpt == NULL) {
        printf("Error: Could not open file.\n");
        return 1;
    }
    printf("========================================\n");
    printf(" SYSTEM UPTIME\n");
    printf("========================================\n");
    int text;
    while ((text = fgetc(fpt)) != EOF)
        printf("%c", text);
    fclose(fpt);
    printf("========================================\n");
    return 0;
}