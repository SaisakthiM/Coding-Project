package com.bankmanagement.bank_management.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bankmanagement.bank_management.database.Bank;
import com.bankmanagement.bank_management.dto.AccountRequest;
import com.bankmanagement.bank_management.dto.AccountResponse;
import com.bankmanagement.bank_management.repository.BankRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class BankService {
    
    private final BankRepository bankRepository;
    
    // Create new account
    @Transactional
    public AccountResponse createAccount(AccountRequest request) {
        // Check if account number already exists
        if (bankRepository.existsByAccountNumber(request.getAccountNumber())) {
            throw new IllegalArgumentException("Account number already exists");
        }
        
        Bank account = new Bank();
        account.setCustomerName(request.getCustomerName());
        account.setAccountNumber(request.getAccountNumber());
        account.setCreditScore(700); // Default credit score
        account.setBalance(0L);
        account.setCreatedAt(LocalDateTime.now());
        account.setUpdatedAt(LocalDateTime.now());
        
        Bank savedAccount = bankRepository.save(account);
        return mapToResponse(savedAccount);
    }
    
    // Get account by ID
    public AccountResponse getAccountById(Long id) {
        Bank account = bankRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Account not found with ID: " + id));
        return mapToResponse(account);
    }
    
    // Get all accounts
    public List<AccountResponse> getAllAccounts() {
        return bankRepository.findAll()
                .stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }
    
    // Deposit money
    @Transactional
    public AccountResponse deposit(Long accountId, Long amount) {
        if (amount <= 0) {
            throw new IllegalArgumentException("Deposit amount must be positive");
        }
        
        Bank account = bankRepository.findById(accountId)
                .orElseThrow(() -> new IllegalArgumentException("Account not found"));
        
        account.setBalance(account.getBalance() + amount);
        account.setUpdatedAt(LocalDateTime.now());
        
        Bank updatedAccount = bankRepository.save(account);
        return mapToResponse(updatedAccount);
    }
    
    // Withdraw money
    @Transactional
    public AccountResponse withdraw(Long accountId, Long amount) {
        if (amount <= 0) {
            throw new IllegalArgumentException("Withdrawal amount must be positive");
        }
        
        Bank account = bankRepository.findById(accountId)
                .orElseThrow(() -> new IllegalArgumentException("Account not found"));
        
        // Check for sufficient balance
        if (account.getBalance() < amount) {
            throw new IllegalArgumentException("Insufficient balance. Current balance: " + account.getBalance());
        }
        
        account.setBalance(account.getBalance() - amount);
        account.setUpdatedAt(LocalDateTime.now());
        
        Bank updatedAccount = bankRepository.save(account);
        return mapToResponse(updatedAccount);
    }
    
    // Helper method to convert Entity to DTO
    private AccountResponse mapToResponse(Bank account) {
        return new AccountResponse(
            account.getId(),
            account.getCustomerName(),
            account.getAccountNumber(),
            account.getBalance(),
            account.getCreditScore(),
            account.getCreatedAt(),
            account.getUpdatedAt()
        );
    }
}