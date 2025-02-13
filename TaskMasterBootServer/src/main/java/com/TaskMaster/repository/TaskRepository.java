package com.TaskMaster.repository;

import com.TaskMaster.model.Task;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface TaskRepository extends JpaRepository<Task, Integer> {
    List<Task> findByUserUserID(int userID);
}
