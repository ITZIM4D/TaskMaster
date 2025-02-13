package com.TaskMaster.repository;

import com.TaskMaster.model.Progress;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProgressRepository extends JpaRepository<Progress, Integer> {
    Progress findByUserUserID(int userID);
}
