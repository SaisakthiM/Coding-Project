"""
Dunder[__init__] : it is a set of functions available to only class variable

__init__ [constructor] : it is a dunder that can be used to create functions which runs automatically without calling __init__
                       : to access codes inside it, we can use object name stored as self

__str__ : it is also a constructor, but it only allows inputs as string

__add__(x,y) : return ClassName(self.val + y.val)

threading : it is used to speed up the program execution by executing multiple tasks at the same time
          : they are referred as light-weight processes
          : It is a module which helps to execute 2 functions at the same time

eg : import threading


def function1():
    for tt in range(10000):
        print("One")


def function2():
    for tt in range(10000):
        print("Two")


t1 = threading.Thread(target=function1)

t2 = threading.Thread(target=function2)
t1.start()
t2.start()


import threading
import time

event = threading.Event()


def myfunc():
    print("Waiting For Event To Trigger")
    event.wait()
    for xp in range(100):
        xp -= 1
        print(xp)
        time.sleep(1)


t1 = threading.Thread(target=myfunc)
t1.start()

xv = input("Trigger The Event ( Y/N ) ")

if xv == "Y" or xv == "y":
event.set()

Race Condition : A race condition occurs when two or mor threads tries to access a shared variable
               : the first thread tries to read the shared variable . At the same time second thread tries to read the shared variable
               : then both threads tries to change the shared variable
               : the final value of shared variable depends on who wins the race condition

eg : import threading
import time

counter = 0


def increase(by):
    global counter
    local_counter = counter
    local_counter += by

    time.sleep(0.1)

    counter = local_counter
    print(f"counter={counter}")


t1 = threading.Thread(target=increase, args=(10,))
t2= threading.Thread(target=increase, args=(20,))

t1.start()
t2.start()

t1.join()
t2.join()

print(f"The final counter is {counter}")

threading.Lock : The threading lock is a synchronisation primitive that provides exclusive access to shared variable
               : This only works in multithread application

There are two states in lock ( Lock and unlock ) :

       Lock : When a thread acquires a lock the lock enter the locked state
            : The Locked thread have exclusive access to the shared variable
            : other thread tries to acquire the lock while (the locked thread) locked
            : the other thread will be blocked until the locked thread finishes the program

       Unlock : When a thread releases a lock the lock exit the locked state

eg : import threading
import time

lock = threading.Lock()
counter = 0

with lock:
    def increase(by):
        global counter

        lock.acquire()

        local_counter = counter
        local_counter += by

        time.sleep(0.1)

        counter = local_counter
        print(f"counter={counter}")
        lock.release()

    lock = threading.Lock()


t1= threading.Thread(target=increase, args=(10,))
t2 = threading.Thread(target=increase, args=(20,))

t1.start()
t2.start()

t1.join()
t2.join()

print(f"The Final Counter is: {counter}")




queue : when multiple threads are running
      : they are need to be arranged in a queue
      : or simply we need a proper way getting the data in and out
      : if not done data result will be corrupted most of the time

q = queue.Queue() : theis is the function to activate queue
q = queue.PriorityQueue() : this is a queue which helps to give particular num or str priorities
                        : that can be done by q.put((1, "hello world"))
                        : the number in left side describes the position and right siide is where we can input number or string
q.put() : this helps to put the desired numbers and strings in queue function
Note : .Queue only prints first number or string in the list
     : to get the last number in the list we need to use .LisfQueue
q.get() : tit is the function used to get the numbers or strings we entered

eg : import queue

q = queue.Queue()
q1 = queue.LifoQueue()
q_1 = queue.PriorityQueue()
num_1 = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]

q_1.put((1, "Hello World!"))
q_1.put((2, "He World!"))
q_1.put((3, "Hello Worl!"))
q_1.put((4, "Hel rld!"))
q_1.put((5, " World!"))


for num in num_1:
    q.put(num)
    q1.put(num)


print(q.qsize())
print(q.get())

print(q1.qsize())
print(q.get())

print(q_1.get())
print(q_1.get())
print(q_1.get())
print(q_1.get())
print(q_1.get())


sockets : they are endpoints of communication channel
        : for eg : take server(1st socket) client(2nd socket)
        : when these two tries to exchange data is called network
    Now we have to answer and choose 4 questions ,
    1) we are going to use internet socket instead of UNIX socket
    because it is easier to use
    2) protocol : i) TCP ii) UDP
    we are going to use TCP because it is easier to use and better for any sensible data
    In UPD , data transfer is faster, but it has the risk of losing data

    eg : socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    here, (socket.AF_INET) means we are going to use internet socket instead of UNIX socket
    (socket.SOCK_STREAM) means we are going to use
    for UDP we have ti type(socket.SOCK_DGRAM)

ports : port is a logical connetion that is used to exchange data between server and client
      : it can also be used by program to exchange data between programs
      : it specifically determines which program or service on a computer is being used
      : eg ; Web Page , FTP

      : port have a unique number that identifies them [ teh range is between 0 - 65535 ]
      : common port number are 80 , 443 - Web Pages (HTTP , HTTPS) , 25 - Email (SMTP)

IP address : Port is always identified with IP address
           : It is an numeric address
           : it is a identifier for a computer or device on a network
           : every Device has to have an IP address for communication purpose

           : An IP address and port work together to exchange data on a network

uses example : An IP address determines the geographical location of that server
             : A port number determines which server or program that server it wants to use

             : the commonly used port is 80 [HTTP]
             : Lets imagine that we have to go to google
             : we type www.google.com
             : our computer converts this domain name into IP address and then connects with port 80 as we are using HTTP services


recursion : it is basically a technique for a function for calling itself
          : lets take function f1 , in this function as soon as starts running it calls itself as i entered a special code for running automatically without calling
          : and there is also a problem , if a function calls itself without an end it creates a loop which causes to run infinite times
          : its symbol is !
          : yes , you may have seen this symbol in mathematics factorial
          : eg : 9! = 9*8*7*6*5*4*3*2

eg : def factorial(p):
    if p < 1:
        return 1
    else:
        number = p * factorial(p-1)
        return number


print(factorial(5))



xml processing : xml is a file format that is used to store data
                : it is used to store data in the form of nodes

                there are 2 types of formatting xml
                1) SAX
                2) DOM
        SAX : It is used in low memory computer because it loads the data only wanted not the entire file
            : The data inside xml cannot be edited but can be accessed


collections : a container that is used to store collections of data

there are 5 types of it ,
1) Counter : it counts elements inside string or number or float and print in dictionary form

eg : from collections import Counter
     a = '1738627397298319689361939163018396893701979163091739861093789163709'
     b = Counter(a)
     print(list(b.elements()))
     print(b)
     print(b.most_common(1)[0][0])

2) namedtuple:
    Its is similar to giving a variable more variable so that we can manage easily

    Eg : from collections import namedtuple

Point = namedtuple('Point', 'x,y,z,a,q,w,e,r')

pt = Point('hi', 'sai', 'how', 'are', 'you', 'i', 'am', 'nice')[0:9]

for x in pt:
    print(x)

3) defaultdict:

    defautdict acts like a filter for value entry
    if we set a = default_dict(int)
    the values should only be int and str or float cannot be added

eg : from collections import defaultdict
import random

default_dict = defaultdict(int)

e = random.randint(1,6)
f = random.randint(7, 14)

default_dict['a'] = e
default_dict['b'] = f

print(default_dict)

           Logging

It is a program Which actually solves or alerts the user about problems
It also has the solution for the error and works like a Administrator
It also knows the reason why the error occurred and learn from it

there are 5 levels in Logging :

1) DEBUG
2) INFO
3) WARNING
4) ERROR
5) CRITICAL


Python Unit Test :

It is a module which helps to test the code ,
which are required and helps to save a lot of time if error found in a long run

Uses :

it helps in automating tests for different function
if there is like say 1000 function , we acnnot call each of them and test it out
this is where unittest.py comes at clutch


















"""

