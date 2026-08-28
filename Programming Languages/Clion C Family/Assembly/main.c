#include <stdio.h>
#include <stdlib.h>
int main() {
    FILE *fpt = fopen("output.txt", "r");
    if (fpt == NULL) {
        perror("Error opening file");
        return 1;
    }

    fseek(fpt, 0, SEEK_END);
    long fileSize = ftell(fpt);
    rewind(fpt); 

    char *buffer = (char *)malloc(fileSize + 1);
    if (buffer == NULL) {
        perror("Memory allocation failed");
        fclose(fpt);
        return 1;
    }

    size_t bytesRead = fread(buffer, 1, fileSize, fpt);
    buffer[bytesRead] = '\0';

    printf("%s", buffer);

    // 5. Clean up resources
    free(buffer);
    fclose(fpt);
    return 0;
    
}