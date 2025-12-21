package com.bankmanagement.bank_management.repository;

import com.bankmanagement.bank_management.database.Bank;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface BankRepository extends JpaRepository<Bank, Long> {
    
    // Custom query methods - Spring will implement these automatically
    Optional<Bank> findByAccountNumber(String accountNumber);
    
    boolean existsByAccountNumber(String accountNumber);
    
    // You automatically get these from JpaRepository:
    // - save(Bank account)
    // - findById(Long id)
    // - findAll()
    // - deleteById(Long id)
    // - count()
}