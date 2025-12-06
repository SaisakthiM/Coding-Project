"""

This code demonstrates the difference between stack and heap memory allocation in Python.

# Stack memory is used for static memory allocation, while heap memory is used for dynamic memory allocation.
# In Python, all variables are references to objects in memory, and the memory management is handled by Python's garbage collector.
# However, we can simulate stack and heap behavior using lists and dictionaries.

# Stack: LIFO (Last In First Out) structure
stack = []
stack.append(1)  # Push 1 onto the stack
stack.append(2)  # Push 2 onto the stack
stack.append(3)  # Push 3 onto the stack
stack.pop()  # Pop the top element (3) from the stack

This is stack 

Heap: Dynamic memory allocation
heap = {}
heap['a'] = 1  # Allocate memory for 'a' in the heap
heap['b'] = 2  # Allocate memory for 'b' in the heap
heap['c'] = 3  # Allocate memory for 'c' in the heap
del heap['b']  # Deallocate memory for 'b'

You can ask how this is helpful in memory allocation and how it works in Python.

Languages like C and C++, the code gets converted into machine code and the memory is allocated in stack and heap.

The Stacks stores temporary variables created by a function, 
while the heap stores global variables and data structures that are dynamically allocated.

When the code is Running, the stack is used to store the function calls and local variables,
After the function or variable is no longer needed, the stack memory removes it from the stack.

Heap stores the  Static variables and global variables,
which can be only accessed by the pointer or reference.
The heap memory is managed by the programmer, and it requires manual allocation and deallocation of memory.

But in modern day compilers, we use garbage collector to manage the heap memory.
# In Python, the garbage collector automatically manages memory allocation and deallocation,

"""