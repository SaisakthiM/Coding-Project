package com.api.saiapi.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.api.saiapi.service.HelloService;

@RestController
public class HelloWorld {

    @Autowired
    HelloService service;
    @GetMapping("/")
    public String hello() {
        return "Hello World";
    }
}