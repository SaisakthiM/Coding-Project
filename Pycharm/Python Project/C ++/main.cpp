#include <iostream>
using namespace std;

int main(){
    double sales = 95000;
    double country_tax = 0.04;
    double state_tax = 0.02;
    cout << "Sales Before Tax = " << sales << endl;
    cout << "Sales After Country Tax = " << sales - (sales * country_tax) << endl;
    cout << "Sales After Country Tax and State tax = " << sales - (sales * (country_tax + state_tax)) << endl;
}




















