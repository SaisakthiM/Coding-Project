package sai.saisakthi.models;

import java.util.Scanner;

public class Choice {
    int choice() {
        Scanner scanner = new Scanner(System.in);
        System.out.print("""
                You Choose to Continue. Now Choose Your Task : \n
                \n
                1) Add a Task \n
                2) View all Task \n
                3) Mark Task as complete \n
                4) Delete a task \n
        \n
                        Enter a Choice (1-4) : """);
        int res = scanner.nextInt();
        scanner.close();
        return res;
    }
}
