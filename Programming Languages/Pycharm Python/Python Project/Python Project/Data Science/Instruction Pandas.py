"""

Pandas Arithmetic Operations :

import pandas as pd

k = pd.DataFrame([2, 4, 6, 8, 10])
l = pd.DataFrame([1, 3, 5, 7, 9])
i = [k+l,k-l,k*l,k/l]
print(i)


Pandas Logical Operations :

import pandas as pd
ds1 = pd.Series([2, 4, 6, 8, 10])
ds2 = pd.Series([1, 3, 5, 7, 10])
print("Series1:")
print(ds1)
print("Series2:")
print(ds2)
print("Compare the elements of the said Series:")
print("Equals:")
print(ds1 == ds2)
print("Greater than:")
print(ds1 > ds2)
print("Less than:")
print(ds1 < ds2)


Converting Dict to DataFrmae:


import pandas as pd


o = {
    'a': 100,
    'b': 200,
    'c': 300,
    'd': 400,
    'e': 800}

k = pd.DataFrame(o,index=[o for o in range(len(o))])
print(k)

Converting array to DataFrame:

import numpy as np
import pandas as pd

j = np.array([x*2 for x in range(0,10)])
k = pd.DataFrame(j)
print(k)

converting series to DataFrame:

import pandas as pd
s1 = pd.Series(['100', '200', 'python', '300.12', '400'])
print("Original Data Series:")
print(s1)
print("Change the said data type to numeric:")
s2 = pd.to_numeric(s1, errors='coerce')
print(s2)



























"""