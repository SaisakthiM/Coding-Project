package com.sai.saisakthi;

public class Student {
    int marks;

    Student(int marks) {
        this.marks = marks;
        System.out.println("Student is created");
    }

    private Pen pen;
    int age;
    int rno;
    private Writer writer;

    public Student(int age, Writer writer, int rno) {
        this.age = age;
        this.writer = writer;
        this.rno = rno;
    }

    void show() {
        System.out.print("Hi i aPm a Student");
    }

    public void writeExam() {
        writer.write();
    }

    /**
     * @return Pen return the pen
     */
    public Pen getPen() {
        return pen;
    }

    /**
     * @param pen the pen to set
     */
    public void setPen(Pen pen) {
        this.pen = pen;
    }

    /**
     * @return Writer return the writer
     */
    public Writer getWriter() {
        return writer;
    }

    /**
     * @param writer the writer to set
     */
    public void setWriter(Writer writer) {
        this.writer = writer;
    }

}
