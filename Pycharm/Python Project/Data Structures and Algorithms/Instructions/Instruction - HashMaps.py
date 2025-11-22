"""class HashTable:
    def __init__(self):
        self.MAX = 100
        self.arr = [None for i in range(self.MAX)]

    def get_hash(self,key):
        h = 0
        for char in key:
            h += ord(char)

        return h % self.MAX

    def add(self,key,value):
        h = self.get_hash(key)
        self.arr[h] = value

    def get(self,key):
        h = self.get_hash(item)
        return self.arr[h]
    def del_item(self,key):
        h = self.get_hash(key)
        self.arr.remove(self.arr[h])


    def __setitem__(self, key, value):
        h = self.get_hash(key)
        self.arr[h] = value

    def __getitem__(self, item):
        h = self.get_hash(item)
        return self.arr[h]
    def __delitem__(self, key):
        h = self.get_hash(key)
        self.arr[h] = None




t = HashTable()
t.add('march 6',250)
t.add('march 7',270)
t.add('march 8',290)
t['march 9'] = 100
del t['march 9']
print(t['march 9'])

this is HashMaps.

explanation on how it works :
it is simple

first user needs to assign a key which gets turned into hash values and stored in an list array

the hash function used here is get_hash which turns alphabets ad numbers int ascii codes and
remainder of 100 is takes

now the value is stored in the list array with respect to the hash function value

it can be either addded deleted or replaced


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


t = HashMaps()
t['march 6'] = 19
t['march 6'] = 18
t['march 17'] = 10

del t['march 6']

print(t.arr)

This is collision of hashmaps.
because the keys 'march 6' and 'march 17' has same hash value 9.
so instead of creating None , we create nested loops.
now we can set items in a tuple and access both by respective indexes
"""











