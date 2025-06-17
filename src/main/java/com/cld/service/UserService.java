package com.cld.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.cld.dao.UserDAO;
import com.cld.model.User;

public interface UserService {
    boolean register(User user);
    User login(String username, String password);
    User findByUsername(String username);
    List<User> findAllUsers();
    User findById(Long id);
    void updateUser(User user);
    void deleteUser(Long id);
    User getUserById(Long id);
    List<User> getAllUsers();
    List<User> getRecentUsers(int limit);
    long getTotalUsers();
    User findByEmail(String email);
    void saveUser(User user);
}