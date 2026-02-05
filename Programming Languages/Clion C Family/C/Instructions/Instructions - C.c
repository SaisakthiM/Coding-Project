/*

What is C and history of C :

You might have heard that C is the mother of all languages and it is the best in
that still now why it is called like that

C was founded in 1978 and it is more popular than ever since now.
that's the reason why C is still used in like
1) Kernels
2) Games
3) Compilers for many languages like Python and JS

and many more actually.

so now let's see what is C

C is s General Purpose Programming languages
Developed for UNIX operating system a predecessor for
B Programming language

It is also a low level language which allows user to manipulate the
CPU memory and disk directly
that's why it is used in the low level works like Compilers andother low level
ones

Basics :

First we have to know how C works and then we can help

C is a low level Programming language which is famous for it's simple syntax
and fast Compile time. It actually Compiles to Assembly and then run that to
create a executable

there are many famous Compilers for C but the most famous one is GCC which is a
GNU Compiler

now we know that we can see about the syntax part now

1) It is a static and strictly typed procedural / functional language which do
not use OOP for that there is C++

2) It is also low level which means we know that it does not have Garbage
Collector we have to maually manage memory

for that we can allocate, free and also use pointers which is most powerful
concept in C

3) Tip : Unlike other languages we cannot normally print the integers
C does not support direct printing but it supports through string interpolation

This is the basic structure on how we can declare
%[flags][width][.precision][length]specifier


| Format  | Type Expected    | Output Description                  | Width / Precision Effect | Example Output |
| ------- | ---------------- | ----------------------------------- | ------------------------ | -------------- |
| `%d`    | `int`            | Signed decimal integer              | —                        | `42`           |
| `%6d`   | `int`            | Integer, min width 6                | Left padded with spaces  | `␣␣␣␣42`       |
| `%u`    | `unsigned int`   | Unsigned integer                    | —                        | `42`           |
| `%o`    | `int`            | Octal representation                | —                        | `52`           |
| `%x`    | `int`            | Hexadecimal (lowercase)             | —                        | `2a`           |
| `%X`    | `int`            | Hexadecimal (uppercase)             | —                        | `2A`           |
| `%ld`   | `long int`       | Long integer                        | —                        | `100000`       |
| `%lld`  | `long long int`  | Long long integer                   | —                        | `123456789`    |
| `%f`    | `float / double` | Floating-point (6 decimals default) | Precision → decimals     | `3.140000`     |
| `%6f`   | `float / double` | Float, min width 6                  | Width includes decimals  | `3.140000`     |
| `%.2f`  | `float / double` | Float with 2 decimals               | Precision control        | `3.14`         |
| `%6.2f` | `float / double` | Width 6, 2 decimals                 | Space padded             | `␣␣3.14`       |
| `%e`    | `float / double` | Scientific notation                 | —                        | `1.23e+03`     |
| `%E`    | `float / double` | Scientific notation (caps)          | —                        | `1.23E+03`     |
| `%g`    | `float / double` | Shortest of `%f` or `%e`            | —                        | `1230`         |
| `%Lf`   | `long double`    | Long double floating-point          | —                        | `3.140000`     |
| `%c`    | `char`           | Single character                    | —                        | `A`            |
| `%s`    | `char *`         | String                              | Precision → max chars    | `Hello`        |
| `%.3s`  | `char *`         | First 3 characters                  | String truncation        | `Hel`          |
| `%p`    | `void *`         | Memory address                      | —                        | `0x7ffd...`    |
| `%%`    | —                | Literal `%`                         | —                        | `%`            |
| `%+d`   | `int`            | Force sign                          | Shows `+` or `-`         | `+42`          |
| `%06d`  | `int`            | Zero-padded integer                 | Pads with `0`            | `000042`       |
| `%-6d`  | `int`            | Left-aligned integer                | Right padded             | `42␣␣␣␣`       |
| `%#x`   | `int`            | Hex with prefix                     | Adds `0x`                | `0x2a`         |






*/
