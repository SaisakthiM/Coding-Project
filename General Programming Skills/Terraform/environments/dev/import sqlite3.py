import sqlite3

# create database
conn = sqlite3.connect("students.db")

# create cursor
cursor = conn.cursor()

# create table
cursor.execute("""
CREATE TABLE IF NOT EXISTS students(
    id INTEGER PRIMARY KEY,
    name TEXT,
    marks INTEGER
)
""")

# insert data
cursor.execute("INSERT INTO students (name, marks) VALUES ('Kaveyan', 95)")

conn.commit()

# read data
cursor.execute("SELECT * FROM students")
rows = cursor.fetchall()

for row in rows:
    print(row)

conn.close()