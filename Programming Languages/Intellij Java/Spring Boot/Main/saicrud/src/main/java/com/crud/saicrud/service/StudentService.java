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
    public void createService(Student student) {
        students.add(student);
    }
    public void updateService(Student student, int rno) {
        for (int i = 0; i < students.size(); i++) {
            if (students.get(i).getId() == rno) {
                students.set(i, student); // replace
                break;
            }
        }   
    }
    public void deleteService(int rno) {
        for (int i = 0; i < students.size(); i++) {
            if (students.get(i).getId() == rno) {
                students.remove(students.get(i)); // remove
                break;
            }
        } 
    } 

    public Student getStudentService(int rno) {
        for (Student student : students) {
            if (student.getId() == rno) {
                return student;
            }
        }
        return null;
    }

}