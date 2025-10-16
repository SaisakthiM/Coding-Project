import csv

def create_csv():
    f = open('data.csv', 'w', newline="")
    s = csv.writer(f)
    k = [1,2,3,4]
    l = ["name", "name1", "name2", "name3"]
    o = [k,l]
    s.writerows(o)
    f.close()


create_csv()P