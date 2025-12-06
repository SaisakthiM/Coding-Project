class HashMaps:
    def  __init__(self):
        self.max = 10
        self.arr = [[] for i in range(self.max)]

    def hash(self, key):
        h = 0
        for char in key:
            h += ord(char)

        return h % self.max

    def __getitem__(self, item):
        h = self.hash(item)
        return self.arr[h]
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


t = HashMaps()
t['march 6'] = 19
t['march 6'] = 18
t['march 17'] = 10

print(t['march 6'])







