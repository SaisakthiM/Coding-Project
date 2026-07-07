#include <math.h>
#include <stdio.h>
#include <string.h>

int find() {
    int a;
    printf("Enter a number : ");
    scanf("%d",&a);

    for (int i = a; i > 0; i--) {
        int r = (int)sqrt(i);
        if (r * r == i) {
            printf("nearest square number is : %d", i);
            return 0;
        }
    };
    printf("no near square number");
    return 0;
}

int sum_of_digits() {
    int b;
    printf("Enter a number : ");
    scanf("%d",&b);

    int sum = 0;
    char str[10];
    sprintf(str, "%d", b);

    for (int i = 0; i < strlen(str); i++) {
        sum += (int) str[i] - '0';
    }
    return sum;

}

int main() {
    char a = 253;
    printf("%c",a);
}