/* JS Intro

* What is JavaScript?
JavaScript is the programming language of the web.

It can update and change both HTML and CSS.

It can calculate, manipulate and validate data.

Why Study JavaScript?
JavaScript is one of the 3 languages all web developers must learn:

   1. HTML to define the content of web pages

   2. CSS to specify the layout of web pages

   3. JavaScript to program the behavior of web pages

JavaScript Can Change HTML Content
One of many JavaScript HTML methods is getElementById().

The example below "finds" an HTML element (with id="demo"), and changes the element content (innerHTML) to "Hello JavaScript":

Example
document.getElementById("demo").innerHTML = "Hello JavaScript";

*
*
*
*
* JavaScript Introduction
What is JavaScript?
JavaScript is the programming language of the web.

It can update and change both HTML and CSS.

It can calculate, manipulate and validate data.

Why Study JavaScript?
JavaScript is one of the 3 languages all web developers must learn:

   1. HTML to define the content of web pages

   2. CSS to specify the layout of web pages

   3. JavaScript to program the behavior of web pages

JavaScript Can Change HTML Content
One of many JavaScript HTML methods is getElementById().

The example below "finds" an HTML element (with id="demo"), and changes the element content (innerHTML) to "Hello JavaScript":

Example
document.getElementById("demo").innerHTML = "Hello JavaScript";
JavaScript accepts both double and single quotes:

Example
document.getElementById('demo').innerHTML = 'Hello JavaScript';
JavaScript Can Change HTML Attribute Values
In this example JavaScript changes the value of the src (source) attribute of an <img> tag:

The Light Bulb
Turn on the light  Turn off the light


JavaScript Can Change HTML Styles (CSS)
Changing the style of an HTML element, is a variant of changing an HTML attribute:

Example
document.getElementById("demo").style.fontSize = "35px";
JavaScript Can Hide HTML Elements
Hiding HTML elements can be done by changing the display style:

Example
document.getElementById("demo").style.display = "none";

*/

/* JS can be used in 2 ways. inline and external

Inline method uses <script></script> tag for JS. you can use JS into that
Eg : <!DOCTYPE html>
<html>
<head>
<script>
function myFunction() {
  document.getElementById("demo").innerHTML = "Paragraph changed.";
}
</script>
</head>
<body>
<h2>Demo JavaScript in Head</h2>

<p id="demo">A Paragraph</p>
<button type="button" onclick="myFunction()">Try it</button>

</body>
</html>


External method uses .js file. you can link that file to HTML using <script src="file.js"></script> tag
Eg : <!DOCTYPE html>
<html>
<head>
<script src="myScript.js"></script>
<body>

<h2>Demo JavaScript in External File</h2>

</body>
</head>
</html>


External References
An external script can be referenced in 3 different ways:

With a full URL (a full web address)
With a file path (like /js/)
Without any path
This example uses a full URL to link to myScript.js:

Example
<script src="https://www.w3schools.com/js/myScript.js"></script>

This example uses a file path to link to myScript.js:

Example
<script src="/js/myScript.js"></script>

This example uses no path to link to myScript.js:

Example
<script src="myScript.js"></script>

*/

/* JavaScript Output
JavaScript Display Possibilities
JavaScript can "display" data in different ways:

Writing into an HTML element, using innerHTML or innerText.
Writing into the HTML output using document.write().
Writing into an alert box, using window.alert().
Writing into the browser console, using console.log().

Using innerHTML
To access an HTML element, you can use the document.getElementById(id) method.
Use the id attribute to identify the HTML element.
Then use the innerHTML property to change the HTML content of the HTML element:

Example
<!DOCTYPE html>
<html>
<body>

<h1>My First Web Page</h1>
<p>My First Paragraph</p>

<p id="demo"></p>

<script>
document.getElementById("demo").innerHTML = "<h2>Hello World</h2>";
</script>

</body>
</html>
Note: Changing the innerHTML property of an HTML element is the most common way to display data in HTML.

Using innerText
To access an HTML element, use the document.getElementById(id) method.
Then use the innerText property to change the inner text of the HTML element:

Example
<!DOCTYPE html>
<html>
<body>

<h1>My First Web Page</h1>
<p>My First Paragraph</p>

<p id="demo"></p>

<script>
document.getElementById("demo").innerText = "Hello World";
</script>

</body>
</html>
Note: Use innerHTML when you want to change an HTML element. Use innerText when you only want to change the plain text.

Using document.write()
For testing purposes, it is convenient to use document.write():

Example
<!DOCTYPE html>
<html>
<body>

<h1>My First Web Page</h1>
<p>My first paragraph.</p>

<script>
document.write(5 + 6);
</script>

</body>
</html>
Using document.write() after an HTML document is loaded, will delete all existing HTML:

Example
<!DOCTYPE html>
<html>
<body>

<h1>My First Web Page</h1>
<p>My first paragraph.</p>

<button type="button" onclick="document.write(5 + 6)">Try it</button>

</body>
</html>

Note: The document.write() method should only be used for testing.

*/

/*JavaScript Statements

Example

let x, y, z;    // Statement 1
x = 5;          // Statement 2
y = 6;          // Statement 3
z = x + y;      // Statement 4

JavaScript Programs
A computer program is a list of "instructions" to be "executed" by a computer.
In a programming language, these programming instructions are called statements.
A JavaScript program is a list of programming statements.
In HTML, JavaScript programs are executed by the web browser.

JavaScript statements are composed of:
Values, Operators, Expressions, Keywords, and Comments.
This statement tells the browser to write "Hello Dolly." inside an HTML element with id="demo":

Example
document.getElementById("demo").innerHTML = "Hello Dolly.";
Most JavaScript programs contain many JavaScript statements.

The statements are executed, one by one, in the same order as they are written.
JavaScript programs (and JavaScript statements) are often called JavaScript code.

Semicolons ;
Semicolons separate JavaScript statements.
Add a semicolon at the end of each executable statement:

Examples
let a, b, c;  // Declare 3 variables
a = 5;        // Assign the value 5 to a
b = 6;        // Assign the value 6 to b
c = a + b;    // Assign the sum of a and b to c

When separated by semicolons, multiple statements on one line are allowed:
a = 5; b = 6; c = a + b;

On the web, you might see examples without semicolons.
Ending statements with semicolon is not required, but highly recommended.

JavaScript White Space
JavaScript ignores multiple spaces. You can add white space to your script to make it more readable.

The following lines are equivalent:

let person = "Hege";
let person="Hege";

A good practice is to put spaces around operators ( = + - * / ):
Eg : let x = y + z;

JavaScript Line Length and Line Breaks
For best readability, programmers often like to avoid code lines longer than 80 characters.
If a JavaScript statement does not fit on one line, the best place to break it is after an operator:

Example
document.getElementById("demo").innerHTML =
"Hello Dolly!";

JavaScript Code Blocks
JavaScript statements can be grouped together in code blocks, inside curly brackets {...}.
The purpose of code blocks is to define statements to be executed together.
One place you will find statements grouped together in blocks, is in JavaScript functions:

Example
function myFunction() {
  document.getElementById("demo1").innerHTML = "Hello Dolly!";
  document.getElementById("demo2").innerHTML = "How are you?";
}*/

/* References
Keyword	   Description
var	      Declares a variable
let	      Declares a block variable
const	      Declares a block constant
if	         Marks a block of statements to be executed on a condition
switch	   Marks a block of statements to be executed in different cases
for	      Marks a block of statements to be executed in a loop
function	   Declares a function
return	   Exits a function
try	      Implements error handling to a block of statements

Note: JavaScript keywords are reserved words. Reserved words cannot be used as names for variables.

*/

/* JavaScript Syntax

JavaScript syntax is the set of rules, how JavaScript programs are constructed:

// How to create variables:
var x;
let y;

// How to use variables:
x = 5;
y = 6;
let z = x + y;

JavaScript Values

The JavaScript syntax defines two types of values:

Fixed values
Variable values
Fixed values are called Literals.
Variable values are called Variables.

JavaScript Literals
The two most important syntax rules for fixed values are:

1. Numbers are written with or without decimals:
10.5
1001

2. Strings are text, written within double or single quotes:
"John Doe"
'John Doe'


JavaScript Variables

In a programming language, variables are used to store data values.
JavaScript uses the keywords var, let and const to declare variables.
An equal sign is used to assign values to variables.
In this example, x is defined as a variable. Then, x is assigned (given) the value 6:

let x;
x = 6;

JavaScript Operators
JavaScript uses arithmetic operators ( + - * / ) to compute values:

(5 + 6) * 10
JavaScript uses an assignment operator ( = ) to assign values to variables:

let x, y;
x = 5;
y = 6;

JavaScript Expressions

An expression is a combination of values, variables, and operators, which computes to a value.
The computation is called an evaluation.
For example, 5 * 10 evaluates to 50:
5 * 10

Expressions can also contain variable values:
x * 10

The values can be of various types, such as numbers and strings.
For example, "John" + " " + "Doe", evaluates to "John Doe":
"John" + " " + "Doe"

JavaScript Keywords
JavaScript keywords are used to identify actions to be performed.
The let keyword tells the browser to create variables:

let x, y;
x = 5 + 6;
y = x * 10;

The var keyword also tells the browser to create variables:

var x, y;
x = 5 + 6;
y = x * 10;

In these examples, using var or let will produce the same result.
You will learn more about var and let later in this tutorial.

JavaScript Comments
Not all JavaScript statements are "executed".
Code after double slashes // or between  is treated as a comment.
Comments are ignored, and will not be executed:

let x = 5;   // I will be executed

// x = 6;   I will NOT be executed
You will learn more about comments in a later chapter.

JavaScript Identifiers / Names
Identifiers are JavaScript names.
Identifiers are used to name variables and keywords, and functions.
The rules for legal names are the same in most programming languages.
A JavaScript name must begin with:

A letter (A-Z or a-z)
A dollar sign ($)
Or an underscore (_)
Subsequent characters may be letters, digits, underscores, or dollar signs.

Note: Numbers are not allowed as the first character in names.

This way JavaScript can easily distinguish identifiers from numbers.

JavaScript is Case Sensitive

All JavaScript identifiers are case sensitive. 
The variables lastName and lastname, are two different variables:

let lastname, lastName;
lastName = "Doe";
lastname = "Peterson";
JavaScript does not interpret LET or Let as the keyword let.

JavaScript and Camel Case
Historically, programmers have used different ways of joining multiple words into one variable name:

Hyphens:
first-name, last-name, master-card, inter-city.
Hyphens are not allowed in JavaScript. They are reserved for subtractions.

Underscore:
first_name, last_name, master_card, inter_city.

Upper Camel Case (Pascal Case):
FirstName, LastName, MasterCard, InterCity.


Lower Camel Case:
JavaScript programmers tend to use camel case that starts with a lowercase letter:
firstName, lastName, masterCard, interCity.

*/

/* JavaScript Variables

Variables are Containers for Storing Data
JavaScript Variables can be declared in 4 ways:

Automatically
Using var
Using let
Using const

In this first example, x, y, and z are undeclared variables.
They are automatically declared when first used:

Example
x = 5;

Note: It is considered good programming practice to always declare variables before use.

From the examples you can guess:
x stores the value 5

Example using var
var x = 5;


Note: The var keyword was used in all JavaScript code from 1995 to 2015.
The let and const keywords were added to JavaScript in 2015.
The var keyword should only be used in code written for older browsers.


Example using const
const x = 5;
const y = 6;
const z = x + y;
Mixed Example
const price1 = 5;
const price2 = 6;
let total = price1 + price2;
The two variables price1 and price2 are declared with the const keyword.

These are constant values and cannot be changed.

The variable total is declared with the let keyword.

The value total can be changed.

When to Use var, let, or const?
1. Always declare variables

2. Always use const if the value should not be changed

3. Always use const if the type should not be changed (Arrays and Objects)

4. Only use let if you can't use const

5. Only use var if you MUST support old browsers.

Just Like Algebra
Just like in algebra, variables hold values:

let x = 5;
let y = 6;
Just like in algebra, variables are used in expressions:

let z = x + y;
From the example above, you can guess that the total is calculated to be 11.

Note
Variables are containers for storing values.


JavaScript Identifiers
All JavaScript variables must be identified with unique names.

These unique names are called identifiers.

Identifiers can be short names (like x and y) or more descriptive names (age, sum, totalVolume).

The general rules for constructing names for variables (unique identifiers) are:

Names can contain letters, digits, underscores, and dollar signs.
Names must begin with a letter.
Names can also begin with $ and _ (but we will not use it in this tutorial).
Names are case sensitive (y and Y are different variables).
Reserved words (like JavaScript keywords) cannot be used as names.
Note
JavaScript identifiers are case-sensitive.

The Assignment Operator
In JavaScript, the equal sign (=) is an "assignment" operator, not an "equal to" operator.

This is different from algebra. The following does not make sense in algebra:

x = x + 5
In JavaScript, however, it makes perfect sense: it assigns the value of x + 5 to x.

(It calculates the value of x + 5 and puts the result into x. The value of x is incremented by 5.)

Note
The "equal to" operator is written like == in JavaScript.

JavaScript Data Types
JavaScript variables can hold numbers like 100 and text values like "John Doe".

In programming, text values are called text strings.

JavaScript can handle many types of data, but for now, just think of numbers and strings.

Strings are written inside double or single quotes. Numbers are written without quotes.

If you put a number in quotes, it will be treated as a text string.

Example
const pi = 3.14;
let person = "John Doe";
let answer = 'Yes I am!';
Declaring a JavaScript Variable
Creating a variable in JavaScript is called "declaring" a variable.

You declare a JavaScript variable with the var or the let keyword:

var carName;
or:
let carName;
After the declaration, the variable has no value (technically it is undefined).

To assign a value to the variable, use the equal sign:

carName = "Volvo";
You can also assign a value to the variable when you declare it:

let carName = "Volvo";
In the example below, we create a variable called carName and assign the value "Volvo" to it.

Then we "output" the value inside an HTML paragraph with id="demo":

Example
<p id="demo"></p>

<script>
let carName = "Volvo";
document.getElementById("demo").innerHTML = carName;
</script>
Note
It's a good programming practice to declare all variables at the beginning of a script.

One Statement, Many Variables
You can declare many variables in one statement.

Start the statement with let and separate the variables by comma:

Example
let person = "John Doe", carName = "Volvo", price = 200;
A declaration can span multiple lines:

Example
let person = "John Doe",
carName = "Volvo",
price = 200;
Value = undefined
In computer programs, variables are often declared without a value. The value can be something that has to be calculated, or something that will be provided later, like user input.

A variable declared without a value will have the value undefined.

The variable carName will have the value undefined after the execution of this statement:

Example
let carName;
Re-Declaring JavaScript Variables
If you re-declare a JavaScript variable declared with var, it will not lose its value.

The variable carName will still have the value "Volvo" after the execution of these statements:

Example
var carName = "Volvo";
var carName;
Note
You cannot re-declare a variable declared with let or const.

This will not work:

let carName = "Volvo";
let carName;
JavaScript Arithmetic
As with algebra, you can do arithmetic with JavaScript variables, using operators like = and +:

Example
let x = 5 + 2 + 3;
You can also add strings, but strings will be concatenated:

Example
let x = "John" + " " + "Doe";
Also try this:

Example
let x = "5" + 2 + 3;
Note
If you put a number in quotes, the rest of the numbers will be treated as strings, and concatenated.

Now try this:

Example
let x = 2 + 3 + "5";
JavaScript Dollar Sign $
Since JavaScript treats a dollar sign as a letter, identifiers containing $ are valid variable names:

Example
let $ = "Hello World";
let $$$ = 2;
let $myMoney = 5;
Using the dollar sign is not very common in JavaScript, but professional programmers often use it as an alias for the main function in a JavaScript library.

In the JavaScript library jQuery, for instance, the main function $ is used to select HTML elements. In jQuery $("p"); means "select all p elements".

JavaScript Underscore (_)
Since JavaScript treats underscore as a letter, identifiers containing _ are valid variable names:

Example
let _lastName = "Johnson";
let _x = 2;
let _100 = 5;
Using the underscore is not very common in JavaScript, but a convention among professional programmers is to use it as an alias for "private (hidden)" variables.
*/

/*JavaScript Let

The let keyword was introduced in ES6 (2015)
Variables declared with let have Block Scope
Variables declared with let must be Declared before use
Variables declared with let cannot be Redeclared in the same scope

Block Scope
Before ES6 (2015), JavaScript did not have Block Scope.
JavaScript had Global Scope and Function Scope.
ES6 introduced the two new JavaScript keywords: let and const.
These two keywords provided Block Scope in JavaScript:

Example
Variables declared inside a { } block cannot be accessed from outside the block:

{
  let x = 2;
}
// x can NOT be used here

Global Scope

Variables declared with the var always have Global Scope.
Variables declared with the var keyword can NOT have block scope:

Example
Variables declared with varinside a { } block can be accessed from outside the block:

{
  var x = 2;
}
// x CAN be used here

Cannot be Redeclared
Variables defined with let can not be redeclared.
You can not accidentally redeclare a variable declared with let.
With let you can not do this:

let x = "John Doe";
let x = 0;

Variables defined with var can be redeclared.
With var you can do this:

var x = "John Doe";
var x = 0;

Redeclaring Variables
Redeclaring a variable using the var keyword can impose problems.
Redeclaring a variable inside a block will also redeclare the variable outside the block:

Example
var x = 10;
// Here x is 10

{
var x = 2;
// Here x is 2
}

// Here x is 2

Redeclaring a variable using the let keyword can solve this problem.
Redeclaring a variable inside a block will not redeclare the variable outside the block:

Example
let x = 10;
// Here x is 10

{
let x = 2;
// Here x is 2
}

// Here x is 10


Difference Between var, let and const

        Scope	Redeclare	Reassign	Hoisted	    Binds this
var	    No	       Yes	       Yes	       Yes	        Yes
let	    Yes	       No	       Yes	       No	        No
const	Yes	       No	       No	       No	        No

What is Good?

let and const have block scope.
let and const can not be redeclared.
let and const must be declared before use.
let and const does not bind to this.
let and const are not hoisted.

What is Not Good?
var does not have to be declared.

var is hoisted.

var binds to this. */

/*JavaScript Const

The const keyword was introduced in ES6 (2015)
Variables defined with const cannot be Redeclared
Variables defined with const cannot be Reassigned
Variables defined with const have Block Scope

Cannot be Reassigned

A variable defined with the const keyword cannot be reassigned:

Example
const PI = 3.141592653589793;
PI = 3.14;      // This will give an error
PI = PI + 10;   // This will also give an error
Must be Assigned
JavaScript const variables must be assigned a value when they are declared:

Correct
const PI = 3.14159265359;

When to use JavaScript const?

Always declare a variable with const when you know that the value should not be changed.
Use const when you declare:
A new Array
A new Object
A new Function
A new RegExp

Constant Objects and Arrays

The keyword const is a little misleading.
It does not define a constant value. It defines a constant reference to a value.
Because of this you can NOT:

Reassign a constant value
Reassign a constant array
Reassign a constant object

But you CAN:

Change the elements of constant array
Change the properties of constant object
Constant Arrays
You can change the elements of a constant array:

Example
// You can create a constant array:
const cars = ["Saab", "Volvo", "BMW"];

// You can change an element:
cars[0] = "Toyota";

// You can add an element:
cars.push("Audi");

But you can NOT reassign the array:
Example
const cars = ["Saab", "Volvo", "BMW"];

cars = ["Toyota", "Volvo", "Audi"];    // ERROR
Constant Objects
You can change the properties of a constant object:

Example
// You can create a const object:
const car = {type:"Fiat", model:"500", color:"white"};

// You can change a property:
car.color = "red";

// You can add a property:
car.owner = "Johnson";
But you can NOT reassign the object:

Example
const car = {type:"Fiat", model:"500", color:"white"};
car = {type:"Volvo", model:"EX60", color:"red"}    // ERROR

*/

/*JavaScript Arithmetic
JavaScript Arithmetic Operators
Arithmetic operators perform arithmetic on numbers (literals or variables).

Operator	Description
+	Addition
-	Subtraction
*	Multiplication
**	Exponentiation (ES2016)
/	Division
%	Modulus (Remainder)
++	Increment
--	Decrement

function arithmetic() {
    let x = 10;
    var y = 10;

    console.log(x+y); // Addition
    console.log(x-y); // Subtraction
    console.log(x*y); // Multiplication
    console.log(x/y); // Division
    console.log(x**y); // It is same as math.pow(x,y); (Exponentiation)
    console.log(x%y); // Modulus (Remainder)
    x ++; // This is increment function (Add by 1)
    y --; // This is decrement Function (Reduce by 1)
}

// This function is enough to teach about arithmetic
*/

/* JavaScript Assignment
JavaScript Assignment Operators
Assignment operators assign values to JavaScript variables.

Standard Assignment Operators

| Operator | Example   | Same As      | Function                                                      |
| -------- | --------- | ------------ | ------------------------------------------------------------- |
| `=`      | `x = y`   | `x = y`      | Assigns the value of `y` to `x`.                              |
| `+=`     | `x += y`  | `x = x + y`  | Adds `y` to `x` and assigns the result to `x`.                |
| `-=`     | `x -= y`  | `x = x - y`  | Subtracts `y` from `x` and assigns the result to `x`.         |
| `*=`     | `x *= y`  | `x = x * y`  | Multiplies `x` by `y` and assigns the result to `x`.          |
| `/=`     | `x /= y`  | `x = x / y`  | Divides `x` by `y` and assigns the result to `x`.             |
| `%=`     | `x %= y`  | `x = x % y`  | Assigns the remainder of `x / y` to `x`.                      |
| `**=`    | `x **= y` | `x = x ** y` | Raises `x` to the power of `y` and assigns the result to `x`. |

Bitwise Assignment Operators

| Operator | Example  | Same As     | Function                                                                       |         |     |                                                                               |
| -------- | -------- | ----------- | ------------------------------------------------------------------------------ | ------- | --- | ----------------------------------------------------------------------------- |
| `&=`     | `x &= y` | `x = x & y` | Performs a bitwise AND operation on `x` and `y` and assigns the result to `x`. |         |     |                                                                               |
| `^=`     | `x ^= y` | `x = x ^ y` | Performs a bitwise XOR operation on `x` and `y` and assigns the result to `x`. |         |     |                                                                               |

Shift Assignment Operator

| Operator | Example    | Same As       | Function                                                                             |
| -------- | ---------- | ------------- | ------------------------------------------------------------------------------------ |
| `<<=`    | `x <<= y`  | `x = x << y`  | Shifts the bits of `x` to the left by `y` places and assigns the result to `x`.      |
| `>>=`    | `x >>= y`  | `x = x >> y`  | Shifts the bits of `x` to the right by `y` places and assigns the result to `x`.     |
| `>>>=`   | `x >>>= y` | `x = x >>> y` | Shifts the bits of `x` to the right by `y` places with zero-fill and assigns to `x`. |

Logical Assignment Operators

| Operator | Example   | Same As            | Function                                                 |   |       |         |   |           |                                          |
| -------- | --------- | ------------------ | -------------------------------------------------------- | - | ----- | ------- | - | --------- | ---------------------------------------- |
| `&&=`    | `x &&= y` | `x = x && (x = y)` | Assigns `y` to `x` only if `x` is truthy.                |   |       |         |   |           |                                          |
| `??=`    | `x ??= y` | `x = x ?? (x = y)` | Assigns `y` to `x` only if `x` is `null` or `undefined`. |   |       |         |   |           |                                          |


*/

/* Accept User Input : 

there are 2 ways to accept user inputs in JS
1) Window box
2) HTML Textbox

1) Eg : 

let username;
username = window.prompt("Enter Your Username : ");
console.log(username);

2) Eg : 

let username;
document.getElementById("mySubmit").onclick = function() {
    username = document.getElementById("user_text").value;
    document.getElementById("myH1").textContent = `Hello, ${username}`
}



*/

/*Javascript Datatypes 

function datatypes() {
// Numbers:
let length = 16;
let weight = 7.5;

// Strings:
let color = "Yellow";
let lastName = "Johnson";

// Booleans
let x = true;
let y = false;

// Object:
const person = {firstName:"John", lastName:"Doe"};

// Array object:
const cars = ["Saab", "Volvo", "BMW"];

// Date object:
const date = new Date("2022-03-25");
}

JavaScript has 8 Datatypes
String
Number
Bigint
Boolean
Undefined
Null
Symbol
Object

The Object Datatype
The object data type can contain both built-in objects, and user defined objects:

Built-in object types can be:
objects, arrays, dates, maps, sets, intarrays, floatarrays, promises, and more.

The hell starts now.
Think what could happened if we add a string and int, 
if you have previous experience in programming, you would have said that it throws a error 
but in JS, it considers int as string and add it to the string
it will add normally till it encounters string.

It is illogical but we have to accept

another thing you want to hear,
it has only one type which is float 64 or long int we commonly say
there is no int, no 32 bit float, only 64 bit

what about numbers, it is stored with .0
for eg : if you use let x = 10; , it stores 10.0 not 10'

then all are normal python script like

booleans, same true or false

if you want to assign a array, 
in JS, it is dynamic and you can put any value
like, const cars = ["Saab", "Volvo", "BMW"];

why const, we use it because we cannot change the type after declaration
but you can change the values inside it

and instead of dictionaries or hash-maps, we have objects which is same key:value pair
for eg : const person = {firstName:"John", lastName:"Doe", age:50, eyeColor:"blue"};
just remove const and you get python dictionaries

and in python we use type to find type, here we use typeof() function

instead of None in python, we have undefined
 */

/*Javascript Functions :

JavaScript Function Syntax

A JavaScript function is defined with the function keyword, followed by a name, followed by parentheses ().
Function names can contain letters, digits, underscores, and dollar signs (same rules as variables).
The parentheses may include parameter names separated by commas:
(parameter1, parameter2, ...)
The code to be executed, by the function, is placed inside curly brackets: {}

function name(parameter1, parameter2, parameter3) {
  // code to be executed
}

Function parameters are listed inside the parentheses () in the function definition.
Function arguments are the values received by the function when it is invoked.
Inside the function, the arguments (the parameters) behave as local variables.

Function Invocation
The code inside the function will execute when "something" invokes (calls) the function:

When an event occurs (when a user clicks a button)
When it is invoked (called) from JavaScript code
Automatically (self invoked)
You will learn a lot more about function invocation later in this tutorial.

Function Return
When JavaScript reaches a return statement, the function will stop executing.
If the function was invoked from a statement, JavaScript will "return" to execute the code after the invoking statement.
Functions often compute a return value. The return value is "returned" back to the "caller":

Example
Calculate the product of two numbers, and return the result:

// Function is called, the return value will end up in x
let x = myFunction(4, 3);

function myFunction(a, b) {
    // Function returns the product of a and b
    return a * b;
}

Note: There is a difference between invoking with function_name() and function_name.
Python throws a object pointer if function_name is called
JS gives the object itself if function_name is called

Local Variables
Variables declared within a JavaScript function, become LOCAL to the function.
Local variables can only be accessed from within the function.

Example
// code here can NOT use carName

function myFunction() {
  let carName = "Volvo";
  // code here CAN use carName
}

// code here can NOT use carName


*/

/* Javascript Objects

Before we learn about objects in JS, we have to learn what is object in real life 
in real life, objects are like : houses, cars, bikes and so on.

each object has a unique property. like take a car , it has a name, model, speed and brake
a user needs to call (invoke) a method like take if a user wants to start a car, he has to use a key
similarly, here we use car.start() method 

so a object looks like this
it is similar to a variable like
let a = 10;
but it has a {name:value pair}
like const a = {name:"saisakthi",place="london"}
Note: It is a common practice to declare objects with the const keyword.because we cannot change the object type once declared

JavaScript Object Definition / Initialization

How to Define a JavaScript Object
1) Using an Object Literal
2) Using the new Keyword
3) Using an Object Constructor

Examples :

// Create an Object
const person = {firstName:"John", lastName:"Doe", age:50, eyeColor:"blue"};
Spaces and line breaks are not important. An object initializer can span multiple lines:

// Create an Object
const person = {
  firstName: "John",
  lastName: "Doe",
  age: 50,
  eyeColor: "blue"
};

This example creates an empty JavaScript object, and then adds 4 properties:

// Create an Object
const person = {};

// Add Properties
person.firstName = "John";
person.lastName = "Doe";
person.age = 50;
person.eyeColor = "blue";
Using the new Keyword
This example create a new JavaScript object using new Object(), and then adds 4 properties:

Example
// Create an Object
const person = new Object();

// Add Properties
person.firstName = "John";
person.lastName = "Doe";
person.age = 50;
person.eyeColor = "blue";

Note: The examples above do exactly the same. But, there is no need to use new Object(). For readability, simplicity and execution speed, use the object literal method.

Object Properties
The named values, in JavaScript objects, are called properties.

Property	    Value
firstName	    John
lastName	    Doe
age	            50
eyeColor	    blue

Objects written as name value pairs are similar to:

Associative arrays in PHP
Dictionaries in Python
Hash tables in C
Hash maps in Java
Hashes in Ruby and Perl

Important: Accessing Object Properties
You can access object properties in two ways:

objectName.propertyName
objectName["propertyName"]

Important: In JavaScript, Objects are King.

If you Understand Objects, you Understand JavaScript.
Objects are containers for Properties and Methods.
Properties are named Values.
Methods are Functions stored as Properties.
Properties can be primitive values, functions, or even other objects.

In JavaScript, almost "everything" is an object.

Objects are objects
Maths are objects
Functions are objects
Dates are objects
Arrays are objects
Maps are objects
Sets are objects
All JavaScript values, except primitives, are objects.

JavaScript Primitives
A primitive value is a value that has no properties or methods.
3.14 is a primitive value
A primitive data type is data that has a primitive value.
JavaScript defines 7 types of primitive data types:

string
number
boolean
null
undefined
symbol
bigint

Important: The Main Difference between JS Objects and JS Primitive Values
| **Feature**           | **JavaScript Objects**                                             | **Primitive Values**                                                    |
| --------------------- | ------------------------------------------------------------------ | ----------------------------------------------------------------------- |
| **Definition**        | A collection of key-value pairs (complex data structure).          | Immutable data types representing a single value.                       |
| **Types**             | `Object`, `Array`, `Function`, `Date`, etc.                        | `String`, `Number`, `Boolean`, `Symbol`, `BigInt`, `Undefined`, `Null`. |
| **Mutability**        | Mutable (can be changed after creation).                           | Immutable (cannot be changed, but can be reassigned).                   |
| **Stored As**         | Reference (points to a memory location).                           | Value (stored directly in the variable).                                |
| **Comparison**        | Compared by reference (`===` checks memory location).              | Compared by value (`===` checks actual value).                          |
| **Performance**       | Slower due to reference handling and additional memory allocation. | Faster due to direct value storage.                                     |
| **Usage**             | Useful for storing collections and complex data structures.        | Useful for storing simple values like numbers, text, etc.               |
| **Memory Allocation** | Allocated on the **heap** (dynamic memory).                        | Allocated on the **stack** (static memory).                             |
| **Examples**          | `{name: "John"}`, `[1, 2, 3]`, `function() {}`                     | `42`, `"Hello"`, `true`, `null`, `undefined`.                           |





*/

/* Javascript Object Properties

Definition: Objects are unordered collections of key-value pairs (properties).
Properties can be changed, added, deleted, or be read-only.

Accessing Properties
Dot Notation:
let age = person.age;

Bracket Notation:
let age = person["age"];

Expression Notation:
let x = "age";
let age = person[x];

Adding New Properties

Simply assign a value to a new key:
person.nationality = "English";

Deleting Properties

Use the delete keyword:
delete person.age;
delete person["age"];
Note: Deleting a property removes both the property and its value.

Nested Objects
Property values can be objects themselves:

const myObj = {
  name: "John",
  myCars: {
    car1: "Ford",
    car2: "BMW",
  }
};

Access Nested Properties:

myObj.myCars.car2;
myObj["myCars"]["car2"];

*/

/*Javascript Object Methods :

Definition: Object methods are actions that can be performed on objects.
A method is a function definition stored as a property value.

Example
const person = {
  firstName: "John",
  lastName: "Doe",
  id: 5566,
  fullName: function() {
    return this.firstName + " " + this.lastName;
  }
};

In the example above, this refers to the person object:
this.firstName means the firstName property of person.
this.lastName means the lastName property of person.


Accessing Object Methods

You access an object method with the following syntax:
objectName.methodName()

If you invoke the fullName property with (), it will execute as a function:
Example
name = person.fullName();

If you access the fullName property without (), it will return the function definition:
Example
name = person.fullName;


Adding a Method to an Object

Adding a new method to an object is easy:
Example
person.name = function () {
  return this.firstName + " " + this.lastName;
};

Using JavaScript Methods

This example uses the JavaScript toUpperCase() method to convert a text to uppercase:
Example
person.name = function () {
  return (this.firstName + " " + this.lastName).toUpperCase();
};

// Tip: The Concept String Formatting can be use here with ${} instead of f"{}" in Python


*/

/* Javascript Display Objects :

Important: Displaying a JavaScript object will output [object Object].

Example
// Create an Object
const person = {
  name: "John",
  age: 30,
  city: "New York"
};

document.getElementById("demo").innerHTML = person;

Some solutions to display JavaScript objects are:

Displaying the Object Properties by name
Displaying the Object Properties in a Loop
Displaying the Object using Object.values()
Displaying the Object using JSON.stringify()

Displaying Object Properties
The properties of an object can be displayed as a string:
Example

// Create an Object
const person = {
  name: "John",
  age: 30,
  city: "New York"
};

// Display Properties
document.getElementById("demo").innerHTML =
person.name + "," + person.age + "," + person.city;


Displaying Properties in a Loop
The properties of an object can be collected in a loop:
Example

// Create an Object
const person = {
  name: "John",
  age: 30,
  city: "New York"
};
// Build a Text
let text = "";
for (let x in person) {
  text += person[x] + " ";
};
// Display the Text
document.getElementById("demo").innerHTML = text;

Note: You must use person[x] in the loop. person.x will not work (Because x is the loop variable).


Using Object.values()
Object.values() creates an array from the property values:

// Create an Object
const person = {
  name: "John",
  age: 30,
  city: "New York"
};
// Create an Array
const myArray = Object.values(person);
// Display the Array
document.getElementById("demo").innerHTML = myArray;


Using Object.entries()
Object.entries() makes it simple to use objects in loops:

Example

const fruits = {Bananas:300, Oranges:200, Apples:500};
let text = "";
for (let [fruit, value] of Object.entries(fruits)) {
  text += fruit + ": " + value + "<br>";
}

Using JSON.stringify()
JavaScript objects can be converted to a string with JSON method JSON.stringify().
JSON.stringify() is included in JavaScript and supported in all major browsers.

Note: The result will be a string written in JSON notation: {"name":"John","age":50,"city":"New York"}

Example

// Create an Object
const person = {
  name: "John",
  age: 30,
  city: "New York"
};
// Stringify Object
let myString = JSON.stringify(person);
// Display String
document.getElementById("demo").innerHTML = myString;

*/

/* Javascript Object Constructors

Object Constructor Functions

Sometimes we need to create many objects of the same type.
To create an object type we use an object constructor function.
It is considered good practice to name constructor functions with an upper-case first letter.

Object Type Person
function Person(first, last, age, eye) {
  this.firstName = first;
  this.lastName = last;
  this.age = age;
  this.eyeColor = eye;
}

Note: In the constructor function, this has no value. The value of this will become the new object when a new object is created.

Constructor Function Methods
A constructor function can also have methods:

Example
function Person(first, last, age, eyecolor) {
  this.firstName = first;
  this.lastName = last;
  this.age = age;
  this.eyeColor = eyecolor;
  this.fullName = function() {
    return this.firstName + " " + this.lastName;
  };
}
Adding a Method to an Object
Adding a method to a created object is easy:

Example
myMother.changeName = function (name) {
  this.lastName = name;
}
Note: The new method will be added to myMother. Not to any other Person Objects.

Adding a Method to a Constructor
You cannot add a new method to an object constructor function.

This code will produce a TypeError:

Example
Person.changeName = function (name) {
  this.lastName = name;
}

myMother.changeName("Doe");
 TypeError: myMother.changeName is not a function

Adding a new method must be done to the constructor function prototype:

Example
Person.prototype.changeName = function (name) {
  this.lastName = name;
}

myMother.changeName("Doe");
Note: The changeName() function assigns the value of name to the person's lastName property, substituting this with myMother.

Built-in JavaScript Constructors
JavaScript has built-in constructors for all native objects:

new Object()   // A new Object object
new Array()    // A new Array object
new Map()      // A new Map object
new Set()      // A new Set object
new Date()     // A new Date object
new RegExp()   // A new RegExp object
new Function() // A new Function object
Note: The Math() object is not in the list. Math is a global object. The new keyword cannot be used on Math.

Did You Know?

Use object literals {} instead of new Object().
Use array literals [] instead of new Array().
Use pattern literals /()/ instead of new RegExp().
Use function expressions () {} instead of new Function().




*/

/*  JavaScript Events


HTML events are "things" that happen to HTML elements.
When JavaScript is used in HTML pages, JavaScript can "react" on these events.

HTML Events

An HTML event can be something the browser does, or something a user does.
Here are some examples of HTML events:

An HTML web page has finished loading
An HTML input field was changed
An HTML button was clicked
Often, when events happen, you may want to do something.

JavaScript lets you execute code when events are detected.
HTML allows event handler attributes, with JavaScript code, to be added to HTML elements.

In the following example, an onclick attribute (with code), is added to a <button> element:

<button onclick="document.getElementById('demo').innerHTML = Date()">The time is?</button>

In the example above, the JavaScript code changes the content of the element with id="demo".
In the next example, the code changes the content of its own element (using this.innerHTML):

<button onclick="this.innerHTML = Date()">The time is?</button>

JavaScript code is often several lines long. It is more common to see event attributes calling functions:
<button onclick="displayDate()">The time is?</button>

Common HTML Events
Here is a list of some common HTML events:

Event	            Description
onchange	        An HTML element has been changed
onclick	The         user clicks an HTML element
onmouseover	        The user moves the mouse over an HTML element
onmouseout	        The user moves the mouse away from an HTML element
onkeydown	        The user pushes a keyboard key
onload	            The browser has finished loading the page


JavaScript Event Handlers
Event handlers can be used to handle and verify user input, user actions, and browser actions:

Things that should be done every time a page loads
Things that should be done when the page is closed
Action that should be performed when a user clicks a button
Content that should be verified when a user inputs data
And more ...
Many different methods can be used to let JavaScript work with events:

HTML event attributes can execute JavaScript code directly
HTML event attributes can call JavaScript functions
You can assign your own event handler functions to HTML elements
You can prevent events from being sent or being handled
And more ...
You will learn a lot more about events and event handlers in the HTML DOM chapters.
*/

/* JavaScript Strings

Strings are for storing text
Strings are written with quotes

eg : const k = "sai";
here, sai is the string 

you can also use single quote
eg : const k = 'sai';

Note: A Strings created with single or double quotes work the same. There is no difference between the two in JS

Quotes Inside Quotes
You can use quotes inside a string, as long as they don't match the quotes surrounding the string:

Example
let answer1 = "It's alright";
let answer2 = "He is called 'Johnny'";
let answer3 = 'He is called "Johnny"';

Template Strings
Templates were introduced with ES6 (JavaScript 2016).
Templates are strings enclosed in backticks (`This is a template string`).  
Templates allow single and double quotes inside a string:

Example
let text = `He's often called "Johnny"`;

Note: Templates are not supported in Internet Explorer.

String Length
To find the length of a string, use the built-in length property:

Example
let text = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
let length = text.length;

Escape Characters

Because strings must be written within quotes, JavaScript will misunderstand this string:
let text = "We are the so-called "Vikings" from the north.";
The string will be chopped to "We are the so-called ".

To solve this problem, you can use an backslash escape character.
The backslash escape character (\) turns special characters into string characters:

Code	    Result	Description
\'	'	    Single quote
\"	"	    Double quote
\\	\	    Backslash

Examples
\" inserts a double quote in a string:
let text = "We are the so-called \"Vikings\" from the north.";

\' inserts a single quote in a string:
let text= 'It\'s alright.';

\\ inserts a backslash in a string:
let text = "The character \\ is called backslash.";

Six other escape sequences are valid in JavaScript:

Code	 Result
\b	    Backspace
\f	    Form Feed
\n	    New Line
\r	    Carriage Return
\t	    Horizontal Tabulator
\v	    Vertical Tabulator

Note: The 6 escape characters above were originally designed to control typewriters, teletypes, and fax machines. 
They do not make any sense in HTML.




*/

/*Javascript String Method : 
Basic String Methods
Javascript strings are primitive and immutable: All string methods produce a new string without altering the original string.

String length
String charAt()
String charCodeAt()
String at()
String [ ]
String slice()
String substring()
String substr()
String toUpperCase()
String toLowerCase()
String concat()
String trim()
String trimStart()
String trimEnd()
String padStart()
String padEnd()
String repeat()
String replace()
String replaceAll()
String split()

These are all the necessary and most used methods in JS

We are going to see the function uses with examples

function string_method() {
    const string = "Basic";

    // toUpperCase() : Converts all cases to upper
    string.toUpperCase();

    // toLowerCase() :Converts all cases to lower
    string.toLowerCase();

    // length : Returns the length of the string 
    const len_string = string.length;

    // charAt() : returns the character at a specified index (position) in a string
    const a = string.charAt(2);

    // charCodeAt() :  returns the code of the character at a specified index in a string 
    // The method returns a UTF-16 code (an integer between 0 and 65535).

    const code_at = string.charCodeAt(2)

    // at() : latest added. returns the index. 
    // Note: in at() function, negative index is supported but whereas not in charAt()

    const at_str = string.at(-2);

    // Property Access or we call it indexing in python []
    /* 
    Note: Property access might be a little unpredictable:

    It makes strings look like arrays (but they are not)
    If no character is found, [ ] returns undefined, while charAt() returns an empty string.
    It is read only. str[0] = "A" gives no error (but does not work!)
    

    let char = string[0];

    /* slice()

    slice() extracts a part of a string and returns the extracted part in a new string.
    The method takes 2 parameters: start position, and end position (end not included). 
    
    Syntax : str_name.slice(start, end)

    let j = "This is a Long string";
    var sliced = j.slice(5,12);

    // substring() : it is similar to slice. the only difference is that it does not support negative indexing 
    // and starts from 0 if anyone does 

    let str = "Apple, Banana, Kiwi";
    let part = str.substring(7, 13);

    // trim() : removes whitespace from both sides of a string. it is similar to strip() function in python

    let str5 = "    Hello World !   "
    var str_after_space_removed = str5.trim();

    // Then There is TrimStart() and TrimEnd() function
    // Works like lstrip() and rstrip() in python

    let str6 = "   Hello World!";
    let trimStart_str6 = str6.trimStart();

    let str7 = "Hello World!       ";
    let trimStart_str7 = str7.trimEnd();

    // PadStart() : We have to know what is padding
    //            : Padding is adding strings till the given range ends
    //            : Syntax - strName.padStart [starts padding from start] / padEnd [Starts padding.end] (range / no of times, "String to pad")

    var str8 =  "Hi ";
    var pad_str = str8.padStart(4," There ") // This is for start
    var pad_str_ned = str8.padEnd(4," No ")

    /*JavaScript String repeat()

    The repeat() method returns a string with a number of copies of a string.
    The repeat() method returns a new string.
    The repeat() method does not change the original string. 
    
    

    let text = "Hello world!";
    let result = text.repeat(2);

    // Syntax : string.repeat(count)

    /* Replacing String Content
    The replace() method replaces a specified value with another value in a string:

    let text1 = "Please visit Microsoft!";
    let newText2 = text.replace("Microsoft", "W3Schools");

    /*
    Note: The replace() method does not change the string it is called on. The replace() method returns a new string.The replace() method replaces only the first match 

    // To replace a case-sensitive, use /i flag

    let new_text3 = text.replace(/Microsoft/i, "W3School")
    // Note: Regular expressions are written without quotes.

    // To replace all matches, use a regular expression with a /g flag (global match):
    let new_text4 = text.replace(/Microsoft/g, "Micro")

    /*  JavaScript String split()
    A string can be converted to an array with the split() method: 
    let x = text.split(",")    // Split on commas
    // Note: If the separator is omitted, the returned array will contain the whole string in index [0].
}


*/

/*JavaScript String Search
indexOf()
The indexOf() method returns the index (position) of the first occurrence of a string in a string, or it returns -1 if the string is not found:


*/

/* Javascript Arrays 

An Array is an object type designed for storing data collections.

Key characteristics of JavaScript arrays are:

Elements: An array is a list of values, known as elements.
Ordered: Array elements are ordered based on their index.
Zero indexed: The first element is at index 0, the second at index 1, and so on.
Dynamic size: Arrays can grow or shrink as elements are added or removed.
Heterogeneous: Arrays can store elements of different data types (numbers, strings, objects and other arrays).


Why Use Arrays?

If you have a list of items (a list of car names, for example), storing the names in single variables could look like this:
let car1 = "Saab";
let car2 = "Volvo";
let car3 = "BMW";

However, what if you want to loop through the cars and find a specific one? And what if you had not 3 cars, but 300?
The solution is an array!
An array can hold many values under a single name, and you can access the values by referring to an index number.

Creating an Array

Using an array literal is the easiest way to create a JavaScript Array.
Syntax:
const array_name = [item1, item2, ...];  
Note: It is a common practice to declare arrays with the const keyword.

Initializing a Array : 
There are 2 ways to Initialize a Array 

1) const name = [elements];
2) const name = new Array(elements);

My recommendation is to use first method

Changing an Array Element
This statement changes the value of the first element in cars:
cars[0] = "Opel";


Converting an Array to a String
The JavaScript method toString() converts an array to a string of (comma separated) array values.

Example
const fruits = ["Banana", "Orange", "Apple", "Mango"];
document.getElementById("demo").innerHTML = fruits.toString();

Access the Full Array
With JavaScript, the full array can be accessed by referring to the array name:

Example
const cars = ["Saab", "Volvo", "BMW"];
document.getElementById("demo").innerHTML = cars;

Methods to remember for arrays :

| **Method**     | **Definition**                                                         | **Syntax**                    | **Example**                      | **Output**          |
| -------------- | ---------------------------------------------------------------------- | ----------------------------- | -------------------------------- | ------------------- |
| `length`       | Returns the number of elements in the array                            | `array.length`                | `[1, 2, 3].length`               | `3`                 |
| `toString()`   | Converts array to a comma-separated string                             | `array.toString()`            | `[1, 2, 3].toString()`           | `"1,2,3"`           |
| `at()`         | Returns element at a specific index, supports negative indexing        | `array.at(index)`             | `[10, 20, 30].at(-1)`            | `30`                |
| `join()`       | Joins array elements into a string with a separator                    | `array.join(separator)`       | `['a','b','c'].join('-')`        | `"a-b-c"`           |
| `pop()`        | Removes and returns the last element                                   | `array.pop()`                 | `let a=[1,2,3]; a.pop()`         | `a → [1,2]`         |
| `push()`       | Adds elements to the end and returns new length                        | `array.push(elem1, ...)`      | `let a=[1,2]; a.push(3)`         | `a → [1,2,3]`       |
| `shift()`      | Removes and returns the first element                                  | `array.shift()`               | `let a=[1,2,3]; a.shift()`       | `a → [2,3]`         |
| `unshift()`    | Adds elements to the start and returns new length                      | `array.unshift(elem1, ...)`   | `let a=[2,3]; a.unshift(1)`      | `a → [1,2,3]`       |
| `delete`       | Deletes an element at a given index but leaves `undefined`             | `delete array[index]`         | `let a=[1,2,3]; delete a[1]`     | `a → [1, empty, 3]` |
| `concat()`     | Merges arrays and returns a new array                                  | `array1.concat(array2)`       | `[1,2].concat([3,4])`            | `[1,2,3,4]`         |
| `copyWithin()` | Copies elements within the array to another index                      | `array.copyWithin(to, from)`  | `[1,2,3,4].copyWithin(1,2)`      | `[1,3,4,4]`         |
| `flat()`       | Flattens nested arrays (1 level or more)                               | `array.flat(depth)`           | `[1,[2,[3]]].flat(2)`            | `[1,2,3]`           |
| `slice()`      | Returns a shallow copy from start to end (not included)                | `array.slice(start, end)`     | `[1,2,3,4].slice(1,3)`           | `[2,3]`             |
| `splice()`     | Modifies array by removing/replacing/adding items                      | `array.splice(start, delete)` | `let a=[1,2,3,4]; a.splice(1,2)` | `a → [1,4]`         |
| `toSpliced()`  | Returns a new array with elements removed (non-destructive `splice()`) | `array.toSpliced(start, del)` | `[1,2,3,4].toSpliced(1,2)`       | `[1,4]`             |

Javascript Array Search : 

| **Method**        | **Definition**                                                                                      | **Syntax**                                    | **Example**                                |
| ----------------- | --------------------------------------------------------------------------------------------------- | --------------------------------------------- | ------------------------------------------ |
| `indexOf()`       | Returns the **first index** at which a given element can be found, or `-1` if not found.            | `array.indexOf(searchElement, fromIndex)`     | `['a', 'b', 'c'].indexOf('b') // 1`        |
| `lastIndexOf()`   | Returns the **last index** at which a given element can be found, or `-1` if not found.             | `array.lastIndexOf(searchElement, fromIndex)` | `['a', 'b', 'a'].lastIndexOf('a') // 2`    |
| `includes()`      | Checks if an array **includes** a certain value among its entries. Returns `true` or `false`.       | `array.includes(searchElement, fromIndex)`    | `['a', 'b', 'c'].includes('b') // true`    |
| `find()`          | Returns the **first element** that satisfies the provided testing function.                         | `array.find(callbackFn, thisArg)`             | `[1, 4, 7].find(n => n > 3) // 4`          |
| `findIndex()`     | Returns the **index of the first element** that satisfies the testing function, or `-1`.            | `array.findIndex(callbackFn, thisArg)`        | `[1, 4, 7].findIndex(n => n > 3) // 1`     |
| `findLast()`      | Returns the **last element** that satisfies the testing function. *(ES2023+)*                       | `array.findLast(callbackFn, thisArg)`         | `[1, 4, 7].findLast(n => n > 3) // 7`      |
| `findLastIndex()` | Returns the **index of the last element** that satisfies the testing function, or `-1`. *(ES2023+)* | `array.findLastIndex(callbackFn, thisArg)`    | `[1, 4, 7].findLastIndex(n => n > 3) // 2` |

Note: For searching from end to start, use negative indexing

Array Sorting :
| **Name**               | **Definition**                                                                  | **Function / Use**                                  | **Syntax**                              | **Example**                                                                |
| ---------------------- | ------------------------------------------------------------------------------- | --------------------------------------------------- | --------------------------------------- | -------------------------------------------------------------------------- |
| **Alphabetic Sort**    | Sorts array elements as strings in lexicographic (Unicode) order.               | Sorts strings alphabetically.                       | `array.sort()`                          | `["banana", "apple"].sort()` → `["apple", "banana"]`                       |
| **Array sort()**       | Sorts elements **in place** and returns the sorted array.                       | Default: Converts elements to strings and compares. | `array.sort([compareFn])`               | `[40, 1, 5].sort()` → `[1, 40, 5]` (wrong for numbers without `compareFn`) |
| **Array reverse()**    | Reverses the elements **in place**.                                             | Changes the order of elements in the array.         | `array.reverse()`                       | `[1, 2, 3].reverse()` → `[3, 2, 1]`                                        |
| **Array toSorted()**   | Returns a **shallow copy** of the array sorted, **without modifying original**. | Safer alternative to `sort()` for immutability.     | `array.toSorted([compareFn])`           | `[3, 1, 2].toSorted()` → `[1, 2, 3]`                                       |
| **Array toReversed()** | Returns a **shallow copy** of the reversed array.                               | Reverses without changing the original array.       | `array.toReversed()`                    | `[1, 2, 3].toReversed()` → `[3, 2, 1]`                                     |
| **Sorting Objects**    | Sorts array of objects using a `compareFn`.                                     | Useful for sorting by property value.               | `array.sort((a, b) => a.prop - b.prop)` | `users.sort((a, b) => a.age - b.age)`                                      |
| **Numeric Sort**       | Sorts numbers using a comparison function.                                      | Sorts numbers correctly (vs. alphabetically).       | `array.sort((a, b) => a - b)`           | `[40, 1, 5].sort((a, b) => a - b)` → `[1, 5, 40]`                          |
| **Random Sort**        | Shuffles an array randomly (not truly random).                                  | Used for shuffling items (e.g., quiz questions).    | `array.sort(() => Math.random() - 0.5)` | `[1, 2, 3].sort(() => Math.random() - 0.5)`                                |
| **Math.min()**         | Returns the smallest number from a list.                                        | Finds the minimum value.                            | `Math.min(a, b, ...)`                   | `Math.min(1, 5, -3)` → `-3`                                                |
| **Math.max()**         | Returns the largest number from a list.                                         | Finds the maximum value.                            | `Math.max(a, b, ...)`                   | `Math.max(1, 5, -3)` → `5`                                                 |
| **Home made Min()**    | Custom logic to find min from an array.                                         | Alternative to `Math.min`.                          | `Math.min(...arr)` or loop              | `Math.min(...[5, 2, 9])` → `2`                                             |
| **Home made Max()**    | Custom logic to find max from an array.                                         | Alternative to `Math.max`.                          | `Math.max(...arr)` or loop              | `Math.max(...[5, 2, 9])` → `9`                                             |































Const Block Scope

An array declared with const has Block Scope.
An array declared in a block is not the same as an array declared outside the block:

Example
const cars = ["Saab", "Volvo", "BMW"];
// Here cars[0] is "Saab"
{
  const cars = ["Toyota", "Volvo", "BMW"];
  // Here cars[0] is "Toyota"
}
// Here cars[0] is "Saab"

An array declared with var does not have block scope:

Example
var cars = ["Saab", "Volvo", "BMW"];
// Here cars[0] is "Saab"
{
  var cars = ["Toyota", "Volvo", "BMW"];
  // Here cars[0] is "Toyota"
}
// Here cars[0] is "Toyota"




*/

/* Javascript Array Iteration : 

Array Iteration Methods
Array iteration methods operate on every array item.

1) forEach(callback_function):
This is a simple one. it just take each element in array and apply it to the function.
instead of writing : 
for x in array: 
    f(x)
we can use : 
forEach(f)

2) map() : The map() method creates a new array by performing a function on each array element.
The map() method does not execute the function for array elements without values.

The map() method does not change the original array.


*/

/*Javascript Spread and Rest Operator

... : these look like 3 dots but it is the 3 stages of reaching god if you are using arrays for singular function
remember we have map in python, these are also the same.

just for eg : 
let a = [1,2,3,4,5];
let b = Math.max(a);
if you expected 5, i expect you are a python programmer. because js cannot unpack array and find max
for that we have ... operator which unpacks all the element and make it easier to iterate

we can do the same thing with strings
let k = "jasgkjaskh.kha,dghvsjhads";
let o = [...k];

*/

/* Javascript Callback Function


Callback : a function that is passed as an argument to another function.

used to handle asynchronous operations:
1. Reading a file
2. Network requests
3. Interacting with databases

"Hey, when you're done, call this next."

arr_name.foreach(callback_function) :
It is one of the many function that utilizes the callback function

Instead of writing what we do in Python
l = [1,2,3,4,,5]
def double(x) :
    return x * 2
for x in range(len(l)):
	l[x] = double(l[x])

this function want essentially does is iterate through every loop and applies the double function
Instead of doing this, 
we can just use

let k = [1,2,3,4,5]
k.foreach(function(val) => {return val * 2});
this also does the same thing but with less code


*/

/* Javascript Function Expression 

There are 2 ways to initialize a function

1) This is the most common declaration, we use  function keyword and use a bracket and curly bracket 
function name() {
    statment
}
name


2) This is the less common one, the expression, we can declare a function like just a variable and use it
var k = function() {
	Statment;
}
k();

*/

/* Asynchronous Programming 


Asynchronous programming is a technique that enables your program to start a potentially long-running task 
and still be able to be responsive to other events while that task runs, 
rather than having to wait until that task has finished. Once that task has finished, 
your program is presented with the result.

Many functions provided by browsers, especially the most interesting ones, can potentially take a long time, and therefore, are asynchronous. For example:

Making HTTP requests using fetch()
Accessing a user's camera or microphone using getUserMedia()
Asking a user to select files using showOpenFilePicker()

So before we go into what is a asynchronous programming really is 
we have to see about what is synchronous prgramming is and what's the difference

synchronous programming : it is a continuous programming where the code runs continuously without any interrupt
if any interrupt is needed like (Getting a user input), the program stops and only runs after that task is over

asynchronous programming : it is a non-continuous programmming where the program doesn't need to be continuous
the task which needs time is taken care of afterwards and the program runs continuesly 

there are 2 concept in JS for asynchronous programming

1) promises
2) async/await


first we are going to see about promises


Promise : An Object that manages asynchronous operations. 
          Wrap a Promise object around (asynchronous code} "I promise to return a value"
          PENDING -> RESOLVED or REJECTED
          new Promise((resolve, reject) => (asynchronous code})

DO THESE CHORES IN ORDER
1. WALK THE DOG
2. CLEAN THE KITCHEN 
3. TAKE OUT THE TRASH

function asynchronousProgramming() {
    function clean_the_house(callback) {
        setTimeout(() => {console.log("Cleaned the House");callback();}, 3000)
        
    }
    function walk_the_dog(callback) {
        setTimeout(() => {console.log("Walked the Dog");callback();}, 10000)
        
    }
    function take_the_trash(callback) {
        setTimeout(() => {console.log("Take the Trash");callback();}, 8000)
    }

    clean_the_house(() => {
        walk_the_dog(() => {
            take_the_trash(() => {
                console.log("Completed  the Chores")
            })
        })
    })

}

that code is called the "Callback Hell" which was the most common problem among coders before promise
so the callback is chained and definitely not redable in any sense 
so we introduced promises
now we are going to use those







*/










































