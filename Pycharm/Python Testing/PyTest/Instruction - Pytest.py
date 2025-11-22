
"""
testing : it is a important process in python to check whether the code written output the desired result or not. to check it , Testing is used

Pytest : It is a module in python which is used for testing code

Unit testing : It is the process where testing is done to code in building stages.
the code is broken into small pieces (functions and classes) and each one of them is tested would they give their desired output

uses : it is easier ot do unit test than other methods because we can find error easily in which part the error occurred

eg :

main code :
def add(x,y):
    return x+y
def divide(dividend,divisor):
    if dividend == 0:
        raise ValueError ("Cannot be divided by 0")
    return divisor/dividend

test_main:
from main import add
from main import divide
import pytest

def test_add():
    assert add(1,3) == 4
    assert add(0,0) == 0
def test_divide():
    assert divide(1,2) == 2
    assert divide(-1,5) == -5
    with pytest.raises(ValueError,match="Cannot be divided by 0"):
        divide(0,10)    

"""
