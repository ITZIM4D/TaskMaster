package com.TaskMaster.model;

import jakarta.persistence.*;
import java.util.Set;

import com.fasterxml.jackson.annotation.JsonBackReference;

@Entity
@Table(name = "Users")
public class User {
    
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int userID;

    @Column(name = "username", nullable = false, unique = true)
    private String username;

    @Column(name = "passwordHash", nullable = false)
    private String passwordHash;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    @JsonBackReference
    private Set<Task> tasks;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private Set<Sentiment> sentiments;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private Set<Progress> progress;

    // Getters and setters
    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public Set<Task> getTasks() {
        return tasks;
    }

    public void setTasks(Set<Task> tasks) {
        this.tasks = tasks;
    }

    public Set<Sentiment> getSentiments() {
        return sentiments;
    }

    public void setSentiments(Set<Sentiment> sentiments) {
        this.sentiments = sentiments;
    }

    public Set<Progress> getProgress() {
        return progress;
    }

    public void setProgress(Set<Progress> progress) {
        this.progress = progress;
    }
}
