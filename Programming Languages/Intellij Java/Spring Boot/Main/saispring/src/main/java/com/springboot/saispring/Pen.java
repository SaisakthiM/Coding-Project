package com.springboot.saispring;

import org.springframework.stereotype.Component;

@Component

public class Pen implements Writer{
    @Override
    public void write() {
        System.out.println("Writing using Pen");
    }
}