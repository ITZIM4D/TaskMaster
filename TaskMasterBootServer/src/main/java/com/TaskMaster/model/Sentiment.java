package com.TaskMaster.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonBackReference;

@Entity
@Table(name = "Sentiments")
public class Sentiment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int sentimentID;

    @ManyToOne
    @JoinColumn(name = "userID", nullable = false)
    @JsonBackReference
    private User user;

    @Column(name = "mood", nullable = false)
    private String mood;

    @Column(name = "createdAt", nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    // Getters and Setters
    public int getSentimentID(){return sentimentID;}

    public void setSentimentID(int sentimentID){this.sentimentID = sentimentID;}

    public User getUser(){return user;}

    public void setUser(User user){this.user = user;}

    public String getMood(){return mood;}

    public void setMood(String mood){this.mood = mood;}

    public LocalDateTime getCreatedAt(){return createdAt;}

    public void setCreatedAt(LocalDateTime createdAt){this.createdAt = createdAt;}

}
