package com.saihibernate.saihibernate.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.saihibernate.saihibernate.model.Student;
import java.util.List;
import com.saihibernate.saihibernate.model.Student;

@Repository 
public interface StudentRepo extends JpaRepository<Student, Integer> {
    List<Student> findByTechnology(String Technology);
    @Query(value = "select * from student where gender = :gender and technology = :technology; ", nativeQuery = true)
    List<Student> findByTechnologyandgender(@Param("gender") String gender, @Param("technology") String technology);
}
