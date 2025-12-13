package com.springboot.saispring;

import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import lombok.Data;

@Component("s1")
@Scope("prototype")
@Data
public class Student {
    int age;
    private Pen pen;
    public void show() {
        System.out.println("this is student class");
    }
}
