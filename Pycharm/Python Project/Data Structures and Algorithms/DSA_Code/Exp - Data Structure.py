from types import NoneType


class Node:
    def __init__(self, data, next):
        self.data = data
        self.next = next

class LinkedList:
    Node = Node()
    def __init__(self):
        self.head = None
        

    def insert_beginning(self,data):
        node = Node(data,None)
        self.head = node

    def print(self):
        if self.head is None:
            self.head = Node(self.data,None)

        itr = self.head
        while itr.next is not None:
            itr = itr.next

        itr.next = Node(self.data,None)





