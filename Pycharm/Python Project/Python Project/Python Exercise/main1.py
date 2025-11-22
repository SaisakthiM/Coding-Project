import csv
f = open(r'C:\Coding Project\Pycharm\Python Project\Python Project\Python Exercise\college.csv', 'r',newline="")
s = csv.reader(f)
for x in s:
    print(x)
f.close()