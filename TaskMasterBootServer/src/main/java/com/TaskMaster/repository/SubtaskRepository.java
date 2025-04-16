package com.TaskMaster.repository;

import com.TaskMaster.model.Subtask;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface SubtaskRepository extends JpaRepository<Subtask, Integer> {
    List<Subtask> findByTaskTaskID(int taskID);

    @Query("SELECT COUNT(s) FROM Subtask s WHERE s.task.taskID = :taskId AND s.taskStatus = 'In Progress'")
    long countInProgressSubtasksByTaskId(Long taskId);
}
