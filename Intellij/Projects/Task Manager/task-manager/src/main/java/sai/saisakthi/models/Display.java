package sai.saisakthi.models;

import java.util.Scanner;

public class Display {
    String display() {
        Scanner scanner = new Scanner(System.in);
        System.out.print("""
                This is a Console Based Task Manager. Here You can : \n
                \n
                1) Add a Task \n
                2) View all Task \n
                3) Mark Task as complete \n
                4) Delete a task \n
        \n
                        Do You Wish To Continue (y/n) : """);
        String res = scanner.nextLine();
        scanner.close();
        return res;
    }
}
