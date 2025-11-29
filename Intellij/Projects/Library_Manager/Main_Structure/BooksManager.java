import java.util.ArrayList;
import java.util.Scanner;

class Book {
    String title;
    String author;
    String isbn;
    int year;
    String genre;

    Book(String title, String author, String isbn, int year, String genre){
        this.title = title;
        this.author = author;
        this.isbn = isbn;
        this.year = year;
        this.genre = genre;
    }
}

class Library {
    ArrayList<Book> library = new ArrayList<>();
    Scanner scanner;

    Library(Scanner scanner){
        this.scanner = scanner;
    }

    void addBook(){
        System.out.print("Enter The Title: ");
        String title = scanner.nextLine();
        System.out.print("Enter The Author Name: ");
        String author = scanner.nextLine();
        System.out.print("Enter The ISBN Number: ");
        String isbn = scanner.nextLine();
        System.out.print("Enter The Year Published: ");
        int year = scanner.nextInt();
        scanner.nextLine(); // consume leftover newline
        System.out.print("Enter The Genre of the Book: ");
        String genre = scanner.nextLine();

        library.add(new Book(title, author, isbn, year, genre));
        System.out.println("Book added successfully!\n");
    }

    void removeBook(){
        System.out.print("Enter The ISBN to remove: ");
        String isbnToRemove = scanner.nextLine();
        boolean removed = library.removeIf(book -> book.isbn.equals(isbnToRemove));
        if(removed) System.out.println("Book removed successfully!\n");
        else System.out.println("Book not found!\n");
    }

    void listAllBooks(){
        if(library.isEmpty()){
            System.out.println("Library is empty!\n");
            return;
        }
        for(Book book : library){
            System.out.printf(
                "Title: %s\nAuthor: %s\nISBN: %s\nYear: %d\nGenre: %s\n\n",
                book.title, book.author, book.isbn, book.year, book.genre
            );
        }
    }

    void searchBook(){
        System.out.print("Enter the Title to search: ");
        String titleToSearch = scanner.nextLine();
        boolean found = false;
        for(Book book : library){
            if(book.title.equalsIgnoreCase(titleToSearch)){
                System.out.printf(
                    "Title: %s\nAuthor: %s\nISBN: %s\nYear: %d\nGenre: %s\n\n",
                    book.title, book.author, book.isbn, book.year, book.genre
                );
                found = true;
            }
        }
        if(!found) System.out.println("Book not found!\n");
    }
}

public class BooksManager {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        Library library = new Library(scanner);

        boolean running = true;
        while(running){
            System.out.println("""
                ==== Library Menu ====
                1) Add Book
                2) Remove Book
                3) List All Books
                4) Search Book by Title
                5) Exit
                """);
            System.out.print("Choose an option: ");
            int choice = scanner.nextInt();
            scanner.nextLine(); // consume leftover newline

            switch(choice){
                case 1 -> library.addBook();
                case 2 -> library.removeBook();
                case 3 -> library.listAllBooks();
                case 4 -> library.searchBook();
                case 5 -> running = false;
                default -> System.out.println("Invalid option! Try again.\n");
            }
        }
        scanner.close();
        System.out.println("Goodbye!");
    }
}
