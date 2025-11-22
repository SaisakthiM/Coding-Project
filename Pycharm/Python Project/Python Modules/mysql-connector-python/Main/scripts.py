from SQL import SQL

k = SQL()

db = "workers"
tb = "employee"

k.use(db)
k.insert_values(db,[["Hi",1010]])
