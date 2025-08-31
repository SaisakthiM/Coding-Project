"""

Usage of stacks :
                It is most commonly used in browsers ,
                which always records user browsing data (Aso Called History)
                and used to navigate to previous page visited
Operation :
        Push : In this data structure , the data is pushed like putting disk in disk holder
        Retrieve or Pop : When needed , it can retrieve the last given data (Just like pulling last CD when needed)
        This Data-Structure is called LIFO - (Last In First Out)

Programming Uses Of Stack :
                            Function calling in any programming language is managed using a stack
                            Undo (Ctrl+Z) functionality in any editor uses stack to track down last set of operations

Ways to use stacks:
    With Lists:
        * pop() : It is used to retrieve the last element and return the next last element is called twice and so on
        Note : It also removes the element after you accessed

        * u index [-1] : we can also use -1 index to access the element and also access the next last element by -2 and so on

Eg : s.append('https://www.cnn.com/')
s.append('https://www.cnn.com/world')
s.append('https://www.cnn.com/india')
s.append('https://www.cnn.com/china')

print(s.pop())
print(s[-1])

    With collections.deque :

from collections import deque

class Stack:
    def __init__(self):
        self.stack = deque()
    def push(self,val):
        self.stack.append(val)
    def peek(self):
        return self.stack[-1]
    def pop(self):
        return self.stack.pop()
    def is_empty(self):
        return len(self.stack) == 0

obj = Stack()
obj.push(45)
obj.push(55)
obj.push(65)
obj.push(75)
obj.push(85)
print(obj.pop())
print(obj.pop())













































































"""