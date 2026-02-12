import csv
from enum import pickle_by_global_name
import pickle
import contextlib


def count_words():
    print("No of Vowels in the text file is", sum([1 for lines in open('words.txt', 'r').readlines() for words in lines for letter in words if letter.lower() in 'aeiou']))

def count_record():
    print("No of records in CSV file is : ", sum([1 for lines in csv.reader(open("customers-1000.csv", 'r', newline=""))])-1)

def csv_to_bin():
    with open('customers-1000.csv', 'r', newline="") as csvfile, open('customers.dat', 'wb') as bin: [None for row in csv.reader(csvfile) if pickle.dump(row, bin)]

def count_binary():
    with open('customers.dat', 'rb') as f, contextlib.suppress(EOFError, pickle.UnpicklingError):print("No of Lines in binary file is : ", sum(1 for _ in iter(lambda : pickle.load(f), None)))

count_binary()

