"""

First basics :

Every variable or values or functions we create, they are all classes.
I mean everything from int to str to functions

Adding of int, its __add__ dunder method
Finding len of string its __str__ dunder methods

list its class list
tuples, dictionaries every single thing is class and the variables are the objects

objects are the instances that we create using variable.

these classes are called "built-in 

they are literal backbone for every operations happening in python

Dunder methods :
Here are some examples

class Person:
    def __init__(self,name):
        self.name = name # It is constructor . It runs automatically when object is created. Eg k = Person("hi")
    def __repr__(self):
        return self.name # Controls what to print after object is called. eg print(k) here returns hi
    def __mul__(self, other):
        if type(other) != int:
            raise TypeError("Cannot be multiplied")
        return self.name * other # Controls what to do after * is used. eg k * 4 returns HiHiHiHi
    def __sub__(self, other):
        raise TypeError("<class 'str'> cannot be subtracted") # Controls what to do after objects get - symbol
    def __call__(self, *args, **kwargs):
        raise InterruptedError("<class 'Person'> cannot be called") # Controls what to do after being called. eg : k()
    def from queue import Queue as q


class Queue(q):
    def __repr__(self):
        return f"Queue({self._qsize()})"
    def __add__(self, other):
        self.put(other)
    def __sub__(self, other):
        self.get(other)
    def __mul__(self, other : int):
        if type(other) != int:
            raise TypeError("Cannot be multiplied other than <class 'int'>")
        for x in range(other):
            self.put(x)




l = Queue(9)
l * 6
l / 2
print(l)__getitem__(self, item):
        raise SyntaxError("<class 'Person'> cannot be Sliced") # Controls what to after getting [] and indexed. eg k[]
    def __bool__(self):
        raise SyntaxError("<class 'Person'> cannot be Boolean") # Controls what to after bool() func is called. eg : bool(k)

k = Person("Hi")
o = Person("Hello")

print(bool(k))

this is another example of changing the functions of Queue using inheritance



Decorator : it is like an modifier or mod for functions.
they can change how an function works and codes inside an function


def factorial(f):
    def wrapper():
        print("Started")
        f()
        print("Ended")
    return wrapper

def func2():
    print("HI")

k = factorial(func2)
k()

here is an example of nested functions returning functions and using functions.
as you heared, yes it uses nested returned and called another function as parameter

explanation : we create a function with another function as parameter
then we create another function inside it and tell it to print(start0 and call the parameter function and ended
and we rae returning a pointer , remember we did not call the wrapper function ,
we are simply returning the memory address.

so if we print , the result is <function factorial.<locals>.wrapper at 0x000001C0F0979C60>
first is type function then function name then it says the function wrapper is local function at this memory address

so what we are going to do is instead of passing the parameter each of the time to call it ,
if we create an function we should set it like after created , automatically pass it to factorial and run it
here is where decorators comes in

func2 = factorial(func2)
func2

this above line looks confusing but easy.
we are storing func2 as variable and assigning it factorial(func2).
this is confusing

so what we can do is like inheritance in classes,
we can mke this function as inheritance to factorial which makes it as parameter and run it


@factorial
def func2():
    print(hi)

def factorial(f):
    def wrapper():
        print("Started")
        f()
        print("Ended")
    return wrapper

@factorial
def func2(x):
    print(x)

func2(5)

another issue we face is that we might get error like below

 func2(5)
    ~~~~~^^^
TypeError: factorial.<locals>.wrapper() takes 0 positional arguments but 1 was given

as we pass an argument , it also passes it to wrapper but wrapper doesn't know how many arguments coming
if we put one argument and if we inherit function with 2 arguments , same error is occurred again
so to fix this,

def factorial(f):
    def wrapper(*args,**kwargs):
        print("Started")
        f(*args,**kwargs)
        print("Ended")
    return wrapper

@factorial
def func2(x,i):
    print(x,i)

func2(5,"hi")

*args and **kwargs are simply like telling that we don't know how many inputs coming in,
so no matter how many comes accept it all




















































"""