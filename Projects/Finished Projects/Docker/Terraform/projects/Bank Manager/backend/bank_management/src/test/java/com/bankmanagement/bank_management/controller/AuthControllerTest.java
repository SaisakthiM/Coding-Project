package com.bankmanagement.bank_management.controller;

import org.junit.jupiter.api.BeforeEach;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;


@EnableWebMvc
public class AuthControllerTest {

    @Autowired
    MockMvc mockMvc;

    @BeforeEach
    void setUp() {

    }
}