/*

Go : It is a statically typed language which is very fast and it is backbone of dev-ops due to it's speed
the mainn advantages of the go languages is 
1) Concurrency : we will learn about it so wait a bit
2) garbage Collector : 	the main advantage go has over it's other languages is that 
						it has gargabe collector and runs on low level which is never heard of

Now the real task start

Basic Variables
bool: a boolean value, either true or false
string: a sequence of characters
int: a signed integer
float64: a floating-point number
byte: exactly what it sounds like: 8 bits of data
Declaring a Variable the Sad Way
var mySkillIssues int
mySkillIssues = 42

The first line, var mySkillIssues int, defaults the mySkillIssues variable to its zero value, 0. On the next line, 42 overwrites the zero value.

We'll talk about a better way to declare variables in the next lesson.

*/

/* Short Variables

Short Variable Declaration
Sad variable declaration:
var mySkillIssues int
mySkillIssues = 42

GOATed variable declaration:
mySkillIssues := 42

The walrus operator, :=, declares a new variable and assigns a value to it in one line. Go can infer that mySkillIssues is an int because of the 42 value. Yay type inference!
When to Use the Walrus Operator
The :=, (walrus operator) should be used instead of var style declarations basically anywhere possible. The limitation is that := can't be used outside of a function (in the global/package scope which we'll talk about later).

Type inference is based on the value being assigned.

An int:
mySkillIssues := 42

A float64:
pi := 3.14159

A string:
message := "Hello, world!"

A bool:
isGoat := true

*/

/* Interface : 

What interface{} Is
interface{} is called the empty interface.
It can hold a value of any type — int, string, struct, etc.
It essentially tells the compiler:
“I don’t know the type yet — accept anything.”

Example:
var x interface{}
x = 42       // int
fmt.Println(x)

x = "hello"  // string
fmt.Println(x)

x = 3.14     // float64
fmt.Println(x)


✅ Works fine — no compile-time type error.

2️⃣ Important Notes

You lose type safety:
The compiler won’t know what type is inside interface{}.
You must type-assert to use it as a specific type:

*/

/* Type of Errors 

The Compilation Process
Computers need machine code, they don't understand English or even Go. We need to convert our high-level (Go) code into machine language, which is really just a set of instructions that some specific hardware can understand. In your case, your CPU.
The Go compiler's job is to take Go code and produce machine code, an .exe file on Windows or a standard executable on Mac/Linux.

Go Program Structure
We'll go over this all later in more detail, but to sate your curiosity:

package main lets the Go compiler know that we want this code to compile and run as a standalone program, as opposed to being a library that's imported by other programs.
import "fmt" imports the fmt (formatting) package from the standard library. It allows us to use fmt.Println to print to the console.
func main() defines the main function, the entry point for a Go program.

Two Kinds of Bugs
Generally speaking, there are two kinds of errors in programming:

Compilation errors. Occur when code is compiled. It's generally better to have compilation errors because they'll never accidentally make it into production. 
You can't ship a program with a compiler error because the resulting executable won't even be created.

Runtime errors. Occur when a program is running. These are generally worse because they can cause your program to crash or behave unexpectedly.
While we're in the browser it can be a bit hard to tell the difference because we run and compile the code in the same step.

*/

/* Type Sizes

Integers, uints, floats, and complex numbers all have type sizes.

Signed Integers (No Decimal)
int  int8  int16  int32  int64

Unsigned Integers (Whole Numbers/No Decimal)
"uint" stands for "unsigned integer".

uint uint8 uint16 uint32 uint64 uintptr

Signed Decimal Numbers
float32 float64

Complex Numbers (a Complex Number Has a Real and Imaginary Part)
complex64 complex128

What's the Deal With the Sizes?
The size (8, 16, 32, 64, 128, etc) represents how many bits in memory will be used to store the variable. The "default" int and uint types refer to their respective 32 or 64-bit sizes depending on the environment of the user.

The "standard" sizes that should be used unless you have a specific performance need (e.g. using less memory) are:

int
uint
float64
complex128
Converting Between Types
Some types can be easily converted like this:

temperatureFloat := 88.26
temperatureInt := int64(temperatureFloat)

Casting a float to an integer in this way truncates the floating point portion.

*/
