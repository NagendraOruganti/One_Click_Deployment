package com.example.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ApiController {

    @GetMapping("/")
    public String root() {
        System.out.println("Root endpoint called");
        return "Hello from Java REST API behind ALB + ASG! V1";
    }

    @GetMapping("/health")
    public String health() {
        System.out.println("Health endpoint called");
        return "ok";
    }
}

