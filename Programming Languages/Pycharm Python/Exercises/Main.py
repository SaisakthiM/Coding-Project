def countH():
    f = open("words.txt", 'r')
    s = f.readlines()
    c = 0
    for lines in s:
        if lines.startswith('H'):
            print(s)
            c += 1 
    print("The no of lines starting with c is : ", c)
countH()
