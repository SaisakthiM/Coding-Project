"""

What is a Algorithm :
It is a Step-by-Step process of solving a computational problem

What is a program :
It is a Step-by-Step process of solving a computational problem

Then what is the difference ?
There is two stages in Software Engineering 
One is Design Stage and other is Implementation stage
In Design stage, the software engineer actually sketches a raw image of how his app going to be
In Implementation stage, he is going to use syntax for it

Algorithm - Design Stage
Programs - Implementation Stage

Another factor is Domain Knowledge and Programmer
Again, here take we are building a Finance app. The client is a Accountant. So who knows the Accountant well 
The programmer or an accountant, obviously the accountant. 

Algorithm - Domain Knowledge
Programs - Programmer

With what languages we can use for both
Algorithms are nothing but pre-defined maths. so you can use any language
but for programs we can only use Machine Language like python or Java

So does Algorithm depends on Machine Specs :
No, It does not. Algorithms are mathematical steps so it does not
But Programs does.

Algorithm - Does not depend on MS
Programs - Changes depend on MS

For Algorithm, It is already tested and there is only need of analyze if that Algorithm is most efficient for this project
but for programs, they need testing before deploying

Algorithm - Analyze
Programs - Testing

Priori Analysis 
1- Algorithm
2.Independent of Language
3. Hardware Independent
4 Time & Space Function

Posteriori Testing 
1. Program
2. Language dependent
3. Hardware dependent
4 watch time & Bytes

Characteristics of Algorithm
1. Input - Should be 0 ro more
2. Output - Atleast 1 O/P
3. Definiteness
4. Finiteness
5. Effectiveness

------------------------------------------------------------------------------------------------------------------------------

How to write a Algorithm : 
Eg : Algorithm Swap(a,b)
Begin
    temp = a;
    a = b;
    b = temp;
End

This is how you can write a Algorithm. This code is called Pseudo-Code which looks like a program but it is not
Abdul Bari uses C Language so the Pseudo-Code looks like a C Language

------------------------------------------------------------------------------------------------------------------------------

How to Analyze a Algorithm : 
1) Time - The Algorithm you write should be efficient for the Program which is going to run
          When we say Tine in Algorithm, It is generally time function (X - No of Inputs : Y - Time Taken to process)
2) Space - The Algorithm also should be Memory efficient as we are creating a App for a various unknown devices
           So you have to use a Algorithm which uses memory as low as it can
           When we talk about space, It is actually Space-Function (X - Input Size : Y - Space Required to return Output (in Bytes))
3) N/W - If your Program is using Internet for collecting inputs, The Algorithm is also analyzed by 
         How much internet it consumed to return that output. This criteria is specific for cloud-services
         Again, It is a Network Function 
4) Power Consumption - This is generally related to how many computation is needed for processing a data
                       This might be confusing but I will explain
                       Take a algorithm which returns integer for your input.
                       If I input bin or a hash which is faster
                       Yes the bin because even if it takes the same space needed for a hash, it needs less power to process
5) CPU Registers - This is also secondary criteria and similar to like space function
                   but instead of ram space, it's CPU space

-------------------------------------------------------------------------------------------------------------------------------------------

this is a algorithm to find a sum of all elements in a array

Algorithm sum(arr,n)
Begin {
int sum = 0
for (int x = 0; x < n; x++){
    sum += x;
}
return sum;
} End
Note: Do you wonder why we did not iterate through array with index instead of using (int x : arr) because it is not supported

To find the time complexity of this, we will use frequency count method.
calculating time function : 
let's take the sum algorithm
count the initialization of variables as 1
also count return function as 1
so total is 2

now we take the for loop. remember, the function runs till the condition is false. so only the statement is n times.
the for loop itself is n+1 times

add all these : 1 + (n+1) + n +1 = 2n+3 
this is the time function and degree of 1 (degree means highest power of the variable inside it)
big O is only accounts with highest degree of time function so the Big O(n) is the worst-case scenario

Now we can calculate space-complexity. 
the variables are 1 and arrays are n (take even the for loop variable)
total space complexity : n+3
Big O(n) is the worst complexity here

------------------------------------------------------------------------------------------------------------------------------------

Time complexity :

take the algorithm (sum of a list) 
for (int x = 0; x < n; x++){ --> n+1
    statment --> n
}

This is a basic for loop for finding the sum
The for loop itself run in time (n+1) because remember, the loop only ends if condition is false
to get that condition false, the loop runs once again and then break the loop 

the statment itself runs for n times because the statment is not executed if condition is false
adding n + (n+1) you get 2n+1. by frequency count method, we can say that highest power of n is 1
so the time complexity is O(n)

now take a reverse indexing for loop 
for (int x = n; x > 0; x--) {
    statment
}
This also has the same time complexity as indexing O(n)

Now take a nested for loop
for (int i; i < n; i++) { --> n+1
    for (int j; j < i; j++) { --> n^2 or n * n
        statment 
    }
}

Frequency Count method : 































"""