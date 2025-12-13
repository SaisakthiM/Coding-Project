package com.springboot.saispring;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import lombok.Setter;

@Component("s1")
@Scope("prototype")
public class Student {
    private String name;

    public Student(String name, int age) {
        this.name = name;
        this.age = age;
    }
    int age;
    @Setter(onMethod_ = @Autowired)
    private Pen pen;
    
    public void show() {
        System.out.println("this is student class");
    }
    public void writeExam() {
        pen.write();
    }
}
