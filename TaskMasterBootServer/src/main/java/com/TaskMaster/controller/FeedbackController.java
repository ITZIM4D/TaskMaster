package com.TaskMaster.controller;

import com.TaskMaster.model.Feedback;
import com.TaskMaster.repository.FeedbackRepository;
import com.TaskMaster.service.FeedbackAnalysisService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.*;

import java.util.List;

@RestController
@RequestMapping("/api/feedback")
public class FeedbackController {

    @Autowired
    private FeedbackRepository feedbackRepository;

    @Autowired
    private FeedbackAnalysisService feedbackAnalysisService;

    @GetMapping
    public List<Feedback> getAllFeedback() {
        return feedbackRepository.findAll();
    }

    @PostMapping
    public Feedback createFeedback(@RequestBody Feedback feedback) {
        Feedback savedFeedback = feedbackRepository.save(feedback);

        try {
            String recommendation = feedbackAnalysisService.analyzeFeedback(
                feedback.getChallenges(),
                feedback.getDifficulty(),
                feedback.getFeedbackID()
            );

            savedFeedback.setReccomendation(recommendation);
            savedFeedback = feedbackRepository.save(savedFeedback);
            return feedbackRepository.findById(savedFeedback.getFeedbackID()).orElse(savedFeedback);
        } catch (Exception e) {
            e.printStackTrace();
            return savedFeedback;
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<Feedback> getFeedbackByID(@PathVariable(value = "id") int feedbackID) {
        return feedbackRepository.findById(feedbackID)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Object> deleteFeedback(@PathVariable(value = "id") int feedbackID) {
        return feedbackRepository.findById(feedbackID)
            .map(feedback -> {
                feedbackRepository.delete(feedback);
                return ResponseEntity.ok().build();
            }).orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/user/{userId}")
    public List<Feedback> getFeedbackByUserID(@PathVariable(value = "userId") int userID) {
        return feedbackRepository.findByUserID(userID);
    }

    @GetMapping("/task/{taskId}")
    public List<Feedback> getFeedbackByTaskID(@PathVariable(value = "taskId") int taskID) {
        return feedbackRepository.findByTaskID(taskID);
    }
}