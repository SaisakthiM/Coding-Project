"""

Selection Sort Implementation
To implement the Selection Sort algorithm in a programming language, we need:

An array with values to sort.
An inner loop that goes through the array, finds the lowest value, and moves it to the front of the array. This loop must loop through one less value each time it runs.
An outer loop that controls how many times the inner loop must run. 
For an array with n values, this outer loop must run n-1 times.

We first iterate through the loop using index.
for i in range(len(k)):
Take a minimum index as i
min_index = i
Now we nested loop j which helps to skip the switched parts


"""

k = [64, 34, 25, 12, 22, 11, 90, 5]
for i in range(len(k)):
    min_index = i
    for j in range(i+1,len(k)):
        if k[j] < k[i]:
            min_index = j
    k[i], k[min_index] = k[min_index], k[i]
            
print(k)






