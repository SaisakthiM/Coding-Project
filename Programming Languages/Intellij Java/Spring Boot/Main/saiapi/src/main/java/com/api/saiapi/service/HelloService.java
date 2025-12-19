package com.api.saiapi.service;

import org.springframework.stereotype.Service;

@Service
public class HelloService {
    
    public String greet() {
        return "Hello";
    }
}