from dbm import error


class Node:
    def __init__(self, data=None, next=None):
        self.data = data
        "Here data is the real storage of the array"
        self.next = next
        "next is Just the memory address storage array"

"""We are basically creating a array where array size is n * 2 
because it stores memory address of previous value continuously.
Note : The First and Last element stores null because they have no address to store 
"""

class LinkedList:
    def __init__(self):
        self.head = None


    def insert_beginning(self, data):
        node = Node(data,self.head)
        self.head = node

    def insert_end(self, data):
        if self.head is None:
            self.head = Node(data, None)

        itr = self.head
        while itr.next:
            itr = itr.next

        itr.next = Node(data, None)



    def print_list(self,data):
        if self.head is None:
            print("linked list is empty")
            self.head = Node(data)
            return

        itr = self.head
        llstr = ''
        while itr:
            llstr += str(itr.data) + '-->'
            itr = itr.next

        print(llstr)

    def insert_data(self, data_list):
        self.head = None

        for data in data_list:
            self.insert_end(data)

    def get_length(self):
        count = 0
        itr = self.head
        while itr:
            count += 1
            itr = itr.next

        return count

    def remove_element(self,index):
        if index < 0 or index > self.get_length():
            raise Exception("Invalid Input")
        if index == 0:
            self.head = self.head.next
        if index > 0:
            count = 0
            itr = self.head
            while itr:
                if count == index - 1:
                    itr.next = itr.next.next
                itr = itr.next
                count += 1









if __name__ == '__main__':
    ll = LinkedList()
    ll.insert_end(54)
    ll.print_list()













































