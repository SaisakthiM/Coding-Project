import random

class Sets:
    def __init__(self):
        self.sets = set()
    def insert(self,value):
        return self.sets.add(value)
    def remove(self,value):
        return self.sets.remove(value)
    def getRandom():
        random_index = random.randint(0,len(self.sets))
        return self.sets[random_index]
