#include <stdio.h>
#include<ctime>
#include <iostream>
#include <cmath>

int main() {
    // pseudo-random = NOT truly random (but close)
    srand(time(NULL));
    int num = (rand() % 2222222);
    std::cout << num;
    return 0;
}