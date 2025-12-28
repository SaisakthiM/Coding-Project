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

now this works for a normal value
what if we need to set a object/reference to a provate variable
like this
private Pen pen;

public Pen getPen() {
        return pen;
    }

public void setPen(Pen pen) {
    this.pen = pen;
}

what about this 
you have to create a object for this and then 
use ref not value 
like this
<bean id="p1" class="com.sai.saisakthi.Pen"></bean>
 <bean id="class1" class="com.sai.saisakthi.Student">
       <constructor-arg value="95" />
       <property name="age" value="92"></property>
       <property name="pen" ref="p1"></property>
     </bean>
like this
here the object is created and then it is referenced to it like this
so for a reference/object type you have to use ref

also now take this function 
public void setPen(Pen pen) {
    this.pen = pen;
}
is it tightly coupled or loosely couples
it is indeed tight coupled right
that function is dependent on one class and object and if that one breaks
the function depending on that function breaks and so on

so will you accept a pencil to write a exam
yes i will if it is allowed

so how can we make this function loosely coupled so it does not depend on only pen
there comes abstraction and interface
what's that 
a abstraction or a interface is a class which tells what to do not how to do
confusing right here take a eg 
take a computer 
is all computer same
no there is AMD and also Intel 
there is also a factor that is it has a dedicated GPU or Intergrated
if dedicated who is that Nvidia or AMD or Intel

these are many factors that change 
but the fact that a computer has a CPU, RAM, Motherboard etc
this is abstraction
it is a structure class which tells what to follow not how to follow

and there is a difference between abstraction and interface

interface : it's like saying 
if you are a implementation of me "interface" you have to have these traits, 
i will not tell what to do with these traits/methods you figure that out but you have to use it 

abstract class : 
you can implement on your own intrests, i can say (non abstract properties) 
but you also have to obey / implement what i say sometimes (abstract properties)

and oh i forgot a important factor
they cannot be instanced with a object 
they are meant to be implemented and used 
not as a object  but as a structure to other classes

let's go to the pen one
who do you think is common between pen and a pencil 
both used to write and yeah 
A Writer class that's it it's a abstraction here
it's upon us on what we choose, an abstraction or a interface

so this process that we do 
like giving a reference for a variable which needs object
it is called wiring
what we did was manual wiring
how can we do a auto wiring 
it's automatic but we have to use autowire property
we can autowire in 2 types 
1) by name
2) by property


     <bean id="class1" class="com.sai.saisakthi.Student" autowire="byName">
       <constructor-arg value="95" />
       <property name="pen" ref="p1"></property>
       <!--<property name="writer" ref="p1"></property>-->
     </bean>
     <bean id="writer" class="com.sai.saisakthi.Pencil"></bean>

see, the autowire is done 
it just searches the name and if any id has writer (it should match the variable name), the framework autowires
you can also inject teh values using the byType but there is a catch 
you can't have more than 1 matching type else it thorows error
<bean id="class1" class="com.sai.saisakthi.Student" autowire="byType">
       <constructor-arg value="95" />
       <property name="pen" ref="p1"></property>
       <!--<property name="writer" ref="p1"></property>-->
     </bean>
     <bean id="class2" class="com.sai.saisakthi.Student">
       <constructor-arg value="95" />
     </bean>
     <bean class="com.sai.saisakthi.Teacher" ></bean>
     <bean id="p1" class="com.sai.saisakthi.Pen" primary="true"></bean>
     <bean id="writer" class="com.sai.saisakthi.Pencil"></bean>
here there is 3 so it throws error
so you can also set the primary one to tell java spring that prioritize this over others 
so you won't get these error 

now come to constructor injection now
we aldready touched that 
so it is nothing but injecting parameters into a constructor
there is also indexing in this which means if there is multiple parameter you can treat it like array and set it with index order like this
<bean id="class1" class="com.sai.saisakthi.Student" autowire="byType">
       <constructor-arg index="0" value="15" />
       <constructor-arg index="1" ref="writer"></constructor-arg>
       <constructor-arg index="2" value="92"></constructor-arg>

       <property name="pen" ref="p1"></property>
       
       <!--<property name="writer" ref="p1"></property>-->
     </bean>
see, this is how you can also do the indexing 

now we can also see how difficult it is to create these getters and setters
you have to create it for every single property 
like if you have 100 what can you do 
you cannot go and create 200 getters and setters
so there comes project lombok 
this is a package which can create getters and setters for you using annonation
annonation is java is important as we use it everywhere
so here 

package com.sai.saisakthi;
import lombok.Data;

@Data
public class Student {
    int age;
    int rno;
    private Writer writer;

    public Student(int age, Writer writer, int rno) {
        this.age = age;
        this.writer = writer;
        this.rno = rno;
    }

    public void writeExam() {
        writer.write();
    }

}

you can see there is there is no setters and getters and it still works


II) Class based COnfig in Spring Framework

now we can also use Classes as a config in Spring for it's work 
here's how
1) Create or use a previous class for congig like this

package com.java.sai.config;

import org.springframework.context.annotation.Configuration;

@Configuration
public class Config {
    
}

Note: You have to use that Annonation compulsory to tell spring that this is a config class
2) Use it in Application
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
		SpringApplication.run(SaiApplication.class, args);
	}

}

see we normally use XmlConfig now we use Annonation Config to use class 
Note: you cannot directly use class here 
you have to mention the class name with .class so framework can know it is a class and not an object
now there are 2 parts in Class based configuration like in XML based

1) The Beaned Classes : The Classes which are going to be beaned are the beaned classes
2) The Config Class : The Classes which we are going to use for config 

here is a example for both
1) Student Class : 
package com.java.sai;

public class Student {
    public Student() {
        System.out.println("Student is Created");
    }
    public void show() {
        System.out.println("this is a show method");
    }
}

2) The Config Class
package com.java.sai.config;
import com.java.sai.Student;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class Config {
    @Bean
    public Student student() {
        return new Student();
    }
}

3) The Main App 
package com.java.sai;
import com.java.sai.config.Config;  // ✅ correct import


import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

@SpringBootApplication
public class SaiApplication {

	public static void main(String[] args) {
		ApplicationContext context = new AnnotationConfigApplicationContext(Config.class);
		System.out.println("hello world");
		Student st = (Student) context.getBean("student");
		
	}

}

these are the main parts let's start with how it flows 
so first the application context goes into the class config 
it sees there the class and creates a bean for it 
then it goes into the app again and creates a object as the user requested
so also we have different configuration names actually for different classes
and we can set different names for each bean which will be created 
the default one will be the method name



this is Java based config 
everything is same except we do that in classes 
the below class can give you a idea of class based config

package com.java.sai.config;
import com.java.sai.Pen;
import com.java.sai.Pencil;
import com.java.sai.Student;
import com.java.sai.Writer;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Primary;


import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class Config {
    @Bean(name = "s1")
    public Student student(@Autowired Writer writer) {
        Student s1 = new Student();
        s1.setRno(10);
        s1.setWriter(writer);
        return s1;
    }
    @Bean(name = "writer")
    @Primary
    public Pen pen() {
        return new Pen();
    }
    @Bean(name = "writer1")
    public Pencil pencil() {
        return new Pencil();
    }
}

see concepts like autowiring is too there and also there is also another config
think if there is 2 primary 
in that case java throws error
so in that case we can use @Qualification for that


*/

/* 

Spring Boot and Advantages over spring framework:

1) The main advantage of Spring boot over spring framework is Convention over configuration 
this is the main advantage of spring boot 
Note : Spring boot is not a alternative to the spring, spring boot is built on top of the spring framework 

now we start to write spring boot 
what's it's main advantage over spring boot
we already talked about convention over configuration

so instead of manually typing out all the classes needed in java class or xml
we can do just use annotation
we have to discuss about what is annotation 
which is just a metadata about the class

so now for creating a bean (or object we say)
you can just use the annonation component
just that and spring boot manages rest 
hears like magic 

here is a example

@Component
public class Student {
    public void show() {
        System.out.println("this is student class");
    }
}

see just that and you got a bean right there
no config xml or class

now we can go to scope of classes
there is two
1) Singleton
2) Prototype

what's that 
in default if a bean is created in IoC container, we know it is only created once for each class
so in a case like this
Student student = (Student) context.getBean(Student.class);
		Student student1 = (Student) context.getBean(Student.class);

		student.age = 10;
		student.show();
		student1.show();
		System.out.print(student1.age);
here what we get is 10
even though we only setted the age for student 
not for student1
this concept is also we can call reference
yes the pointers and reference

this scope of object reference and access is called singeton 
now we go to prototype
this creates separate one
no it will not
just use a serperate original reference and will not use the modified ones


now we come to more important one which is dependency injection 
this is a very important concept as it is very frequently used in spring boot 
so now we can see what is dependency injection and how it works clearly 
so we know that a spring managed object is called bean 

we have actually seen what are the types of injection in the spring framework
so we have to just revise how all works together

there are 3 types of injection in spring boot
1) Dependency injection 
2) Setter injection
3) Constructor injection 
we have all seen these in spring framework itself
now we are also going to see how autowired is also used here
Note: Autowire is just another notation which automatically wires all the dependency needed for the object instance we create 

1) Field Injection :
it is just injecting field for the class needed by a component 
an eg will make it clear
 @Autowired
    private Pen pen;
    public void show() {
        System.out.println("this is student class");
    }
    public void writeExam() {
        pen.write();
    }
}

see we injected the field for the classes

2) Setter injection 
so when we use private keyword for encapsulation 
we cannot use normal autowired for field injection 
so we go to setter injection 
eg:
package com.springboot.saispring;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import lombok.Setter;

@Component("s1")
@Scope("prototype")
public class Student {
    int age;
    @Setter(onMethod_ = @Autowired)
    private Pen pen;
    
    public void show() {
        System.out.println("this is student class");
    }
    public void writeExam() {
        pen.write();
    }
}

here lombok creates all the needed setter and it injects
remember to use onMethod parameter wih autowired


*/


/*

Now we finally move on to API and REST
in java spring boot this is important as spring boot is used as a web framework actually 

i know what is API Application Programming Interface 
and more important thing the server is no need to be created
we can use tomcat   

there are also you need to know about layers of servers we are creating
Controller 
Service 
Repository 

so Spring boot can actually handle all of this and without any issue 
so we can start with controller and there is even a architecture fo that which is MVC or o
Model View Controller

this is a important one as it enables clients to interact with us easily 

so this is how we can write API for a hello world program, see
package com.api.saiapi;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloWorld {
    @GetMapping("/")
    public String hello() {
        return "Hello World";
    }
}
this is yes long if you compare to 
import express 
    
const app = express()
app.get("/", () => "Hello World")

this is the same thing in express actually 
see it is long buy the express is actually unopinitated and not frequently used in servers directly 
instead an framework built on top of it like say next js is used actually 

so this we move on to what is even a controller 
what is a controller actually mean 
a controller can listen to a request and send a response according to the page 
so here we can have multiple controllers in java
like HelloController and LoginController we created in here
package com.api.saiapi.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloWorld {
    @GetMapping("/")
    public String hello() {
        return "Hello World";
    }
    @GetMapping("aboutus/")
    public String about() {
        return "this is sai";

    }
}
package com.api.saiapi.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class LoginController {
    @GetMapping("/login")
    public String login() {
        return "Logged in ";
    }
}
this is the both HelloController and LoginController
these can redirect any request to anything 

so now another important thing to note here is that 
you cannot actually duplicate a path in both controller 
that is if you have a path in one controller and you again redeclare in another one 
it will not be accepted and will throw a error 
now we can also talk about other layers in a server now

there is service layer
the answer in the name itself
it is responsible for services 
for this the @Service is used and you can directly use that service by creating the object for it

then also if you want to communicate with a database now
you can use the repository layer which is responsible for communicating with the database 

these are the 3 layers in a server 
all these can be created in Java Spring Boot

Now we move on to CRUD operation 

CRUD - Get Post Put Delete

First Let us see about the Get and Post Part of the REST framework now

so now what we are working on now
we are working on with a data 
a data in java, we can represent it with classes
we call it models
this is what we will be using to design a schema for databases using ORM object relational mapper

the model is the blueprint or a schema for a data for a database or you can use it as a normal schema and use it normally 

here is a example 
Controller:
package com.crud.saicrud.controller;
import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.crud.saicrud.model.Student;
import com.crud.saicrud.service.StudentService;

@RestController
public class StudentController {
    @Autowired
    StudentService service;

    @GetMapping("student")
    public List<Student> getStudents() {
        return service.students_list();
    }

}
Service:
package com.crud.saicrud.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.stereotype.Service;

import com.crud.saicrud.model.Student;

@Service
public class StudentService {
    List<Student> students = new ArrayList<>(
        Arrays.asList(
            new Student(1, "sai", "AI"),
            new Student(2,"sai", "Ai")
        )
    );
    public List<Student> students_list() {
        return students;
    }
}
Model Student
package com.crud.saicrud.model;

import lombok.AllArgsConstructor;
import lombok.Data;


@Data
@AllArgsConstructor
public class Student {
    private int id;
    private String name;
    private String technology;
}

so the response to this call will be like 

HTTP/1.1 200 
Content-Type: application/json
Date: Sun, 28 Dec 2025 02:00:29 GMT
Connection: close
Content-Length: 81

[{"id":1,"name":"sai","technology":"AI"},{"id":2,"name":"sai","technology":"Ai"}]
the top ones are headers of the response it contains details like the protocol, version status code 
content type and date and connection status
(why connection status is given explicitely closed there is a reason, some connections also use the web socket which has a long time connection)

then the body 
see, the object is actually converted into JSON how
it is because of the module called the jackson 
this module works behind the scenes actually for converting the objects into a json


now here is the get put delete and post methods and services and how it works actually 

package com.crud.saicrud.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.stereotype.Service;

import com.crud.saicrud.model.Student;

@Service
public class StudentService {
    List<Student> students = new ArrayList<>(
        Arrays.asList(
            new Student(1, "sai", "AI"),
            new Student(2,"sai", "Ai")
        )
    );
    public List<Student> students_list() {
        return students;
    }
    public void createService(Student student) {
        students.add(student);
    }
    public void updateService(Student student, int rno) {
        for (int i = 0; i < students.size(); i++) {
            if (students.get(i).getId() == rno) {
                students.set(i, student); // replace
                break;
            }
        }   
    }
    public void deleteService(int rno) {
        for (int i = 0; i < students.size(); i++) {
            if (students.get(i).getId() == rno) {
                students.remove(students.get(i)); // remove
                break;
            }
        } 
    } 

    public Student getStudentService(int rno) {
        for (Student student : students) {
            if (student.getId() == rno) {
                return student;
            }
        }
        return null;
    }

}

this is the service actually which handles the business logic 
and here is the controller layer
package com.crud.saicrud.controller;
import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.crud.saicrud.model.Student;
import com.crud.saicrud.service.StudentService;

@RestController
@RequestMapping("/student")
public class StudentController {
    @Autowired
    StudentService service;

    @GetMapping("/")
    public List<Student> getStudents() {
        return service.students_list();
    }

    @GetMapping("{rno}")
    public Student getStudentbyRno(@PathVariable("rno") int rno){
        return service.getStudentService(rno);
    }

    @PostMapping("post/")
    public void createStudent(@RequestBody Student student) {
        service.createService(student);
    }   
    @PutMapping("put/{rno}")
    public void updateStudent(@RequestBody Student student, @PathVariable("rno") int rno) {
        service.updateService(student, rno);
    }
    @DeleteMapping("delete/{rno}")
    public void deleteStudent(@PathVariable("rno") int rno) {
        service.deleteService(rno);
    }

}

this is the controller layer here you have to know some things actually 
the path variable : that's a important guy 
it parses or interpolates the variable (or query parameter actually many say ) it's job is to 
actually 

 */




















/* 
Before we continue to like spring boot we have to know a bit of what is collections and how it is used in java actually now for a better learning of even the spring boot
Collection (Interface)
├── List (Interface)
│   ├── ArrayList (Class)
│   ├── Vector (Class)
│   │   └── Stack (Class)
│   └── LinkedList (Class)
├── Set (Interface)
│   ├── HashSet (Class)
│   ├── LinkedHashSet (Class)
│   └── SortedSet (Interface)
│       └── TreeSet (Class)
└── Queue (Interface)
    ├── PriorityQueue (Class)
    └── Deque (Interface)
        └── ArrayDeque (Class)

Map (Interface)
├── AbstractMap (Class)
│   ├── EnumMap (Class)
│   └── HashMap (Class)
└── SortedMap (Interface)
    └── NavigableMap (Interface)
        └── TreeMap (Class)

this is the collection list 
so we primarily use the List, Set and Queue mostly
in Maps we very often use HashMap and that's industry standard












*/
