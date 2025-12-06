"""
# Modules:

# importing json : first type import and write the name of that file
#                : then create a object and type json.file(open("name of file.extention))

# eg : import json
#
# x = json.load(open("data.json"))
#
#
# print(x.get("Name"))


# import sys : this module provides access to some variables used or maintained by the interpreter and to function that interact strongly with interpreter
# import platform : this module provides various services that interact with host platform

# eg : import sys                   eg (platform) : import platform
# print("python version")                            print(platform.python_version())
# print(sys.version)
# print("version info")
# print(sys.version_info)

# math (pi) : it is used to print real value of pi instead of typing
# eg : from math import pi
# x = float(input("enter the radius"))
# area = pi*x**2
# print(area)

# import datatime : it is a module to work with date and time

# strftime : it is method to format the datatime object as a string with desired format

# eg : import datetime
# now = datetime.datetime.now()
# print(now)
# print(now.strftime("%Y-%m-%d %H-%M-%)

itertools : they are tools which can be used for [for loop]
they are many tools which can be used for [for loop]
some of them are product , permutation , combination , accumulate , groupby and infinite iterators

# Pandas Module :

[ ]
# CSV File to Pandas DataFrame

import pandas as pd
import numpy as np
from sklearn.datasets import load_diabetes

diabeties = load_diabetes

# Pandas Data Frame



[ ]
# Finding The Type Of Data

diabeties_df = pd.read_csv('/content/diabetes.csv')
type(diabeties_df)


[ ]
diabeties_df.head()


[ ]
print(len(diabeties_df.shape))
print(diabeties_df.shape)
2
(768, 9)
Loading an Excel File From Pandas DataFrame

Function : pd.read_excel('file path')


[ ]
excel = pd.read_excel('/content/Excel.xls')
print(excel.head)
<bound method NDFrame.head of       Unnamed: 0 First Name   Last Name  Gender        Country  Age  \
0              1      Dulce       Abril  Female  United States   32
1              2       Mara   Hashimoto  Female  Great Britain   25
2              3     Philip        Gent    Male         France   36
3              4   Kathleen      Hanner  Female  United States   25
4              5    Nereida     Magwood  Female  United States   58
...          ...        ...         ...     ...            ...  ...
4995        4996       Roma  Lafollette  Female  United States   34
4996        4997     Felisa        Cail  Female  United States   28
4997        4998   Demetria       Abbey  Female  United States   32
4998        4999     Jeromy        Danz    Male  United States   39
4999        5000   Rasheeda      Alkire  Female  United States   29

            Date    Id
0     15/10/2017  1562
1     16/08/2016  1582
2     21/05/2015  2587
3     15/10/2017  3549
4     16/08/2016  2468
...          ...   ...
4995  15/10/2017  2654
4996  16/08/2016  6525
4997  21/05/2015  3265
4998  15/10/2017  3265
4999  16/08/2016  6125

[5000 rows x 8 columns]>
Exporting Pandas DataFrame to CSV and Excel


[ ]
diabeties_dr = pd.read_csv('/content/diabetes.csv')
diabeties_excel = diabeties_dr.to_excel('Diabeties.xlsx')
Creating DaatFrame With Random Values


[ ]
np_random = pd.DataFrame(np.random.rand(20,10))

[ ]
np_random.head()


[ ]
np_random.shape
(20, 10)
Inspecting a DataFrame

[ ]
# Print Rows And Columns

diabeties_df.shape
(768, 9)

[ ]
# Print First 5 Rows and Columns Of DataFrame
diabeties_df.head()


[ ]
# Print Last 5 Rows and Columns Of DataFrame

diabeties_df.tail()


[ ]
# This Function Gives All Connon Info About DataFrame Such As
# 1) Rows and Columns
# 2) Data Type of Elements

diabeties_df.info()
<class 'pandas.core.frame.DataFrame'>
RangeIndex: 768 entries, 0 to 767
Data columns (total 9 columns):
 #   Column                    Non-Null Count  Dtype
---  ------                    --------------  -----
 0   Pregnancies               768 non-null    int64
 1   Glucose                   768 non-null    int64
 2   BloodPressure             768 non-null    int64
 3   SkinThickness             768 non-null    int64
 4   Insulin                   768 non-null    int64
 5   BMI                       768 non-null    float64
 6   DiabetesPedigreeFunction  768 non-null    float64
 7   Age                       768 non-null    int64
 8   Outcome                   768 non-null    int64
dtypes: float64(2), int64(7)
memory usage: 54.1 KB

[ ]
# Finding The Number Of Missing Values Inside The Dataframe
# To say , In Python , This Function used To Find None type Elements Inside a DataFrame

diabeties_df.isnull().sum()


[ ]
diabeties_df.count(1)


[ ]
# Counting The values Based On labels

diabeties_df.value_counts('Outcome')


[ ]
diabeties_df.value_counts('Age')


[ ]
# Group The Values based On Mean

diabeties_df.groupby('Outcome').median()


[ ]
diabeties_df.groupby('Age').mean()

Statistical Measure


[ ]
# Count Number Of Values
import pandas as pd

diabeties_df = pd.read_csv('/content/diabetes.csv')
diabeties_df.count()


[ ]
# Mean Value - Column Wise

diabeties_df.mean()


[ ]
# Median - Column Wise
diabeties_df.median()


[ ]
# Standarad Deviaton - Column Wise

diabeties_df.std()


[ ]
# Minimum Value

diabeties_df.min()


[ ]
# Maximum Value

diabeties_df.max()


[ ]
# All the Statistical Measure

diabeties_df.describe()

Manipulating a DataFrame

[ ]
# Adding a Column To a DataFrame
# target function is used

[ ]
# Remove a Row
# Syntax : filename.drop(index,axis)

import pandas as pd
import numpy as np
from sklearn.datasets import load_diabetes

diabeties = load_diabetes

# Pandas Data Frame

diabeties_df = pd.read_csv('/content/diabetes.csv')

diabeties_df.drop(2)




[ ]
# Remove a Column
# Syntax : filename.drop(column='Column name')
diabeties_df2 = diabeties_df.drop(columns='Pregnancies')
diabeties_df.drop(columns='Pregnancies')




[ ]
# Locate a Partiular column

diabeties_df.iloc[2]


[ ]
# Locating Specific Columns

diabeties_df.iloc[:0] # Top Column
print(diabeties_df.iloc[:,0])
print(diabeties_df.iloc[:,1])
print(diabeties_df.iloc[:,2])
print(diabeties_df.iloc[:,3])
0       6
1       1
2       8
3       1
4       0
       ..
763    10
764     2
765     5
766     1
767     1
Name: Pregnancies, Length: 768, dtype: int64
0      148
1       85
2      183
3       89
4      137
      ...
763    101
764    122
765    121
766    126
767     93
Name: Glucose, Length: 768, dtype: int64
0      72
1      66
2      64
3      66
4      40
       ..
763    76
764    70
765    72
766    60
767    70
Name: BloodPressure, Length: 768, dtype: int64
0      35
1      29
2       0
3      23
4      35
       ..
763    48
764    27
765    23
766     0
767    31
Name: SkinThickness, Length: 768, dtype: int64
Corealtion
1) Postive Coreation 2) Negative Corelated

Explanation

Take Any 2 Columns (In Diabeties DataFrame , We csn take B.P and Skin Thickness) Let Both Be xand y

if x ∝ y, It Is Positively Corelated if x ∝ 1/y , It is Negatively Corelated


[ ]
diabeties_df.corr()




"""
