package com.java.sai;
import lombok.Data;

@Data
public class Student {
    private int rno;
    private Writer writer;

    public Student() {
        System.out.println("Student is Created");
    }
    public void show() {
        System.out.println("this is a show method");
    }
    public void writeExam() {
        writer.write();
    }
}
