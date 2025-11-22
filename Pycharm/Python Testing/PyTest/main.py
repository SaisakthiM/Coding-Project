def add(x,y):
    return x+y
def divide(dividend,divisor):
    if dividend == 0:
        raise ValueError ("Cannot be divided by 0")
    return divisor/dividend