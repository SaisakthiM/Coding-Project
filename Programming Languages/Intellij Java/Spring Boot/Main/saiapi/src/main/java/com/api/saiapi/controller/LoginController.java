    package com.api.saiapi.controller;

    import org.springframework.web.bind.annotation.GetMapping;
    import org.springframework.web.bind.annotation.RestController;

    @RestController
    public class LoginController {
        @GetMapping("/login")
        public String login() {
            return "Logged in ";
        }
        @GetMapping("/ping")
        public String ping() {
            return "pong";
        }
    }