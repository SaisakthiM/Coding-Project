package com.saihibernate.saihibernate.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.saihibernate.saihibernate.model.Student;
import com.saihibernate.saihibernate.repository.StudentRepo;

@Service
public class StudentService {
    
    @Autowired
    StudentRepo repo;

    public List<Student> getAllStudents() {
        return repo.findAll();
    }

    public void postDetail(Student student) {
        repo.save(student);
    }
    
    public void putDetail(Student student) {
        repo.save(student);
    }
    public void deleteStudent(int id) {
        repo.deleteById(id);
    }

    public Student getDetailsbyRno(int rno) {
        return repo.getReferenceById(rno);
    }
    
}
