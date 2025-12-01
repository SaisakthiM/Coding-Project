package com.sai.saisakthi;
import lombok.Data;

@Data
public class Student {
    int age;
    int rno;
    private Writer writer;

    public Student(int age, Writer writer, int rno) {
        this.age = age;
        this.writer = writer;
        this.rno = rno;
    }

    public void writeExam() {
        writer.write();
    }

}
