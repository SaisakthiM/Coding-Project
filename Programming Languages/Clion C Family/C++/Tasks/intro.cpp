#include <cstddef>
#include <iostream>
#include <string>
#include <vector>
using namespace std;

int sum(int a, int b) {
    return a+b;
}

int multiply(int a, int b) {
    return a*b;
}

int divide(int a, int b) {
    return a/b;
}

int main() {
    std::cout << "hello world" << std::endl;
    unsigned int x = 10;
    cout << x << endl;
    cout << x << endl;
    cout << sizeof(float) << endl;
    cout << multiply(1, -1) << endl;

    return 1;
}