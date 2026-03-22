S1 = {"AMIT": [92, 90, 90], "NAGMA": [77,100,100], "DAVID": [87,55,54]}

def showGrades(S):
    for k, v in S.items():
        avg = (v[0]+v[1]+v[2])/3
        if avg > 90:
            print(k, ": A")
        elif avg < 60:
            print(k, ": C")
        elif avg > 60 and avg < 90:
            print(k, ": B")
        

showGrades(S1)