package com.cld.service;

import com.cld.model.User;
import java.util.List;

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