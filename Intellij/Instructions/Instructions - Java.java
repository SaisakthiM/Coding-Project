/*
Java : what is java 

java is a high level OOP legacy language which was invented long ago and 
revolutionized the field of high level language with JVM

JVM was revolutionary as it was easier now to deploy code and solve the age old problem which was there
"It works on my machine, but not you"

after java there were many languages like Python and JS in high level language but 
still most companies use Java because their legacy code depends on it

                  ┌──────────────────────────────────────────────────────────┐
                  │          Java Development Kit (JDK)                      │
                  │  (Contains everything, including Development Tools)      │
                  │                                                          │
                  │  ┌────────────────────────────────────────────────────┐  │
                  │  │          Java Runtime Environment (JRE)            │  │
                  │  │  (Necessary for running Java programs)             │  │
                  │  │                                                    │  │
                  │  │  ┌──────────────────────────────────────────────┐  │  │
                  │  │  │          Java Virtual Machine (JVM)          │  │  │
                  │  │  │  (Executes Java bytecode)                    │  │  │
                  │  │  └──────────────────────────────────────────────┘  │  │
                  │  │                                                    │  │
                  │  │  Libraries and classes                             │  │
                  │  │  (The core API classes)                            │  │
                  │  └────────────────────────────────────────────────────┘  │
                  │                                                          │
                  │  Development Tools                                       │
                  │  (e.g., compiler, debugger, archive)                    │
                  └──────────────────────────────────────────────────────────┘

this is the basic structure of what JDK has inside it
the most important part is JVM and JRE here

Basics:
Things to Remember in Java
1) Java is a heavily OOP Oriented programming language, everything we do is Classes and Objects
2) Java is heavily and purely used for it's stability so many enterprise companies used it and still uses it

As I said, Java is all about classes, the variables you see, the datatypes and the every dam built in feature you use
it is a class

class is java
java is class

in java version 1.0.2 which was the first public version, it had 230 classes 
now in java 5.0+ it has 3200 classes which is enormous comapred ot other languages

so also everything we and will run will be a .class file which is converted into bytecode file

OOP in Java:

We know the basics mostly now
so we now jump on what is even OOP means

OOP : Object oriented Programming with classes and objects
take a car
how it looks 
what it has

these are properties of a car
so if we consider Car as a class, then all these like looks, engines and others are properties

class Car {
    String engine; 
    String Model;
    String accelerator; // Properties
}

so we know about properties right 
now if we want to say run a car
what we have to do 
start the engine and press the accelerator

now it has a method
method is a block of code which runs when called
here, take this class

class Car {
    String engine; 
    String Model;
    String accelerator; // Properties
    startCar() {
        engine = "start";
        acceleration = "press";
    }
}

see, when i call this startCar(), it just runs
that's method

now you also need to make a good structure
you just can't create any car now 
you have to get like the model and engine of each car definitely 
others are optional 
here is where constructors comes in 
think of it like a set of rules, when a class is initialized, 
you have to follow or give these properties 
else you cannot create Car

and also we have to know about object 
what is it
it is just a instance of a class 
what's a instance 
they are entity created in the moment with unique or 
same property of the class
that's objects
we can create a object with new keyword

Car ford = new Car();
this is how we can create one

ok also you know we can create like many instances of a same class 
with different properties

Note: There is also another way of using a object like creating a pointer/reference for the object and you can manipulate from there
in C++, you can directly create a pointer but in Java you can only create a reference only 
not any other things like pointers and any other things

now take a car right 
so each car differs like ferrari is fast and lightweight
and bugatti is popular and many models have different things
and they want to keep it secret
still we don't know the coke recipe do we

like that each classes has some values which it thinks it should not expose to 
this in java we can achieve that using private keyword 
also there is public and protected also 

these are collectively called access modifiers in java
so let's see what each modifies

public : it allows access to the properties/functions to all instance, packages and sub modules which uses the class
protected : it allows access to the properties/function to just the sub modules and packages, not for all instaces outside it
private : only for the class and no access anywhere 

so now we know that let's talk about what is instance variable is
so we create a class and a object right 
this object is just a instance of a class 
so what it does is it follows the blueprint of the class
and creates it's own variation 
and that variation is called instance variable

so how can you access these variables
we can use the . operator 
which can access and help to modify the values inside the object 

so now let's talk about how to create a object in 
we normally use new keyword which is fine

so also take this statement which os 
Student student;
what does it mean 
it means we are creating a reference in java for that class

we are allocating a memory for the object we are creating 
and if we allocate it like above it will store on stack memory 
which is temporary memory and
it also dynamically allocates memory 

so when the actual logic is written down like this with new keyword

Student student = new Student();
this creates a heap memory of the class Student and then points the reference there 
becoming that reference a heap variable

so new keyword makes a stack reference to a heap reference 

then come to this
like this 
this is a keyword bro 
yes it is
what is this
this in java means the object/reference name

take a scenario where you have to use a variable / function inside the class itself
how can you do that 
use this
keyword i told 
ok i will not do that again
use "this" keyword to reference/use the variable inside a class

Note: it is not necessary to use this keyword if it is global inside a class like this
public class Student {
        int rno;
        String name;
        float mark;

        void greet() {
            System.out.print("Hello my name is", name);
        }
    }
see you don't have to 
but here in this case
public class Student {
        int rno;
        String name;
        float mark;

        void greet() {
            System.out.print("Hello my name is", name);
        }
        void special() {
            String name2 = "sai";
        }
        void k() {
            System.out.print(name2);
        }
    }
you have to use this keyword as this throw error
Main.java:19: error: cannot find symbol
            System.out.print(name2);
                             ^
  symbol:   variable name2
  location: class Main.Student










*/ 