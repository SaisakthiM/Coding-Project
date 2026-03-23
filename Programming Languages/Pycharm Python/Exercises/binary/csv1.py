import csv

def read_data():
    f = open("main.csv", 'r', newline="")
    s = csv.reader(f)
    for l in list(s):
        print(l)

read_data()