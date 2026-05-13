package com.generics.sai;

import com.sai.generics.Car;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;


@SpringBootApplication
public class SaiApplication extends Car {

	public static void main(String[] args) {
		SpringApplication.run(SaiApplication.class, args);
		Car int1 = new Car();
		HashMap<String, Integer> map = new HashMap<>(); // breakpoint

		map.put("apple", 1);
		map.put("banana", 2);
		map.put("cherry", 3);
		map.put("Aa", 1);      // breakpoint
		map.put("BB", 2);      // breakpoint — collision happens here!
        
	}

}
