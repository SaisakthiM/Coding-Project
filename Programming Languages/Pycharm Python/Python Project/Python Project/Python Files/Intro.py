import collections
import colorsys
import json
import math
import random
import sqlite3
import threading
import time
from turtle import *
import matplotlib.pyplot as plt

class Basics:
    Watch, x = 25, 2
    print(Watch // 7.7)
    name = "     saisakthi    .m"
    print(name, Watch)
    watch = price = 3
    print(price)
    watch1, watch2 = 5, 6
    print(watch2)
    print(43 - 5)
    na = "king"
    print(na)
    customer_name = "sai"
    print(watch1, na, x, Watch, customer_name)
    hi_k = 26
    print(hi_k)
    p = 100
    print(p, x, Watch)
    print(watch1)
    saisakthi = 100
    print(saisakthi - x)
    kat = 200
    nam = "jjk"
    print(saisakthi - x - kat, nam)
    ball_price = 100
    bat_price = 'byedahasask'
    print("your order is", "ball and bat (total) price is =", ball_price)
    float = 5.6
    print("use", float)
    wall = """hi i am saisakthi bye
    i am studying 10th standard"""
    print(wall)
    print(bat_price[3])
    print(bat_price[-5:-2])
    print(wall.strip())
    print(wall.upper().strip())
    print(wall.replace('hi', 'hello').strip())
    print(wall.split('bye'))
    word = " hello in world"
    print("h" in wall)
    print(wall + word)
    print(1 == 1)
    print(1 * 6 > 1 * 78)
    print(3 * 9 >= 3 * 9)
    print(wall.upper())
    print(wall.capitalize().strip())
    print(word.isidentifier())
    print(wall.upper())
    print(wall.isupper())
    fruits = ['Appple', 'Orange', 'Strawberry']
    fruits.remove('Orange')
    fruits.copy()
    print(fruits)
    n = ['1', '2', '3']
    n.count('T')
    n.extend('3')
    n.clear()
    print(n)
    a = input('hi')
    print(a)



class Sentences:
    def __init__(self,x):
        self.x = x
    def __add__(self,other):
        return  Sentences(self.x + " " + other.x)
    def __repr__(self):
        return "<class 'Sentences'>"
    def __len__(self):
        return sum(1 for i in self.x)

a = Sentences("Hi bro")
b = Sentences("I am sai")
c = a+b
print(c.x)
print(repr(c))


class Projects:
    listr = list(range(10))
    print(listr)
    list1211 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    listnew = [i * 2 for i in list1211]
    print(listnew)

    list2233 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    listnew1 = []
    for x in list2233:
        if x % 2 == 1:
            listnew1.append(x)
        else:
            continue

    print(listnew1)

    list22334 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    listnew2 = []
    for x in list22334:
        if x % 2 == 1:
            listnew2.append(-1)
        else:
            listnew2.append(x)

    print(listnew2)

    absx = [-5, -4, 0, 0, 0, 0, 1, 2, 3, 4, 5]
    listnew3 = []

    for x in absx:
        if x == 0:
            listnew3.append(False)
        else:
            listnew3.append(True)

    print(listnew3)

    absx = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    listnew4 = []

    for x in absx:
        if x % 2 == 0:
            listnew4.append(-x)
        else:
            listnew4.append(x)

    print(listnew4)

    # Palidrome Number

    x = int(input('Enter a Number : '))

    z = str(x)

    if z[::] == z[::-1]:
        print(True)
    else:
        print(False)

    x = input('Enter a String : ')

    k = x.split(' ')
    list(k)

    l = k[-1]
    print(len(l))
    @staticmethod
    def count_even_or_odd():
        k = [1,2,3,4,5,6,7,8,9,10]
        l = [sum(k.count(x) for x in k if x%2 == 0),sum(k.count(x) for x in k if x%2 == 1)]
        print(f"""The Number of odds : {l[0]}
            The Number of evens : {l[1]}""")



class InMutableList:
    List = []
    def __init__(self):
        self.List = List = []

    def __setitem__(self, key, value):
        self.List[key].append(value)
    def __delitem__(self, key):
        raise Exception("You Cannot Remove Elements in InMutableList")
    def __getitem__(self, item):
        return self.List[item]
    def __del__(self):
        raise Exception("You Cannot Remove Elements in InMutableList")
    def __delattr__(self, item):
        raise Exception("You Cannot Remove Elements in InMutableList")
    def __delete__(self, instance):
        raise Exception("You Cannot Remove Elements in InMutableList")
    def __delslice__(self, i, j):
        raise Exception("You Cannot Remove Elements in InMutableList")

class Project1:
    print("This is Computer quiz. Do You want to continue.")
    p = input("If Yes , enter Yes : ")
    points = 0

    if p.capitalize() == 'no':
        quit()


    q = ["What is the full form of CPU","What is full form of RAM","What is full form of ROM","What is full form of ALU"
        ,"What is base value of binary","What is base value of octal","What is base value of decimal","What is base value of hexa-decimal",
        "Name the most important part in processor","Full form of GPU",]

    a = ["Central processing Unit","Random Access Memory","Read-Only Memory","Arithmetic Logic Unit","2",
        "8","10","16","Transistors","Graphical Processing Unit",]

    for x in range(len(q)):
        print("{} : ".format(q[x]))
        o = input("Enter Your Answer Here : ")
        if o.capitalize() == a[x]:
            points += 1
        else:
            pass

    print(f"Your Score is : {points}")

class Project:
    @staticmethod
    def grade_checker(x):
        if x > 90:
            return "A Grade"
        elif (x > 80) and (x <= 90):
            return "B Grade"
        elif (x >= 60) and (x <= 80):
            return "C Grade"
        elif x <= 60:
            return "D Grade"
        else:
            return "Wrong Input"

    @staticmethod
    def tax_checker(y):
        if y > 100000:
            return "15% Tax"
        elif (y < 100000) and (y >= 50000):
            return "10% Tax"
        elif y < 50000:
            return "5% Tax"

    @staticmethod
    def year_checker(g):
        if g % 4 == 0:
            return "It is a leap year"
        else:
            return "It is not a leap year"

    @staticmethod
    def no_of_days_returner(x):
        if x.capitalise() == 'January':
            return "There is 31 Days"
        elif x.capitalise() == 'February':
            i = input("Is it leap Year (reply With Yes Or No) : ")
            if i.capitalize() == "Yes":
                return "There is 29 Days"
            else:
                return "There is 28 Days"
        elif x.capitalise() == 'March':
            return "There is 31 Days"
        elif x.capitalise() == 'April':
            return "There is 30 Days"
        elif x.capitalise() == 'May':
            return "There is 31 Days"
        elif x.capitalise() == 'June':
            return "There is 30 Days"
        elif x.capitalise() == 'July':
            return "There is 31 Days"
        elif x.capitalise() == 'August':
            return "There is 31 Days"
        elif x.capitalise() == 'September':
            return "There is 30 Days"
        elif x.capitalise() == 'October':
            return "There is 30 Days"
        elif x.capitalise() == 'November':
            return "There is 30 Days"
        elif x.capitalise() == 'December':
            return "There is 30 Days"
        else:
            return "Wrong Input"

    @staticmethod
    def city_returner(x) -> str:
        if x.capitalise() == "Chennai":
            return "Chennai Central"
        elif x.capitalise() == "Mumbai":
            return "Mumbai Port"
        elif x.capitalise() == "Kolkata":
            return "Victoria Memorial"
        elif x.capitalise() == "Agra":
            return "Taj Mahal"
        elif x.capitalise() == "Jaipur":
            return "Pink Fort"
        elif x.capitalise() == "Delhi":
            return "Red fort"

    @staticmethod
    def hello_bye(d):
        if (d > 5) and (d <= 10):
            return "Hello"
        else:
            return "Bye"

    @staticmethod
    def digit_checker(x):
        if x == x.isdigit():
            c = str(x)
            if len(c) == 3:
                return "It is a 3 Digit Number"
        else:
            return "Wrong Input"

class Quiz:
    print("""Welcome to the Python Quiz.
    Rules :
    1) The Questions are based on MCQ 
    2) You Will Be Given a Question with 2 Choices 
    3) It can Range From Choose To Assertion And Reasoning

    Do You Want to Continue ...
    """)
    current_score = 0

    k = input('Enter Your Choice : ')

    if k.capitalize() == 'Yes':
        print("""Question 1 : What is The Deepest Point On Earth
        1) Mariana Trench
        2) Mariana Beach
        """)
        o = int(input('Enter Your Choice : '))
        if o == 1:
            print('Congrats, One Point is Added')
            current_score += 1
        elif o == 2:
            print('You Have Entered a Wrong Option')

        else:
            print('Wrong Input')

        print("""Question 2 : What is The Farthest Point On Earth
            1) Mount Everest
            2) Himalayas
            """)

        o = int(input('Enter Your Choice : '))
        if o == 1:
            print('Congrats, One Point is Added')
            current_score += 1
        elif o == 2:
            print('You Have Entered a Wrong Option')

        else:
            print('Wrong Input')

        print("""Question 3 : Bermuda Triangle is One of the Dangerous Places On Earth
                1) True
                2) False
                """)

        o = int(input('Enter Your Choice : '))
        if o == 1:
            print('Congrats, One Point is Added')
            current_score += 1
        elif o == 2:
            print('You Have Entered a Wrong Option')

        else:
            print('Wrong Input')

        print("""Question 4 : Ongoing War is between 
                1) Israel And Palestine
                2) Russia and Ukrainian Federation
                """)

        o = int(input('Enter Your Choice : '))
        if o == 1:
            print('Congrats, One Point is Added')
            current_score += 1
        elif o == 2:
            print('You Have Entered a Wrong Option')

        else:
            print('Wrong Input')

        print("""Question 5 : India is Located in Continent of 
                1) Asia
                2) Indian Sub-Continent
                """)

        o = int(input('Enter Your Choice : '))
        if o == 2:
            print('Congrats, One Point is Added')
            current_score += 1
        elif o == 1:
            print('You Have Entered a Wrong Option')

        else:
            print('Wrong Input')

        print("""Question 6 : Weight of an Electron
                1) 9.12 * 10^-33
                2) 9.10 * 10^-31
                """)

        o = int(input('Enter Your Choice : '))
        if o == 2:
            print('Congrats, One Point is Added')
            current_score += 1
        elif o == 1:
            print('You Have Entered a Wrong Option')

        else:
            print('Wrong Input')

        print("""Question 7 : Atomic Number is Found Using Number of Protons
                1) True
                2) False
                """)

        o = int(input('Enter Your Choice : '))
        if o == 1:
            print('Congrats, One Point is Added')
            current_score += 1
        elif o == 2:
            print('You Have Entered a Wrong Option')

        else:
            print('Wrong Input')

        print(f'Your Total Points is {current_score}')

    else:
        print('Ok Bye')

class Matplotlib:
    X = [value * 3 for value in range(0, 100)]
    Y = [value for value in range(0, 100)]
    A = [value * -3 for value in range(0, 100, 2)]
    B = [value for value in range(0, 100, 2)]
    plt.plot(X, Y, A, B)
    plt.show()

    X = [1, 2, 3]
    Y = [2, 4, 1]
    plt.plot(X, Y)
    plt.show()

def recursion(i):
    if i <= 1:
        return i
    else:
        return i * recursion(i - 1)




o = int(input("Enter a Positive Integer : "))
if o < 0:
    print("Enter a Positive Integer")
else:
    l = recursion(o)
    print(l)


def recursion_add(i):
    if i <= 1:
        return i
    else:
        return recursion_add(i - 1) * recursion_add(i - 2)


o = int(input("Enter a Positive Integer : "))
if o < 0:
    print("Enter a Positive Integer")
else:
    l = recursion_add(o)
    print(l)


def ask():
    print('hi world')


ask()
print("outside world")
dictionary = {
    name := "saisakthi",
    age := '15'
}
print(dictionary)
years = 21
if years == 20:
    print('you can earn money on your own')
else:
    print('depend on your parent')
payment = 25700
if payment < 2600:
    print("thankyou for your purchase")
elif payment > 2600:
    print("thankyou for your purchase you also won $10 coupon")
else:
    print("""thankyou for your purchase
pay remaining via cash on delivery""")
a, b = 8, 11
if a == 10 and b == 20:
    print('correct answer')
elif a > 5 and b > 10:
    print("correct answer")
else:
    print("incorrect answer")

oal = [x for x in range(1500, 2701)]
counter21 = []

for i in oal:
    if i % 7 == 0 and i % 5 == 0:
        counter21.append(i)
    else:
        continue

print(counter21)


class calculate:
    @staticmethod
    def add(a, b):
        print(a + b)

    add(12, 12)

    @staticmethod
    def sub(c, d):
        print(c - d)

    sub(12, 27)

    @staticmethod
    def mul(c, d):
        print(c * d)

    sub(15, 25)


for numbered in range(1, 10, 2):
    print(numbered)
else:
    print('numbers are finished')


def km(l):
    print(l * 1000, 'm')


i = 10
while i < 5:
    print(i)
else:
    print('over')

add = lambda num: num + 90
print(add(40))

fact = 0

did = int(input('Enter The Fibonacci Number : '))

for x in range(1, did + 1):
    fact += x
    print(fact)

lst = [1, 2, 3, 4, 5]
str_lst = list(map(str, lst))
print(type(str_lst))


def new_func():
    xx = input("Enter a line point: ")
    yx = input("Enter a line point: ")

    xx_ = xx.split(',')
    yx_ = yx.split(',')

    xx__ = xx_[0]
    y__ = yx_[0]

    xx___ = xx_[1]
    yx___ = yx_[1]

    x1 = int(xx___)
    y1 = int(yx___)

    x2 = int(xx___)
    y2 = int(xx___)

    mid_point = (x1 + y2) // 2, ':', (y1 + x2) // 2
    print(mid_point)


new_func()


def factorial(p):
    if p < 1:
        return 1
    else:
        number = p * factorial(p - 1)
        return number


print(factorial(5))


class Game:
    @staticmethod
    def add_sub_game():
        min_value = 2
        max_value = 6
        roll = random.randint(min_value, max_value)
        return roll

    max_score = 35
    current_score = 0

    print("""This is Odd or Even Game
    1) Choose How Many Times You Want To Play
    2) Then Computer Automatically Choose a Number For You
    3) If Its Even You Can Continue
    4) If It IS Odd The Game Is Over
    """)
    print("")

    if max_score > current_score:
        cont = input("Do You Want To Start The Game? (Y/N)")
        times_play = int(input("How many times would you like to play?"))
        if cont.lower() == 'y':
            for i in range(times_play):
                current_score += add_sub_game()
                if current_score % 2 != 0:
                    print(f"Oops! That's not an even number. Its {current_score}. Game Over.")
                    time.sleep(1)
                    break
                elif current_score % 2 == 0:
                    print(f"Good Keep going. The Number is {current_score}.")
                    time.sleep(1)

    elif current_score > max_score:
        print(f"Congrats's You Won The Game! Your Lucky Number is {current_score}.")

    game1 = input("Enter Your Set Of Numbers You Want to Play With: ")
    game2 = game1.split(",")
    set_game = random.choice(game2)

    current__score = 0
    max__score = 100

    print(set_game)

    if current__score < max__score:
        con = input("Would You Want To Start The Game?(Y/N)")
        times = input("How Many Times You Want to Play With: ")
        if con.upper() == "Y":
            for i in range(int(times)):
                set_sqrt = set_game.pow(2)
                current__update = current__score + set_game
                if current__update > max__score:
                    print("You Won")
                    time.sleep(2)
                elif current__update.sqrt() < max__score:
                    print("You Lost")
                    time.sleep(2)

    str1 = input("Enter a string: ")

    d = collections.defaultdict(int)

    for i in str1:
        d[i] += 1

    for i in sorted(d, key=d.get, reverse=True):
        print('%s %d' % (i, d[i]))


alp = "abcdefghijklmpqrstuvwxyz"
alp1 = "ABCDEFGHIJKLMPQRSTUVWXYZ"

str23 = input("Enter a string: ")

if alp or alp1 in str23:
    print("It Contain All the Alphabet".capitalize())
else:
    print("It Doesn't Contain All The Alphabet".capitalize())

str22 = input("Enter a string: ")

if ',' and '.' in str22:
    str24 = str22.replace(',', '.').replace('.', ',')

else:
    print(str22, "Wrong Input")

userdata = {
    "name": "saisakthi",
    "age": 15
}
print(userdata.get("age"))

name = input()
print("your name is " + name)
x = int(input('enter your desired number'))
y = int(input('enter your 2nd desired number'))
print(x + y)

ind = int(input("Enter a Number"))
if ind > 0:
    print("Number is Postive")
elif ind == 0:
    print("Number is Neutral")
else:
    print("Number is Negative")

ins1 = int(input("enter a number"))
ins2 = int(input("enter a number")) + ins1
if ins2 > 0:
    for inl in range(1, 11):
        print(inl)
elif ins2 == 0:
    print(0)
else:
    for ke in range(-1, -11):
        print(ke)


class Pattern_Printer:
    @staticmethod
    def one_character_printer():
        def pattern_forward(x, y, z):
            for o in range(x, y + 1):
                print(f'{z}' * o)

        def pattern_backward(x, y, z):
            for o in range(x, y - 1, -1):
                print(f'{z}' * o)

        print("""Hello , This is Pattern Printer
            You can Print Pattern for any Characters Forward or Backwards

            1) To Print Only Forward, Enter F
            2) To Print Only Backwards, Enter E
            3) To Print Both Forward and Backwards, Enter FE
            4) To Print First Backwards And Then Forward , Enter EF

            5) To Print Multiple Times (Forward), Enter MF
            6) To Print Multiple Times (Backward), Enter ME
            7) To Print Multiple Times (Forward and Backward), Enter MFE
            8) To Print Multiple Times (Backward and Forward), Enter MEF

            """)

        h = input("Enter Your Choice : ")

        if h.upper() == 'F':
            kocs = input("Enter Your Character You Want to Print : ")
            xoa = int(input("Enter Your Starting Pattern Number : "))
            yoa = int(input("Enter Your Ending Pattern Number : "))

            pattern_forward(xoa, yoa, kocs)

        elif h.upper() == 'E':
            kocs1 = input("Enter Your Character You Want to Print : ")
            xoa1 = int(input("Enter Your Starting Pattern Number : "))
            yoa1 = int(input("Enter Your Ending Pattern Number : "))

            if xoa1 > yoa1:
                pattern_backward(xoa1, yoa1, kocs1)
            elif yoa1 > xoa1:
                pattern_backward(yoa1, xoa1, kocs1)

        elif h.upper() == 'FE':
            print("""Do You Want to Print
                Options : 
                1) Forward and Backwards are Same Character , Enter 1
                2) Forward and Backwards are Different Character, Enter 2
                3) You Want a Space After Printing Forward And Backwards , Enter 3
                """)
            l = int(input("Enter The Correct Choice : "))

            if l == 1:
                kocs = input("Enter Your Character You Want to Print : ")

                xoa1 = int(input("Enter Your Starting Pattern Number (Forward) : "))
                yoa1 = int(input("Enter Your Ending Pattern Number (Forward) : "))

                xoa2 = int(input("Enter Your Starting Pattern Number (Backwards) : "))
                yoa2 = int(input("Enter Your Ending Pattern Number (Backwards) : "))

                pattern_forward(xoa1, yoa1, kocs)
                pattern_backward(xoa2, yoa2, kocs)

            elif l == 2:
                kocs = input("Enter Your Character You Want to Print (Forward Character) : ")
                kocs1 = input("Enter Your Another Character You Want to Print (Backwards Character) : ")

                xoa1 = int(input("Enter Your Starting Pattern Number (Forward) : "))
                yoa1 = int(input("Enter Your Ending Pattern Number (Forward) : "))

                xoa2 = int(input("Enter Your Starting Pattern Number (Backwards) : "))
                yoa2 = int(input("Enter Your Ending Pattern Number (Backwards) : "))

                pattern_forward(xoa1, yoa1, kocs)
                pattern_backward(xoa2, yoa2, kocs1)

            elif l == 3:
                kao = int(input("Enter How Much Space You Want Between Forward and Backwards : "))

                kocs = input("Enter Your Character You Want to Print (Forward Character) : ")
                kocs1 = input("Enter Your Another Character You Want to Print (Backwards Character) : ")

                xoa1 = int(input("Enter Your Starting Pattern Number (Forward) : "))
                yoa1 = int(input("Enter Your Ending Pattern Number (Forward) : "))

                xoa2 = int(input("Enter Your Starting Pattern Number (Backwards) : "))
                yoa2 = int(input("Enter Your Ending Pattern Number (Backwards) : "))

                pattern_forward(xoa1, yoa1, kocs)

                for x in range(1, kao + 1):
                    print('')

                pattern_backward(xoa2, yoa2, kocs1)

        elif h.upper() == 'EF':
            print("""Do You Want to Print
                        Options : 
                        1) Forward and Backwards are Same Character , Enter 1
                        2) Forward and Backwards are Different Character, Enter 2
                        3) You Want a Space After Printing Forward And Backwards , Enter 3
                        """)
            l = int(input("Enter The Correct Choice : "))

            if l == 1:
                kocs = input("Enter Your Character You Want to Print : ")

                xoa1 = int(input("Enter Your Starting Pattern Number (Forward) : "))
                yoa1 = int(input("Enter Your Ending Pattern Number (Forward) : "))

                xoa2 = int(input("Enter Your Starting Pattern Number (Backwards) : "))
                yoa2 = int(input("Enter Your Ending Pattern Number (Backwards) : "))

                pattern_backward(xoa2, yoa2, kocs)
                pattern_forward(xoa1, yoa1, kocs)

            elif l == 2:
                kocs = input("Enter Your Character You Want to Print (Forward Character) : ")
                kocs1 = input("Enter Your Another Character You Want to Print (Backwards Character) : ")

                xoa1 = int(input("Enter Your Starting Pattern Number (Forward) : "))
                yoa1 = int(input("Enter Your Ending Pattern Number (Forward) : "))

                xoa2 = int(input("Enter Your Starting Pattern Number (Backwards) : "))
                yoa2 = int(input("Enter Your Ending Pattern Number (Backwards) : "))

                pattern_backward(xoa2, yoa2, kocs1)
                pattern_forward(xoa1, yoa1, kocs)

            elif l == 3:
                kao = int(input("Enter How Much Space You Want Between Forward and Backwards : "))

                kocs = input("Enter Your Character You Want to Print (Forward Character) : ")
                kocs1 = input("Enter Your Another Character You Want to Print (Backwards Character) : ")

                xoa1 = int(input("Enter Your Starting Pattern Number (Forward) : "))
                yoa1 = int(input("Enter Your Ending Pattern Number (Forward) : "))

                xoa2 = int(input("Enter Your Starting Pattern Number (Backwards) : "))
                yoa2 = int(input("Enter Your Ending Pattern Number (Backwards) : "))

                pattern_backward(xoa2, yoa2, kocs1)

                for i in range(1, kao + 1):
                    print('')

                pattern_forward(xoa1, yoa1, kocs)

        elif h.upper() == 'MF':
            n = int(input("Enter The Number of Times You Want To Print : "))
            kocs = input("Enter Your Character You Want to Print : ")
            xoa = int(input("Enter Your Starting Pattern Number : "))
            yoa = int(input("Enter Your Ending Pattern Number : "))

            while n > 0:
                pattern_forward(xoa, yoa, kocs)
                n -= 1

        elif h.upper() == 'ME':
            n = int(input("Enter The Number of Times You Want To Print : "))
            kocs1 = input("Enter Your Character You Want to Print : ")
            xoa1 = int(input("Enter Your Starting Pattern Number : "))
            yoa1 = int(input("Enter Your Ending Pattern Number : "))

            while n > 0:
                if xoa1 > yoa1:
                    pattern_backward(xoa1, yoa1, kocs1)
                elif yoa1 > xoa1:
                    pattern_backward(yoa1, xoa1, kocs1)
                n -= 1

        elif h.upper() == 'MFE':
            print("""Do You Want to Print
                        Options : 
                        1) Forward and Backwards are Same Character , Enter 1
                        2) Forward and Backwards are Different Character, Enter 2
                        3) You Want a Space After Printing Forward And Backwards , Enter 3
                        """)
            l = int(input("Enter The Correct Choice : "))

            if l == 1:
                n = int(input("Enter The Number of Times You Want To Print : "))
                kocs = input("Enter Your Character You Want to Print : ")

                xoa1 = int(input("Enter Your Starting Pattern Number (Forward) : "))
                yoa1 = int(input("Enter Your Ending Pattern Number (Forward) : "))

                xoa2 = int(input("Enter Your Starting Pattern Number (Backwards) : "))
                yoa2 = int(input("Enter Your Ending Pattern Number (Backwards) : "))

                while n > 0:
                    pattern_forward(xoa1, yoa1, kocs)
                    pattern_backward(xoa2, yoa2, kocs)

                    n -= 1

            elif l == 2:
                n = int(input("Enter The Number of Times You Want To Print : "))
                kocs = input("Enter Your Character You Want to Print (Forward Character) : ")
                kocs1 = input("Enter Your Another Character You Want to Print (Backwards Character) : ")

                xoa1 = int(input("Enter Your Starting Pattern Number (Forward) : "))
                yoa1 = int(input("Enter Your Ending Pattern Number (Forward) : "))

                xoa2 = int(input("Enter Your Starting Pattern Number (Backwards) : "))
                yoa2 = int(input("Enter Your Ending Pattern Number (Backwards) : "))

                while n > 0:
                    pattern_forward(xoa1, yoa1, kocs)
                    pattern_backward(xoa2, yoa2, kocs1)
                    n -= 1

            elif l == 3:
                n = int(input("Enter The Number of Times You Want To Print : "))
                kao = int(input("Enter How Much Space You Want Between Forward and Backwards : "))

                kocs = input("Enter Your Character You Want to Print (Forward Character) : ")
                kocs1 = input("Enter Your Another Character You Want to Print (Backwards Character) : ")

                xoa1 = int(input("Enter Your Starting Pattern Number (Forward) : "))
                yoa1 = int(input("Enter Your Ending Pattern Number (Forward) : "))

                xoa2 = int(input("Enter Your Starting Pattern Number (Backwards) : "))
                yoa2 = int(input("Enter Your Ending Pattern Number (Backwards) : "))
                while n > 0:
                    pattern_forward(xoa1, yoa1, kocs)

                    for x in range(1, kao + 1):
                        print('')

                    pattern_backward(xoa2, yoa2, kocs1)

                    n -= 1

        elif h.upper() == 'MEF':
            print("""Do You Want to Print
                                Options : 
                                1) Forward and Backwards are Same Character , Enter 1
                                2) Forward and Backwards are Different Character, Enter 2
                                3) You Want a Space After Printing Forward And Backwards , Enter 3
                                """)
            l = int(input("Enter The Correct Choice : "))

            if l == 1:
                n = int(input("Enter The Number of Times You Want To Print : "))
                kocs = input("Enter Your Character You Want to Print : ")

                xoa1 = int(input("Enter Your Starting Pattern Number (Forward) : "))
                yoa1 = int(input("Enter Your Ending Pattern Number (Forward) : "))

                xoa2 = int(input("Enter Your Starting Pattern Number (Backwards) : "))
                yoa2 = int(input("Enter Your Ending Pattern Number (Backwards) : "))

                while n > 0:
                    pattern_backward(xoa2, yoa2, kocs)
                    pattern_forward(xoa1, yoa1, kocs)
                    n -= 1

            elif l == 2:
                n = int(input("Enter The Number of Times You Want To Print : "))
                kocs = input("Enter Your Character You Want to Print (Forward Character) : ")
                kocs1 = input("Enter Your Another Character You Want to Print (Backwards Character) : ")

                xoa1 = int(input("Enter Your Starting Pattern Number (Forward) : "))
                yoa1 = int(input("Enter Your Ending Pattern Number (Forward) : "))

                xoa2 = int(input("Enter Your Starting Pattern Number (Backwards) : "))
                yoa2 = int(input("Enter Your Ending Pattern Number (Backwards) : "))

                while n > 0:
                    pattern_backward(xoa2, yoa2, kocs1)
                    pattern_forward(xoa1, yoa1, kocs)
                    n -= 1

            elif l == 3:
                n = int(input("Enter The Number of Times You Want To Print : "))
                kao = int(input("Enter How Much Space You Want Between Forward and Backwards : "))

                kocs = input("Enter Your Character You Want to Print (Forward Character) : ")
                kocs1 = input("Enter Your Another Character You Want to Print (Backwards Character) : ")

                xoa1 = int(input("Enter Your Starting Pattern Number (Forward) : "))
                yoa1 = int(input("Enter Your Ending Pattern Number (Forward) : "))

                xoa2 = int(input("Enter Your Starting Pattern Number (Backwards) : "))
                yoa2 = int(input("Enter Your Ending Pattern Number (Backwards) : "))

                while n > 0:
                    pattern_backward(xoa2, yoa2, kocs1)

                    for x in range(1, kao + 1):
                        print('')

                    pattern_forward(xoa1, yoa1, kocs)

                    n -= 1

        else:
            print("Wrong Input")

    @staticmethod
    def number_printer():

        def alphabet_pyramid():
            rows = int(input("Enter the number of rows: "))
            # Outer for loop to handle number of rows
            for num in range(rows + 1):
                # Inner for loop to handle number of columns
                # values change according to the outer loop
                for i in range(num):
                    print(num, end=" ")

                    # End line after each row
                print()

        def inverterd_alphabet_pyramid():
            rows = int(input("Enter the number of rows: "))

            # Outer for loop executing in reverse order
            for i in range(rows, 0, -1):
                num = i
                # Inner for loop to handle number of columns
                # values change according to the outer loop
                for j in range(0, i):
                    print(num, end=" ")

                    # End line after each row
                print()

        def mirrored_semi_pyramid():
            rows = int(input("Enter the number of rows: "))

            # Outer for loop to handle number of rows
            for i in range(1, rows + 1):
                num = 1
                # Inner for loop to handle number of columns
                # values change according to the outer loop
                for j in range(rows, 0, -1):
                    if j > i:
                        print(" ", end=" ")
                    else:
                        print(num, end=" ")
                        num += 1

                # End line after each row
                print()

        def number_pattern_inverted_pyramid():
            rows = int(input("Enter the number of rows: "))

            # Outer for loop to handle number of rows
            for i in range(rows, 0, -1):
                # Inner for loop to handle number of columns
                # values change according to the outer loop
                for j in range(0, i + 1):
                    print(j, end=" ")

                    # End line after each row
                print()

        def reverse_number_pyramid():
            rows = int(input("Enter the number of rows: "))

            # Outer for loop to handle number of rows
            for i in range(1, rows + 1):
                # Inner for loop to handle number of columns
                # values change according to the outer loop
                for j in range(i, 0, -1):
                    print(j, end=" ")

                    # End line after each row
                print()

        def natural_number_pyramid():
            rows = int(input("Enter the number of rows: "))
            num = 1
            stop = 2

            # Outer for loop to handle number of rows
            for i in range(rows):
                # Inner for loop to handle number of columns
                # values change according to the outer loop
                for j in range(1, stop):
                    print(num, end=" ")
                    num += 1

                    # End line after each row
                print()
                stop += 2

        def odd_number_pyramid():
            rows = int(input("Enter the Number Of Rows : "))

            num = 1
            stop = 3

            for i in range(rows):
                for k in range(1, stop + 1):
                    if k % 2 == 1:
                        print(num, end=" ")
                print()
                stop += 2

        print("""Hello, this is Multiple Printer.
        Your Choices Are
        1) For Building Inverted Alphabet Pyramid , Enter IAP
        2) For Building Alphabet Pyramid , Enter AP
        3) For Building Mirrored Semi Pyramid , Enter MP
        4) For Building Pattern Inverted Pyramid , Enter PIP
        5) For Building Reverse Number Pyramid , Enter RP
        6) For Building Natural Number Pyramid , Enter NP
        7) For Building Odd Number Pyramid , Enter OP
        """)
        print('')
        l = input("Enter Your Choice")
        if l.upper() == 'IAP':
            inverterd_alphabet_pyramid()
        elif l.upper() == 'AP':
            alphabet_pyramid()
        elif l.upper() == 'MP':
            mirrored_semi_pyramid()
        elif l.upper() == 'PIP':
            number_pattern_inverted_pyramid()
        elif l.upper() == 'RP':
            reverse_number_pyramid()
        elif l.upper() == 'NP':
            natural_number_pyramid()
        elif l.upper() == 'OP':
            odd_number_pyramid()


l = Pattern_Printer

l.number_printer()

m1 = int(input("enter the mass 1"))
m2 = int(input("enter the mass2"))
g = 6.67384 * 10 ** -11
d = int(input("enter the distance between"))


def calgrav(g, m1, m2, d):
    print(g * m1 * m2 / d ** 2)


calgrav(g, m1, m2, d)


class Pattern_Printer:

    @staticmethod
    def pattern_forward(x, y, z):
        for o in range(x, y + 1):
            print(f'{z}' * o)

    @staticmethod
    def pattern_backward(x, y, z):
        for o in range(x, y - 1, -1):
            print(f'{z}' * o)

    print("""Hello , This is Pattern Printer
    You can Print Pattern for any Characters Forward or Backwards

    1) To Print Only Forward, Enter F
    2) To Print Only Backwards, Enter E
    3) To Print Both Forward and Backwards, Enter FE
    4) To Print First Backwards And Then Forward , Enter EF

    5) To Print Multiple Times (Forward), Enter MF
    6) To Print Multiple Times (Backward), Enter ME
    7) To Print Multiple Times (Forward and Backward), Enter MFE
    8) To Print Multiple Times (Backward and Forward), Enter MEF

    """)

    h = input("Enter Your Choice : ")

    if h.upper() == 'F':
        kocs = input("Enter Your Character You Want to Print : ")
        xoa = int(input("Enter Your Starting Pattern Number : "))
        yoa = int(input("Enter Your Ending Pattern Number : "))

        pattern_forward(xoa, yoa, kocs)

    elif h.upper() == 'E':
        kocs1 = input("Enter Your Character You Want to Print : ")
        xoa1 = int(input("Enter Your Starting Pattern Number : "))
        yoa1 = int(input("Enter Your Ending Pattern Number : "))

        if xoa1 > yoa1:
            pattern_backward(xoa1, yoa1, kocs1)
        elif yoa1 > xoa1:
            pattern_backward(yoa1, xoa1, kocs1)

    elif h.upper() == 'FE':
        print("""Do You Want to Print
        Options : 
        1) Forward and Backwards are Same Character , Enter 1
        2) Forward and Backwards are Different Character, Enter 2
        3) You Want a Space After Printing Forward And Backwards , Enter 3
        """)
        l = int(input("Enter The Correct Choice : "))

        if l == 1:
            kocs = input("Enter Your Character You Want to Print : ")

            xoa1 = int(input("Enter Your Starting Pattern Number (Forward) : "))
            yoa1 = int(input("Enter Your Ending Pattern Number (Forward) : "))

            xoa2 = int(input("Enter Your Starting Pattern Number (Backwards) : "))
            yoa2 = int(input("Enter Your Ending Pattern Number (Backwards) : "))

            pattern_forward(xoa1, yoa1, kocs)
            pattern_backward(xoa2, yoa2, kocs)

        elif l == 2:
            kocs = input("Enter Your Character You Want to Print (Forward Character) : ")
            kocs1 = input("Enter Your Another Character You Want to Print (Backwards Character) : ")

            xoa1 = int(input("Enter Your Starting Pattern Number (Forward) : "))
            yoa1 = int(input("Enter Your Ending Pattern Number (Forward) : "))

            xoa2 = int(input("Enter Your Starting Pattern Number (Backwards) : "))
            yoa2 = int(input("Enter Your Ending Pattern Number (Backwards) : "))

            pattern_forward(xoa1, yoa1, kocs)
            pattern_backward(xoa2, yoa2, kocs1)

        elif l == 3:
            kao = int(input("Enter How Much Space You Want Between Forward and Backwards : "))

            kocs = input("Enter Your Character You Want to Print (Forward Character) : ")
            kocs1 = input("Enter Your Another Character You Want to Print (Backwards Character) : ")

            xoa1 = int(input("Enter Your Starting Pattern Number (Forward) : "))
            yoa1 = int(input("Enter Your Ending Pattern Number (Forward) : "))

            xoa2 = int(input("Enter Your Starting Pattern Number (Backwards) : "))
            yoa2 = int(input("Enter Your Ending Pattern Number (Backwards) : "))

            pattern_forward(xoa1, yoa1, kocs)

            for x in range(1, kao + 1):
                print('')

            pattern_backward(xoa2, yoa2, kocs1)

    elif h.upper() == 'EF':
        print("""Do You Want to Print
                Options : 
                1) Forward and Backwards are Same Character , Enter 1
                2) Forward and Backwards are Different Character, Enter 2
                3) You Want a Space After Printing Forward And Backwards , Enter 3
                """)
        l = int(input("Enter The Correct Choice : "))

        if l == 1:
            kocs = input("Enter Your Character You Want to Print : ")

            xoa1 = int(input("Enter Your Starting Pattern Number (Forward) : "))
            yoa1 = int(input("Enter Your Ending Pattern Number (Forward) : "))

            xoa2 = int(input("Enter Your Starting Pattern Number (Backwards) : "))
            yoa2 = int(input("Enter Your Ending Pattern Number (Backwards) : "))

            pattern_backward(xoa2, yoa2, kocs)
            pattern_forward(xoa1, yoa1, kocs)

        elif l == 2:
            kocs = input("Enter Your Character You Want to Print (Forward Character) : ")
            kocs1 = input("Enter Your Another Character You Want to Print (Backwards Character) : ")

            xoa1 = int(input("Enter Your Starting Pattern Number (Forward) : "))
            yoa1 = int(input("Enter Your Ending Pattern Number (Forward) : "))

            xoa2 = int(input("Enter Your Starting Pattern Number (Backwards) : "))
            yoa2 = int(input("Enter Your Ending Pattern Number (Backwards) : "))

            pattern_backward(xoa2, yoa2, kocs1)
            pattern_forward(xoa1, yoa1, kocs)

        elif l == 3:
            kao = int(input("Enter How Much Space You Want Between Forward and Backwards : "))

            kocs = input("Enter Your Character You Want to Print (Forward Character) : ")
            kocs1 = input("Enter Your Another Character You Want to Print (Backwards Character) : ")

            xoa1 = int(input("Enter Your Starting Pattern Number (Forward) : "))
            yoa1 = int(input("Enter Your Ending Pattern Number (Forward) : "))

            xoa2 = int(input("Enter Your Starting Pattern Number (Backwards) : "))
            yoa2 = int(input("Enter Your Ending Pattern Number (Backwards) : "))

            pattern_backward(xoa2, yoa2, kocs1)

            for x in range(1, kao + 1):
                print('')

            pattern_forward(xoa1, yoa1, kocs)

    elif h.upper() == 'MF':
        n = int(input("Enter The Number of Times You Want To Print : "))
        kocs = input("Enter Your Character You Want to Print : ")
        xoa = int(input("Enter Your Starting Pattern Number : "))
        yoa = int(input("Enter Your Ending Pattern Number : "))

        while n > 0:
            pattern_forward(xoa, yoa, kocs)
            n -= 1

    elif h.upper() == 'ME':
        n = int(input("Enter The Number of Times You Want To Print : "))
        kocs1 = input("Enter Your Character You Want to Print : ")
        xoa1 = int(input("Enter Your Starting Pattern Number : "))
        yoa1 = int(input("Enter Your Ending Pattern Number : "))

        while n > 0:
            if xoa1 > yoa1:
                pattern_backward(xoa1, yoa1, kocs1)
            elif yoa1 > xoa1:
                pattern_backward(yoa1, xoa1, kocs1)
            n -= 1

    elif h.upper() == 'MFE':
        print("""Do You Want to Print
                Options : 
                1) Forward and Backwards are Same Character , Enter 1
                2) Forward and Backwards are Different Character, Enter 2
                3) You Want a Space After Printing Forward And Backwards , Enter 3
                """)
        l = int(input("Enter The Correct Choice : "))

        if l == 1:
            n = int(input("Enter The Number of Times You Want To Print : "))
            kocs = input("Enter Your Character You Want to Print : ")

            xoa1 = int(input("Enter Your Starting Pattern Number (Forward) : "))
            yoa1 = int(input("Enter Your Ending Pattern Number (Forward) : "))

            xoa2 = int(input("Enter Your Starting Pattern Number (Backwards) : "))
            yoa2 = int(input("Enter Your Ending Pattern Number (Backwards) : "))

            while n > 0:
                pattern_forward(xoa1, yoa1, kocs)
                pattern_backward(xoa2, yoa2, kocs)

                n -= 1

        elif l == 2:
            n = int(input("Enter The Number of Times You Want To Print : "))
            kocs = input("Enter Your Character You Want to Print (Forward Character) : ")
            kocs1 = input("Enter Your Another Character You Want to Print (Backwards Character) : ")

            xoa1 = int(input("Enter Your Starting Pattern Number (Forward) : "))
            yoa1 = int(input("Enter Your Ending Pattern Number (Forward) : "))

            xoa2 = int(input("Enter Your Starting Pattern Number (Backwards) : "))
            yoa2 = int(input("Enter Your Ending Pattern Number (Backwards) : "))

            while n > 0:
                pattern_forward(xoa1, yoa1, kocs)
                pattern_backward(xoa2, yoa2, kocs1)
                n -= 1

        elif l == 3:
            n = int(input("Enter The Number of Times You Want To Print : "))
            kao = int(input("Enter How Much Space You Want Between Forward and Backwards : "))

            kocs = input("Enter Your Character You Want to Print (Forward Character) : ")
            kocs1 = input("Enter Your Another Character You Want to Print (Backwards Character) : ")

            xoa1 = int(input("Enter Your Starting Pattern Number (Forward) : "))
            yoa1 = int(input("Enter Your Ending Pattern Number (Forward) : "))

            xoa2 = int(input("Enter Your Starting Pattern Number (Backwards) : "))
            yoa2 = int(input("Enter Your Ending Pattern Number (Backwards) : "))
            while n > 0:
                pattern_forward(xoa1, yoa1, kocs)

                for x in range(1, kao + 1):
                    print('')

                pattern_backward(xoa2, yoa2, kocs1)

                n -= 1

    elif h.upper() == 'MEF':
        print("""Do You Want to Print
                        Options : 
                        1) Forward and Backwards are Same Character , Enter 1
                        2) Forward and Backwards are Different Character, Enter 2
                        3) You Want a Space After Printing Forward And Backwards , Enter 3
                        """)
        l = int(input("Enter The Correct Choice : "))

        if l == 1:
            n = int(input("Enter The Number of Times You Want To Print : "))
            kocs = input("Enter Your Character You Want to Print : ")

            xoa1 = int(input("Enter Your Starting Pattern Number (Forward) : "))
            yoa1 = int(input("Enter Your Ending Pattern Number (Forward) : "))

            xoa2 = int(input("Enter Your Starting Pattern Number (Backwards) : "))
            yoa2 = int(input("Enter Your Ending Pattern Number (Backwards) : "))

            while n > 0:
                pattern_backward(xoa2, yoa2, kocs)
                pattern_forward(xoa1, yoa1, kocs)
                n -= 1

        elif l == 2:
            n = int(input("Enter The Number of Times You Want To Print : "))
            kocs = input("Enter Your Character You Want to Print (Forward Character) : ")
            kocs1 = input("Enter Your Another Character You Want to Print (Backwards Character) : ")

            xoa1 = int(input("Enter Your Starting Pattern Number (Forward) : "))
            yoa1 = int(input("Enter Your Ending Pattern Number (Forward) : "))

            xoa2 = int(input("Enter Your Starting Pattern Number (Backwards) : "))
            yoa2 = int(input("Enter Your Ending Pattern Number (Backwards) : "))

            while n > 0:
                pattern_backward(xoa2, yoa2, kocs1)
                pattern_forward(xoa1, yoa1, kocs)
                n -= 1

        elif l == 3:
            n = int(input("Enter The Number of Times You Want To Print : "))
            kao = int(input("Enter How Much Space You Want Between Forward and Backwards : "))

            kocs = input("Enter Your Character You Want to Print (Forward Character) : ")
            kocs1 = input("Enter Your Another Character You Want to Print (Backwards Character) : ")

            xoa1 = int(input("Enter Your Starting Pattern Number (Forward) : "))
            yoa1 = int(input("Enter Your Ending Pattern Number (Forward) : "))

            xoa2 = int(input("Enter Your Starting Pattern Number (Backwards) : "))
            yoa2 = int(input("Enter Your Ending Pattern Number (Backwards) : "))

            while n > 0:
                pattern_backward(xoa2, yoa2, kocs1)

                for x in range(1, kao + 1):
                    print('')

                pattern_forward(xoa1, yoa1, kocs)

                n -= 1

    else:
        print("Wrong Input")


h = open("data.json")
x = json.load(h)
print(x.get('age'))

speed(0)
hideturtle()
bgcolor('white')
tracer(5)
width(2)
h = 0
for r in range(16):
    for j in range(18):
        c = colorsys.hsv_to_rgb(h, 1, 1)
        color(c)
        h += 0.005
        rt(90)
        circle(150 - j * 6, 90)
        lt(90)
        circle(150 - j * 6, 90)
        rt(180)
    circle(40, 24)
done()

a = """Twinkle , Twinkle , little star
                  How I wonder what you are!
                           Up above the world so high ,
                           Like a diamond in the sky
       Twinkle , Twinkle little stars
                  How i wonder what you are """
print(a)

x = str(input("Enter Your First Name"))
y = str(input("Enter Your Last Name"))
print(y + "", x)

a = int(input("Enter A Number"))
b = int(input("Enter A Number"))
if a > b:
    print(a, "is greater")
elif b > a:
    print(b, "is greater")

    k = """Enter a choice
    1) change to list
    2) change to tuples"""

    print(k)

    l = int(input("Choice Is Here"))

    n = input('Enter A Sequence Of Number')
    c = n.split(",")
    if l == 1:
        b = list(c)
        print('Tuple', ":", b)
    elif l == 2:
        m = tuple(c)
        print('Tuple', ":", m)

color_list = ['Red', 'Green', 'White', 'Yellow']
c = color_list[0]
f = color_list[3]
print(c, '', f)

n = int(input("Enter A Number"))
a = int("%s" % n)
b = int("%s%s" % (n, n))
c = int("%s%s%s" % (n, n, n))


def mul(x):
    return a + b + c


v = mul(n)
print(v)

x = {
    "Name": "Sai sakthi",
    "Age": "17",
    "Register NO": 2113,
    "Mark": "405/500",

    "name": "sai kumar",
    "age": "19",
    "register NO": 1345,
    "mark": "445/500"
}

u = x.get("name")
i = x.get("Name")
l = x.get("age")
o = x.get("Age")
w = x.get("register NO")
m = x.get("Register NO")

ol = x.get("Mark")
jj = x.get("mark")

nb = """Mark Verifyer
Instruction:
1) Enter Your Name
2) Enter Your Age
3) Enter Your Registration NO

Congratulations"""
print(nb)

ba = int(input("Enter a Number"))
ab = int(input("Enter a Number"))

for i in range(ba + 1, ab):
    print(i)


    class Country:
        country_Important = ['Currency', 'Tax', 'Trade']
        hi = ""

        @staticmethod
        def gdp():
            return "3.12 Trillion Dollars"

        @staticmethod
        def gpc():
            return "3,200 Dollars"


    citizen1 = Country()
    citizen2 = Country()

    u = citizen2.gdp()
    print(u)

    citizen1.country_Important.append("I am Indian Citizen")
    print(citizen1.country_Important)

    citizen2.country_Important.append("I am a Foreign Citizen")

    citizen2.hi = "Hello"
    print(citizen2.hi)

    print(citizen2.country_Important)

k = input("Enter a String")
o = "Is"
j = "is"

if o or j in k:
    print(k)
else:
    print(o, "", k)


class calculator:
    @staticmethod
    def add(x, y):
        print(x + y)

    @staticmethod
    def sub(x, y):
        print(x - y)

    @staticmethod
    def mul(x, y):
        print(x * y)

    @staticmethod
    def div(x, y):
        print(x / y)

    def __init__(self, x, y):
        u = int(input('Enter a number'))
        if u == 1:
            self.add(x, y)
        if u == 2:
            self.sub(x, y)
        if u == 3:
            self.mul(x, y)
        if u == 4:
            self.div(x, y)


cal = calculator(10, 3)


class laptop:
    price = 0
    ram = ""
    processor = ""


dell = laptop()
hp = laptop()

dell.price = 50000
hp.price = 55000

dell.ram = "8 GB"
hp.ram = "16 GB"

dell.processor = "i5 11400H"
hp.processor = "i5 12450H"

laptop1 = {
    "Price": dell.price,
    "Ram": dell.ram,
    "Processor": dell.processor
}
laptop2 = {
    "Price": hp.price,
    "Ram": hp.ram,
    "Processor": hp.processor
}

print(laptop1)
print("Vs")
print(laptop2)

k = int(input("Enter a Number"))
if k < 100:
    print("It Is Less Than 100")
elif 100 < k < 1000:
    print("It is more than 100 but lesser than 1000")
elif 1000 < k < 2000:
    print("It is more than 1000 but less than 2000")

ok = input("Enter Your Name")
hh = input("Enter Your Age")
kk = int(input("Enter Your Reistration NO"))

if ok == u:
    if hh == l:
        if kk == w:
            print(jj)
else:
    print("You Have Entered Wrong Detail")

if ok == i:
    if hh == o:
        if kk == m:
            print(ol)
else:
    print("You Have Entered Wrong Detail")

llk = open("data.json")
x = json.load(llk)

u = x.get("name")
i = x.get("Name")
l = x.get("age")
o = x.get("Age")
w = x.get("register NO")
m = x.get("Register NO")

ol = x.get("Mark")
jj = x.get("mark")

b = """Mark Verifyer
Instruction:
1) Enter Your Name
2) Enter Your Age
3) Enter Your Registration NO

Congratulations"""
print(b)

ok = input("Enter Your Name")
hh = input("Enter Your Age")
kk = int(input("Enter Your Reistration NO"))

if ok == u:
    if hh == l:
        if kk == w:
            print(jj)

if ok == i:
    if hh == o:
        if kk == m:
            print(ol)

f = """Pythagoras Theorem
1) Converts Opp and Adj to Hyp
2) Converts Hyp and Opp to Adj
3) Converts Hyp and Adj to Opp"""

print(f)

u = int(input("Enter a choice"))


def calc():
    if u == 1:
        opp = int(input("Enter the Opposite length"))

        adj = int(input("Enter the Adjacent length"))

        x = opp ** 2 + adj ** 2
        x1 = math.sqrt(x)
        print(x1)
    if u == 2:
        opp = int(input("Enter the Opposite length"))
        hyp = int(input("Enter the Hypotenuse"))

        y = hyp ** 2 - opp ** 2
        y1 = math.sqrt(y)
        print(y1)
    if u == 3:
        opp = int(input("Enter the Opposite length"))
        hyp = int(input("Enter a Hypotenuse"))

        z = hyp ** 2 - opp ** 2
        z1 = math.sqrt(z)
        print(z1)


calc()

tim = int(input("Enter the time "))
si = input("Enter the unit ")

if si == 'c':
    print(tim * 3153600 * 100)
if si == 'd':
    print(tim * 3153600 * 10)
if si == 'y':
    print(tim * 3153600)
elif si == 'm':
    print(tim * 3153600 / 12)
elif si == 'w':
    print(tim * 604800)
elif si == 'd':
    print(tim * 86400)
elif si == 'h':
    print(tim * 3600)
elif si == 'mi':
    print(tim * 60)

a = int(input("Enter a number or sting "))
b = int(input("Enter a number or sting "))
c = int(input("Enter a number or sting "))
d = int(input("Enter a number or sting "))

h = a, b, c, d

f = list(h)

f1 = f[0]
f2 = f[3]

print("Before Switching Character ", f)
print("After Switching Character ", '[', f[3], f[2], f[1], f[0], ']')

num = int(input("Enter a Number"))
total_sum = 0

for n in range(num):
    numbers = int(input("Enter any Number"))
    total_sum += numbers

avg = total_sum / num

print("Average is ", avg)

x = int(input("Enter a number: "))
y = int(input("Enter another number: "))

if x >= 2000 or y <= 3200:
    for i in range(x, y):
        if i % 7 == 0 and i % 5 != 0:
            print(i)

hik = str(input("Enter a number: "))

ko = hik.split(',')

al = tuple(ko)
ks = list(ko)


def conver(ka, kl):
    print(ka)
    print(kl)


conver(al, ks)


class book:

    def __init__(self, title, author, price, quantity):
        self.title = title
        self.author = author
        self.price = price
        self.quantity = quantity

    def get_price(self):
        return self.price

    def get_quantity(self):
        return self.quantity

    def set_quantity(self, quantity):
        self.quantity = quantity

    def get_author(self):
        return self.author

    def get_title(self):
        return self.title

    def sell(self, number_sold):
        self.quantity -= number_sold

    def restock(self, number_restock):
        self.quantity += number_restock


my_book = book("The Book Of Wings", "A.P.J Abdul Kalam", 120.0, 25000)

ee = {
    my_book.get_price(),
    my_book.get_quantity(),
    my_book.get_author(),
    my_book.get_title(),
    my_book.get_price(),
    my_book.get_quantity(),
    my_book.set_quantity(100),
    my_book.sell(250),
    my_book.restock(100)
}
print(ee)

new_list = [1]


def counter(v):
    x = v.count(19)
    y = v.count(5)

    if x == 2 and y >= 3:
        print(True)
    else:
        print(False)


counter(new_list)
print(new_list)

os = json.load(open('Bank Data.json'))
odi = json.load(open('person2.json'))

Nam = os.get('Name')
kao = os.get('Age')
la = os.get('Serial Number')
amo = os.get('Balance')
od = os.get('Pin')
pp = os.get('UPI ID')
hhi = os.get('Loan')

al = odi.get('Name')
kd = odi.get('Age')
ls = odi.get('Serial Number')
an = odi.get('Balance')
oa = odi.get('Pin')
pq = odi.get('UPI ID')
kw = odi.get('Balance')

vi = """This is SBI Bank

Choose any One in this Options
And Answer with Y or N
If one answered with answer other with A
"""
print(vi)

b = input("Withdraw :")
j = input("Add Amount :")
p = input("Repay Amount :")
ll = input("UPI Method")

print("")
bd = """Enter The Following Details Correctly
1) Name
2) Age
3) Serial Number
4) Pin
5) Amount Paid (If Option Chosen Was Add Amount)
6) Repaid Amount (If Option Chosen Was Repay Amount)
7) Withdraw Amount (If Option Chosen Was Withdraw)
"""

if b == "Y" and j == "A" and p == "A" and ll == "A":
    pd = input("Enter The Name :")
    JJ = int(input("Enter The Age :"))
    hs = int(input("Enter The Serial Number :"))
    nn = int(input("Enter The Pin :"))
    uo = int(input("Enter The Amount :"))

    if pd == Nam and JJ == kao and hs == la and nn == od and uo < kw:
        print(amo - kw)
        print("")
        print("The Amount Was Successfully Withdrawn")

    elif pd == Nam and JJ == kao and hs == la and nn == od and uo > kw:
        print("Amount Exceeded The Balance")

    elif pd == al and JJ == kd and hs == ls and nn == pq and uo < amo:
        print(amo - uo)
        print("")
        print("Thank You For The Withdraw")

    elif pd == Nam and JJ == kao and hs == la and nn == od and uo > amo:
        print("Amount Exceeded The Balance")

    else:
        print("You have entered the wrong details")

if j == "Y" and b == "A" and p == "A" and ll == "A":
    pd = input("Enter The Name :")
    JJ = int(input("Enter The Age :"))
    hs = int(input("Enter The Serial Number :"))
    nn = int(input("Enter The Pin :"))
    uo = int(input("Enter The Amount To Add :"))

    if pd == Nam and JJ == kao and hs == la and nn == od:
        print(amo + kw)
        print("")
        print("Amount Was Successfully Added")

    elif pd == Nam and JJ == kao and hs == la and nn == od:
        print(amo + uo)
        print("")
        print("Amount Was Successfully Added")

    else:
        print("You have entered the wrong details")

if p == "Y" and b == "A" and j == "A" and ll == "A":
    pd = input("Enter The Name :")
    JJ = int(input("Enter The Age :"))
    hs = int(input("Enter The Serial Number :"))
    nn = int(input("Enter The Pin :"))
    uo = int(input("Enter The Amount To Repay:"))

    if pd == Nam and JJ == kao and hs == la and nn == od:
        print(hhi - uo)
        print("")
        print("Your Amount Was Successfully Repaid The Loan")

    else:
        print("You have entered the wrong details")

if ll == "Y" and b == "A" and j == "A" and p == "A":
    our = int(input("Enter The UPI ID (Yours) : "))
    if our == pp:
        print(our + kw)
        print("")
        print("The Amount Was Successfully Transferred")

lock = threading.Lock()

hh = 8192


def double():
    global hh
    while hh < 16384:
        hh *= 2
        print(hh)
        time.sleep(1)


def halve():
    global hh
    while hh > 1:
        hh /= 2
        print(hh)
        time.sleep(1)
        print("Reached the maximum")
        lock.release()


t1 = threading.Thread(target=double)
t2 = threading.Thread(target=halve)
t1.start()
t2.start()

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

hs = int(input("Enter The Number: "))
hs1 = int(input("Enter The Number 2: "))

hs3 = hs - hs1
hs4 = hs1 - hs
hs5 = hs1 + hs

if hs == hs1:
    print("The numbers are equal")
    print(True)
elif hs3 or hs4:
    print("The numbers are not equal")
    print("Difference is either 5 or -5")
elif hs5:
    print("The numbers are not equal")
    print("Sum is either 5 or -5")
else:
    print(False)

xi = input("Enter a File: ")
xi1 = open(xi, "r")

xi2 = xi.split(".")

print("The Name Of File Is : {}".format(xi2[0]))
print("The Type Of File Is : {}".format(xi2[1]))
print("The Path Of File Is : {}".format(os.path.realpath(xi)))


def is_leap(years):
    leap = False
    leaps = True

    if years % 4 == 0 and years % 400 == 0:
        return leaps
    elif years % 100 == 0:
        return leap
    else:
        return leap


year = int(input("Enter a year"))
x = is_leap(year)
print(x)

connection = sqlite3.connect('Sai.db')
cursor = connection.cursor()


class person:

    def __init__(self, id_number=0, first="", last="", age=23):
        self.id_number = None
        self.id = id_number
        self.first = first
        self.last = last
        self.age = age
        self.connection = sqlite3.connect('Sai.db')
        self.cursor = connection.cursor()

    def load_person(self, id_number):
        self.cursor.execute("""
        SELECT * FROM person
        WHERE id = {}
        """.format(id_number))

        result = self.cursor.fetchone()

        self.id_number = id_number
        self.first = result[1]
        self.last = result[2]
        self.age = result[3]

    def insert_person(self):
        self.cursor.execute(f"""
           INSERT INTO person DEFAULT VALUES 
           ({self.id_number}, '{self.first}', '{self.last}', '{self.age}')
           """)

        self.connection.commit()
        self.connection.close()

