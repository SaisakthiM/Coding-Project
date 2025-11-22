#include <iostream>
#include <iterator>
#include <stdio.h>
#include <array>

float calculate(float x, float y, char cond) {
    switch (cond) {
        case '+':
            return x+y;
        case '-':
            return x-y;
        case '*':
            return x*y;
        case '/':
            return x/y;
        default: 
            return 1;
    }
}

std::array<int, 2> input() {
    int a, b;
    std::cout << "Enter First Number: ";
    if (!(std::cin >> a)) a = 0;
    std::cout << "Enter Second Number: ";
    if (!(std::cin >> b)) b = 0;
    return {a, b};
}

int main() {
    char c;
    auto val = input();
    std::cout << "Enter The Operation to be done : ";
    std::cin >> c;
    std::cout << "The Result was : " << calculate(val[0], val[1], c) << std::endl;

}

