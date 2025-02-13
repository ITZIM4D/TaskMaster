package com.TaskMaster.model;

import com.fasterxml.jackson.annotation.JsonBackReference;

import jakarta.persistence.*;

@Entity
@Table(name = "Progress")
public class Progress {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int progressID;

    @ManyToOne
    @JoinColumn(name = "userID", nullable = false)
    @JsonBackReference
    private User user;

    @Column(name = "completedTasks", nullable = false)
    private int completedTasks;

    @Column(name = "pendingTasks", nullable = false)
    private int pendingTasks;

    // Getters and Setters
    public int getProgressID(){return progressID;}

    public void setProgressID(int progressID){this.progressID = progressID;}

    public User getUser(){return user;}

    public void setUser(User user){this.user = user;}

    public int getCompletedTasks(){return completedTasks;}

    public void setCompletedTasks(int completedTasks){this.completedTasks = completedTasks;}

    public int getPendingTasks(){return pendingTasks;}

    public void setPendingTasks(int pendingTasks){this.pendingTasks = pendingTasks;}
}
