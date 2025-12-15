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