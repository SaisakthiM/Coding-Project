#include <iostream>

int main() {
    int enemiesHP[] = {100, 80, 60, 120};

    int* p = enemiesHP;

    p++;
    std::cout << *p;
    
    return 0;
}