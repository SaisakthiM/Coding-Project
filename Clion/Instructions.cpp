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

    the above metnod in an data-fixed dynamic array that is it can only have what type we assigned
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

 
Temperature Converter :

 #include <iostream>
typedef std::string String;
int main(){
    printf("Hello , This is Temperature Converter.\n "
           "Basic Knowledge : There are 3 Commercial and Popular Units we use to measure temperature.\n "
           "Those are Celsius, Fahrenheit and Kelvin.\n"
           "To convert Celsius to Fahrenheit , Enter CF\n"
           "To convert Celsius to Kelvin , Enter CK\n"
           "To convert Fahrenheit to Celsius , Enter FC\n"
           "Enter your Choice : ");
    String ans;
    std::cin >> ans;

    if (ans == "CF") {
        double temperature;
        printf("Enter your temperature : ");
        std::cin >> temperature;
        double farenheit = (temperature * (9.0/5)) + 32;
        String k = "The result of conversion from Celsius to Farenheit is : ";
        std::cout << farenheit;
    }
    else if (ans == "CK"){
        double temperature;
        printf("Enter your temperature : ");
        std::cin >> temperature;
        double kelvin = temperature+273;
        String k = "The result of conversion from Celsius to Farenheit is : ";
        std::cout << kelvin;
    }
    else if (ans == "FC"){
        double temperature;
        printf("Enter your temperature : ");
        std::cin >> temperature;
        double fahrenheit = (temperature-32) * (5.0/9);
        String k = "The result of conversion from Celsius to Fahrenheit is : ";
        std::cout << fahrenheit;
    }



}

String Functions in C++ :

    string.length() : returns the length of the string
    string.empty() : returns true if the string is empty else false
    string.clear() : deletes the string contents entirely and returns an empty string
    string.append(substr) : used to add the given string at the end of the string
    string.at(index) : returns the character there in index of the string
    string.insert(index, substr) : replaces the substr and moves the string at index to the next index
    string.find(substr) : it is opposite of at func. it returns the index of the substr in the string
    string.erase(starting index, stopping index) : it erases the content from starting to ending index (not inclusive)


 
while loop :

 syntax :
 while (condition) {
        statments
    }

 eg :

 #include <iostream>
typedef std::string String;
int main(){
    String name;

    while (name.empty()){
        std::cout << "Enter your name : ";
        std::getline(std::cin,name);

    }

    std::cout << "Hello, " + name;


}

 do while loop : execute some blocks of code before executing the main loop

eg :

  #include <iostream>
typedef std::string String;
int main(){
    String name;
    do {
        std::cout << "Enter your name : ";
        std::getline(std::cin,name);
    }while (name.empty())
    std::cout << "Hello, " + name;
}

 for loop :

 syntax :
 for (declaration of variable [int variable], condition, step value) {
        statements
    }

 eg :

 #include <iostream>
typedef std::string String;
int main(){
    int k;
    std::cout << "Enter a number : ";
    std::cin >> k;

    for (int i = 0;i <= k; i++){
        std::cout << i << std::endl;
    }

}

 iterating through other data types :

 syntax :
 for (type variable : iterator) {
        statements
    }

 eg :

 int main(){
    String k;
    std::cout << "Enter a String : ";
    std::getline(std::cin,k);

    for (char i : k){
        std::cout << i << std::endl;

    }

Random Modules :
 Generating Random Number in C++ is different.
 First , You have to seed the random using srand function

 int main(){
    srand(time(nullptr));
    int num = rand() % 18;
    std::cout << num;
}

 I wil explain this code
 we are using rand() func which returns numbers from  range 0 to 32768
 we are using srand because if an number is stored using rand ,
 it cannot generate another number but rather fixes it and will not cahnge another number

 so srand is used to reset the variable to restore an another random number

Exercise :
 To generate an random number from user inputs

 #include <iostream>
#include <random>

int main(){
    srand(time(nullptr));
    int num;
    std::cout << "This is random number generator."\
    "The ranger starts from 0 to User Input."\
    "So enter a number : ";
    std::cin >> num;
    int rand_num = rand() % num;
    std::string k = std::to_string(rand_num);
    std::cout << "The number gotten from your range : " + k;

}




 struct :

 C++ Structures (struct)
C++ Structures
Structures (also called structs) are a way to group several related variables into one place. Each variable in the structure is known as a member of the structure.

Unlike an array, a structure can contain many different data types (int, string, bool, etc.).

Create a Structure
To create a structure, use the struct keyword and declare each of its members inside curly braces.

After the declaration, specify the name of the structure variable (myStructure in the example below):

struct {             // Structure declaration
  int myNum;         // Member (int variable)
  string myString;   // Member (string variable)
} myStructure;       // Structure variable
Access Structure Members
To access members of a structure, use the dot syntax (.):

Example
Assign data to members of a structure and print it:

// Create a structure variable called myStructure
struct {
  int myNum;
  string myString;
} myStructure;

// Assign values to members of myStructure
myStructure.myNum = 1;
myStructure.myString = "Hello World!";

// Print members of myStructure
cout << myStructure.myNum << "\n";
cout << myStructure.myString << "\n";
One Structure in Multiple Variables
You can use a comma (,) to use one structure in many variables:

struct {
  int myNum;
  string myString;
} myStruct1, myStruct2, myStruct3; // Multiple structure variables separated with commas
This example shows how to use a structure in two different variables:

Example
Use one structure to represent two cars:

struct {
  string brand;
  string model;
  int year;
} myCar1, myCar2; // We can add variables by separating them with a comma here

// Put data into the first structure
myCar1.brand = "BMW";
myCar1.model = "X5";
myCar1.year = 1999;

// Put data into the second structure
myCar2.brand = "Ford";
myCar2.model = "Mustang";
myCar2.year = 1969;

// Print the structure members
cout << myCar1.brand << " " << myCar1.model << " " << myCar1.year << "\n";
cout << myCar2.brand << " " << myCar2.model << " " << myCar2.year << "\n";


 C++ References
Creating References
A reference variable is a "reference" to an existing variable, and it is created with the & operator:

string food = "Pizza";  // food variable
string &meal = food;    // reference to food
Now, we can use either the variable name food or the reference name meal to refer to the food variable:

Example
string food = "Pizza";
string &meal = food;

cout << food << "\n";  // Outputs Pizza
cout << meal << "\n";  // Outputs Pizza


C++ Memory Address
Memory Address
In the example from the previous page, the & operator was used to create a reference variable. But it can also be used to get the memory address of a variable; which is the location of where the variable is stored on the computer.

When a variable is created in C++, a memory address is assigned to the variable. And when we assign a value to the variable, it is stored in this memory address.

To access it, use the & operator, and the result will represent where the variable is stored:

Example
string food = "Pizza";

cout << &food; // Outputs 0x6dfed4


 C++ Pointers
Creating Pointers
You learned from the previous chapter, that we can get the memory address of a variable by using the & operator:

Example
string food = "Pizza"; // A food variable of type string

cout << food;  // Outputs the value of food (Pizza)
cout << &food; // Outputs the memory address of food (0x6dfed4)
A pointer however, is a variable that stores the memory address as its value.

A pointer variable points to a data type (like int or string) of the same type, and is created with the * operator. The address of the variable you're working with is assigned to the pointer:

Example
string food = "Pizza";  // A food variable of type string
string* ptr = &food;    // A pointer variable, with the name ptr, that stores the address of food

// Output the value of food (Pizza)
cout << food << "\n";

// Output the memory address of food (0x6dfed4)
cout << &food << "\n";

// Output the memory address of food with the pointer (0x6dfed4)
cout << ptr << "\n";
Example explained
Create a pointer variable with the name ptr, that points to a string variable, by using the asterisk sign * (string* ptr). Note that the type of the pointer has to match the type of the variable you're working with.

Use the & operator to store the memory address of the variable called food, and assign it to the pointer.

Now, ptr holds the value of food's memory address.


 Now the functions :

 There are different ways of calling or initialising it but if you want to return nothing , use void.
 functions in math are like modifiers or moods which boosts the input given by the user.
 programming functions is similar to this byu you can also return nothing

 syntax : returntype functionname(typeofinput input){
                statements
            }
eg :
 void play(string x){
    std::cout << "Play, " << x << std::endl;
}

int main(){
    play("sia");
    play("Sat");
}


Function initialisation with same name:
 In C++ we can use the same name of function and create duplicates with different parameters.
 each functions initialised with different parameters have identity called signature


 Rock Paper Scissor Game : 
 #include <iostream>
#include <string>
#include <random>
#include <ctime>
typedef std::string String;


class RPS_Game{
    public:
        String User_Selection;
        void User_Print(){
            std::cout << "*******************************" << std::endl;
            std::cout << "This is Rock Paper Scissor Game" << std::endl;
            std::cout << "*******************************" << std::endl;
            printf(" ");
            std::cout << "Options are,: " << std::endl;
            std::cout << "1. Rock" << std::endl;
            std::cout << "2. Paper" << std::endl;
            std::cout << "3. Scissor" << std::endl;
            printf(" ");
        }
        String Get_User_Choice(){
            printf("Please enter your choice : ");
            std::cin >> User_Selection;
            return User_Selection;
        }
        String Computer_Choice(){
            srand(time(nullptr));
            String Computer_Choice;
            int choice = rand() % 3;
            switch (choice){
                case 1:
                    return "Rock";
                    break;
                case 2:
                    return "Paper";
                    break;
                case 3:
                    return "Scissor";
                    break;
            }
        }
        void Result(){
            String User = User_Selection;
            String Computer = Computer_Choice();
            std::cout << "User Choice: " << User << std::endl;
            std::cout << "Computer Choice: " << Computer << std::endl;
            if (User == Computer){
                std::cout << "It's a Tie!" << std::endl;
            } else if ((User == "Rock" && Computer == "Scissor") || (User == "Paper" && Computer == "Rock") || (User == "Scissor" && Computer == "Paper")){
                std::cout << "You Win!" << std::endl;
            } else if ((User == "Rock" && Computer == "Paper") || (User == "Paper" && Computer == "Scissor") || (User == "Scissor" && Computer == "Rock")){
                std::cout << "You Lose!" << std::endl;
            } else {
                std::cout << "Invalid Input!" << std::endl;
            }

    }
};

int main(){
    RPS_Game game;
    game.User_Print();
    game.Get_User_Choice();
    game.Computer_Choice();
    game.Result();
    
}

This Works Perfectly


































































 */