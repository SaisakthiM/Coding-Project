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