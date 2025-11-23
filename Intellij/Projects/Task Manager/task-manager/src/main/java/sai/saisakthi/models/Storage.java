package sai.saisakthi.models;

import java.util.ArrayList;
public class Storage {
    static class Task {
        int id;
        String name;
        boolean complete;
        Task(int id, String name, boolean complete) {
            this.id = id;
            this.name = name;
            this.complete = complete;
        }
    }

    public static void main(String[] args) {
        ArrayList<ArrayList<Task>> task = new ArrayList<>();
        
        ArrayList<Task> task1 = new ArrayList<>();

        task1.add(new Task(1, "main", false));
        System.out.print(task1);
    }

}
