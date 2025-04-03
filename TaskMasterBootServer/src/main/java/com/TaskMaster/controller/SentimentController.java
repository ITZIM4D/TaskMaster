package com.TaskMaster.controller;

import com.TaskMaster.model.Sentiment;
import com.TaskMaster.repository.SentimentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.*;
import java.util.List;

@RestController
@RequestMapping("/api/sentiments")
public class SentimentController {

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
    private SentimentRepository sentimentRepository;

    @GetMapping
    public List<Sentiment> getAllSentiments() {
        return sentimentRepository.findAll();
    }

    @PostMapping 
    public Sentiment createSentiment(@RequestBody Sentiment sentiment){
        return sentimentRepository.save(sentiment);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Sentiment> getSentimentByID(@PathVariable(value = "id") int sentimentID){
        return sentimentRepository.findById(sentimentID)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Object> deleteSentiment(@PathVariable(value = "id") int sentimentID){
        return sentimentRepository.findById(sentimentID)
            .map(sentiment -> {
                sentimentRepository.delete(sentiment);
                return ResponseEntity.ok().build();
            }).orElse(ResponseEntity.notFound().build());
    }

}