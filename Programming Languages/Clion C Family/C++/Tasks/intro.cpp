#include <algorithm>
#include <cstdio>
#include <iostream>
#include "log.h"
#include <memory>
using namespace std;

int sum(int a, int b) {
    return a+b;
}

int multiply(int a, int b) {
    return a*b;
}

extern int divide(int a, int b) {
    return a/b;
}

void story(char a) {
    if (a == 'a') {
        cout << "hi" << endl;
    }
    else if (a == 'b') {
        cout << "hello" << endl;
    } 
    else {
        cout << "who" << endl;
    }
}

int main() {
    string s = "saisakthi";
    /*
    printf("%s", s.c_str());
    log(1);
    bool a = -1;
    printf("%s", (char*) a);
    story('a');
    */
    std::cout << "hello world" << std::endl;
    unsigned int x = 10;
    cout << x << endl;
    cout << x << endl;
    cout << sizeof(float) << endl;
    cout << multiply(1, -1) << endl;
    for (; ; ) {
        std::allocator<double> alloc;
        double* raw_array = alloc.allocate(100);
        raw_array[0] = 1;
    }

    return 1;
}