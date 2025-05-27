package com.cld.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cld.dao.UserDAO;
import com.cld.model.User;

@Service
public class UserService {
    
    @Autowired
    private UserDAO userDAO;
    
    public boolean register(User user) {
        if (userDAO.existsByUsername(user.getUsername())) {
            return false;
        }
        userDAO.save(user);
        return true;
    }
    
    public User login(String username, String password) {
        return userDAO.findByUsernameAndPassword(username, password);
    }
    
    public User findByUsername(String username) {
        return userDAO.findByUsername(username);
    }
}