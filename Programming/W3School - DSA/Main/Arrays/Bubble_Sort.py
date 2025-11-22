"""
Bubble Sort Implementation
To implement the Bubble Sort algorithm in a programming language, we need:

An array with values to sort.
An inner loop that goes through the array and swaps values if the first value is higher than the next value. 
This loop must loop through one less value each time it runs.
An outer loop that controls how many times the inner loop must run. For an array with n values,
this outer loop must run n-1 times.

How This works :
1) Let's take a array k = [64, 34, 25, 12, 22, 11, 90, 5]
2) we have to iterate through the loop with index.add()
for i in range(len(k)):
so we are starting with i = 0 
3) Do a nested for loop through the first loop.
for j in range(len(k)-(i+1)):
We have to subtract the length of loop with (i+1)
here i = 0 so len(k) - 1 = 7
now take j = 0, j+1 = 1
The Condition  is k[j] > k[j+1]: 64 > 34
Then we switch the values. else leave it as it is

This method is O(n ** 2)




"""

k = [64, 34, 25, 12, 22, 11, 90, 5]

for i in range(len(k)):
    for j in range(len(k)-(i+1)):
        if k[j] > k[j+1]:
            k[j], k[j+1] = k[j+1], k[j]

print(k)
