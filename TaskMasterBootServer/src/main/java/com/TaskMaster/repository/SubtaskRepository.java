package com.TaskMaster.repository;

import com.TaskMaster.model.Subtask;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface SubtaskRepository extends JpaRepository<Subtask, Integer> {
    List<Subtask> findByTaskTaskID(int taskID);
}
