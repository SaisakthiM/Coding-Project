package com.saihibernate.saihibernate.service;

import java.util.List;
import java.util.ListResourceBundle;

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
    public void deleteall() {
        repo.deleteAll();
    }
    public List<Student> getByTech(String technology){
      return repo.findByTechnology(technology);
    }
    public List<Student> getByTechandGend(String gender, String technology) {
    return repo.findByTechnologyandgender(gender, technology);
  }   
}
