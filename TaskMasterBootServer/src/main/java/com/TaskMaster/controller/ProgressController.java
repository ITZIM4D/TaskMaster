package com.TaskMaster.controller;

import com.TaskMaster.model.Progress;
import com.TaskMaster.repository.ProgressRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.*;
import java.util.List;

@RestController
@RequestMapping("/api/progresses")
public class ProgressController {

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
    private ProgressRepository progressRepository;

    @GetMapping
    public List<Progress> getAllProgresses(){
        return progressRepository.findAll();
    }

    @PostMapping
    public Progress createProgress(@RequestBody Progress progress){
        return progressRepository.save(progress);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Progress> getProgressByID(@PathVariable(value = "id") int progressID){
        return progressRepository.findById(progressID)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Object> deleteProgress(@PathVariable(value = "id") int progressID){
        return progressRepository.findById(progressID)
            .map(progress -> {
                progressRepository.delete(progress);
                return ResponseEntity.ok().build();
            }).orElse(ResponseEntity.notFound().build());
    }

}