package com.sai.config;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Primary;

import com.sai.Pen;
import com.sai.Pencil;
import com.sai.Student;
import com.sai.Writer;

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
