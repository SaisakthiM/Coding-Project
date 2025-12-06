class Adidas:
    def __init__(self, name, price):
        self.price_list = [119.99, 449.99, 49.99, 999.99, 1199.99, 159.99, 99.99]
        self.shoe_list = ["Adidas Supernova Rise", "Adidas Adistar", "Adidas Adizero Adios Pro 3", "Adidas Ultraboost 24", "Adidas Ultraboost Lite", "Adidas Ultraboost 22", "Adidas Adizero Adios Pro 3"]
        k = min(self.price_list, key=lambda x:abs(x-price))
        index = self.price_list.index(k)
        
        self.name = self.shoe_list[index]
        self.price = self.price_list[index]
    
    def models(self):
        return f"{self.name} - ${self.price} Will be best-fitted for you"
