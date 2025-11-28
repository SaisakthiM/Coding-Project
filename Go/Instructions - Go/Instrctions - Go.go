package main
/* 

Six main Points about Go :
1) Strongly Typed
2) Statically typed
3) Compiled language
4) Fast compilation time
5) Built in fast concurrency
6) Simplicity

package main
import "fmt"

func main() {
	var name string;
	fmt.Print("Enter your name: ");
	fmt.Scan(&name);
	fmt.Print(name);
}

this is a basic code
1) package main : it is a package command which tells go where to search for the package 
here it is main so it searches main one and use the packages
2) import "fmt" : it is a package used mainl in go for printing and scanning 

Variables Assigning : 
In go, we can declare a variable in 2 ways 
1) static : it is assignikg the datatype on our own 
eg : var name string = "hi"

Data Types and Auto assign in runtime:
there are many data types in Go, most mentionably 
1) int : there are also uint which is unsigned so it has a extra but more than signed int 
it is also categorized by 8,16,32,64 bit
2) float: there is only 2 types which is 32 and 64
3) char and string : you know abiut it right 
Note: the len() function we use here is actually not useful as it adds the ASCII value of the character
use utf8.RuneCountInString()
4) bool : just true or false

for auto assigning use name := value and go does the rest

Default value : 
for int, float, bool, rune the defaut value is 0 (false for bool)
for string and chqr it is "" and ''


*/

/* 
What is Go and how it's Born : 
GO is a language born in google and also it is famous for it's 
concurrency and features and syntax like C programming language and often refered as 
C language of the 21st century

there is also a intresting on how the concurrency concept was born 
there was a concept called communicating sequence process which was a famous theroy 
developed by a Hoare. he was the one who developed this concept 

the main purpose of GO is to remove the complexity that C and other prohramming languages 
brought. it also has a type system like JS and also like C (both loosely and strictly typing is supported)

Start with hello world : 
package main
import "fmt"

func main() {
	fmt.Print("Hello World");
}

this is a simple function in Go for now 
Go is a compiled language. The Go toolchain converts a program source code into a executable file
to run this we use go tun filename.go
but as a traditional method you have to first compile and then run 
for compiling we have to first build the executable with go build

now let's talk about packages and how it works in go 
in go, functions like input and output are made in packages with .go source file
they are packaged and are ready to use

that's why we use the fmt package which 

*/