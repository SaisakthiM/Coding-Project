package com.springboot.saispring;

import org.springframework.stereotype.Component;

@Component
public class Pencil implements Writer{
    @Override
    public void write(){
        System.out.println("writing using pencil");
    }
}