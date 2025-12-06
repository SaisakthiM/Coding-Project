from errno import errorcode
from myconnection import connect_to_mysql
import mysql

class SQL:
    def __init__(self):
        config = {
        "host": "127.0.0.1",
        "user": "root",
        "password": "saisakthi@2008",
        "database": "saisakthi",
    }
        cnx = connect_to_mysql(config, attempts=3)
        cursor = cnx.cursor()
        self.cursor = cursor
        self.cnx = cnx
        
    def close(self):
        self.cursor.close()
        self.cnx.close()
        
    def create_database(self, db_name):
        try: 
            self.cursor.execute(F"CREATE DATABASE {db_name} DEFAULT CHARACTER SET 'utf8'")
            print("Database is successfully created!")
        except mysql.connector.Error as err:
            print("Failed creating database: {}".format(err))
            exit(1)
        
    def drop_database(self,db_name):
        try: 
            self.cursor.execute(F"DROP DATABASE {db_name}")
            print("Database is successfully dropped!")
        except mysql.connector.Error as err:
            print("Failed creating database: {}".format(err))
            exit(1)

    def use(self,DB_NAME):
        try:
            self.cursor.execute("USE {}".format(DB_NAME))
            print("Database is in use!")
        except mysql.connector.Error as err:
            print("Database {} does not exists.".format(DB_NAME))
            if err.errno == errorcode.ER_BAD_DB_ERROR:
                self.create_database(self.cursor)
                print("Database {} created successfully.".format(DB_NAME))
                self.cnx.database = DB_NAME
            else:
                print(err)
                exit(1)
        
    def create_table(self,tb_name,tb_values):
        values = ""
        for idx,val in enumerate(tb_values):
            values += f"{val[0]} {val[1]}({val[2]}),"
        values = values[:-1]
        try:
            self.cursor.execute(f"CREATE TABLE {tb_name}({values});")
            print(f"Successfully created table {tb_name}")
        except mysql.connector.Error as err:
            if err.errno == errorcode.ER_TABLE_EXISTS_ERROR:
                print("already exists.")
            else:
                    print(err.msg)
        
    def insert_values(self,tb_name,tb_values : list):
        values = ""
        for val in enumerate(tb_values):
            values += f"{val[0]},{val[1]},"
        values = values[:-1]
        self.cursor.execute(f"INSERT INTO {tb_name} VALUES({values});")









