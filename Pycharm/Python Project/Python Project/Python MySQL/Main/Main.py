import mysql.connector
from mysql.connector import errorcode
from SQL import MySQL

class Test:
    def __init__(self):
        try:
            cnx = mysql.connector.connect(user='root',password='saisakthi@2008',
                                        host='127.0.0.1')
            self.cursor = cnx.cursor()
            print("Connection Was Successful")
        except mysql.connector.Error as err:
            if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
                print("Something is wrong with your user name or password")
            elif err.errno == errorcode.ER_BAD_DB_ERROR:
                print("Database does not exist")
            else:
                print(err)

    def columns(self):
        k = int(input("Enter no of columns you want : "))
        index = 0
        name = input("Enter Table Name : ") 
        
        while index != k:
            column = input("Enter Column Name : ")
            type = input("Enter Column Type : ")
            size = input("Enter Column Size (If it is not Date) : ")
            if index == 0:
                self.cursor.execute(f"""CREATE TABLE IF NOT EXISTS {name}({column} {type}({size}));""")
                print("")
                print("Table added Successfully!")
                print("")
            else:
                self.cursor.execute(f"""ALTER TABLE {name} ADD {column} {type}({size});""")
                print("")
                print("Column Added Successfully!")
                print("")
            
            

            index += 1
    def values(self):
        k = int(input("Enter the amount of values to insert : "))
        index = 0
        while index != k:
            name = input("Enter Table Name Again : ")
            values = input("""Enter the values in the order and
                        type you gave in with commas eg-(101,"hi", 19,33) : """)
            self.cursor.execute(f"""INSERT INTO {name} VALUES{values};""")
            index += 1
            print("")
            print("Values Added Successfully!")
            print("")
    def double_table(self):
        table1 = input("Enter Table 1 : ")
        table2 = input("Enter Table 2 : ")

        self.cursor.execute(f"""SELECT * FROM {table1},{table2};""")
        print(self.cursor.fetchall())



def SQL(): 
    db = MySQL("localhost", "root", "saisakthi@2008")
    db.instructions()
    db.set_database("test_db")
    db.start_connection()
    db.start_cursor()
    db.database_connection()
    db.create_table("product1", [["name", "varchar",20], ["email", "varchar",30]])
    db.add_columns("product1", [["age", "int",20], ["is_active", "BOOLEAN"],["manufacturer_date","date"]])

def test():
    # Initialize the MySQL class
    db = MySQL("localhost", "root", "saisakthi@2008")

    # Show instructions
    db.instructions()

    # Set a new database name
    db.set_database("inventory_db")

    # Start connection
    db.start_connection()

    # Initialize cursor
    db.start_cursor()

    # Connect to or create the database
    db.database_connection()

    # Create a new table
    print("Creating a new table 'products'...")
    db.create_table(
        "products",
        [
            ["product_name", "varchar", 50],
            ["price", "decimal", 10],  # Decimal for price with precision
            ["quantity", "int", 5]    # Integer for quantity
        ]
    )

    # Add new columns to the table
    print("Adding new columns to 'products'...")
    db.add_columns(
        "products",
        [
            ["manufacturer", "varchar", 30],  # Manufacturer name
            ["in_stock", "BOOLEAN"],          # Boolean for stock availability
            ["added_on", "date"]              # Date column for when the product was added
        ]
    )
    

    db.delete("Column", "price", table_name="products")

test()
    


