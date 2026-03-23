import csv

def read_data():
    f = open("main.csv", 'r', newline="")
    s = csv.reader(f)
    print(s)
    f.close()
read_data()