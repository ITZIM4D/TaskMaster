package com.TaskMaster.model;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Set;

@Entity
@Table(name = "Tasks")
public class Task {
    
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long taskID;

    @ManyToOne
    @JoinColumn(name = "userID", nullable = false)
    //@JsonManagedReference
    private User user;

    @Column(name = "taskName", nullable = false)
    private String taskName;

    // @JsonFormat(pattern = "yyyy-MM-dd")
    @Column(name = "taskDeadline", nullable = false)
    private LocalDate taskDeadline;

    @Column(name = "taskStatus", nullable = false)
    private String taskStatus;

    @Column(name = "createdAt", nullable = false, updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "completedAt")
    private LocalDateTime completedAt;

    @OneToMany(mappedBy = "task", cascade = CascadeType.ALL)
    private Set<Subtask> subtasks;

    // Getters and setters
    public Long getTaskID(){return taskID;}

    public void setTaskID(Long taskID){this.taskID = taskID;}

    public User getUser(){return user;}

    public void setUser(User user){this.user = user;}

    public String getTaskName(){return taskName;}

    public void setTaskName(String taskName){this.taskName = taskName;}

    public LocalDate getTaskDeadline(){return taskDeadline;}

    public void setTaskDeadline(LocalDate taskDeadline){this.taskDeadline = taskDeadline;}

    public String getTaskStatus(){return taskStatus;}

    public void setTaskStatus(String taskStatus){this.taskStatus = taskStatus;}

    public LocalDateTime getCreatedAt(){return createdAt;}

    public void setCreatedAt(LocalDateTime createdAt){this.createdAt = createdAt;}

    public LocalDateTime getCompletedAt(){return completedAt;}

    public void setCompletedAt(LocalDateTime completedAt){this.completedAt = completedAt;}

    public Set<Subtask> getSubtasks(){return subtasks;}

    public void setSubtasks(Set<Subtask> subtasks){this.subtasks = subtasks;}     

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

