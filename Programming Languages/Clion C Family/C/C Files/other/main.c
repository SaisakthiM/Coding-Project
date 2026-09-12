
/*
Program : To find whether a given number is positive or negative
*/

#include <stdio.h>

int main() {
    int i = 0;
    while (i < 3) {
        printf("%d\n", i);
        i++;
    }
    printf("%d\n", i);

    i = 0;
    while (i < 3) {
        printf("%d\n", i);
        ++i;
    }
    printf("%d\n", i);

    // Both are same but here is the difference 

    printf("\n\n");

    int x = i++;
    printf("%d\n", x);
    printf("%d\n", i);
    // x gets assigned value of i then i is added 

    int y = ++i;
    printf("%d\n", y);
    printf("%d\n", i);
    // i is added first and then assigned value so both will be same value


    return 0;
}





