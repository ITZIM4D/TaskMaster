CREATE DATABASE TaskMaster;

USE TaskMaster;


CREATE TABLE Users (
    userID INT PRIMARY KEY AUTO_INCREMENT,
    username varchar(255) NOT NULL UNIQUE,
    passwordHash varchar(255) NOT NULL -- Stores a hash of the password
);

CREATE TABLE Tasks (
    taskID INT PRIMARY KEY AUTO_INCREMENT,
    userID INT NOT NULL,
    taskName varchar(255) NOT NULL,
    taskDeadline DATE, -- When the task has to be done by
    taskStatus ENUM("In Progress", "Completed") NOT NULL, -- Whether the task is done or not
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    completedAt TIMESTAMP DEFAULT NULL,
    FOREIGN KEY (userID) REFERENCES Users(userID) ON DELETE CASCADE
);

CREATE TABLE Subtasks (
    subtaskID INT PRIMARY KEY AUTO_INCREMENT,
    taskID INT NOT NULL,
    subtaskName varchar(255) NOT NULL,
    taskStatus ENUM("In Progress", "Completed") NOT NULL, -- Whether the task is done or not
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    completedAt TIMESTAMP DEFAULT NULL,
    FOREIGN KEY (taskID) REFERENCES Tasks(taskID) ON DELETE CASCADE
);

CREATE TABLE Sentiments (
    sentimentID INT PRIMARY KEY AUTO_INCREMENT,
    userID INT NOT NULL,
    mood varchar(255) NOT NULL,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (userID) REFERENCES Users(userID) ON DELETE CASCADE
);

CREATE TABLE Progress (
    progressID INT PRIMARY KEY AUTO_INCREMENT,
    userID INT NOT NULL,
    completedTasks INT NOT NULL,
    pendingTasks INT NOT NULL,
    FOREIGN KEY (userID) REFERENCES Users(userID) ON DELETE CASCADE
);

CREATE TABLE Feedback (
    feedbackID INT AUTO_INCREMENT PRIMARY KEY,
    userID INT,
    taskID INT,
    difficulty INT,
    timeAccuracy ENUM("Less", "Expected", "More"),
    challenges varchar(255),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
