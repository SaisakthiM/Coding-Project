class BinaryNode:
    def __init__(self, data):
        self.data = data
        self.left = None
        self.right = None

    def add_child(self, data):
        if data == self.data:
            return
        if data < self.data:
            if self.left:
                self.left.add_child(data)
            else:
                self.left = BinaryNode(data)
        else:
            if self.right:
                self.right.add_child(data)
            else:
                self.right = BinaryNode(data)

    def in_order_traversal(self):
        elements = []
        if self.left:
            elements += self.left.in_order_traversal()
        elements.append(self.data)
        if self.right:
            elements += self.right.in_order_traversal()
        return elements

    def pre_order_traversal(self):
        elements = [self.data]
        if self.left:
            elements += self.left.pre_order_traversal()
        if self.right:
            elements += self.right.pre_order_traversal()
        return elements

    def post_order_traversal(self):
        elements = []
        if self.left:
            elements += self.left.post_order_traversal()
        if self.right:
            elements += self.right.post_order_traversal()
        elements.append(self.data)
        return elements

    def search(self, val):
        if self.data == val:
            return True
        if val < self.data:
            return self.left.search(val) if self.left else False
        else:
            return self.right.search(val) if self.right else False

    def find_min(self):
        return self.data if self.left is None else self.left.find_min()

    def find_max(self):
        return self.data if self.right is None else self.right.find_max()

    def calculate_sum(self):
        total = self.data
        if self.left:
            total += self.left.calculate_sum()
        if self.right:
            total += self.right.calculate_sum()
        return total

    def delete(self, val):
        if val < self.data:
            if self.left:
                self.left = self.left.delete(val)
        elif val > self.data:
            if self.right:
                self.right = self.right.delete(val)
        else:
            if self.left is None and self.right is None:
                return None
            if self.left is None:
                return self.right
            if self.right is None:
                return self.left
            # Node with two children
            min_val = self.right.find_min()
            self.data = min_val
            self.right = self.right.delete(min_val)
        return self

    def delete_right(self, val):
        return self.delete(val)

    def delete_left(self, val):
        if val < self.data:
            if self.left:
                self.left = self.left.delete(val)
        elif val > self.data:
            if self.right:
                self.right = self.right.delete(val)
        else:
            if self.left is None and self.right is None:
                return None
            if self.left is None:
                return self.right
            if self.right is None:
                return self.left
            max_val = self.left.find_max()
            self.data = max_val
            self.left = self.left.delete(max_val)
        return self
    
    def level_tree(self):
        level_dict = dict()
        count = 0
        if self.left and self.right:
            count += 1
            level_dict.update({f'{count}' : self.left})
            level_dict.update({f'{count}' : self.right})


def build_tree(elements : list):
    root = BinaryNode(elements[0])
    for i in elements:
        root.add_child(i)
    return root



if __name__ == '__main__':
    numbers = [50,10,20,70,90,30,100]
    numbers_tree = build_tree(numbers)
    current = numbers_tree
    