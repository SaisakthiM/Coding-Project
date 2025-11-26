"""
File handling - Txt file
"""

""" 1) Write a user defined function countH() in python that displays the no of lines starting with H in file para.txt """
def countH():
    f = open("para.txt",'r')
    S = f.readlines()
    c = 0
    for line in S:
        if line[0] == "H":
            c += 1
            print(line)
    print("The no of lines starts with H is : ", c)
    f.close()

"""2) Write a method countlines_et() in python to read lines from a txt file and count which starts with E or T
and display the total count seperately """

def countlines_et():
    f = open("report.txt",'r')
    S = f.readlines()
    e = 0
    t = 0
    for line in S:
        if line[0] == "E":
            print(line)
            e += 1
        if line[0] == "T":
            print(line)
            t += 1

    print("The no of lines starts with E is : ", e)
    print("The no of lines starts with T is : ", t)
    f.close()

""" 3) Write a method show_todo() in python to read abc.txt and display lines which has 'TO' or 'DO' """

def show_todo():
    f = open("abc.txt",'r')
    S = f.readlines()
    for line in S:
        if "TO" in line or "DO" in line:
            print(line)
    f.close()

"""4) write a program to count the lines start with the word "the" in file "xyz.txt" """

def count_the():
    f = open("xyz.txt", 'r')
    S = f.readlines()
    c = 0
    for line in S:
        words = line.split()
        if len(words) > 0 and words[0].lower() == "the":
            c += 1
            print(line)
    print("The no of lines starting with 'the' is :", c)
    f.close()

"""5) write a python function to count total vowels in abc.txt"""

def count_vowels():
    f = open("abc.txt", 'r')
    S = f.readlines()
    v = "aeiouAEIOU"
    c = 0
    for line in S:
        for ch in line:
            if ch in v:
                c += 1
    print("Total vowels in abc.txt :", c)
    f.close()

"""6) write a program that extracts and displays all the words present in vocab.txt that begins with a vowel """

def show_vowel_words():
    f = open("vocab.txt", 'r')
    S = f.readlines()
    vowels = "AEIOUaeiou"
    for line in S:
        words = line.split()
        for w in words:
            if w[0] in vowels:
                print(w)
    f.close()

"""7) write a function that displays all the containing hyphen words present in  HyphenatedWords.txt which has 3 letters before 
hyphen and  4 letters after hyphen
"""

def show_hyphen_words():
    f = open("HyphenatedWords.txt", 'r')
    S = f.readlines()
    for line in S:
        words = line.split()
        for w in words:
            if "-" in w:
                p = w.split("-")
                if len(p) == 2 and len(p[0]) == 3 and len(p[1]) == 4:
                    print(w)
    f.close()

"""8) write a function that counts no of words beginning with a capital letter from RatanJi.txt
"""

def count_capital_words():
    f = open("RatanJi.txt", 'r')
    S = f.readlines()
    c = 0
    for line in S:
        words = line.split()
        for w in words:
            if w[0].isupper():
                c += 1
    print("Total capital letter words :", c)
    f.close()

"""10) Write a python function that displays all the words starting with 'C' in char.txt 
"""

def show_c_words():
    f = open("char.txt", 'r')
    S = f.readlines()
    for line in S:
        words = line.split()
        for w in words:
            if w.startswith("C"):
                print(w)
    f.close()

"""11) write a function that prints only numbers in info.txt
"""

def print_numbers():
    f = open("info.txt", 'r')
    S = f.readlines()
    for line in S:
        words = line.split()
        for w in words:
            if w.isdigit():
                print(w)
    f.close()
