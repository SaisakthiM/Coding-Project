#include <iostream>
#include <string>
using namespace std;

class Car{
    public: 
        string model;
    void printModel() {
        std::cout << model;
    }
};
int main(){
    Car car = *new Car;
    car.model = "name";
    car.printModel();

}