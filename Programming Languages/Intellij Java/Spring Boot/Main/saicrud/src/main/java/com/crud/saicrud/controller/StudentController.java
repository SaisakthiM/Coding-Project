package com.crud.saicrud.controller;
import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.crud.saicrud.model.Student;
import com.crud.saicrud.service.StudentService;

@RestController
@RequestMapping("/student")
public class StudentController {
    @Autowired
    StudentService service;

    @GetMapping("/")
    public List<Student> getStudents() {
        return service.students_list();
    }

    @GetMapping("{rno}")
    public Student getStudentbyRno(@PathVariable("rno") int rno){
        return service.getStudentService(rno);
    }

    @PostMapping("post/")
    public void createStudent(@RequestBody Student student) {
        service.createService(student);
    }   
    @PutMapping("put/{rno}")
    public void updateStudent(@RequestBody Student student, @PathVariable("rno") int rno) {
        service.updateService(student, rno);
    }
    @DeleteMapping("delete/{rno}")
    public void deleteStudent(@PathVariable("rno") int rno) {
        service.deleteService(rno);
    }

}