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
