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