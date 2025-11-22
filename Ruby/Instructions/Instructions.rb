=begin 

Ruby : before we learn ruby, we have to know some things

1) it is dynamically typed, loosely typed language, which means in simpler term, syntax is easier and also it is non-verbose
2) Ruby is primarily used in web development, with ruby on rails which is one of the most famous backend framework
3) Ruby is an interpreted scripting language, the scripting languages are usually slower than compiled languages therefore, 
Ruby is slower than many other languages.
4) It is a line-by-line execution compiler which compiles line after line. so even if entire code is correct
but if first line is wrong, it throws the error and stop execution

Variables : They are codes which are used for reusability of a information
for eg : take a statment My name is George. 
        if i want to create them for a let's say 100 persons like My name is Sia,
        here is where variables comes handy, it allows to use the statment multiple type
        in dynamically typed language, you  can straight initialize and go to use

Note: you cannot just "Initialize" and leave it as it is which most do in a statically typed language
you have to give a value if initialized
Note : You have to use brackets in order to do addition in Ruby

Data Types :

Before we know what is a Data Type, we have to know what is data means
A data is a human-readable form where we can store information or fact 
and collection of data's like
String : k = "HI"
Integer : k = 12
Boolean : k = true
No Values : k = nil


String Functions : 
Tips: For cases where you have to use "" inside "" where usually it get's over-ride
you can use /" to place quotes so that computer knows you are using a quote

k = " \" Giraffe Academy \" "
puts k

Functions : 
1) variable.upcase() : converts the variable into a upper-case one
2) variable.downcase() : converts the variable into downcase
3) variable.strip() : strips the starting and ending spaces
4) variable.length() : returns the length of the string
5) variable.include ? : this is where ruby is different, it uses a ternary operator ? which means value if true
This is a complicated one so here is a example

Indexing of Strings : 

Tip : String is just collection of Characters
As String is just collection of Characters, we can also access the strings using it's position 
called Index which is default assigned if you declared string
it starts from 0 and ends in n-1

There is also a concept called slicing which slices a part from string 
Syntax : string[start,end]

























=end