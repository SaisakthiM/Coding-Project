package com.bankmanagement.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.bankmanagement.entity.Bank;

public interface BankRepository extends JpaRepository<Bank, Long> {
}
