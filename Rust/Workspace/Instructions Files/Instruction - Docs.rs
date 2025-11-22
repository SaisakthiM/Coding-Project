/*

Rust : It is a low-level programming language with a special feature
it doesn't have a garbage collector
so if it doesn't have a garbage collector then it has ot have a memory allocation
no it has not that 
but better it is Ownership and Borrowing

first a number guessing game straight away

use std::io;

fn main() {
    println!("Guess a number : ");
    let mut guess = String::new();
    io::stdin().read_line(&mut guess).expect("Failed to read line");
    println!("You guessed: {guess}");
}

this might seem weird at first but as we go through it is easy
so first of all, the std::io is a set of items defined in a standiard library
think of it like waht we use in the #include <stdio.h> which is standard library for input-output in C/C++

so before proceedeing to code further we ahev to learn about what's a pointer and a reference 
for that i found a good analogy here it is

Windows Analogy

Administrator (Owner) → Full control of the system.
Can create, delete, modify anything. When the admin account is deleted, everything tied to it is gone.

User (Reference) → Can use the system, maybe even change files, 
but only within rules set by the administrator.

Immutable user (&T) → “Read-only account.” Can see everything, can’t modify.
Mutable user (&mut T) → “Power user.” Can modify stuff, but only one power user at a time to avoid conflicts.

Data-Types 

1) Integer : There are 2 types of integer and 2 methods to store

*) Unsigned : only + signed integer, starts from 0 N
*) Signed : starts from - and +

Note : Unsigned has the 2x capacity for signed + so if you want to purely use +, better to use unsigned

*) 8-bit, 16-bit, 32-bit, 64-bit : these are the no of the ways to store the integer in different ways

formula for finding integer range :

for unsigned : (0 to 2 ** n) - 1 
where n is the bit range like 8, 16, 32 and 64

for signed : (-2 ** n-1) to (2 ** n-1) -1

variable declaration : there are 2 types of variable declaraion in rust

static declaration : here the type is explicitely mentioned before declaring (explicit type declaration)
example : let a: int32 = 10;

dynamically typed (type inference)
let a := 10;
this declaration type is inferred when the program is in the compile time


functions : they are a repetable bolck of code where you can give an input and it returns a output 
like a function in math
you can also create a void function where it does not input or output anything


*/

/* Common Programming Concepts 

1) Variables and Mutabilty :
Note: 

*/