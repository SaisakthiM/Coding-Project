#include <ctype.h>
#include <stdio.h>



int main(int argc, char *argv[]) {
    FILE *fpt = fopen(argv[1], "r");
    int lines = 0;
    int words = 0;
    int characters = 0;

    if (fpt == NULL) {
        printf("Error : Could not open the file");
        return 1;
    }

    int ch;
    while ((ch = fgetc(fpt)) != EOF) {
        if (ch == 10) {
            lines += 1;
        }
        if (isspace(ch)) {
            words += 1;
        }
        characters += 1;
    }
    fclose(fpt);
    printf("Lines : %i \n", lines);
    printf("Words : %i \n", words);
    printf("Characters : %i \n", characters);
}