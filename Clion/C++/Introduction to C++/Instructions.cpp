    /*#include <iostream>
using namespace std;
int main() // Start of the main function
{
    cout << "\n\n Check the upper and lower limits of integer :\n"; // Outputting a message for checking integer limits
    cout << "--------------------------------------------------\n"; // Outputting a separator line

    // Outputting the maximum and minimum limits of various data types
    cout << " The maximum limit of int data type :                  " << INT_MAX << endl;
    cout << " The minimum limit of int data type :                  " << INT_MIN << endl;
    cout << " The maximum limit of unsigned int data type :         " << UINT_MAX << endl;
    cout << " The maximum limit of long long data type :            " << LLONG_MAX << endl;
    cout << " The minimum limit of long long data type :            " << LLONG_MIN << endl;
    cout << " The maximum limit of unsigned long long data type :   " << ULLONG_MAX << endl;
    cout << " The Bits contain in char data type :                  " << CHAR_BIT << endl;
    cout << " The maximum limit of char data type :                 " << CHAR_MAX << endl;
    cout << " The minimum limit of char data type :                 " << CHAR_MIN << endl;
    cout << " The maximum limit of signed char data type :          " << SCHAR_MAX << endl;
    cout << " The minimum limit of signed char data type :          " << SCHAR_MIN << endl;
    cout << " The maximum limit of unsigned char data type :        " << UCHAR_MAX << endl;
    cout << " The minimum limit of short data type :                " << SHRT_MIN << endl;
    cout << " The maximum limit of short data type :                " << SHRT_MAX << endl;
    cout << " The maximum limit of unsigned short data type :       " << USHRT_MAX << endl;

    cout << endl; // Outputting a blank line for better readability

    return 0; // Returning 0 to indicate successful program execution
}

Typedef Function :
 It is very useful for Customising an built-in function . we can assign an new name to Built-in functions
 reserved keyword used to create an additional name (alias) for another data type.
New identifier for an existing type
Helps with readability and reduces typos
Use when there is a clear benefit
Replaced with 'using' (work better w/ templates)

 eg : typedef std::string String;

Using Function :
 It is same as Typedef but more easy. here (=) symbol is used

 eg : using ha = int

 Ternary Operator :

 ternary operator ?:= replacement to an if/else statement
condition? expression1: expression2;

Logical Operator:

 && : checks if the both condition are true
 ! : reverses the given condition
 || : checks if any one condition are true

 eg :

 #include <iostream>


int main() {
    int x;
    std::cout << "Enter a Number :";
    std::cin >> x;

    x >= 60 ? std::cout << "You pass" : std::cout << "You Fail";
}



Problem 2 :

 Calculating Area Of Circles

 #include <iostream> // Including the input-output stream header file
#include <cmath>

int main(){
    std::string x = "Enter The Value Of radius in cm :";
    std::cout << x;
    double y;
    std::cin >> y;
    double area = (22/7) * pow(y,2);
    std::cout << "The Area Of Given Radius is :" << area << "cm" << std::endl;
    return 0;

}

Data Types :

 C++ : It has a statistically - typed data types that is ,

 user is required to assign an integer value before declaring
 this declaration comes handy when value is assigned because user cannot change data types

 Python : It has Dynamically - typed data tye
 the user is not required to type data types and user can anytime change the data type,
 the computer can change its data type after assigning

 int main() {
    int k = 0;
    std::cout << k << std::endl;
    return -1;

}
data types :
    every code in any program is divided into different datas

#include <iostream>
int main() {
    char a = 'q';
    std::string b = "Hi";
    int c = 1;
    long int j = 100;
    const std::string t = "iirkn";
    float i = 10.3;
    double q = 10.2029;
    bool k = true;
    std::cout << a << b <<  c << j << i << q << k << std::endl;
}




 Creating a List :

 List : It is an Collection Of Elements in an Array
 The Elements can be accessed by index value assigned to it

 To Create In C++ :

 Method 1) :
    # include <iostream>

    int main() {
    int nums[] = {1,2,3};
    std::cout << nums[0] << std::endl;
    }

    the above method in an data-fixed dynamic array that is it can only have what type we assigned
    (To simply say if we assigned int , we cannot add string to this list)

 Method 2) :
    # include <iostream>

    int main() {
    int nums[10] = {1,2,3};
    std::cout << nums[0] << std::endl;
    }

    the above method in an data-fixed static array that is it can only have what type we assigned
    also we cannot add more elements
    Q) Why We can't Add More Elements!
    Ans) It is because when we assingn any number inside square bracket,
    it is going to pre-assign the space in RAM and it cannot extend the space if the capacity exceeded


    (To simply say if we assigned int , we cannot add string to this list)


 Functions in C++ :
        A Function in a C.S is a set of instructions or actions which modify or affect the input user gives

To Create a Function:
    Syntax:
    (Return Data Type) (Name of Function) (variables){
    }

    Special Function main() {
    } : It gets executed even when

    Pre - Requirements for Creating Function :

    1)Assigning Return Type:
        It is important in C++ that the user have to assign the return type so that it can convert the result faster

 Return Types For Functions :
 Void : It is not going to return anything

 Calling an Function :
 Syntax :

 int main() {
    function name();
    }


 If statements :

 if statements acts according to the given condition
 if the given condition is true , the below following code gets executed
 else the (else) line gets executed
 there are 3 types of giving if statements

 if statments :

 Syntax :
 if (condition) {
    code or instructions
}
 if the condition is false it returns nothing

 else if statement:
 Syntax :
 if (i && o){
        std::cout << "True" << std::endl;
    }
    else if (i){
        std::cout << "True" << std::endl;
    }
    else if (o){
        std::cout << "False" << std::endl;
    }
    else{
        std::cout << "True" << std::endl;
    }

 if the top condition is false , it goes to (else if) . if (else if) is false , it goes to (else)

 Syntax :
 if (condition) {
    code or instructions
}
 else{
    code
}
 if the condition is false the lese condition becomes true and gets executed

 if , elseif statments :

 nested if statments :

 if (condition) {
    if (condition) {
        code or instructions
    }
}

 in nested if statements , the condition has to satisfy both of the conditions to get the line executed
 we can also include else statements if neeeded


 Type Conversion :
 conversion a value of one data type to another
Implicit : automatic
Explicit = Precede value with new data type (int) |

int main(){
    double x = (int) 10.3;
    std::cout << x << std::endl;
    return 0;
}


 Math related Functions :

 # include <iostream>
#include <valarray>


int main(){
    double x = 10;
    double y = 19;
    double z;
    double i;
    double j;
    double k;
    double l;
    double m;
    double o;

    z = std::max(x,y);
    i = std::min(x,y);
    j = std::sqrt(9);
    m = std::abs(-12);
    k = std::round(20.45);
    l = std::ceil(28.5);
    o = std::floor(182.23);

    double p[] = {z,i,j,k,m,k,l,o};

    std::cout << p << std::endl;
}

 Switch Statments :

 It is used to reduce the amount of else if statements.

 eg : # include <iostream>

int main(){
    int month;
    printf("Enter the month (1-12) : ");
    std::cin >> month;
    switch (month) {
        case 1:
            std::cout << "It is January" << std::endl;
            break;
        case 2:
            std::cout << "It is February" << std::endl;
            break;
        case 3:
            std::cout << "It is March" << std::endl;
            break;
        case 4:
            std::cout << "It is April" << std::endl;
            break;
        case 5:
            std::cout << "It is May" << std::endl;
            break;
        case 6:
            std::cout << "It is June" << std::endl;
            break;
        case 7:
            std::cout << "It is July" << std::endl;
            break;
        case 8:
            std::cout << "It is August" << std::endl;
            break;
        case 9:
            std::cout << "It is September" << std::endl;
            break;
        case 10:
            std::cout << "It is October" << std::endl;
            break;
        case 11:
            std::cout << "It is November" << std::endl;
            break;
        case 12:
            std::cout << "It is December" << std::endl;
            break;
    }
}


int main(){
    char grade;
    printf("Enter Your Grade (A-F) : ");
    std::cin >> grade;
    switch (grade) {
        case 'A':
            std::cout << "It's Between 91-100" << std::endl;
            break;
        case 'B':
            std::cout << "It's Between 81-90" << std::endl;
            break;
        case 'C':
            std::cout << "It's Between 71-80" << std::endl;
            break;
        case 'D':
            std::cout << "It's Between 61-70" << std::endl;
            break;
        case 'E':
            std::cout << "It's Between 51-60" << std::endl;
            break;
        case 'F':
            std::cout << "You are Fail" << std::endl;


    }
}

 console calculator :

 int main(){
    char op;
    double num1;
    double num2;
    printf("This is a calculator. Enter Number 1 :");
    std::cin >> num1;
    printf("Enter Number 2 :");
    std::cin >> num2;
    printf("Enter The Operator :");
    std::cin >> op;

    switch (op) {
        case '+':
            std::cout << num1+num2 << std::endl;
            break;
        case '-':
            std::cout << num1-num2 << std::endl;
            break;
        case '*':
            std::cout << num1*num2 << std::endl;
            break;
        case '/':
            std::cout << num1/num2 << std::endl;
            break;
    }

}

random number generator :
Note: The numbers generated are not truly random
they are called pseudo-random for a reason

int main() {
    // pseudo-random = NOT truly random (but close)
    srand(time(NULL));
    int num = (rand() % 100)] + 1;
    std::cout << num;
    return 0;
}



















































 */