package com.sai.saisakthi;

public class Student {
    int marks;
    Student(int marks) {
        this.marks = marks;
        System.out.println("Student is created");
    }
    private int age;
    private String pen;


    void show() {
        System.out.print("Hi i am a Student");
    }

    /**
     * @param age the age to set
     */
    public void setAge(int age) {
        this.age = age;
    }

    /**
     * @return String return the pen
     */
    public String getPen() {
        return pen;
    }

    /**
     * @param pen the pen to set
     */
    public void setPen(String pen) {
        this.pen = pen;
    }


    /**
     * @return int return the age
     */
    public int getAge() {
        return age;
    }

}
