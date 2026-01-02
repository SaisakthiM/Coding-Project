package com.saihibernate.saihibernate.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.saihibernate.saihibernate.model.Student;
import com.saihibernate.saihibernate.service.StudentService;

@RestController
public class StudentController {
    @Autowired
    StudentService service;
    @GetMapping("/student")
    public List<Student> getStudent(){
        return service.getAllStudents();
    }
    @PostMapping("/student_post/")
    public String postStudent(@RequestBody Student student) {
        service.postDetail(student);
        return "Posted";
    }
    @PutMapping("/student_put/")
    public Student putStudent(@RequestBody Student student) {
        service.putDetail(student);
        return student;
    }
    @DeleteMapping("/student_delete/{rno}")
    public String deleteStudent(@PathVariable int rno) {
        service.deleteStudent(rno);
        return "Deleted";
    }
    @GetMapping("/student/{rno}")
    public Student getStudentbyRno(@PathVariable int rno) {
        return service.getDetailsbyRno(rno);
    }
}
