def factorial(f):
    def wrapper(*args,**kwargs):
        print("Started")
        f(*args,**kwargs)
        print("Ended")
    return wrapper

@factorial
def func2(x,i):
    print(x,i)

func2(5,"hi")