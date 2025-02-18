package com.TaskMaster.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "Feedback")
public class Feedback {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer feedbackID;

    @Column(name = "userID")
    private Integer userID;

    @Column(name = "taskID")
    private Integer taskID;

    @Column(name = "difficulty")
    private Integer difficulty;

    @Enumerated(EnumType.STRING)
    @Column(name = "timeAccuracy")
    private TimeAccuracy timeAccuracy;

    @Column(name = "challenges")
    private String challenges;

    @Column(name = "reccomendation")
    private String reccomendation;

    @Column(name = "createdAt", nullable = false, updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    // Enum for timeAccuracy
    public enum TimeAccuracy {
        Less,
        Expected,
        More
    }

    // Getters and setters
    public Integer getFeedbackID() {
        return feedbackID;
    }

    public void setFeedbackID(Integer feedbackID) {
        this.feedbackID = feedbackID;
    }

    public Integer getUserID() {
        return userID;
    }

    public void setUserID(Integer userID) {
        this.userID = userID;
    }

    public Integer getTaskID() {
        return taskID;
    }

    public void setTaskID(Integer taskID) {
        this.taskID = taskID;
    }

    public Integer getDifficulty() {
        return difficulty;
    }

    public void setDifficulty(Integer difficulty) {
        this.difficulty = difficulty;
    }

    public TimeAccuracy getTimeAccuracy() {
        return timeAccuracy;
    }

    public void setTimeAccuracy(TimeAccuracy timeAccuracy) {
        this.timeAccuracy = timeAccuracy;
    }

    public String getChallenges() {
        return challenges;
    }

    public void setChallenges(String challenges) {
        this.challenges = challenges;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getReccomendation() {
        return reccomendation;
    }

    public void setReccomendation(String reccomendation) {
        this.reccomendation = reccomendation;
    }
}