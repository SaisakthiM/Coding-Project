package com.sai;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public class Others {
    public static void main(String[] args) {
        List<String> color = new ArrayList<>();
        color.add("blue");
        color.add("red");
        color.add("green");
        color.add("white");
        System.out.println(color);
        color.addFirst("new color");
    }
}
