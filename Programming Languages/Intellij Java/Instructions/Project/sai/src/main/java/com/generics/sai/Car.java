package com.generics.sai;
import java.util.ArrayList;
import java.util.List;


public class Car {
    public static <T> List<T> ToCar(T...list) {
        List<T> list1 = new ArrayList<>();
        for (T i : list)  list1.add(i);
        return list1;
    };
}
