
#include <stdio.h>

# define pi 3.14

float area;

int main() {
    int r;
    printf("enter the radius");
    scanf("%d",&r);
    area = pi * r * r;
    printf("Area , %f",area);
}