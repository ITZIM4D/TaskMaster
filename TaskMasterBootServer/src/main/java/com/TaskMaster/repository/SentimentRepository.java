package com.TaskMaster.repository;

import com.TaskMaster.model.Sentiment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface SentimentRepository extends JpaRepository<Sentiment, Integer> {
    List<Sentiment> findByUserUserID(int userID);
}
