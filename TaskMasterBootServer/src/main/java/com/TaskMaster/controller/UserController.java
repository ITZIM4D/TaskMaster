package com.TaskMaster.controller;

import com.TaskMaster.model.User;
import com.TaskMaster.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.*;
import java.util.List;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserRepository userRepository;

    @GetMapping
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    @PostMapping
    public User createUser(@RequestBody User user){
        return userRepository.save(user);
    }

    @GetMapping("/{id}")
    public ResponseEntity<User> getUserByID(@PathVariable(value = "id") int userID){
        return userRepository.findById(userID)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping("/{id}/password")
    public ResponseEntity<User> updatePassword(
        @PathVariable(value = "id") int userID,
        @RequestBody PasswordUpdateRequest passwordRequest) {
        
        return userRepository.findById(userID)
            .map(user -> {
                user.setPasswordHash(passwordRequest.getPasswordHash());
                User updatedUser = userRepository.save(user);
                return ResponseEntity.ok(updatedUser);
            })
            .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Object> deleteUser(@PathVariable(value = "id") int userID){
        return userRepository.findById(userID)
            .map(user -> {
                userRepository.delete(user);
                return ResponseEntity.ok().build();
            }).orElse(ResponseEntity.notFound().build());
    }
}

class PasswordUpdateRequest {
    private String passwordHash;

    // Getter and setter
    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }
}
