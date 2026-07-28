#include <ctime>
#include <linux/limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>

int print_file(char *filename) {
    FILE *fpt;
    fpt = fopen(filename, "r");
    if (fpt == NULL) {
        printf("Error: Could not open file.\n");
        return 1;
    }
    int text;
    while ((text = fgetc(fpt)) != EOF)
        printf("%c", text);
    fclose(fpt);
    return 0;
}

int file_metadata(char *filename) {
    FILE *fpt;
    fpt = fopen(filename, "r");
    struct stat file_stat;
    // Call stat() and check if it succeeds (returns 0)
    if (stat(filename, &file_stat) != 0) {
        perror("Error opening file");
        return 1;
    }

    // 1. Print File Size (cast to long long for safety)
    printf("File Size:       %lld bytes\n", (long long)file_stat.st_size);

    // 2. Print Owner UID
    printf("Owner UID:       %ld\n", (long)file_stat.st_uid);

    // 3. Print Permissions in Octal format
    printf("Permissions:     %o\n", file_stat.st_mode & 0777);

    // 4. Print Number of Hard Links
    printf("Hard Links:      %ld\n", (long)file_stat.st_nlink);

    // 5. Print Last Modification Time
    // ctime() converts the time_t timestamp into a readable string
    printf("Last Modified:   %s", ctime(&file_stat.st_mtime));

    return 0;

}


