package com.sai;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.sai.sai.config.Config;

@SpringBootApplication
public class SaiApplication {

	public static void main(String[] args) {
		ApplicationContext context = new AnnotationConfigApplicationContext(Config.class);
		System.out.println("hello world");
		Student st = (Student) context.getBean("s1");
		st.writeExam();
		System.out.println(st.getRno());
	}

}
