/*
area.c : To find the area of a circle 
Author : RT Surya
Date : 23-09-2026
*/
#include <stdio.h>


# define PI 3.14

float area;

int main() {
    int r;
    printf("Enter the radius : ");
    scanf("%d",&r);
    double area = PI * r * r;
    printf("Area : %f" ,area);
    
}


