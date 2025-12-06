
# Python3 program to convert a list
# of integers into a single integer
def convert(list):

    res = sum(d * 10 ** i for i, d in enumerate(list[::-1]))

    return(res)

# Driver code
list = [1, 2, 3]
print(convert(list))





























