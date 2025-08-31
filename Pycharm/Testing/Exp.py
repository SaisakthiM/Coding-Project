def rectangle(l,b):
    for x in range(l):
        if x == 0 or x == l-1:
            print('*' * b)
        else:
            print('*' + ' ' * (b-2) + '*')
        

rectangle(10,5)
        
        
