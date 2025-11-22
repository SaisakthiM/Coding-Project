from collections import deque
class Stack:
    def __init__(self):
        self.stack = deque()
        self.rev = deque()
    def push(self,val):
        self.stack.append(val)
    def peek(self):
        return self.stack[-1]
    def pop(self):
        return self.stack.pop()
    def is_empty(self):
        return len(self.stack) == 0
    def rev(self,value):
        self.stack.append(value)
        for x in range(len(self.stack)):
            self.rev.append(self.stack.pop())

        return self.rev


obj = Stack()













































































































