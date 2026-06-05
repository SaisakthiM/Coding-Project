#include <algorithm>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <iostream>
#include "log.h"
#include <memory>
#include <sys/mman.h>


using namespace std;

class Log;

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

    Log log;
    log.printLog('a');
    int a = 10;
    int* ptr = &a;
    *ptr = 100;
    std::cout << a << std::endl;

    int** ptr1 = &ptr;
    **ptr1 = 19;
    std::cout << a << endl;

    int& r = a;
    r = 199;
    

    std::cout << a << std::endl;
    return 0;
}