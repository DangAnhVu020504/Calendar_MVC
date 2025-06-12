package com.cld.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
    
    public List<User> findAllUsers() {
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        return userDAO.getJdbcTemplate().query(sql, new UserDAO.UserRowMapper());
    }
    
    public User findById(Long id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        try {
            return userDAO.getJdbcTemplate().queryForObject(sql, new UserDAO.UserRowMapper(), id);
        } catch (Exception e) {
            return null;
        }
    }
    
    @Transactional
    public void updateUser(User user) {
        String sql = "UPDATE users SET username = ?, password = ?, email = ?, full_name = ? WHERE id = ?";
        userDAO.getJdbcTemplate().update(sql, user.getUsername(), user.getPassword(), 
                                       user.getEmail(), user.getFullName(), user.getId());
    }
    
    @Transactional
    public void deleteUser(Long id) {
        String sql = "DELETE FROM users WHERE id = ?";
        userDAO.getJdbcTemplate().update(sql, id);
    }
}