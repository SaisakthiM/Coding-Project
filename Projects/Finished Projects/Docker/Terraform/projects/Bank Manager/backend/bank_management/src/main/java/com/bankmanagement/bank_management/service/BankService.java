package com.bankmanagement.bank_management.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bankmanagement.bank_management.database.Bank;
import com.bankmanagement.bank_management.database.User;
import com.bankmanagement.bank_management.dto.AccountRequest;
import com.bankmanagement.bank_management.dto.AccountResponse;
import com.bankmanagement.bank_management.repository.BankRepository;
import com.bankmanagement.bank_management.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class BankService {
    
    @Autowired
    private final BankRepository bankRepository;

    @Autowired 
    private final UserRepository userRepository;

    
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

    @Transactional
    public AccountResponse loan(Long accountId, Long amount) {
        if (amount <= 0) {
            throw new IllegalArgumentException("Loan amount must be positive");
        }

        Bank account = bankRepository.findById(accountId)
                .orElseThrow(() -> new IllegalArgumentException("Account not found"));

        User user = userRepository.findByAccount_Id(accountId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        long creditScore = user.getCreditScore();

        // Check eligibility
        if (creditScore < 600) {
            throw new IllegalArgumentException("Credit score too low for a loan. Score: " + creditScore);
        }

        // Max loan based on credit score
        long maxLoan;
        if (creditScore >= 750) maxLoan = 500000L;
        else if (creditScore >= 700) maxLoan = 200000L;
        else maxLoan = 50000L;

        if (amount > maxLoan) {
            throw new IllegalArgumentException(
                "Loan amount exceeds limit for your credit score. Max: ₹" + maxLoan
            );
        }

        // Check existing unpaid loan
        if (account.getLoanBalance() > 0) {
            user.setCreditScore(creditScore - 15);
            userRepository.save(user);
            throw new IllegalArgumentException(
                "Existing loan unpaid. Repay ₹" + account.getLoanBalance() + " first. Credit score reduced."
            );
        }

        // Apply loan
        account.setBalance(account.getBalance() + amount);
        account.setLoanBalance(amount);
        account.setUpdatedAt(LocalDateTime.now());

        user.setCreditScore(creditScore - 5);
        userRepository.save(user);

        Bank updated = bankRepository.save(account);
        return mapToResponse(updated);
    }

    @Transactional
    public AccountResponse repay(Long accountId, Long amount) {
        if (amount <= 0) {
            throw new IllegalArgumentException("Repayment amount must be positive");
        }

        Bank account = bankRepository.findById(accountId)
                .orElseThrow(() -> new IllegalArgumentException("Account not found"));

        User user = userRepository.findByAccount_Id(accountId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        if (account.getLoanBalance() <= 0) {
            throw new IllegalArgumentException("No outstanding loan to repay");
        }

        if (account.getBalance() < amount) {
            // Insufficient balance — penalize credit score
            user.setCreditScore(user.getCreditScore() - 10);
            userRepository.save(user);
            throw new IllegalArgumentException(
                "Insufficient balance. Credit score reduced. Score: " + user.getCreditScore()
            );
        }

        account.setBalance(account.getBalance() - amount);
        long remaining = account.getLoanBalance() - amount;

        if (remaining <= 0) {
            // Loan fully cleared — bonus
            account.setLoanBalance(0L);
            user.setCreditScore(Math.min(850L, user.getCreditScore() + 20));
        } else {
            account.setLoanBalance(remaining);
            user.setCreditScore(Math.min(850L, user.getCreditScore() + 10));
        }

        account.setUpdatedAt(LocalDateTime.now());
        userRepository.save(user);

        Bank updated = bankRepository.save(account);
        return mapToResponse(updated);
    }
    
    // Helper method to convert Entity to DTO
    private AccountResponse mapToResponse(Bank account) {
        return new AccountResponse(
            account.getId(),
            account.getCustomerName(),
            account.getAccountNumber(),
            account.getBalance(),      
            account.getLoanBalance(),   
            account.getCreditScore(),
            account.getCreatedAt(),
            account.getUpdatedAt()
        );
    }
}