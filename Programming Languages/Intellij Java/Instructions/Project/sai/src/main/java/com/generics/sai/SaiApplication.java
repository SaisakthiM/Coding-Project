package com.generics.sai;

import com.sai.generics.Car;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import java.util.ArrayList;
import java.util.List;


@SpringBootApplication
public class SaiApplication extends Car {

	public static void main(String[] args) {
		SpringApplication.run(SaiApplication.class, args);
		Car int1 = new Car();
		List<Integer> integers = new ArrayList<>();
		integers.add(1);
		integers.add(1);
		integers.add(1);
		System.out.println(int1.ToCar(integers));
	}

}
