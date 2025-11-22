"""

Tree - It is a data structure which is used in arrangements of hierarchy based problem

eg : take a category electronic devices ,
we can take laptop, mobile, TV which all comes under electronic devices

now take laptop, there are hp and dell producing which comes under laptop
now take mobile , samsung and apple producing which comes under mobile
now take TV , samsung and OG producing which comes under TV

laptop , mobile and TV are branches of electronic devices

the companies are branches of further creating a tree

the top most branch or in this case electronic devices is called root node
the branches from root node in this case laptop , mobile and TV is called node
further from them is called leaf node

we can also call the top most branch as levels  starting with 0
there is no limit to tree branch and it can have n number of branches or levels

problem :


class TreeNode:
    def __init__(self,data):
        self.data = data
        self.children = []
        self.parent = None
    def add_child(self,child):
        child.parent = self
        self.children.append(child)
    def get_level(self):
        level = 0
        p = self.parent
        while p:
            level += 1
            p = p.parent
        return level
    def print_tree(self):
        prefix = " " * self.get_level() * 3 + "|__"if self.parent else ""
        print(prefix + self.data)
        if self.children:
            for child in self.children:
                child.print_tree()

def company():
    root = TreeNode("Nilumpul (CEO)")
    chinmay = TreeNode("Chinmay (CTO)")
    gels = TreeNode("Gels (HR Head)")

    vishwa = TreeNode("Vishwa (Infrastructure Head)")

    dhava = TreeNode("Dhaval (Cloud Manager)")
    abhi = TreeNode("Abhijit (App Manager)")

    aamir = TreeNode("Aamir (Application Head)")

    peter = TreeNode("Abhijit (Recruitment Manager)")
    waques = TreeNode("Abhijit (Policy Manager)")

    root.add_child(chinmay)
    root.add_child(gels)

    chinmay.add_child(vishwa)

    vishwa.add_child(dhava)
    vishwa.add_child(abhi)

    chinmay.add_child(aamir)

    gels.add_child(peter)
    gels.add_child(waques)

    return root

if __name__ == '__main__':
    roots = company()
    print(roots.print_tree())



"""