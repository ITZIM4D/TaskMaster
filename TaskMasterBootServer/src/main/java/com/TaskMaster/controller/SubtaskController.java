package com.TaskMaster.controller;

import com.TaskMaster.model.Subtask;
import com.TaskMaster.repository.SubtaskRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@RestController
@RequestMapping("/api/subtasks")
public class SubtaskController {

    @Autowired
    private SubtaskRepository subtaskRepository;

    @GetMapping
    public List<Subtask> getAllTasks() {
        return subtaskRepository.findAll();
    }

    @PostMapping
    public Subtask createSubtask(@RequestBody Subtask subtask){
        return subtaskRepository.save(subtask);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Subtask> getSubtaskByID(@PathVariable(value = "id") int subtaskID){
        return subtaskRepository.findById(subtaskID)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Object> deleteSubtask(@PathVariable(value = "id") int subtaskID){
        return subtaskRepository.findById(subtaskID)
            .map(subtask -> {
                subtaskRepository.delete(subtask);
                return ResponseEntity.ok().build();
            }).orElse(ResponseEntity.notFound().build());
    }

    @PutMapping("/{id}/toggle")
    public ResponseEntity<Subtask> toggleSubtaskCompletion(
        @PathVariable(value = "id") int subtaskID,
        @RequestBody CompletionToggleRequest request) {
    
    return subtaskRepository.findById(subtaskID)
        .map(subtask -> {
            // If completedAt is null in the request, uncomplete the subtask
            if (request.getCompletedAt() == null) {
                subtask.setCompletedAt(null);
                subtask.setTaskStatus("In Progress");
            } else {
                // Parse the ISO 8601 date string from the request
                LocalDateTime completedDateTime = LocalDateTime.parse(
                    request.getCompletedAt(),
                    DateTimeFormatter.ISO_DATE_TIME
                );
                subtask.setCompletedAt(completedDateTime);
                subtask.setTaskStatus("Completed");
            }
            
            Subtask updatedSubtask = subtaskRepository.save(subtask);
            return ResponseEntity.ok(updatedSubtask);
        })
        .orElse(ResponseEntity.notFound().build());
    }

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