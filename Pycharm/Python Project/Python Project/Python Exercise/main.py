import random
class Set:
    def __init__(self,val):
        if val in self.values:
            raise ValueError("Value Already present in the set")
        else:
            self.values = [val]
        
    def removeElement(self,val):
        self.values.remove(val)

    
    def getRandom(self):
        arrLength = len(self.values)
        return random.choice(self.values)
    