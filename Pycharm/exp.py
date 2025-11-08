class A:
    count = 0
    def __init__(self):
        A.count += 1

a1 = A()
a2 = A()
a1.count = 10
print(A.count, a2.count)
