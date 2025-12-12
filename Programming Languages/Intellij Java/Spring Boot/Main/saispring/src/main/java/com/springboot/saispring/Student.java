package com.springboot.saispring;

import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

@Component("s1")
@Scope("prototype")
public class Student {
    int age;
    public void show() {
        System.out.println("this is student class");
    }
}
