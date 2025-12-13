package com.springboot.saispring;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;

@SpringBootApplication
public class SaispringApplication {

	public static void main(String[] args) {
		ApplicationContext context = SpringApplication.run(SaispringApplication.class, args);	
		Student student = (Student) context.getBean("s1");
		student.show();
		student.writeExam();
		
	}
}
