#include <iostream>
using namespace std;

int main() {
    int *p = new int(10);
cout << *p << endl;
delete p;
cout << *p;   // What happens if you uncomment this line?
}
