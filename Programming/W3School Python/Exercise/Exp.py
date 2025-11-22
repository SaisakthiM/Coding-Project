import os

def PythonConvert(list):
    return [x * 2 if x % 2 == 1 else int(x / 2) for x in list]


f = open(r"C:\Coding Project\Programming\W3School Python\Exercise\text.txt",'r') 

def beginA(file):
    lines = [line and print(line) for line in file.readlines() if line.startswith("A")]
    print(f"No of Lines Starts With A is : {len(lines)}")

def wordsA(file):
    file.seek(0); words = [print(word) or word for line in file for word in line.split() if word.startswith("A")]; print(f"No. of words that start with 'A': {len(words)}")




beginA(f)
print("")
wordsA(f)





