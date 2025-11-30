/*
Before we start out java spring boot one
we have to know about what is spring boot and how it works

ok let's start with spring framework 

SPRING FRAMEWORK
│
├── WEB
│     ├── Spring MVC
│     ├── REST Controllers
│     ├── ViewResolvers
│     └── DispatcherServlet
│
├── DATA
│     ├── Spring Data JPA
│     ├── Repositories (CRUD / JPA / Paging)
│     ├── Transaction Management
│     └── Entity Mapping (Hibernate)
│
├── AOP
│     ├── Aspect
│     ├── Advice (Before, After, Around)
│     ├── Pointcut
│     └── Proxy-based Interception
│
├── CORE
│     ├── IoC Container
│     ├── Dependency Injection
│     ├── ApplicationContext / BeanFactory
│     └── Bean Lifecycle
│
└── TEST
      ├── Spring Test Framework
      ├── MockMvc
      ├── @SpringBootTest
      └── Integration Testing



What's the use of java and spring boot : 
Java and spring is mostly used for building enterprise level application

SO what is even a Spring is 
it is a ecosystem of java which has all the tools and to build a application 
we can also say "so it is a set of tools used for building applications with java collectively named as spring"
one of the tools in spring is spring framework 

now what does spring and spring framework provide that java cannot
it is Dependency Injection (DI) and Inversion of Control (IoC)

what is dependency injection and IoC

IoC : it is like inverting the power to control to create objects (from humans creating manually to code/framework creating it)
DI : it is a method to achieve IoC, Instead of creating the dependency yourself, someone injects it into your class
we use the Annonations/Metadata for this purpose
the weird @ symbol you see everywhere in spring boot, it's metadata for spring to tell it how to run 

then another advantage is it can create loosely coupled applications 
what is loosely coupled application and tightly coupled application

take a application and services inside it
in a big application, there will he always a dependency on other services to complete it's task
but most of the times, that other service which is also dependent is also having a separate task ot finish
so if one service is down all other is also wil be down

that's where loosely coupled comes in, 
with asynchronous functions and dependency injection we can achieve it

Disadvantages of Spring and Spring framework and use of Spring Boot:
there is a disadvantage in spring framework which is manual configuration 
you have to configure from scratch everything you need 
but with spring boot and pre-configured with servers

what server is built in 
it's tomcat
which was a apache project and used Java EE which was under oracle and they donated it to eclipse 

then we can also build API's in minutes with java spring boot

there are 2 types of API's we can build
1) REST API's : GET,POST,PUT,DELETE
2) Spring Data JPA

You can also build standalone (less or zero configured) applications
these are advantages of spring boot

This is a introduction to spring boot

 */

/* 

IOC and DI in Spring and Spring Boot

There are actually 3 types of injections

1)Field injection
2) Getter and Setter injection
3) Object injection

Dependency injection is just a type of injection which inject all the dependency needed by a class

ok now we can show how a IoC looks like and where it is resided 
it is actually resided in JVM as a container 
we know what a container in VM right 
so now we can see what is IoC in detail 

                     ┌───────────────────────────────────────────────────────┐
                     │                      JVM                              │
                     │                                                       │
                     │   ┌───────────────────────────────────────────────┐   │
                     │   │                    HEAP                       │   │
                     │   │                                               │   │
                     │   │   ┌───────────────────────────────────────┐   │   │
                     │   │   │            Spring IoC Container       │   │   │
                     │   │   │     (ApplicationContext / BeanFactory)│   │   │
                     │   │   │                                       │   │   │
                     │   │   │   ┌────────────┐   ┌────────────┐     │   │   │
                     │   │   │   │   Bean 1    │  │   Bean 2    │     │   │   │
                     │   │   │   │ (@Service)  │  │(@Component) │     │   │   │
                     │   │   │   └──────┬──────┘  └──────┬──────┘     │   │   │
                     │   │   │          │                 │            │   │   │
                     │   │   │   ┌──────┴──────┐   ┌─────┴──────┐     │   │   │
                     │   │   │   │   Bean 3    │   │   Bean 4    │     │   │   │
                     │   │   │   │(@Repository)│   │(@Controller)│     │   │   │
                     │   │   │   └─────────────┘   └─────────────┘     │   │   │
                     │   │   │                                       │   │   │
                     │   │   └───────────────────────────────────────┘   │   │
                     │   │                                               │   │
                     │   └───────────────────────────────────────────────┘   │
                     │                                                       │
                     │   ┌───────────────────────────────────────────────┐   │
                     │   │              Execution Engine                 │   │
                     │   │  ├ Interpreter                                │   │
                     │   │  ├ JIT Compiler                               │   │
                     │   │  └ Garbage Collector                          │   │
                     │   └───────────────────────────────────────────────┘   │
                     └───────────────────────────────────────────────────────

can you see that 
that inside that's IoC container which creates and manages all the bean
what's a bean 
it's just a object we need to create
it is called a bean in this context 
so we can configure how this works and we can tell spring how to create 
what objects and how to create and manage it
we can configure those by xml files which is useful for these

now we move on how it actually works and flows
package com.sai.saisakthi;


import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;


import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class SaisakthiApplication {

	public static void main(String[] args) {
		ApplicationContext context = new ClassPathXmlApplicationContext("springconfig.xml");
		Student student = (Student) context.getBean("class2");
		student.show();
		
		SpringApplication.run(SaisakthiApplication.class, args);
	}

}

this is the application code now
so see that line context
now there it goes to resources/springcongig.xml

<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="
           http://www.springframework.org/schema/beans
           https://www.springframework.org/schema/beans/spring-beans.xsd">

    <!-- Define your beans here -->
     <bean id="class1" class="com.sai.saisakthi.Student"></bean>
     <bean id="class2" class="com.sai.saisakthi.Student"></bean>
     <bean class="com.sai.saisakthi.Teacher" ></bean>
</beans>

this is the xml logic 
here we can create and define how a object should be created 
here you can see 2 classes 
1) Student
package com.sai.saisakthi;

public class Student {
    Student() {
        System.out.println("Student is created");
    }
    void show() {
        System.out.print("Hi i am a Student");
    }
}
2) Teacher
package com.sai.saisakthi;

public class Teacher {
    public Teacher() {
        System.out.print("Hi I am a teacher");
    }
}

now it initializes this classes and creates a object in there and it calls the constructor

so this is how the java spring framework flow will go 
Note: There is also a edge case here too
what if we want to give a input and there is no empty constructor
it cannot compile 
so we can also give the arguments for the class in xml line this
<bean id="class1" class="com.sai.saisakthi.Student">
       <constructor-arg value="95" />
</bean>
     <bean id="class2" class="com.sai.saisakthi.Student">
       <constructor-arg value="95" />
</bean>
the constructor arg is useful and good for these

ok also sometimes you need to change these values inside the class as private (encapsulated)
but not just like that
you can edit a variable by using getters and setters
think of it like this
you have to at some point give control to edit variables like age etc
but why full control 
we can set some conditions to edit those 
there comes getters and setters 

what is getters : it get's the value we need to edit
how think of it like this
we told that private variable belongs to the class
so it also means it belongs to the functions inside the class
what if we give a variable inside a function and tell that function to edit the variable
technically it's ok and that's setter 
the function which get's the variable is getters

here is a eg : 
package com.sai.saisakthi;

public class Student {
    int marks;
    Student(int marks) {
        this.marks = marks;
        System.out.println("Student is created");
    }
    private int age;
    
    public void setAge(int age) {
        if (age < 0) {
            System.out.print("Age Cannot be negative");
        }
        else {
            this.age = age;
        }
    }

    public int getAge() {
        return age;
    }

    void show() {
        System.out.print("Hi i am a Student");
    }
}


like you cannot access or modify these variable normally 
so we use a loophole (you can call it like that) for editing or getting that variable

now how can we do the same in the xml 
we can use the <property> tag in xml with name and value like this
<property name="age" value="92"></property>
this will automatically call the function and get the value 
Note: If we change the name of the setter, it will not work and also there is no properties for getters in xml

so now what we did is for a primary datatype 
what about a reference datatype take this eg 



*/