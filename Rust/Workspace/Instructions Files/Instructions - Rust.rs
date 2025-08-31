/*
Hi this is rust hand-made instructions

Rust : it is a compiler language like C or C++ which compiles its code to machine (binary) code and we get output.

it is among the favorite programming language in stack overflow which is an impressive feat

Advantages over other languages ; 
1. Memory Safety : Rust is designed to prevent common errors like null pointer dereferences and data races
2. Performance : Rust code can be compiled to run on the web, on mobile devices, and
3. Concurrency : Rust has strong support for concurrent programming, which makes it a great choice for
4. Error Handling : Rust has a strong focus on error handling, which makes it a great choice
5. Interoperability : Rust can be used to build libraries and frameworks that can be used by
6. Cross-platform : Rust can be used to build applications that can run on multiple platforms
7. Garbage Collector : Unlike C or C++, it has Garbage collector like python which makes programming it 
easier and less time consuming




Data Types :
• Memory only stores binary data
    • Anything can be represented in binary
• Program determines what the binary represents 
• Basic types that are universally useful are provided by the language

• Variables make it easier to work with data
• Variables can be assigned to any value
    • This include other variables
• Immutable by default


Primary Data Types
• Boolean : true, false
• Integer : 1, 2, 50, 99, -2
• Double / Float:  1.1, 5.5, 200.0001, 2.0 
• Character : 'a','b','c','d','e'


Reference or Compound Data Types :
• Array : [1, 2, 3, 4, 5]
• Tuple : (1, 2, 3, 4, 5)
• String : "Hello, World!"
• Vector : [1, 2, 3, 4, 5]



What are functions?
• A way to encapsulate program functionality
• Optionally accept data
• Optionally return data
• Utilized for code organization
    Also makes code easier to read


Syntax : 
fn function_name(parameter : type, parameters : type ...)-> return_type {
    values_to_return 
}

Note : there is no need to use return keyword to return value 


Now we can Print "Hello World"

for that we have to use main() function like c+or c++
remember, rust is used as a alternative for c or c++m because it cannot support modern modules or dependencies

fn main(){
    println("Hello World");
}


for this to get printed, we have to use what is called rustc or rust-compiler 

this converts our code into .exe and .pdb format.
the file is converted into binary and saved in .exe and .pdb is the information file
we can run this .exe file and get the output.

A disadvantage is that you simply cannot edit the code each time as the file gets converted into .exe
if you what to edit, you have to overwrite the .exe file each time which is frustrating

for that, we have another way called cargo.
this is like python venv which creates an cargo package where we can run our packages 

the advantage here is that we can edit the files easily unlike other format





Primitive Data Types :
int, float, bool, char
Integer
Rust has signed (+ and -) and unsigned integer (only+) types of different sizes. 
i8, i16, i32, i64, i128: Signed integers. 
u8, u16, u32, u64, u128: Unsigned integers.

to be simple of signed and unsigned, 
signed is like integers , which have both negative and postive
whereas unsigned is only positive integers

Range for Signed integer : 

• i8: 8-bit signed integer (range: -128 to 127)
• i16: 16-bit signed integer (range: -32,768 to 32,767)
• i32: 32-bit signed integer (range: -2,147,483,648 to 2,147,483,647)
• i64: 64-bit signed integer (range: -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807)

Range for unsigned integer : 

• u8: 8-bit unsigned integer (range: 0 to 255)
• u16: 16-bit unsigned integer (range: 0 to 65,535)
• u32: 32-bit unsigned integer (range: 0 to 4,294,967,295)
• u64: 64-bit unsigned integer (range: 0 to 18,446,744,073,709,551,615)

    For eg : 
    fn main() {
        let x : i32 = 2147483647;
        println!("Maximum value of i32: {}", x);
    }

Float : 

Rust has two floating-point types: f32 and f64.

• f32: 32-bit floating-point number (single precision)
• f64: 64-bit floating-point number (double precision)

    for eg : 
    fn main() {
        let y : f32 = 3.141123456789;
        println!("Value of y: {}", y);
    }

Boolean : 
// Boolean values are either true or false.
// They are represented by the bool type in Rust.

    for eg : 
    fn main(){
        let y : bool = true;
        println!("Value of y: {}", y);
    }

Character :
// A character is a single Unicode character and is represented by the char type in Rust.
// It is a 4-byte Unicode scalar value.
// The char type is used to represent a single character in Rust.
// It can be assigned under '' quotes

    for eg : 
    fn main(){
        let y : char = 'a';
        println!("Value of y: {}", y);
    }
// A character can be a letter, digit, punctuation mark, or any other symbol.

Compound Data Types :

Arrays : 
// in rust, an array is a collection of elements of the same type.
// It is a fixed-size collection of elements, meaning that the size of the array is known at compile time and cannot be changed at runtime.
// An array is a fixed-size collection of elements of the same type.
// The size of the array is known at compile time and cannot be changed at runtime.
// Arrays are represented by the [type; size] syntax in Rust.

    for eg : 
    fn main(){
        let y : [i32; 5] = [1,2,3,4,5];
        println!("{:?}",y);
    }
// this is an int array

    fn main(){
        let str : [&str; 7] = ["Hello", "World", "This", "is", "a", "string", "array"];
        println!("{:?}",str);
}
// this is a string array

Indexing in Array : 
// The first element of an array is at index 0, the second element is at index 1, and so on.
// The last element of an array is at index size - 1.

    for eg : 
    fn main(){
        let y : [i32; 5] = [1,2,3,4,5];
        println!("The First Element : {}",y[0]);
        println!("The Last Element : {}",y[4]);
    }
// this is an int array

Nested List in Array :
// An array can also contain other arrays as elements, creating a multi-dimensional array.
// A multi-dimensional array is an array of arrays.
// The syntax for a multi-dimensional array is [[type; size1][type; size2]...; sizeN].
// where size1, size2, ..., sizeN are the sizes of the arrays at each dimension.

    for eg : 
    fn main(){
        let y : [[i32; 2] ; 2] = [[1,2],[3,4]];
        println!("The First Element : {}",y[0][0]);
    }




Tuple :
// A tuple is a collection of elements of different types.
// it can be both static and dynamic which means
// either we can fix the values of each position which cannot be done on other languages 
// or we can type any datatype without assigning it to a specific type

for eg : 
    fn main(){
        let y : (i32, f32, char) = (1, 2.0, 'a');
        println!("{:?}",y);
    }


Ownership :
// Ownership is a key concept in Rust that helps manage memory safely and efficiently.
// In Rust, every value has a single owner, and when the owner goes out of scope, the value is dropped.
// This means that the memory used by the value is automatically freed when it is no longer needed.
// This eliminates the need for a garbage collector and helps prevent memory leaks and dangling pointers.

// Ownership Definition:
//  Some languages have garbage collection that regularly looks for no-longer-used memory as the program runs;
    in other languages, the programmer must explicitly allocate and free the memory.
    Rust uses a third approach: memory is managed through a system of ownership with a set of rules that the compiler checks.
    If any of the rules are violated, the program won’t compile.
    None of the features of ownership will slow down your program while it’s running.


Ownership Rules : 
First, let’s take a look at the ownership rules. 
Keep these rules in mind as we work through the examples that illustrate them:

    1) Each value in Rust has an owner.
    2) There can only be one owner at a time.
    3_ When the owner goes out of scope, the value will be dropped





















































*/
