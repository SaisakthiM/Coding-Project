import pandas as pd

class HashMaps:
    def  __init__(self):
        self.max = 10
        self.arr = [[] for i in range(self.max)]

    def hash(self, key):
        h = 0
        for char in key:
            h += ord(char)

        return h % self.max

    def __getitem__(self, key):
        h = self.hash(key)
        for element in self.arr[h]:
            if element[0] == key:
                return element[1]

    def __setitem__(self,key, value):
        h = self.hash(key)
        found = False

        for idx , element in enumerate(self.arr[h]):
            if element[0] == key and len(element) == 2:
                self.arr[h][idx] = (key,value)
                found = True
                break

        if not found:
            self.arr[h].append((key,value))

    def __delitem__(self, key):
        h = self.hash(key)
        for index,kv in enumerate(self.arr[h]):
            if kv[0] == key:
                del self.arr[h][index]

j = open('/ResourceFiles/poem.txt')
print(j)











