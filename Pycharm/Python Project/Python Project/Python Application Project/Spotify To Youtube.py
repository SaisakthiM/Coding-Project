class Node:
    def __init__(self,data,next):
        self.data = data
        self.next = next

class LinkedList:

    def __init__(self):
        self.head = None


    def insert_beginning(self,data):
        node = Node(data,self.head)
        self.head = node

    def insert_end(self,data):
        if self.head is None:
            self.head = Node(data,None)
        itr = self.head
        while itr.next:
            itr = itr.next

        itr = Node(data,None)


    def print(self):
        if self.head is None:
            print("It is Empty List")
        
            return

        itr = self.head
        llstr = ''
        while itr:
            llstr += str(itr.data) + '-->'
            itr = itr.next

        print(llstr)

    def append_list(self,list1 : list):
        self.head = None

        for data in list1:
            self.insert_end(data)


if __name__ == '__main__':
    Linked = LinkedList()
    Linked.append_list([1,2,4,5,6,8,9])
    Linked.print()































