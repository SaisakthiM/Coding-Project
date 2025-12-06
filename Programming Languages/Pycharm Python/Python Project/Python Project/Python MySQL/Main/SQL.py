import mysql.connector as mysql
import time
from mysql.connector import errorcode


class MySQL:
    def __init__(self, hostname, username, password):
        self.hostname = hostname
        self.username = username
        self.password = password
        self.connection = None
        self.cursor = None
        self.database = None

    def instructions(self):
        print("""
This Class simplifies using the mysql.connector module.
Features include:
    - Establishing a connection to MySQL
    - Creating or selecting databases
    - Creating tables with dynamic column definitions
    - Updating values (feature in progress)
    - Adding new columns to existing tables
    - Deleting a Database, Columns or a Table
Stay tuned for updates!
        """)
        time.sleep(1)

    def set_database(self, database):
        self.database = database
        print(f"Database set to '{database}'.")
        time.sleep(1)

    def start_connection(self):
        try:
            print("Attempting to connect to MySQL...")
            time.sleep(2)
            self.connection = mysql.connect(
                user=self.username,
                password=self.password,
                host=self.hostname
            )
            print("\nConnection was successful.\n")
        except mysql.Error as err:
            if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
                print("Invalid username or password.")
            elif err.errno == errorcode.ER_BAD_DB_ERROR:
                print("Database does not exist.")
            else:
                print(f"Connection error: {err}")
            time.sleep(1)

    def start_cursor(self):
        if self.connection:
            print("Initializing cursor...")
            time.sleep(1)
            self.cursor = self.connection.cursor()
            print("\nCursor initialized successfully.\n")
        else:
            print("Connection not established. Call start_connection() first.")
            time.sleep(1)

    def database_connection(self):
        if not self.cursor:
            print("Cursor not initialized. Call start_cursor() first.")
            time.sleep(1)
            return
        if not self.database:
            print("Database not set. Call set_database() first.")
            time.sleep(1)
            return
        try:
            print(f"Setting up the database '{self.database}'...")
            time.sleep(2)
            self.cursor.execute(f"CREATE DATABASE IF NOT EXISTS {self.database};")
            self.cursor.execute(f"USE {self.database};")
            print(f"\nUsing database: {self.database}\n")
        except mysql.Error as err:
            print(f"Database error: {err}")
            time.sleep(1)

    def create_table(self, tablename, columns):
        if not self.cursor:
            print("Cursor not initialized. Call start_cursor() first.")
            time.sleep(1)
            return
        if not isinstance(columns, list) or not all(
            len(col) in [2, 3] and (col[1].lower() == "date" or len(col) == 3) for col in columns
        ):
            print("Columns should be a list of [column_name, type, (optional size)] pairs. 'DATE' does not need a size.")
            time.sleep(1)
            return
        if not tablename.isalnum():
            print("Invalid table name. Use alphanumeric characters only.")
            time.sleep(1)
            return
        try:
            print(f"Creating table '{tablename}'...")
            time.sleep(2)
            self.cursor.execute(f"CREATE TABLE IF NOT EXISTS {tablename} (id INT PRIMARY KEY AUTO_INCREMENT);")

            for column in columns:
                column_name = column[0]
                col_type = column[1]
                if col_type.lower() == "date":
                    self.cursor.execute(f"ALTER TABLE {tablename} ADD COLUMN {column_name} {col_type};")
                elif len(column) == 3:
                    col_size = column[2]
                    if isinstance(col_size, int) and col_size > 0:
                        self.cursor.execute(f"ALTER TABLE {tablename} ADD COLUMN {column_name} {col_type}({col_size});")
                    else:
                        print(f"Invalid size for column '{column_name}'. Skipping...")
                print(f"Column '{column_name}' added successfully.")
            print(f"Table '{tablename}' created or updated successfully.\n")
        except mysql.Error as err:
            print(f"Error creating table: {err}")
            time.sleep(1)

    def add_columns(self, tablename, new_columns):
        if not self.cursor:
            print("Cursor not initialized. Call start_cursor() first.")
            return
        if not isinstance(new_columns, list) or not all(
            len(col) in [2, 3] for col in new_columns
        ):
            print("Columns should be a list of [column_name, type, (optional size)] pairs. 'DATE' does not need a size.")
            return
        try:
            print(f"Adding columns to table '{tablename}'...")
            for column in new_columns:
                column_name = column[0]
                col_type = column[1]
                # Handle `DATE` or other columns without size
                if col_type.lower() == "date":
                    self.cursor.execute(f"ALTER TABLE {tablename} ADD COLUMN {column_name} {col_type};")
                elif len(column) == 3:
                    col_size = column[2]
                    if isinstance(col_size, int) and col_size > 0:
                        self.cursor.execute(f"ALTER TABLE {tablename} ADD COLUMN {column_name} {col_type}({col_size});")
                    else:
                        print(f"Invalid size for column '{column_name}'. Skipping...")
                else:
                    print(f"Invalid column definition for '{column_name}'. Skipping...")
                print(f"Column '{column_name}' added successfully.")
        except mysql.Error as err:
            print(f"Error adding columns: {err}")

    def delete(self, type: str, value: str, table_name: str = ""):
        """
        Deletes a database, table, or column based on the type provided.
        :param type: Type of deletion ("Database", "Table", "Column").
        :param value: Name of the database, table, or column to delete.
        :param table_name: Required if type is "Column"; specifies the table containing the column.
        """
        if not self.cursor:
            print("Cursor not initialized. Call start_cursor() first.")
            return

        try:
            if type.lower() == "database":
                # Drop the database
                self.cursor.execute(f"DROP DATABASE IF EXISTS {value};")
                print(f"Database '{value}' deleted successfully.")

            elif type.lower() == "table":
                # Drop the table
                self.cursor.execute(f"DROP TABLE IF EXISTS {value};")
                print(f"Table '{value}' deleted successfully.")

            elif type.lower() == "column":
                # Drop a column from a table
                if not table_name:
                    print("Table name is required to delete a column.")
                    return

                self.cursor.execute(f"ALTER TABLE {table_name} DROP COLUMN {value};")
                print(f"Column '{value}' from table '{table_name}' deleted successfully.")

            else:
                print("Invalid type. Choose from 'Database', 'Table', or 'Column'.")
        except mysql.Error as err:
            print(f"Error while deleting {type.lower()}: {err}")
