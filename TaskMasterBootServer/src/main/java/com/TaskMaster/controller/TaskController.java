package com.TaskMaster.controller;

import com.TaskMaster.model.Task;
import com.TaskMaster.repository.TaskRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@RestController
@RequestMapping("/api/tasks")
public class TaskController {

    /**
     * @Autowired
     * 
     * This injects a bean (instance) created from spring boot into the variable so it then 
     * instantiates the variable without me needing to
     * 
     * very cool very nice
     * 
     */

    @Autowired
    private TaskRepository taskRepository;

    @GetMapping
    public List<Task> getAllTasks() {
        return taskRepository.findAll();
    }

    @PostMapping
    public Task createTask(@RequestBody Task task) {
        System.out.println("Received task: " + task);
        return taskRepository.save(task);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Task> getTaskByID(@PathVariable(value = "id") int taskID){
        return taskRepository.findById(taskID)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Object> deleteTask(@PathVariable(value = "id") int taskID){
        return taskRepository.findById(taskID)
            .map(task -> {
                taskRepository.delete(task);
                return ResponseEntity.ok().build();
            }).orElse(ResponseEntity.notFound().build());
    }

    @PutMapping("/{id}/toggle")
    public ResponseEntity<Task> toggleTaskCompletion(
            @PathVariable(value = "id") int taskID,
            @RequestBody CompletionToggleRequest request) {
        
        return taskRepository.findById(taskID)
            .map(task -> {
                // If completedAt is null in the request, we're uncompleting the task
                if (request.getCompletedAt() == null) {
                    task.setCompletedAt(null);
                    task.setTaskStatus("In Progress");
                } else {
                    // Parse the ISO 8601 date string from the request
                    LocalDateTime completedDateTime = LocalDateTime.parse(
                        request.getCompletedAt(),
                        DateTimeFormatter.ISO_DATE_TIME
                    );
                    task.setCompletedAt(completedDateTime);
                    task.setTaskStatus("Completed");
                }
                
                Task updatedTask = taskRepository.save(task);
                return ResponseEntity.ok(updatedTask);
            })
            .orElse(ResponseEntity.notFound().build());
    }

    // Request class for the toggle endpoint
    public static class CompletionToggleRequest {
        private String completedAt;

        public String getCompletedAt() {
            return completedAt;
        }

        public void setCompletedAt(String completedAt) {
            this.completedAt = completedAt;
        }
    }
}
