package com.springboot.saispring;

import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Component;

@Component
@Primary
public class Pen implements Writer{
    @Override
    public void write() {
        System.out.println("Writing using Pen");
    }
}