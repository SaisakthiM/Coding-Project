#include <iostream>
using namespace std;
int x = 10;

void change() {
    int x = 20;
    x++;
    cout << x;
}

int main() {
    change();
    cout << x;
}
