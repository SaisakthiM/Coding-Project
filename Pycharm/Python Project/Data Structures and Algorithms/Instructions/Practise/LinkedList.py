from typing import Optional
from typing import List

class Node:
    def __init__(self, val: int, next: Optional['Node'] = None):
        self.val = val
        self.next = next
    def __str__(self):
        return str(self.val)
class LinkedList:
    def __init__(self):
        self.head = None

    def append(self, val):
        new_node = Node(val)
        if not self.head:
            self.head = new_node
            return
        cur = self.head
        while cur.next:
            cur = cur.next
        cur.next = new_node 

    def index(self, val):
        idx = 0
        cur = self.head
        while cur:
            if cur.val == val:
                return idx
            cur = cur.next
            idx += 1
        return -1

    def sum(self):
        total = 0
        cur = self.head
        while cur:
            total += cur.val
            cur = cur.next
        return total

    def _get_max(self):
        max_val = 0
        cur = self.head
        while cur:
            if cur.val > max_val:
                max_val = cur.val
            cur = cur.next
        return max_val

    def _get_length(self):
        count = 0
        cur = self.head
        while cur:
            count += 1
            cur = cur.next
        return count

    def display(self):
        cur = self.head
        while cur:
            print(cur.val, end=" -> ")
            cur = cur.next
        print("None")