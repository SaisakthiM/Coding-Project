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

8-bit has a limit of (0-255) - for unsigned, 
(-128)-(127) for Signed

16-bit has a limit of (0 to 65,535) for unsigned
-32,768 to 32,767 for signed









*/