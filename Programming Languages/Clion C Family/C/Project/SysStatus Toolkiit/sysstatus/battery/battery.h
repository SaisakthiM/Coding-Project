#include <cstdio>
#include <dirent.h>
#include <stdint.h>


void print_battery_file(const char *path) {
    FILE *fpt = fopen(path, "r");
    if (fpt == NULL) {
        perror(path);
        return;
    }

    char text[256];

    if (fgets(text, sizeof(text), fpt) != NULL)
        printf("%s", text);

    fclose(fpt);
}

void battery_status() {
    printf("========================================\n");
    printf(" BATTERY STATUS\n");
    printf("========================================\n");

    printf("Capacity : ");
    print_battery_file("/sys/class/power_supply/BAT0/capacity");

    printf("Status   : ");
    print_battery_file("/sys/class/power_supply/BAT0/status");

    printf("Voltage  : ");
    print_battery_file("/sys/class/power_supply/BAT0/voltage_now");

    printf("Current  : ");
    print_battery_file("/sys/class/power_supply/BAT0/current_now");

    printf("========================================\n");
}