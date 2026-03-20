import mysql.connector as mysql

def Delete_Theatre():
    mycon = mysql.connect(host="localhost", user="root", password="saisakthi2008", database="cinema")
    cur = mycon.cursor()
    th_id = input("Enter the id to delete : ")
    cur.execute(f"delete from cinema where th_id='{th_id}';")
    mycon.commit()
    mycon.close()
Delete_Theatre()