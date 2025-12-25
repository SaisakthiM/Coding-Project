/*
This is C# Tutorial.

C# Syntax : 

using System;

namespace HelloWorld
{
  class Program
  {
    static void Main(string[] args)
    {
      Console.WriteLine("Hello World!");    
    }
  }
}

Line 1: using System means that we can use classes from the System namespace.
Line 2: A blank line. C# ignores white space. However, multiple lines makes the code more readable.
Line 3: namespace is used to organize your code, and it is a container for classes and other namespaces.
Line 4: The curly braces {} marks the beginning and the end of a block of code.
Line 5: class is a container for data and methods, which brings functionality to your program. 
Line 7: Another thing that always appear in a C# program is the Main method. Any code inside its curly brackets {} will be executed.
Line 9: Console is a class of the System namespace, which has a WriteLine() method that is used to output/print text. In our example, it will output "Hello World!".
If you omit the using System line, you would have to write System.Console.WriteLine() to print/output text.

Note: Every C# statement ends with a semicolon ;.
Note: C# is case-sensitive; "MyClass" and "myclass" have different meaning.
Note: Unlike Java, the name of the C# file does not have to match the class name, but they often do (for better organization). 
      When saving the file, save it using a proper name and add ".cs" to the end of the filename

------------------------------------------------------------------------------------------------------------------------------------------------------

C# Functions and Output : 

Just like we use print("Hello World!") in Python, We use Console.WriteLine("Hello World!")
And there is Console.Write("Hello World!") too which will not leave a extra line after printing
It's Similar to System.out.print() and System.out.println()

Comments : /* *\ is used as Multi-Line Comment, // is used as Single-Line Comment

Variables : 
Syntax for creating a Variable : type var_name = value;
Types : int - stores integers (whole numbers), without decimals, such as 123 or -123
        double - stores floating point numbers, with decimals, such as 19.99 or -19.99
        char - stores single characters, such as 'a' or 'B'. Char values are surrounded by single quotes
        string - stores text, such as "Hello World". String values are surrounded by double quotes
        bool - stores values with two states: true or false
        var - it is a dynamic variable which can be assigned with any data values mentioned

Constants : We can add const keyword before variable to make it constant.
            We or No-one can edit the variable after being assigned
            for eg : const int k = 10;
                     k =  19;
            if we did that, it will throw a error to your face.
Note: You cannot declare a constant variable without assigning the value. If you do, an error will occur: A const field requires a value to be provided.

Multiple Variable : 
Syntax : type var_name, var_name2 ... = value1, value2 ...
         or type var_name, var_name2...;
         var_name1 = var_name2 = value (if you vant to assign same value for multiple variable)


Identifiers or rules to write a Variable :

1) C# is case sensitive. Myclass and myclass are both different 
2) Variables can start with letters and Underscore (Not Digits)
3) A variable name can contain Letters, Numbers and Digits
4) Keywords cannot be used as names.
5) variables names cannot contain spaces

------------------------------------------------------------------------------------------------------------------------------------------------------

Data Types in C# :
A data type specifies the size and type of variable values.

It is important to use the correct data type for the corresponding variable; to avoid errors, to save time and memory, but it will also make your code more maintainable and readable. The most common data types are:

Datatype	  Size	  Description
int	      4 bytes	  Stores whole numbers from -2,147,483,648 to 2,147,483,647
long	    8 bytes	  Stores whole numbers from -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807
float	    4 bytes	  Stores fractional numbers. Sufficient for storing 6 to 7 decimal digits
double	  8 bytes	  Stores fractional numbers. Sufficient for storing 15 decimal digits
bool	    1 byte	  Stores true or false values
char	    2 bytes	  Stores a single character/letter, surrounded by single quotes
string	  2 bytes   per character	Stores a sequence of characters, surrounded by double quotes


Number types are divided into two groups:
1) Integer types stores whole numbers, positive or negative (such as 123 or -456), without decimals.
Valid types are int and long. Which type you should use, depends on the numeric value.
The main difference between long and int is that int stores 4 bytes which has shorter range but good memory efficient
but lng uses 8 bytes which extends the range in cost of more memory

2) Floating point types represents numbers with a fractional part, containing one or more decimals. 
Valid types are float and double.
same here double is 8 bytes and float is 4 bytes

------------------------------------------------------------------------------------------------------------------------------------------------------

C# Type Casting
Type casting is when you assign a value of one data type to another type.

In C#, there are two types of casting:

Implicit Casting (automatically) - converting a smaller type to a larger type size
char -> int -> long -> float -> double
Note: You cannot convert larger type to smaller type if it exceeds the byte range
Like :
long k = 2147483650;
int u = k;
Console.WriteLine(u);
This Throws a error, which means you cannot 

Explicit Casting (manually) - converting a larger type to a smaller size type
double -> float -> long -> int -> char

Using Convert Method : 
Convert is a Built-in method to convert a data-type to another
Syntax : Convert.To(new_type)(variable)
Eg to convert int k = 10; to long : Convert.ToInt64(k) [Int is default 32 bytes. Long is 64 bytes]


------------------------------------------------------------------------------------------------------------------------------------------------------

Get User Input
You have already learned that Console.WriteLine() is used to output (print) values. 
Now we will use Console.ReadLine() to get user input.

For Eg: 
Console.Write("Enter Username : ");
string res;
res = Console.ReadLine();
Console.WriteLine("Hi, "+res);

This receives the input and prints with (Hi, input)

User Input and Numbers : 
The Console.ReadLine() method returns a string.
Therefore, you cannot get information from another data type, such as int. 
The following program will cause an error:

Console.WriteLine("Enter your age:");
int age = Console.ReadLine();
Console.WriteLine("Your age is: " + age);

ReadLine can only get string input. 
if we use int., it throws (System.FormatException: 'Input string was not in a correct format.').

To use int or any other types as input 
Syntax : type var_name = Convert.to(your_type)(Console.ReadLine())

------------------------------------------------------------------------------------------------------------------------------------------------------

C# Operators : It is used to operate operations on values and Variables

Arithmetic Operators: 
Operator	        Description	                                    Example	
+	Addition	      Adds together two values	                      x + y	
-	Subtraction	    Subtracts one value from another	              x - y	
*	Multiplication	Multiplies two values	                          x * y	
/	Division	      Divides one value by another	                  x / y	
%	Modulus	        Returns the division remainder	                x % y	
++	              Increment	Increases the value  by 1             	x++	
--	              Decrement	Decreases the value  by 1	              x--	
Note: Data-Type string can only use + and * operators. It cannot use others

Assignment Operators:
Operator	    Example	    Same As	
=	            x = 5	      x = 5	
+=	          x += 3	    x = x + 3	
-=	          x -= 3	    x = x - 3	
*=	          x *= 3	    x = x * 3	
/=	          x /= 3	    x = x / 3	
%=	          x %= 3	    x = x % 3	
&=	          x &= 3	    x = x & 3	
|=	          x |= 3	    x = x | 3	
^=	          x ^= 3	    x = x ^ 3	
>>=	          x >>= 3	    x = x >> 3	
<<=	          x <<= 3	    x = x << 3

Some Operators are confusing so in my own words:
= : assigns a value to a variable
+= : adds the original value with new value
-= : subtracts the original value with new value
*= : multiplies the original value with new value
/= : divides the original value with new value
%= : divides the original value with new value and assigns the remainder to the variable 
&= : assigns 1 if the original value  is non zero else assigns 0 (the value you type will not be counted)
(It is a Bitwise and operator)




Assignment Operator :
Operator	  Name	                    Example	
==	      Equal to	                  x == y	
!=	      Not equal	                  x != y	
>	        Greater than	              x > y	
<	        Less than	                  x < y	
>=	      Greater than or equal to	  x >= y	
<=	      Less than or equal to	      x <= y

Logical Operator :
Operator	     	Description	                                                              Example	
&& 	            Logical and	Returns True if both statements are true	                  x < 5 &&  x < 10	
|| 	            Logical or	Returns True if one of the statements is true	              x < 5 || x < 4	
!	              Logical not	Reverse the result, returns False if the result is true	    !(x < 5 && x < 10)

---------------------------------------------------------------------------------------------------------------------------------------

C# Math :
The C# Math class has many methods that allows you to perform mathematical tasks on numbers.

Methods :
1) Math.Max(x,y) / Math.Min(x,y) : Used to compare Maximum and Minimum value between 2 given value
2) Math.Sqrt(x) / Math.Abs(x) : One used to return the square-root and One used as Modulus 
(Returns same if the value is positive. If negative, converts positive integer)
3) Math.Round(x) : Round off the value to the nearest integer

---------------------------------------------------------------------------------------------------------------------------------------

C# String :
A String is a collection of character 
to initialize it, string string_name = "Value";
for eg : string s = "Hi";

String Functions: (Functions are called by objects so this time we take str as Object)
str.Length : Returns the length of the string
string.Concat(str1, str2) : used to concat two strings into a single string. we can also use + operator.

String Interpolation or String Formatting : 
It's similar to python but the only difference is we will not use any functions like format or f"", 
we should use $ before the string declaration, use {} brackets and put the variable

for eg :
string name = "sai";
Console.WriteLine($"Hi, {name}");

String Indexing :
You can also access strings using index starting from 0.
For eg : string name = "sai";
Console.WriteLine(name[0]);

We can also find the index of specific character using IndexOf Function.
for eg : Console.WriteLine(name.IndexOf('s'));

There is also SubString function which extracts the string after the given index and return as a new string.
For eg : string full_name = "sai sakthi"
string index = full_name.IndexOf("s");
string first_name = name.SubString(index);
Note: The IndexOf function only takes the first occurrence of given char. so this time, only sai is taken even if sakthi also begins

Strings - Special Characters
Because strings must be written within quotes, C# will misunderstand this string, and generate an error:
string txt = "We are the so-called "Vikings" from the north.";

The solution to avoid this problem, is to use the backslash escape character.
The backslash (\) escape character turns special characters into string characters:

Escape character	Result	      Description
\'	                '	          Single quote
\"	                "	          Double quote
\\	                \	            Backslash

The sequence \"  inserts a double quote in a string:
Example
string txt = "We are the so-called \"Vikings\" from the north.";

The sequence \'  inserts a single quote in a string:
Example
string txt = "It\'s alright.";

The sequence \\  inserts a single backslash in a string:
Example
string txt = "The character \\ is called backslash.";

Other useful escape characters in C# are:
Code	  Result	
\n	    New Line	
\t	    Tab	
\b	    Backspace

--------------------------------------------------------------------------------------------------------------------------------

C# Booleans
Very often, in programming, you will need a data type that can only have one of two values, like:
YES / NO
ON / OFF
TRUE / FALSE
For this, C# has a bool data type, which can take the values true or false.

Boolean Values
A boolean type is declared with the bool keyword and can only take the values true or false:

Example
bool isCSharpFun = true;
bool isFishTasty = false;
Console.WriteLine(isCSharpFun);   // Outputs True
Console.WriteLine(isFishTasty);   // Outputs False

However, it is more common to return boolean values from boolean expressions, for conditional testing (see below).


Boolean Expression
A Boolean expression returns a boolean value: True or False, by comparing values/variables.

This is useful to build logic, and find answers.

For example, you can use a comparison operator, such as the greater than (>) operator to find out if an expression (or a variable) is true:

Example
int x = 10;
int y = 9;
Console.WriteLine(x > y); // returns True, because 10 is higher than 9

Or even easier:

Example
Console.WriteLine(10 > 9); // returns True, because 10 is higher than 9

In the examples below, we use the equal to (==) operator to evaluate an expression:

Example
int x = 10;
Console.WriteLine(x == 10); // returns True, because the value of x is equal to 10

Example
Console.WriteLine(10 == 15); // returns False, because 10 is not equal to 15

Real Life Example
Let's think of a "real life example" where we need to find out if a person is old enough to vote.

In the example below, we use the >= comparison operator to find out if the age (25) is greater than OR equal to the voting age limit, which is set to 18:

Example
int myAge = 25;
int votingAge = 18;
Console.WriteLine(myAge >= votingAge);

Cool, right? An even better approach (since we are on a roll now), would be to wrap the code above in an if...else statement, so we can perform different actions depending on the result:

Example
Output "Old enough to vote!" if myAge is greater than or equal to 18. Otherwise output "Not old enough to vote.":

int myAge = 25;
int votingAge = 18;

if (myAge >= votingAge) 
{
  Console.WriteLine("Old enough to vote!");
} 
else 
{
  Console.WriteLine("Not old enough to vote.");
}

------------------------------------------------------------------------------------------------------------------------------------

C# Conditions and If Statements
C# supports the usual logical conditions from mathematics:

Less than: a < b
Less than or equal to: a <= b
Greater than: a > b
Greater than or equal to: a >= b
Equal to a == b
Not Equal to: a != b
You can use these conditions to perform different actions for different decisions.

C# has the following conditional statements:

Use if to specify a block of code to be executed, if a specified condition is true
Use else to specify a block of code to be executed, if the same condition is false
Use else if to specify a new condition to test, if the first condition is false
Use switch to specify many alternative blocks of code to be executed


Syntax :  
if (condition) {
    statement
    statements
}

Short Hand If...Else (Ternary Operator)
There is also a short-hand if else, which is known as the ternary operator because it consists of three operands. 
It can be used to replace multiple lines of code with a single line. 
It is often used to replace simple if else statements:

Syntax
variable = (condition) ? expressionTrue :  expressionFalse;

For eg :
int x = (10 > 5) ? 10 : 5;

--------------------------------------------------------------------------------------------------------------------------------

C# Switch Statements
Use the switch statement to select one of many code blocks to be executed.

SyntaxGet your own C# Server
switch(expression) 
{
    case x:
        // code block
        break;
    case y:
        // code block
        break;
    default:
        // code block
        break;
}

-------------------------------------------------------------------------------------------------------------------------------------

Loops
Loops can execute a block of code as long as a specified condition is reached.
Loops are handy because they save time, reduce errors, and they make code more readable.

C# While Loop : 

The while loop loops through a block of code as long as a specified condition is True:
Syntax
while (condition) 
{
  // code block to be executed
}
In the example below, the code in the loop will run, over and over again, as long as a variable (i) is less than 5:

Example
int i = 0;
while (i < 5) 
{
    Console.WriteLine(i);
    i++;
}

Note: Do not forget to increase the variable used in the condition, otherwise the loop will never end!

The Do/While Loop
The do/while loop is a variant of the while loop. This loop will execute the code block once, 
before checking if the condition is true, then it will repeat the loop as long as the condition is true.

Syntax
do 
{
  // code block to be executed
}
while (condition);
The example below uses a do/while loop. The loop will always be executed at least once,
even if the condition is false, because the code block is executed before the condition is tested:

Example
int i = 0;
do 
{
    Console.WriteLine(i);
    i++;
}
while (i < 5);

C# For Loop
When you know exactly how many times you want to loop through a block of code, use the for loop instead of a while loop:

Syntax
for (statement 1; statement 2; statement 3) 
{
  // code block to be executed
}
for eg : 
for (int x = 0; x < 10; x++){
    statement
    statements

}

There is also nested for loop which runs a loop inside a loop.
for eg : 
for (int x = 0; x < 10; x++){
    for (int y = 0; y < x; x++){
        statment
        statments
    }
}

C# foreach : this is instead of using for (int x : array_name) we generally use to iterate through object, 
             they gave a entire new loop for this specific purpose

Syntax
foreach (type variableName in arrayName) 
{
  // code block to be executed
}

-----------------------------------------------------------------------------------------------------------------------------

C# Break and Continue

C# Break
You have already seen the break statement used in an earlier chapter of this tutorial. It was used to "jump out" of a switch statement.
The break statement can also be used to jump out of a loop.

This example jumps out of the loop when i is equal to 4:
for (int i = 0; i < 10; i++) 
{
  if (i == 4) 
  {
    break;
  }
  Console.WriteLine(i);
}


C# Continue
The continue statement breaks one iteration (in the loop), if a specified condition occurs, and continues with the next iteration in the loop.

This example skips the value of 4:
for (int i = 0; i < 10; i++) 
{
  if (i == 4) 
  {
    continue;
  }
  Console.WriteLine(i);
}


---------------------------------------------------------------------------------------------------------------------------------


C# Array : 
In C#, we can initialize a array like we do in java. 
Syntax :
type[] var_name = {values}; (Initializing with values)
or 
type[] var_name = new type[no of elements] (This is initializing with a fixed no of elements [static])
or
// Create an array of four elements and add values right away 
string[] cars = new string[4] {"Volvo", "BMW", "Ford", "Mazda"}; (Static With Values)
or
// Create an array of four elements without specifying the size 
string[] cars = new string[] {"Volvo", "BMW", "Ford", "Mazda"}; (Dynamic With Values)

For Eg :
int[] k = {1,2,3,4,5}

Accessing a Values:
You can use index (Starting from 0) to access individual elements or use foreach loop ot access entire array one by one
for eg (we use int[] k = {1,2,3,4,5}):
1) Console.WriteLine(k[0]) (First Element)
2) foreach (int x in k){
    Console.WriteLine(x) //This prints each element one by one start to finish
}
Functions : 
arr_name.length : returns the length of the array
Array.Sort(arr_name)

---------------------------------------------------------------------------------------------------------------------------------

C# namespace : it is also a important function in C#.
It is generally a special container which is used to
organize code into logical groups, prevent naming conflicts, and improve code readability and maintainability
If you use a variable under namespace, you cannot use it under any other namespaces 

for eg : namespace MyApplication
{
  class Program
  {
    static void Main(string[] args)
    {
      int[] myNumbers = {5, 1, 8, 9};
      Console.WriteLine(myNumbers.Max());  // returns the largest value
      Console.WriteLine(myNumbers.Min());  // returns the smallest value
      Console.WriteLine(myNumbers.Sum());  // returns the sum of elements
    }
  }
}}
}

---------------------------------------------------------------------------------------------------------------------------

C# Multi-Dimensional array :

In C#, you have to use commas (,) to assign no of arrays.
like in default, it is 0 comma which is 1D,

[,] means 2D 
[,,] means 3D
and so on

syntax : type[, ..] var_name = {{elements ..} elements ..} (dynamic and prefixing some values)
       : type[, ..] var_name = new type[value, ..] (static and no fixed values)
       : type[, ..] var_name = new type[] (dynamic and non fixing values)
       : type[, ..] var_name = new type[value, ..] {elements according to static values} (static with pre-fixed values)

Accessing or Indexing :
It's Simple, use the (,) to separate index values
for eg : int[,] k = {{1,2}, {3,4}};
       : Console.Write(k[0,0]) //{The first index mentions 0th element and second tells 0th element of that element}

------------------------------------------------------------------------------------------------------------------------------------

C# Methods :

A method is a block of code which only runs when it is called.
You can pass data, known as parameters, into a method.
Methods are used to perform certain actions, and they are also known as functions.
Why use methods? To reuse code: define the code once, and use it many times.

Syntax : 
before writing syntax, you have to know difference between static and dynamic

static functions/classes cannot be edited even after creating a object. this prevents unnecessary over-writing 
dynamic functions/classes can be edited which is easier for flexibility of a function

for static, use static keyword
for dynamic, just leave none

the main syntax :
static/none return_type func_name(type var_name [if any]){
    statment
    statements
    return
}
Note: (type var_name) this part is called argument. you have to give an argument if you are calling after assigning a argument
Note: If you are using void. you should not return anything

for multiple arguments :
use (type[] var_name)
This store your arguments as array


for eg : static 
class program {
    static void Main(String[] args){
        Console.Write("Hi");
    }
}



*/

