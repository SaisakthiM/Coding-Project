"""
CSV
"""

import csv
import pickle
import os

class FileHandlingCS:

    # -------------------- Q1: CSV File – Student Details --------------------
    """
    1) Rohit, a student of class 12, is learning how to work with CSV files in Python. 
    During an assignment, he has been asked to create a CSV file named 'Student.csv' 
    that stores the roll number, name, class, and section of students. 
    Rohit needs to ensure the CSV file contains a header row and at least 5 student records. 
    Help him complete the Python code so that it creates the file correctly. 
    Once created, the file should allow easy reading and further processing of student data.
    """
    def q1_csv_student(self):
        fh = open("Student.csv", "w", newline="")
        stuwriter = csv.writer(fh)
        data = []
        header = ['ROLL_NO', 'NAME', 'CLASS', 'SECTION']
        data.append(header)
        for i in range(5):
            roll_no = int(input("Enter Roll Number : "))
            name = input("Enter Name : ")
            Class = input("Enter Class : ")
            section = input("Enter Section : ")
            rec = [roll_no, name, Class, section]
            data.append(rec)
        stuwriter.writerows(data)
        fh.close()
        print("Student.csv created successfully with 5 student records.")

    # -------------------- Q2: Binary File – Student Marks and Percentages --------------------
    """
    2) Amritya Seth is a young programmer who has recently started learning about binary files. 
    He has been tasked with creating a program to store student information in a binary file named 'STUDENT.DAT'. 
    Each student record should include roll number, name, and percentage marks out of 100. 
    Additionally, he needs to write a function that reads this file and displays the names and percentages 
    of only those students who have scored more than 75 percent. 
    The program should also calculate and display the average percentage of the entire class.
    """
    def q2_binary_student(self):
        def AddStudents():
            with open("STUDENT.DAT", "wb") as file:
                while True:
                    Rno = int(input("Enter Roll Number: "))
                    Name = input("Enter Name: ")
                    Percent = float(input("Enter Percentage: "))
                    L = [Rno, Name, Percent]
                    pickle.dump(L, file)
                    k = input("Do you want to add another student? (yes/no): ")
                    if k.lower() not in ["yes", "y"]:
                        break
        def GetStudents():
            Total = 0
            Countrec = 0
            Countabove75 = 0
            with open("STUDENT.DAT", "rb") as F:
                while True:
                    try:
                        R = pickle.load(F)
                        Countrec += 1
                        Total += R[2]
                        if R[2] > 75:
                            print(R[1], " has percentage =", R[2])
                            Countabove75 += 1
                    except EOFError:
                        break
            if Countabove75 == 0:
                print("No student has scored more than 75%.")
            if Countrec > 0:
                average = Total / Countrec
                print("Average percentage of the class =", average)
        AddStudents()
        GetStudents()

    # -------------------- Q3: Text File – Book Details with Filtering --------------------
    """
    3) Priya is learning file handling in Python. She has been asked to maintain a text file 'Books.txt' 
    containing details of books in a library. Each book record should have Book ID, Title, Author, and Price. 
    She wants to write a program that allows entering at least 5 books and then displays only those books 
    whose price is greater than 500. This will help the library staff quickly identify expensive books.
    """
    def q3_text_books(self):
        with open("Books.txt", "w") as f:
            for i in range(5):
                BookID = input("Enter Book ID: ")
                Title = input("Enter Title: ")
                Author = input("Enter Author: ")
                Price = float(input("Enter Price: "))
                record = f"{BookID},{Title},{Author},{Price}\n"
                f.write(record)
        print("\nBooks costing more than 500:")
        with open("Books.txt", "r") as f:
            for line in f:
                data = line.strip().split(",")
                if float(data[3]) > 500:
                    print(f"Book ID: {data[0]}, Title: {data[1]}, Author: {data[2]}, Price: {data[3]}")

    # -------------------- Q4: Binary File – Employee Salaries --------------------
    """
    4) Akash has been given a task by his manager to maintain employee salary records in a binary file. 
    Each record should contain Employee ID, Name, and Salary. 
    Akash needs to write two functions: 
    a) AddEmployee() to add employee details to the file. 
    b) DisplayHighSalary() to display details of employees earning more than 70,000 and to calculate 
    the average salary of all employees. 
    This program will help management identify high earners and track overall salary statistics.
    """
    def q4_binary_employees(self):
        def AddEmployee():
            with open("Employees.DAT", "wb") as f:
                while True:
                    EID = int(input("Enter Employee ID: "))
                    Name = input("Enter Name: ")
                    Salary = float(input("Enter Salary: "))
                    rec = [EID, Name, Salary]
                    pickle.dump(rec, f)
                    ch = input("Add another employee? (yes/no): ")
                    if ch.lower() not in ["yes", "y"]:
                        break
        def DisplayHighSalary():
            total = 0
            count = 0
            high_salary_count = 0
            with open("Employees.DAT", "rb") as f:
                while True:
                    try:
                        rec = pickle.load(f)
                        count += 1
                        total += rec[2]
                        if rec[2] > 70000:
                            print(f"{rec[1]} with Salary = {rec[2]}")
                            high_salary_count += 1
                    except EOFError:
                        break
            if high_salary_count == 0:
                print("No employee has salary above 70,000.")
            if count > 0:
                print("Average salary of all employees =", total/count)
        AddEmployee()
        DisplayHighSalary()

    # -------------------- Q5: CSV File – Movie Ratings --------------------
    """
    5) Sneha is asked to maintain a CSV file 'Movies.csv' containing Movie ID, Movie Name, Genre, and Rating. 
    She needs to write a program that allows the user to input at least 5 movies and their ratings. 
    After creating the CSV, the program should display only the movies with a rating greater than 8.0. 
    This will help users quickly identify high-rated movies.
    """
    def q5_csv_movies(self):
        with open("Movies.csv", "w", newline="") as f:
            writer = csv.writer(f)
            header = ["MovieID", "MovieName", "Genre", "Rating"]
            writer.writerow(header)
            for i in range(5):
                MID = input("Enter Movie ID: ")
                Name = input("Enter Movie Name: ")
                Genre = input("Enter Genre: ")
                Rating = float(input("Enter Rating: "))
                writer.writerow([MID, Name, Genre, Rating])
        print("\nMovies with rating greater than 8.0:")
        with open("Movies.csv", "r") as f:
            reader = csv.reader(f)
            next(reader)
            for row in reader:
                if float(row[3]) > 8.0:
                    print(f"Movie ID: {row[0]}, Name: {row[1]}, Genre: {row[2]}, Rating: {row[3]}")

    # -------------------- Q6: Text File – Employee Attendance --------------------
    """
    6) Ravi, the HR of a company, wants to maintain an attendance record in a text file 'Attendance.txt'. 
    Each record should contain Employee ID, Name, and Number of Days Present in a month. 
    Ravi wants to identify employees who have less than 20 days of attendance and display them for managerial review.
    """
    def q6_text_attendance(self):
        with open("Attendance.txt", "w") as f:
            for i in range(5):
                EID = input("Enter Employee ID: ")
                Name = input("Enter Name: ")
                Days = int(input("Enter Days Present: "))
                f.write(f"{EID},{Name},{Days}\n")
        print("\nEmployees with attendance less than 20 days:")
        with open("Attendance.txt", "r") as f:
            for line in f:
                data = line.strip().split(",")
                if int(data[2]) < 20:
                    print(f"Employee ID: {data[0]}, Name: {data[1]}, Days Present: {data[2]}")

    # -------------------- Q7: Binary File – Product Prices --------------------
    """
    7) Aman wants to maintain a binary file 'Products.DAT' that stores product information including 
    Product ID, Name, and Price. He wants a program that allows adding multiple products, 
    and then displays only products costing more than 1000 along with the average price of all products.
    """
    def q7_binary_products(self):
        def AddProducts():
            with open("Products.DAT", "wb") as f:
                while True:
                    PID = input("Enter Product ID: ")
                    Name = input("Enter Product Name: ")
                    Price = float(input("Enter Price: "))
                    pickle.dump([PID, Name, Price], f)
                    ch = input("Add another product? (yes/no): ")
                    if ch.lower() not in ["yes", "y"]:
                        break
        def DisplayExpensive():
            total = 0
            count = 0
            high_count = 0
            with open("Products.DAT", "rb") as f:
                while True:
                    try:
                        rec = pickle.load(f)
                        count += 1
                        total += rec[2]
                        if rec[2] > 1000:
                            print(f"{rec[1]} with Price = {rec[2]}")
                            high_count += 1
                    except EOFError:
                        break
            if high_count == 0:
                print("No product costs more than 1000.")
            if count > 0:
                print("Average price of all products =", total/count)
        AddProducts()
        DisplayExpensive()
    # -------------------- Q8: CSV File – Student Marks Above 90 --------------------
    """
    8) Neha is preparing a CSV file 'Marks.csv' to maintain the marks of students in a subject. 
    Each record should contain Student ID, Name, Subject, and Marks. 
    After entering at least 5 student records, she wants to display only those students who have scored 
    more than 90 marks, so that teachers can quickly identify top performers.
    """
    def q8_csv_marks(self):
        with open("Marks.csv", "w", newline="") as f:
            writer = csv.writer(f)
            header = ["StudentID", "Name", "Subject", "Marks"]
            writer.writerow(header)
            for i in range(5):
                SID = input("Enter Student ID: ")
                Name = input("Enter Name: ")
                Subject = input("Enter Subject: ")
                Marks = float(input("Enter Marks: "))
                writer.writerow([SID, Name, Subject, Marks])
        print("\nStudents with marks greater than 90:")
        with open("Marks.csv", "r") as f:
            reader = csv.reader(f)
            next(reader)
            for row in reader:
                if float(row[3]) > 90:
                    print(f"StudentID: {row[0]}, Name: {row[1]}, Subject: {row[2]}, Marks: {row[3]}")

    # -------------------- Q9: Text File – Experienced Teachers --------------------
    """
    9) Priyanka is responsible for maintaining teacher records in a school. 
    She wants to create a text file 'Teachers.txt' containing Teacher ID, Name, Subject, and Years of Experience. 
    After entering at least 5 teachers, she wants to display only those teachers who have more than 10 years 
    of experience, helping the principal identify senior staff members.
    """
    def q9_text_teachers(self):
        with open("Teachers.txt", "w") as f:
            for i in range(5):
                TID = input("Enter Teacher ID: ")
                Name = input("Enter Name: ")
                Subject = input("Enter Subject: ")
                Exp = int(input("Enter Experience in Years: "))
                f.write(f"{TID},{Name},{Subject},{Exp}\n")
        print("\nTeachers with experience greater than 10 years:")
        with open("Teachers.txt", "r") as f:
            for line in f:
                data = line.strip().split(",")
                if int(data[3]) > 10:
                    print(f"Teacher ID: {data[0]}, Name: {data[1]}, Subject: {data[2]}, Experience: {data[3]}")

    # -------------------- Q10: Binary File – Bank Account Balances --------------------
    """
    10) Raj is asked to maintain a binary file 'Bank.DAT' storing customer bank account details. 
    Each record should include Account Number, Customer Name, and Account Balance. 
    After adding at least 5 accounts, he wants to display accounts with balance less than 5000 
    and also calculate the average balance across all accounts. This helps the bank monitor low-balance accounts.
    """
    def q10_binary_bank(self):
        def AddAccounts():
            with open("Bank.DAT", "wb") as f:
                while True:
                    AccNo = input("Enter Account Number: ")
                    Name = input("Enter Name: ")
                    Balance = float(input("Enter Balance: "))
                    pickle.dump([AccNo, Name, Balance], f)
                    ch = input("Add another account? (yes/no): ")
                    if ch.lower() not in ["yes", "y"]:
                        break
        def DisplayLowBalance():
            total = 0
            count = 0
            low_count = 0
            with open("Bank.DAT", "rb") as f:
                while True:
                    try:
                        rec = pickle.load(f)
                        count += 1
                        total += rec[2]
                        if rec[2] < 5000:
                            print(f"{rec[1]} with Balance = {rec[2]}")
                            low_count += 1
                    except EOFError:
                        break
            if low_count == 0:
                print("No account has balance less than 5000.")
            if count > 0:
                print("Average balance =", total/count)
        AddAccounts()
        DisplayLowBalance()

    # -------------------- Q11: CSV File – Library Book Availability --------------------
    """
    11) A school library wants to maintain a CSV file 'Library.csv' containing Book ID, Title, Author, and Availability Status. 
    The librarian wants a program to enter at least 5 books and then display only those books which are currently available 
    for issuing. This will help students quickly identify books that can be borrowed.
    """
    def q11_csv_library(self):
        with open("Library.csv", "w", newline="") as f:
            writer = csv.writer(f)
            header = ["BookID", "Title", "Author", "Available"]
            writer.writerow(header)
            for i in range(5):
                BID = input("Enter Book ID: ")
                Title = input("Enter Title: ")
                Author = input("Enter Author: ")
                Available = input("Enter Availability (Yes/No): ")
                writer.writerow([BID, Title, Author, Available])
        print("\nBooks currently available:")
        with open("Library.csv", "r") as f:
            reader = csv.reader(f)
            next(reader)
            for row in reader:
                if row[3].strip().lower() == "yes":
                    print(f"BookID: {row[0]}, Title: {row[1]}, Author: {row[2]}")

    # -------------------- Q12: Text File – Inventory Alert --------------------
    """
    12) A store manager wants to maintain a text file 'Inventory.txt' storing Product ID, Product Name, Quantity in Stock, and Price. 
    The manager wants a program that displays only those products whose quantity is less than 10, so that reordering can be done promptly.
    """
    def q12_text_inventory(self):
        with open("Inventory.txt", "w") as f:
            for i in range(5):
                PID = input("Enter Product ID: ")
                Name = input("Enter Product Name: ")
                Quantity = int(input("Enter Quantity: "))
                Price = float(input("Enter Price: "))
                f.write(f"{PID},{Name},{Quantity},{Price}\n")
        print("\nProducts with low stock (less than 10):")
        with open("Inventory.txt", "r") as f:
            for line in f:
                data = line.strip().split(",")
                if int(data[2]) < 10:
                    print(f"Product ID: {data[0]}, Name: {data[1]}, Quantity: {data[2]}, Price: {data[3]}")

    # -------------------- Q13: Binary File – Exam Results --------------------
    """
    13) An exam coordinator wants to maintain student results in a binary file 'Results.DAT' storing Roll Number, Name, and Marks. 
    The program should allow adding multiple records and then display students who scored more than 80 marks along with the class average.
    """
    def q13_binary_results(self):
        def AddResults():
            with open("Results.DAT", "wb") as f:
                while True:
                    RollNo = input("Enter Roll Number: ")
                    Name = input("Enter Name: ")
                    Marks = float(input("Enter Marks: "))
                    pickle.dump([RollNo, Name, Marks], f)
                    ch = input("Add another record? (yes/no): ")
                    if ch.lower() not in ["yes", "y"]:
                        break
        def DisplayTopResults():
            total = 0
            count = 0
            top_count = 0
            with open("Results.DAT", "rb") as f:
                while True:
                    try:
                        rec = pickle.load(f)
                        count += 1
                        total += rec[2]
                        if rec[2] > 80:
                            print(f"{rec[1]} scored {rec[2]} marks")
                            top_count += 1
                    except EOFError:
                        break
            if top_count == 0:
                print("No student scored more than 80.")
            if count > 0:
                print("Class average marks =", total/count)
        AddResults()
        DisplayTopResults()

    # -------------------- Q14: CSV File – Course Enrollments --------------------
    """
    14) A training institute wants to maintain a CSV file 'Courses.csv' containing Course ID, Course Name, Instructor, and Number of Enrolled Students. 
    After entering at least 5 courses, the program should display courses where more than 50 students are enrolled, helping management identify popular courses.
    """
    def q14_csv_courses(self):
        with open("Courses.csv", "w", newline="") as f:
            writer = csv.writer(f)
            header = ["CourseID", "CourseName", "Instructor", "Enrolled"]
            writer.writerow(header)
            for i in range(5):
                CID = input("Enter Course ID: ")
                Name = input("Enter Course Name: ")
                Instructor = input("Enter Instructor Name: ")
                Enrolled = int(input("Enter Number of Enrolled Students: "))
                writer.writerow([CID, Name, Instructor, Enrolled])
        print("\nCourses with more than 50 students enrolled:")
        with open("Courses.csv", "r") as f:
            reader = csv.reader(f)
            next(reader)
            for row in reader:
                if int(row[3]) > 50:
                    print(f"CourseID: {row[0]}, Name: {row[1]}, Instructor: {row[2]}, Enrolled: {row[3]}")

    # -------------------- Q15: Binary File – Employee Performance --------------------
    """
    15) A company wants to maintain a binary file 'Performance.DAT' storing Employee ID, Name, and Performance Score. 
    The program should allow adding multiple employee records and then display employees with a score above 90, along with the average score of all employees. 
    This helps management reward top-performing employees.
    """
    def q15_binary_performance(self):
        def AddPerformance():
            with open("Performance.DAT", "wb") as f:
                while True:
                    EID = input("Enter Employee ID: ")
                    Name = input("Enter Name: ")
                    Score = float(input("Enter Performance Score: "))
                    pickle.dump([EID, Name, Score], f)
                    ch = input("Add another record? (yes/no): ")
                    if ch.lower() not in ["yes", "y"]:
                        break
        def DisplayTopPerformance():
            total = 0
            count = 0
            top_count = 0
            with open("Performance.DAT", "rb") as f:
                while True:
                    try:
                        rec = pickle.load(f)
                        count += 1
                        total += rec[2]
                        if rec[2] > 90:
                            print(f"{rec[1]} scored {rec[2]}")
                            top_count += 1
                    except EOFError:
                        break
            if top_count == 0:
                print("No employee scored above 90.")
            if count > 0:
                print("Average performance score =", total/count)
        AddPerformance()
        DisplayTopPerformance()
