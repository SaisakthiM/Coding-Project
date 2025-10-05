function others() {
    const output = "what's your name"
    .split("")
    .map(parseInt)
    .filter(a => a)
    .reduce((a, b) => a + b)
    .toString()
    .split("")
    .reverse()
    .join("")
    console.log(output)
    
}

function basics() {
    let x,y,z;
    x = 10;
    y = 20;
    z = 30;
    console.log(x + y + z); // Output: 60
    
    
}

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

function assignment() {
    let x = 10;
    let y = 20;
    // +=
    // x -= 5,
    // x *= 10,
    // x /= 10,
    // x **= 2,
    // x %= 5,

    x |= 10;
    x <<= y
    console.log(x
    );
}

function operators() {
    // There are different Types of operators in JS.
    // One of them is === which checks if both sides have same value and data-type
    // If you are a python user, you might ask what is ===. because in python, there is only == 
    // which will check both value and data-type

    // For Eg 

    let PI = Math.PI;
    if ("3.14" == PI) {
        console.log("True") // This will return true because 
    }
    if ("3.14" === PI) {
        console.log("True") // This is False
        
    }
}

function datatypes() {
    var x = 10;
    var y = "volvo";
    let z = 102;
    console.log(x + y + z);
    let truth = true;
    let lie = false;
    // Numbers:
    let length = 16;
    let weight = 7.5;

    // Strings:
    let color = "Yellow";
    let lastName = "Johnson";

    // Booleans
    let x1 = true;
    let y1 = false;

    // Object:
    const person = {firstName:"John", lastName:"Doe"};

    // Array object:
    const cars = ["Saab", "Volvo", "BMW"];

    // Date object:
    const date = new Date("2022-03-25");


}

function area_of_triangle(a,b,c){
    const S = (a + b + c) / 2;
    return Math.sqrt(S * ((S-a) * (S-b) * (S-c)));
}

function methods() {
    // Method
    const person = {        
        firstName : "Sai",
        lastName : "Sakthi",
        id : 1010,
        fullName : function() {
            // Method Function : you can add functions ias a value in JS
            // Note: this keyword is used to access the local variables like in this case, you cannot just use firstname because it is inside as a value
            return this.firstName + " " + this.lastName;
        }
    }
    // Properties 

    //Acesssing a value : objectName.property
    var x = person.firstName;
    // Accessing a value : objectName["property"], This is similar to accessing values in dictionaries, python
    var x = person["firstName"];

    // Adding a new property, Syntax : objectName.newProperty = "Your value" / function()
    person.nationality = "India";

    // Deleting a value, Syntax : delete objectName.property 
    // Note: You can also delete the entire object using delete keyword
    delete person.firstName;

    /* Unique Situation
    If you delete a variable which is in use by a function in another parameter,
    (person.firstName), It is now undefined */
    
    console.log(person.fullName());
}

function object() {
    /* Object : Objects are similar to dictionary in python. 
    it can represent real world objects like (people, car places)
    object = {
        key : value,
        key : function()
    }
    */ 
    const k = {
        "First_Name" : "Jain",
        "Place" : "London",
        "Last_Name" : "Smith",
        "Full_Name" : function full_name() {
            return (this.First_Name + " " + this.Last_Name).toUpperCase()
        }
         // Tip: The Concept String Formatting can be use here with ${} inside `` (back quotes)
        
    }
    console.log(k.Full_Name());
    const person = {
        name : "saisakthi",
        place : "London",
        age : 27,
        about_me : function about_me() {
            return `My name is ${this.name} and My age is ${this.age}. I am from ${this.place}`
        }
        // document.getElementById("person").innerHTML = JSON.stringify(person);
    }
}   

/* The below code is used to receive and process data from forms using DOM (Document Object Model)
document.addEventListener("DOMContentLoaded", () => {
    console.log(10);
    const data = document.getElementById('form_main');
    data.addEventListener('submit', (event) => {
        event.preventDefault(); // Prevent default form submission
        const form_data = new FormData(data);
        for (let [key, value] of form_data.entries()) {
            console.log(`${key}: ${value}`);
        }
    });
});

*/

function object_constructor() {
    function Person(first, last, age, contact) {
    this.first = first;
    this.last = last;
    this.age = age;
    this.contact = contact;
}

    // Using `new` to create instances
    const p1 = new Person("sai", "sakthi", 19, 1023234554);
    const p2 = new Person("jain", "smith", 24, 1211342344);

    // Correctly accessing properties of the objects
    console.log(p1.age); // Output: 19
    console.log(p2.contact); // Output: 1211342344

    // Adding a method to the prototype for all instances
    Person.prototype.getDetails = function() {
        return `My name is ${this.first}. My last name is ${this.last}. My age is ${this.age}, and this is my contact: ${this.contact}`;
    };
    Person.prototype.change_name = function(new_first, new_last){
        this.first = new_first;
        this.last = new_last;
    }

    console.log(p1.getDetails());
    // Output: My name is sai. My last name is sakthi. My age is 19, and this is my contact: 1023234554

    console.log(p2.getDetails());
    // Output: My name is jain. My last name is smith. My age is 24, and this is my contact: 1211342344

    p1.change_name("Ladakh", "Singh");
    // This changes the name of the p1

    console.log(p1.first)
    console.log(p1.last);
}

function strings() {
    // Normal String
    const str = "hi";

    // Template String 
    const str1 = `This is a "Template" 'String' you can include both quotes inside it`

    // Declaration/Initialization using new keyword
    const str2 = new String("hi");

    // Escape Characters : Instead of using ``, we can also use /" for inserting "" inside "" itself, 
    //                   : /' for using '' inside '' itself 
    //                   : // for using / backslash

    

}

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
    */ 

    let char = string[0];

    /* slice()

    slice() extracts a part of a string and returns the extracted part in a new string.
    The method takes 2 parameters: start position, and end position (end not included). 
    
    Syntax : str_name.slice(start, end)*/

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
    
    */

    let text = "Hello world!";
    let result = text.repeat(2);

    // Syntax : string.repeat(count)

    /* Replacing String Content
    The replace() method replaces a specified value with another value in a string:*/

    let text1 = "Please visit Microsoft!";
    let newText2 = text.replace("Microsoft", "W3Schools");

    /*
    Note: The replace() method does not change the string it is called on. The replace() method returns a new string.The replace() method replaces only the first match */

    // To replace a case-sensitive, use /i flag

    let new_text3 = text.replace(/Microsoft/i, "W3School")
    // Note: Regular expressions are written without quotes.

    // To replace all matches, use a regular expression with a /g flag (global match):
    let new_text4 = text.replace(/Microsoft/g, "Micro")

    /*  JavaScript String split()
    A string can be converted to an array with the split() method: */
    let x = text.split(",")    // Split on commas
    // Note: If the separator is omitted, the returned array will contain the whole string in index [0].

}

function string_search() {
    let str1 = "hi this is a base string. hi there this. this hi";
    let idx_hi = str1.indexOf("hi"); // The output of method indexOf is 1 
    // Note: The position of the first occurrence of a string index is returned. if it is a long string like hi, the index of h is returned which in this case is 0

    // lastIndexOf() returns the last occurrence of the sub-string
    let last_idx_hi = str1.lastIndexOf("hi");
    // Note: The same rule applies here. Here the last occurrence of hi is 26. The function returns -1 if not found

    // Then there is start parameter which starts at the user given index. 
    // here in the str1 if i start from 27, the output is 37

    let last_index_of_hi_with_start = str1.indexOf("hi", 27);

    /*search() : The search() method searches a string for a string (or a regular expression) and returns the position of the match: */
    let text = "Please locate where 'locate' occurs!";
    text.search(/locate/);

    /*Did You Notice?
    The two methods, indexOf() and search(), are equal?
    They accept the same arguments (parameters), and return the same value?

    The two methods are NOT equal. These are the differences:

    The search() method cannot take a second start position argument.
    The indexOf() method cannot take powerful search values (regular expressions). 

    */

    // match() : returns an array containing the results of matching a string against a string (or a regular expression).
    
    let str12 = "The rain in SPAIN stays mainly in the plain";
    let match_ain = str12.match("ain"); // Normal Search : Stops search after found 1 instance of given string 
    let ignore_global_ain = str12.match(/ain/g); // Global Search : Search till the end and add all the founded instances in a array
    // Note: The same thing can be done using matchall() function. 
    // Tip: If you are using RegExp in matchall(), remember to use global case if not, error is thrown
    let global_insensitive_ain = str12.match(/ain/gi); //  Global and Insensitive to case

    //  includes() : returns true if a string contains a specified value. Otherwise it returns false.
    // You can also include start position where it starts teh search from the index you given 
    let text1 = "Hello world, welcome to the universe.";
    text.includes("world");

    // Then there is startsWith() and endsWith() which do what exactly it was named.
    // Returns true if the given substring is starting ro ending with with the given. else False

    let text2 = "Hello world, welcome to the universe.";
    text.startsWith("world", 11); // Searches the start from 11th






    






}

function arrays() {
    
    /* Arrays 
    
    Syntax for creating a Array : const array_name = [items/elements/objects]
    Note: if you use a array inside a array, that array is called nested array and it is very common in data science
    Note: Arrays are also called matrices and it works similar to matrices. instead of a11, we use [rows][columns] (indexing)
    Note: You cannot redeclare a variable if you use const keyword. use var or let

    Tip: The word const is a bit misleading. it only keeps the variable constant, not the elements inside it. It defines a constant reference to an array.
    Because of this, we can still change the elements of a constant array.

    To add a Element use push function (similar to append function in python)
    Arrays are Objects

    Arrays are a special type of objects. The typeof operator in JavaScript returns "object" for arrays.
    But, JavaScript arrays are best described as arrays. 
    */

    /* Now, it's time for functions/methods 
    1) toString() : Converts Array to string

    */
    var array = [1,2,3,4,5,6,7,8];
    var array_str = array.toString(); // returns the string representation of array . The length property is always one more than the highest array index.
    var array_len = array.length; // returns the length of a array
    var at_idx = array.at(4) // returns the element in that index 
    var join_arr = array.join(" * ") // similar to toString but joins the string given after each element
    var pop_arr = array.pop(2) // Removes and returns the last element 
    
    
    /*Accessing the Elements in array : 
    The most common way to access the array is indexing.
    index starts from 0 to n-1 where n is length of array 
    there is also reverse indexing which starts from -1 to -n

    the first element is 0 or -n and 
    last element is -1 or n-1
    */

    /* Looping through Array 
    1) Indexing : 
    we can loop through array using it's index which we need length of the array
    Syntax : for(iteration variable; condition; step){
        statment
    }
    2) Use :
    for (variable of array_name) {
        statment
    }
    */

    // 1st eg : 
    for (let x = 0; x < array.length; x++) {
        console.log(x)
    }

    // 2nd Eg : 
    for (x of array) {
        console.log(x);
    };

    // Map : Map is used to 

    /*Sorting a array : 
    we can custom sort a array using a function we gave */

    sorted = (a,b) => a-b
    let sorted_array = array.sort(sorted);
    


    

}

function math() {
    let x = 4.7;
    let y = 2;
    let z;

    // Rounding and integer functions
    z = Math.round(x);   // z = 5
    z = Math.floor(x);   // z = 4
    z = Math.ceil(x);    // z = 5
    z = Math.trunc(x);   // z = 4

    // Power and root
    z = Math.pow(x, y);  // z = 4.7^2 = 22.09
    z = Math.sqrt(x);    // z = √4.7 ≈ 2.167
    z = Math.log(x);     // z = ln(4.7) ≈ 1.547

    // Trigonometric functions (x in radians)
    z = Math.sin(x);     // z ≈ -0.999
    z = Math.cos(x);     // z ≈ 0.035
    z = Math.tan(x);     // z ≈ -28.636

    // Other functions
    z = Math.abs(x);     // z = 4.7
    z = Math.sign(x);    // z = 1

    // Max and min
    let max = Math.max(x, y, z); // max value among x, y, z
    let min = Math.min(x, y, z); // min value among x, y, z
    console.log(min);
    
}

function spread_operator() {
    let numbers = [1,2,3,4,5];
    let max_numbers = Math.max(...numbers);
    let str = "hi,Bro Code";
    let char = [...str];
    console.log(max_numbers, char);
}

function rest_operator(){
    // This Operator ..rest bundles all the arguments given into a array
    // Similar to a (args, kwargs) in python


    function foods(...foods) {
        console.log(foods);
    }
    let food1 = "pizza";
    let food2 = "burger";
    let food3 = "ham";
    let food4 = "cheese";

    foods(food1, food2, food3, food4);

    // The below function returns the sum of all numbers given
    function sum(...numbers){
        return Math.sum(...numbers);
    }
    let a = 1;
    let b = 2;
    let c = 3;
    let d = 4;

    sum(a,b,c,d);
}

function callback() {
    let fruits = ["apple", "banana", "cherry"];
    // foreach() is a example of a callback function
    // The below foreach call back a function which takes a element and returns the element in upper case

    // syntax : array.foreach(value, index, array)
    fruits.forEach(fruits = fruit => {return fruit.toUpperCase()});
    console.log(fruits);

    let num = [1,2,3,4,5];
    num.forEach(num = value => {
        return num = num * 2;
    })
    console.log(num); // This will return [2, 4, 6, 8, 10]

    // Now Let's talk about map() function
    // map() is a function which takes a function as a parameter and returns a new array
    // syntax : array.map(value, index, array)
    // Note: The map function does not change the original array, it returns a new array

    let k = [1,2,3,4,5,6];
    let double_k = k.map(value => {
        return value * 2;
    });
    console.log(double_k); // This will return [2, 4, 6, 8, 10, 12]

    // filter() is a function which takes a function as a parameter and returns a new array with the elements which pass the test
    let numbers = [1,2,3,4,5,6,7,8,9,10];
    let even_numbers = numbers.filter(value => {
        if (value % 2 === 0) {
            return value; // This will return the even numbers
        }
        else {
            return true;
        }
    });
    console.log(even_numbers); // This will return [2, 4, 6, 8, 10]

    // reduce() : reduce the elements of array into single element
    // Syntax : array.reduce((accumulator, currentValue) => { /* ... */ }, initialValue)

    let nums1 = [1,2,3,4,5];
    let sum = nums1.reduce((accumulator, value) => {
        return accumulator + value;
    });
    let avg = sum / nums1.length; // This will return the average of the numbers
    console.log(avg); // This will return 3 
    console.log(sum); // This will return 15

}

function function_expression() {
    // There is also a way to declare a function like a variable
    // Below function can square a given array
    let n = [1,2,3,4,5,6,7];
    let square = function(n) {
        console.log(Math.pow(n, 2));
        
    }
    let cube_n = n.map(function(n) {
        return Math.pow(n,3);
    });
    console.log(cube_n);
    let even_nums = n.filter(function(n) {
        if (n % 2 == 0) {
            return true;
        }
    });
    console.log(even_nums);
    let total_nums = n.reduce(function(accumulator, k) {
        return accumulator + k;
    });
    console.log(total_nums)
    
}

function arrow_function() {
    function hello() {
        console.log("Hello");
    }
    hello();

    //  arrow functions :  a concise way to write function expressions 
    // good for simple functions that you use only once (parameters) => some code

    let hello1 = () => {console.log("hello")};
    hello1();

    // The below code is going to map the function for squaring with arrow function
    let array = [1,2,3,4,5,6,6,7];
    let even_number = array.filter((Element) => {return Element % 2 == 0});
    let odd_numbers = array.filter((Element) => {return Element % 2 == 1});

    let square_number = array.map((Element) => {return Math.pow(Element, 2)});
    let sum_numbers = array.reduce((accumulator, Element) => {return accumulator + Element});

    console.log(even_number, odd_numbers, square_number,sum_numbers);

}

function this_keyword() {
    // This keyword is one of the most important keyword which we are going to use more frequently in JS
    // This keyword is like a global variable for scope
    /* Can't understand, here is the detailed explanation
    Ok take a function, (you have to know about global scope and local scope)
    if i am using a class, multiple functions , i cannot access what i use inside another function,
    here comes this keyword, using this, you can make a variable global scale inside a class or a function 
    Note: Only inside that function not outside 
    Note: This keyword doesn't work with arrow function
    */
    const k = {
        firstName : "hi",
        latsName : "hello", 
        fullName : () => {console.log(this.firstName)},
    };
    k.fullName();
}

function constructor() {
    /* You know, it a pain to just create a object each and every time 
    you think we can use functions to make it easier, we can try it now */

    function Car(make, model, year, color, start){
        this.make = make;
        this.model = model;
        this.year = year;
        this.color = color;
        this.start = function() {
            console.log(`You have started ${this.model} Car`)
        }
    }
    const car1 = new Car("Ford", "Mustang", 2024, "Red");
    console.log(car1.make);
    console.log(car1.color);
    console.log(car1.year);
    console.log(car1.model);
    car1.start();
}

function classes() {
    /* class = (ES6 feature) provides a more structured and cleaner way to 
        work with objects compared to traditional constructor function

        ex. static keyword, encapsulation, inheritance */
    class Products {
        constructor(name, price){
            this.name = name,
            this.price = price
        };
        
        displayProduct() {
            console.log(`${this.name} : ${this.price}`);
        }
    }
    const product1 = new Products("Food", 112);
    const product2= new Products("Chocolate", 50);

    product1.displayProduct();
    product2.displayProduct();

    /* static : if you want to know about this, you should learn with example
    ok take a class called Math, you have a sum function which adds two numbers,
    what if someone modifies th sum function into a subtract function,  
    to prevent this, we have static keyword which will not allow any modifications
    it's like saying, "ok now as you have declared static, it belongs to me"
    */

    class User{
        static userCount = 0;

        constructor (userName) {
            this.userName = userName;
            User.userCount ++;
        }

        
    }
    const user1 = new User("S");
    const user2 = new User("sakthi");
    const user3 = new User("sandy")

    /*Ok if we use
    console.log(User.userCount);
    what will be the result, guess, 
    you think it is 1 but it is actually undefined because remember, you cannot access the static variables
    you have to use User.countUser
*/

    console.log(User.userCount);

    /* Inheritance : it is a very easy concept but some might find it difficult 
    think of a rich dad and a spoiled son, he wants all his fathers money,
    his father is dead and he takes or we can say "Inherited" his father's wealth,
    like that, you can create a parent class and a child class (actually we call it is inherited class)
    which inherit to it is allowed to use the functions inside parent class
    
    in js, we have to declare there is a inheritance using "extends" keyword*/

    class Parent{
        constructor() {
            this.hair_color = "brown";
            this.eye_color = "black";
        }
        wealth() {
            return "2 Million in asset's";  
        }
        mother_characteristics() {
            return "Angry all the time, Strict and Kind";
        }
        father_characteristics() {
            return "Cool and chill, Good person at heart";
        }
    }   
    class Child extends Parent {
        static name = "Roy";
        child_characteristics() {
            console.log(this.wealth());
            console.log(this.mother_characteristics());
            console.log(this.father_characteristics());
        }
    } 
    let child1 = new Child();
    child1.child_characteristics();

    /* super keyword : it is used inside classes to call the constructor and 
                       access the properties and methods of a parent
                       this = this object
                       super = the parent
     Personal Explanation : Let's be simple, it is like a parent's phone number
     if your parents need a location (that the information, a constructor), you can call them
     (super)
    */

    class Animal {
        constructor (name,age, speed) {
            this.name = name;
            this.age = age;
            this.speed = speed;
        }
        eat() {
            return `This ${this.name} is eating`
        }
        move() {
            return `This ${this.name} moves at ${this.speed} Km/H`
        }
    }
    class Rabbit extends Animal {
        constructor (name, age, runSpeed) {
            super(name,age,runSpeed);
            this.runSpeed = runSpeed;
        }
    }
    class Fish extends Animal {
        constructor (name, age, swimSpeed) {
            super(name,age,swimSpeed);
            this.swimSpeed = swimSpeed;
        }
    }
    class Hawk extends Animal{
        constructor (name, age, flySpeed) {
            super(name,age,flySpeed);
            this.swimSpeed = flySpeed;
        }
    }

    const fish = new Fish("John", 2, 13);
    const rabbit = new Rabbit("Ken", 2, 27);
    const hawk = new Hawk("Zen", 19, 55);

    console.log(fish.eat());
    console.log(fish.move());

    /* Getters and Setters 
    Getters : It is a special property which makes a property readable
    Setters : It is a special property which makes a property writable
    validate and modify a value when reading/writing
    
    Personal Explanation : This feature is actually in python, it is called type annotations
    this allows the parameter to be judged and be fixed if user input the wrong format or details
    for eg : if there is a sum function, you know that it only used for adding two numbers,
    what if user gave one str and one int, it will cause an error
    we can prevent it by "setting" the parameter type as int
    and "getting" the value using get keyword*/

    class Rectangle {
        constructor(width, height) {
            this.width = width;
            this.height = height;
        }
        set width(newWidth) {
            if (newWidth > 0) {
                this._width = newWidth;
            }
            else {
                console.error("The parameter should be a Unsigned integer");
            }
        }
        /**
         * @param {number} newHeight
         */
        set height(newHeight){
            if (newHeight > 0) {
                this._height = newHeight;
            }
            else {
                console.error("The parameter should be a Unsigned integer");
            }
        }
        #width;
        get width() {
            return `${this._width.toFixed(1)} cm`;
        }
        get height() {
            return `${this._height.toFixed(1)} cm`;
        }
        get area() {
            return `${(this._width * this.height).toFixed(1)} cm`;
        }
    }   

    let rectangle = new Rectangle(122, 43);
    console.log(rectangle.width);
    console.log(rectangle.width);
    console.log(rectangle.width);
    
    class Person {
        constructor(firstName, lastName, age) {
            this.firstName = firstName;
            this.lastName = lastName;
            this.age = age;
        }
        set firstName(new_first_name) {
            if (typeof(this.new_first_name) === "string" && new_first_name.length > 0) {
                this.firstName = new_first_name;
            }
            else {
                return console.error("Enter a string with more than 1 character");
            }
        }
        set lastName(new_last_name) {
            if (typeof(this.new_last_name) === "string" && new_last_name.length > 0) {
                this.firstName = new_last_name;
            }
            else {
                return console.error("Enter a string with more than 1 character");
            }
        }
        set age(new_age) {
            if (typeof(this.new_age) === "integer" && new_age > 1) {
                this.firstName = new_age;
            }
            else {
                return console.error("Enter a integer with more than 1 character");
            }
        }

        get firstName() {
            return this.firstName;
        }
        get lastName() {
            return this.lastName;
        }
        get age() {
            return this.age;
        }
        get fullName() {
            return this.firstName + " " + this.lastName;
        }
        
    }
    
}

function destructuring() {
    /*
    destructuring : extract values from arrays and objects,
    then assign them to variables in a convenient way

    [] = to perform array destructuring
    () - to perform object destructuring  */
    
    // ------------- EXAMPLE 1 ---------------
    // Swap variables

    let a = 10;
    let b = 20;

    [a,b] = [b,a];

    console.log(a,b);

    // ------------- EXAMPLE 2 ---------------
    // Swap 2 Elements in Array

    const color = ["red", "green", "blue", "white"];    
    [color[0],color[2]] = [color[2],color[0]]
    console.log(color)

    // ------------- EXAMPLE 3 ---------------
    // Assign Arrays Elements to variables
}

function nested_object() {
    /*
    nested objects :  objects inside of other objects.
                      Allows you to represent more complex data structures
                      Child Object is enclosed by a Parent Object

                      Person{Address(), ContactInfo{}}
                      ShoppingCart(Keyboard(), Mouse{}, Monitor{}}
                       */
    const Person = {
        full_name : "SpongBob Squarepants",
        age: 12, 
        isStudent : true, 
        hobbies:["karate", "jelly-fishing", "cooking"],
        address : {
            street : "Manchester",
            city : "Krabs city",
            country : "Atlantic"
        }
    };
    console.log(Person.full_name);
    console.log(Person.address.street);
    console.log("");
    console.log("");

    // Iterating through object
    for (const property in Person.address) {
        console.log(Person.address[property]);
    }

    class Persons {
        constructor(name, age, ...address) {
            this.name = name;
            this.age = age;
            this.address = new Address(...address);
        }
    }

    class Address {
        constructor(street, city, country) {
            !street ? console.log("Please Enter a street") : this.street = street;
            !city ? console.log("Please Enter a city") : this.city = city;
            !country ? console.log("Please Enter a country") : this.country = country;
        }
        

        set street(new_street) {
            if (!new_street || new_street.length === 0) {
                console.log("Please Enter a street");
            } else {
                this._street = new_street;
            }
        }

        get street() {
            return this._street;
        }

        set city(new_city) {
            if (!new_city || new_city.length === 0) {
                console.log("Please Enter a city");
            } else {
                this._city = new_city;
            }
        }

        get city() {
            return this._city;
        }

        set country(new_country) {
            if (!new_country || new_country.length === 0) {
                console.log("Please Enter a country");
            } else {
                this._country = new_country;
            }
        }

        get country() {
            return this._country;
        }

        full_address() {
            return `${this._street}, ${this._city}, ${this._country}`;
        }
    }

    // Now provide all 3 address fields
    let person1 = new Persons("sai", 13, "KK Nagar", "Cheyyur");
    console.log(person1.address.city);

    console.log("");
    console.log("");

    /* Array of Objects  */
    const fruits = [{name: "apple", color : "red"}, {name: "banana", color : "yellow"}, {name: "orange", color : "orange"}, {name: "kiwi", color : "green"}];
    console.log(fruits[1].name);

    fruits.push({name:"barika", color:"green"});
    console.log(fruits.pop());

    /* mapping objects */
    const fruitNames = fruits.map(fruits => fruits.name);
    const fruit_start_with_a = fruits.filter(fruit => fruit.name.startsWith("A") || fruit.name.startsWith("a"));
    const longest_fruit = fruits.reduce((accumulator, fruit) => fruit.name.length > accumulator.length ? fruit.name : accumulator, "");
    console.log(fruitNames);
    console.log(fruit_start_with_a);
    console.log(longest_fruit);

}

function sort() {
    /* sort : used to sort arrays in place
              Sorts elements as strings in lexographical order, not alphabetical 
              lexographical : (alphabet + numbers + symbols) as strings */
    let fruits = ["apple", "banana", "kiwi", "coconut"];
    let numbers = [1,2,3,6,4,6,10,13,12];
    fruits.sort()
    console.log(fruits);
    console.log("");

    numbers.sort((a,b) => b-a);
    console.log(numbers)
    
    const people = [{name: "Spongebob", age: 30, gpa: 3.0},
                    {name: "Patrick", age: 37, gpa: 1.5}, 
                    {name: "Squidward", age: 51, gpa: 2.5}, 
                    {name: "Sandy", age: 27, gpa: 4.0}]
    let people_by_gpa = people.map(person => person.gpa).sort((a,b) => a-b);
    console.log(people_by_gpa);
    console.log('');

    /* Shuffling a array : best method to shuffle is to use Fisher-yates algorithm */
    const cards = ['A', 2,3,4,5,6,7,8,9,10,'J','Q','K'];
    console.log(cards);
    function shuffle(array) {
        for (let i = 0; i < array.length - 1; i++) {
            const random = Math.floor(Math.random() * (i - 1));
            [array[i], array[random]] = [array[random], array[i]];
        };
    }
    cards.sort(shuffle);
    console.log(cards);
}

function date() {
    /* Date : it is a useful module where we can record Date as a datatype
              it's default parameters are Date(year,month,day,hours,minute,seconds,mille-seconds)
              */
    // Note: This official date here starts from 1970 for some reason, 
    // if you give any numbers say a billion, it adds 1 billion millisecond starting from 1970

    /* There is a history about why Date() module starts in 1970
    The date is also called unix epoch date which starts at 1970 because unix was founded at 1970 
    you can use - milli-seconds to go back in date*/
    console.log(new Date(-62073792000000));
    
    const date_separated = [new Date().getFullYear(), new Date().getMonth(),new Date().getDate(), new Date().getHours(), new Date().getMinutes(), new Date().getSeconds(), new Date().getMilliseconds()];
    date_separated.forEach(date => console.log(date));

}

function closure() {
    /*
    closure =   A function defined inside of another function,
                the inner function has access to the variables and scope of the outer function.
                Allow for private variables and state maintenance Used frequently in JS frameworks: React, Vue, Angular
     */
    function outer() {
        let message = "Hi";
        function inner() {
            console.log(message);
        };
        inner();
        /* Everything inside outer function is closure
        inner function has access everything inside  */
        // ANCHOR - HI
    }
    outer.message = "Goodbye";
    outer()
    console.log("")

    // Example

    function increment(){
        let count = 0;
        function add() {
            count ++;
            console.log(`Count increased to ${count}`)
        }
        return {add};
    }
    increment();
    const counter = new increment();
    counter.add();
    counter.add();

    /* The Above program will be a little bit confusing but it is simple
    if we did what we normally do like 
    function increment() {
        let count = 0;
        function add() {
            count ++;
        }
        add()
        console.log("The Count increased by" + count);
    }
    
    what will be the result, if you think it adds the number each time, you are wrong
    it always shows 1, not increment because each time you call increment, it resets count = 0
    it will not store the count 
    so for that, we have to change the return so that it do not resets the count 
    we can just create the function which can add it and return that function, so if a user calls the main function, 
    it runs the inner function, here it is add and will not get reset
    
    Let's see another example
    */
    console.log("")
    function score() {
        let points = 0;
        function increaseScore(score) {
            points += score;
            console.log(`+${score}pts`);
        }
        function decreaseScore(score) {
            points -= score;
            console.log(`-${score}pts`);
        }
        function getScore() {
            console.log(`Final score is ${score}`);
        }
        return {increaseScore, decreaseScore, getScore};
    }
    let player1 = score();
    player1.increaseScore(10);
    player1.decreaseScore(3);
    player1.getScore();
    
}

function timeout() {
    /*
    setTimeout() =  function in JavaScript that allows you to schedule
                    the execution of a function after an amount of time (milliseconds)
                    Times are approximate (varies based on the workload of the JavaScript runtime env.
                    setTimeout(callback, delay)
    */
    
    function sayHello() {
        console.log("hello");
    }
    sayHello();
}
function asynchronous() {
    /* This is a very new but essential concept in all of programming
    
    Synchronous : Executes code line-by-line in a sequential manner
                  It waits for the code to complete if a code takes long time

                  for eg : if you are getting a input from user of radius to return area
                  It is synchronous because it is executed line-by-line and also waits for the input form user

    Asynchronous : It allows multiple operations to be performed concurrently without waiting
                   Doesn't wait for a block of code, it just goes 
                   "i have other work, if you want time,  wait, i will finish other works and come to you again"
    
    */
    function func1(callback) {
        setTimeout(() => {console.log("Task 0");
            callback();
        }, 3000);
   }
    function func2() {
        console.log("task 1");
        console.log("task 2");
        console.log("task 3");
    }
    func1(func2);
}
function error() {
    /*
    
    Error = An Object that is created to represent a problem that occurs Occur often with user input or establishing a connection
    try { } = Encloses code that might potentially cause an error 
    catch { } = Catch and handle any thrown Errors from try { } 
    finally { } = (optional) Always executes. Used mostly for clean up ex. close files, close connections, release resources

        NETWORK ERRORS PROMISE REJECTION SECURITY ERRORS These are the 3 Types of errors 
        
    ==============================
    JAVASCRIPT ERRORS & TRY/CATCH
    ==============================

    1️⃣ SyntaxError ❌
    - Cannot be caught by try/catch
    - Example: let x = ; 
    - Reason: Code fails to parse → never runs

    2️⃣ ReferenceError ✅
    - Can be caught
    - Example:
        try { console.log(y); } 
        catch(e) { console.log("Caught:", e.message); }

    3️⃣ TypeError ✅
    - Can be caught
    - Example:
        try { null.foo(); } 
        catch(e) { console.log("Caught:", e.message); }

    4️⃣ RangeError ✅
    - Can be caught
    - Example:
        try { new Array(-1); } 
        catch(e) { console.log("Caught:", e.message); }

    5️⃣ URIError ✅
    - Can be caught
    - Example:
        try { decodeURIComponent('%'); } 
        catch(e) { console.log("Caught:", e.message); }

    6️⃣ EvalError ✅
    - Can be caught
    - Example:
        try { eval("foo bar"); } 
        catch(e) { console.log("Caught:", e.message); }

    ==============================
    💡 Key Takeaways:
    - try/catch = runtime errors only
    - Syntax errors stop execution → fix them manually
    - Use linters / editors to catch syntax mistakes early
    ==============================

    */
    // ==========================
    // JAVASCRIPT ERRORS CHEAT SHEET
    // ==========================

    // 1️⃣ SyntaxError
    // Description: Mistake in code structure, JS can't parse it
    // Example:
    try {
        let x = 5
        console.log(x) // missing closing parenthesis
    } catch(e) {
        console.error("SyntaxError:", e.message);
    }

    // 2️⃣ ReferenceError
    // Description: Accessing a variable or function that doesn't exist
    try {
        console.log(y); // y is not defined
    } catch(e) {
        console.error("ReferenceError:", e.message);
    }

    // 3️⃣ TypeError
    // Description: Performing operation on wrong data type
    try {
        let num = 5;
        num.toUpperCase(); // num is number, has no toUpperCase
    } catch(e) {
        console.error("TypeError:", e.message);
    }

    // 4️⃣ RangeError
    // Description: Value out of allowed range
    try {
        let arr = new Array(-1); // invalid array length
    } catch(e) {
        console.error("RangeError:", e.message);
    }

    // 5️⃣ URIError
    // Description: Malformed URI encoding/decoding
    try {
        decodeURIComponent('%'); // invalid URI
    } catch(e) {
        console.error("URIError:", e.message);
    }

    // 6️⃣ EvalError
    // Description: Misuse of eval() (rare in modern JS)
    try {
        eval("foo bar"); // invalid code
    } catch(e) {
        console.error("EvalError:", e.message);
    }

    // 7️⃣ Common Runtime Errors
    try {
        let obj = null;
        console.log(obj.value); // TypeError: cannot read property of null
    } catch(e) {
        console.error("Runtime Error:", e.message);
    }

    // ==========================
    // TIPS TO AVOID JS ERRORS
    // ==========================
    // 1. Always declare variables (let / const)
    // 2. Use try...catch for risky code
    // 3. Check for null/undefined before accessing properties
    // 4. Use 'use strict'; mode
    // 5. Debug with console.log and browser devtools

}
function DOM() {
    /*
    DOM = DOCUMENT OBJECT MODEL
    Object{} that represents the page you see in the web browser and provides you with an API to interact with it.
    Web browser constructs the DOM when it loads an HTML document,
    and structures all the elements in a tree-like representation.
    JavaScript can access the DOM to dynamically
    change the content, structure, and style of a web page. */

    /* 
document
└── <html> (Root element)
    ├── <head> (Element)
    │   └── <title> (Element)
    │       └── "My title" (Text)
    └── <body> (Element)
        ├── <h1> (Element)
        │   └── "A heading" (Text)
        └── <a> (Element)
            ├── href (Attribute)
            └── "Link text" (Text)
    
    This is how the structure actually looks behind the scenes
*/  
    /* 
    element selectors = Methods used to target and manipulate HTML elements They allow you to select one or multiple HTML elements from the DOM (Document Object Model)
    1. document.getElementById()
        ELEMENT OR NULL
    2. document.getElementsClassName() // HTML COLLECTION
    3. document.getElementsByTagName() // HTML COLLECTION
    4. document.querySelector() // ELEMENT OR NULL
    5. document.querySelectorAll() // NODELIST 
    
    */
    
}

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

asynchronousProgramming()
