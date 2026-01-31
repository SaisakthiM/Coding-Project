def push():
    doc_id = int(input("Enter the id : "))
    doc_name = input("Enter the name : ")
    mobile = int(input("Enter the Mobile : "))
    special = input("Enter the specialization : ")
    if special == "ENT":
        stk.append([doc_id, doc_name, mobile, special])

def pop():
    return "Empty" if stk == [] else stk.pop()

def display():
    return "Empty" if stk == [] else [x for x in range(len(stk) -1 ,-1, -1)]

def peek():
    return "Empty" if stk == [] else stk[len(stk)-1]

stk = []
ch = 'y'

while ch == 'y':
    val = int(input("""
Performing Stakc Operation using List.
1) Push 
2) Pop
3) Peek
4) Display
Enter your choice : """))
    if val == 1:
        push()
    elif val == 2:
        print(pop())
    elif val == 3:
        val = display()
        if type(val) == str:
            print(val)
        else:
            [print(x) for x in val]
    elif val == 4:
         val = display()
        if type(val) == str:
            print(val)
        else:
            [print(x) for x in val]
