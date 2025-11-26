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

Deflault value : 
for int, float, bool, rune the defaut value is 0 (false for bool)
for string and chqr it is "" and ''

const declaration : 




*/