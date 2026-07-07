#include <cstdio>
#include <inttypes.h>
#include <stdio.h>

int main(){
    int x = 10;
    double y = 10.2;
    float z = 13.22;
    char a = 'a';
    
    printf("%f", y);
    printf("%d", x);
    printf("%c", a);
    printf("%f", z);

    a = scanf("Enter a : ");
    int b = std::scanf();
    char operator[3] = scanf("Enter the operation in first 3 letters : ")

}

int calculator(int a, int b, char operator[3]) {
    if (operator == "add") {
        return a + b;
    }
    else if (operator == "sub") {
        return a - b;
    }
    else if (operator == "mul") {
        return a * b;
    }
    else if (operator == "div") {
        if ( b == 0 ) {
            printf("divisor cannot be 0");
        }
        else {
            return a / b;
        }
    }
    else {
        printf("wrong option");
    }
}