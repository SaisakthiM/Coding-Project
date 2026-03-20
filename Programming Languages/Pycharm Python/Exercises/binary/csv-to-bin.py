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
read_bin()


































