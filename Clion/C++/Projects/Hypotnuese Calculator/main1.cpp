#include <cmath>
#include <iostream>
#include <stdio.h>
#include <math.h>

int hypotenuse(float x, float y) {
    return sqrtf(pow(x,2)+pow(y,2));
}


int main(){
    float a;
    printf("Enter First Number : ");
    std::cin >> a;
    float b;
    printf("Enter Second Number : ");
    std::cin >> b;
    std::cout << "The Result of Hypotenuse is : " << hypotenuse(a, b);
}