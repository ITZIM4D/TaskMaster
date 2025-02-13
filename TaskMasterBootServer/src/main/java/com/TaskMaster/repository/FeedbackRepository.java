package com.TaskMaster.repository;

import com.TaskMaster.model.Feedback;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface FeedbackRepository extends JpaRepository<Feedback, Integer> {
    List<Feedback> findByUserID(int userID);
    List<Feedback> findByTaskID(int taskID);
}