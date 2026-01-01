import mysql.connector as mysql

# Connect to database
mycon = mysql.connect(
    host="127.0.0.1",
    user="wbhost",
    passwd="saisakthi@2008",
    database="employees"   # change if you used a different DB
)

mycur = mycon.cursor()

mycur.execute("select * from employee;")

datas = mycur.fetchall()
for data in datas:
    print(data)

# Commit changes
mycon.commit()

print("Records inserted successfully")

# Close connection
mycon.close()
