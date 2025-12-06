"""


C++ Syntax
C++ Syntax
Let's break up the following code to understand it better:

Example
#include <iostream>
using namespace std;

int main() {
  cout << "Hello World!";
  return 0;
}
Example explained
Line 1: #include <iostream> is a header file library that lets us work with input and output objects, such as cout (used in line 5). Header files add functionality to C++ programs.

Line 2: using namespace std means that we can use names for objects and variables from the standard library.

Don't worry if you don't understand how #include <iostream> and using namespace std works. Just think of it as something that (almost) always appears in your program.

Line 3: A blank line. C++ ignores white space. But we use it to make the code more readable.

Line 4: Another thing that always appear in a C++ program is int main(). This is called a function. Any code inside its curly brackets {} will be executed.

Line 5: cout (pronounced "see-out") is an object used together with the insertion operator (<<) to output/print text. In our example, it will output "Hello World!".

Note: C++ is case-sensitive: "cout" and "Cout" has different meaning.

Note: Every C++ statement ends with a semicolon ;.

Note: The body of int main() could also been written as:
int main () { cout << "Hello World! "; return 0; }

Remember: The compiler ignores white spaces. However, multiple lines makes the code more readable.

Line 6: return 0; ends the main function.

Line 7: Do not forget to add the closing curly bracket } to actually end the main function.

Omitting Namespace
You might see some C++ programs that runs without the standard namespace library. The using namespace std line can be omitted and replaced with the std keyword, followed by the :: operator for some objects:

Example
#include <iostream>

int main() {
  std::cout << "Hello World!";
  return 0;
}




C++ Statements
C++ Statements
A computer program is a list of "instructions" to be "executed" by a computer.

In a programming language, these programming instructions are called statements.

The following statement "instructs" the compiler to print the text "Hello World" to the screen:

Example
cout << "Hello World!";
It is important that you end the statement with a semicolon ;

If you forget the semicolon (;), an error will occur and the program will not run:

Example
cout << "Hello World!"
error: expected ';' before 'return'

Many Statements
Most C++ programs contain many statements.

The statements are executed, one by one, in the same order as they are written:

Example
cout << "Hello World!";
cout << "Have a good day!";
return 0;
Example explained
From the example above, we have three statements:

cout << "Hello World!";
cout << "Have a good day!";
return 0;
The first statement is executed first (print "Hello World!" to the screen).
Then the second statement is executed (print "Have a good day!" to the screen).
And at last, the third statement is executed (end the C++ program successfully).


C++ Output (Print Text)
The cout object, together with the << operator, is used to output values and print text.

Just remember to surround the text with double quotes (""):

Example
#include <iostream>
using namespace std;

int main() {
  cout << "Hello World!";
  return 0;
}
You can add as many cout objects as you want. However, note that it does not insert a new line at the end of the output:

Example
#include <iostream>
using namespace std;

int main() {
  cout << "Hello World!";
  cout << "I am learning C++";
  return 0;
}


New Lines
To insert a new line in your output, you can use the \n character:

Example
#include <iostream>
using namespace std;

int main() {
  cout << "Hello World! \n";
  cout << "I am learning C++";
  return 0;
}
You can also use another << operator and place the \n character after the text, like this:

Example
#include <iostream>
using namespace std;

int main() {
  cout << "Hello World!" << "\n";
  cout << "I am learning C++";
  return 0;
}
Tip: Two \n characters after each other will create a blank line:

Example
#include <iostream>
using namespace std;

int main() {
  cout << "Hello World!" << "\n\n";
  cout << "I am learning C++";
  return 0;
}
Another way to insert a new line, is with the endl manipulator:

Example
#include <iostream>
using namespace std;

int main() {
  cout << "Hello World!" << endl;
  cout << "I am learning C++";
  return 0;
}



Escape Sequence	DescriptionTry it
\t	Creates a horizontal tab
\\	Inserts a backslash character (\)
\"	Inserts a double quote character




"""