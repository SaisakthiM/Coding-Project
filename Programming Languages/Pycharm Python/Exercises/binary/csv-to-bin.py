import pickle
import csv

def read_bin():
    f = open("main.dat", 'rb')
    try: 
        while True:
            s = pickle.load(f)
            
            print(s)
    except EOFError:
        f.close()

def Create():
    f = open("PASSANGERS.DAT", 'wb')
    pnr = int(input("Enter the ID : "))
    pname = int(input("Enter the Name : "))
    brdstn = int(input("Enter the Boarding station name : "))
    destn = int(input("Enter the Destination : "))
    fare = int(input("Enter the Fare : "))
    l = [pnr, pname, brdstn, destn, fare]
    pickle.dump(l, f)
    f.close()

def Search_Destn(D):
    f = open("PASSANGERS.DAT", 'rb')
    try:
        while True:
            s = pickle.load(f)
            if s[3] == D:
                print(s)
    except EOFError:
        f.close()

def UpdateFare():
    f = open("PASSANGERS.DAT", 'rb')
    rec = []
    try:
        while True:
            s = pickle.load(f)
            rec.append(s)
    except EOFError:
        f.close()

    f1 = open("PASSANGERS.DAT", 'wb')
    for i in range(len(rec)):
        rec[i][4] += rec[i][4] * (5/100)
        

            



































