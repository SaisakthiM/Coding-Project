package com.springboot.saispring;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Primary;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

@Component("writer")
@Primary
@Scope("prototype")
public class Student {
    private String name;

    @Autowired
    @Qualifier("pen")
    private Writer writer;

    public Student() {

    }

    public Student(String name, int age) {
        this.name = name;
        this.age = age;
    }
    int age;
    
    
    public void show() {
        System.out.println("this is student class");
    }
    public void writeExam() {
        writer.write();
    }
}
