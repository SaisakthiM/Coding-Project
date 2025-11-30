package com.sai.saisakthi;


import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;


import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class SaisakthiApplication {

	public static void main(String[] args) {
		ApplicationContext context = new ClassPathXmlApplicationContext("springconfig.xml");
		Student student = (Student) context.getBean("class1");
		System.out.println();
		System.out.print(student.getAge());
		
		SpringApplication.run(SaisakthiApplication.class, args);
	}

}
