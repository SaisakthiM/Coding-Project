package com.java.sai;

import java.io.ObjectInputFilter.Config;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

@SpringBootApplication
public class SaiApplication {

	public static void main(String[] args) {
		ApplicationContext context = new AnnotationConfigApplicationContext(Config.class);
		System.out.print("hello world");
		Student st = context.getBean(Student.class);
		SpringApplication.run(SaiApplication.class, args);
	}

}
