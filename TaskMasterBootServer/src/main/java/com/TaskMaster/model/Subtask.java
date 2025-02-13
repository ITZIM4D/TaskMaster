package com.TaskMaster.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonBackReference;

@Entity
@Table(name = "Subtasks")
public class Subtask {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int subtaskID;

    @ManyToOne
    @JoinColumn(name = "taskID", nullable = false)
    @JsonBackReference
    private Task task;

    @Column(name = "subtaskName", nullable = false)
    private String subtaskName;

    @Column(name = "taskStatus", nullable = false)
    private String taskStatus;

    @Column(name = "createdAt", nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "completedAt", nullable = true)
    private LocalDateTime completedAt;

    // Getters and Setters

    public int getSubtaskID(){return subtaskID;}

    public void setSubtaskID(int subtaskID){this.subtaskID = subtaskID;}

    public Task getTask(){return task;}

    public void setTask(Task task){this.task = task;}

    public String getSubtaskName(){return subtaskName;}

    public void setSubtaskName(String subtaskName){this.subtaskName = subtaskName;}

    public String getTaskStatus(){return taskStatus;}

    public void setTaskStatus(String taskStatus){this.taskStatus = taskStatus;}

    public LocalDateTime getCreatedAt(){return createdAt;}

    public void setCreatedAt(LocalDateTime createdAt){this.createdAt = createdAt;}

    public LocalDateTime getCompletedAt(){return completedAt;}

    public void setCompletedAt(LocalDateTime completedAt){this.completedAt = completedAt;}

    // TaskStatus enum
    public enum TaskStatus {
        IN_PROGRESS("In Progress"),
        COMPLETED("Completed");

        private final String value;

        TaskStatus(String value) {
            this.value = value;
        }

        public String getValue() {
            return value;
        }
    }

}