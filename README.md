# TaskMaster

## Overview
TaskMaster is a task management and stress reduction app designed to help users stay organized and reduce overwhelm. It breaks down large tasks, tracks progress, and visualizes data to improve productivity and well-being.

## Features
- **Task Management**: Create, edit, and delete tasks with deadlines and status tracking.
- **Subtasks**: Break down tasks into smaller, manageable subtasks.
- **Progress Tracking**: Monitor completed and pending tasks with visual progress indicators.
- **Stress Reduction**: Track mood and stress levels to identify patterns and triggers.
- **Feedback Generation**: Receive personalized feedback and recommendations based on task performance.
- **Notifications**: Get reminders for upcoming task deadlines.

## Project Structure
- **TaskMaster/**: iOS app source code (Swift).
- **TaskMasterBootServer/**: Spring Boot backend server.
- **FeedbackGenerator/**: Python script for generating feedback based on task performance.
- **populateTableScript.py**: Script to populate the database with sample data.

## Setup Instructions
1. **Backend Setup**:
   - Navigate to `TaskMasterBootServer/`.
   - Ensure you have Java 17 and Gradle installed.
   - Run `./gradlew bootRun` to start the Spring Boot server.
   - Configure environment variables for database and API keys in `src/main/resources/application.properties`.

2. **iOS App Setup**:
   - Open `TaskMaster/TaskMaster.xcodeproj` in Xcode.
   - Install dependencies using Swift Package Manager.
   - Run the app on a simulator

3. **Feedback Generator Setup**:
   - Navigate to `FeedbackGenerator/`.
   - Install required packages
   - Run `python FeedbackGenerator.py` to test the feedback generation.

4. **Database Setup**:
   - Run `TaskMaster/TaskMasterDDL.sql` to create the database schema.
   - Use `populateTableScript.py` to populate the database with sample data.

## Environment Variables
- `MYSQL_USER`: MySQL database username.
- `MYSQL_PASSWORD`: MySQL database password.
- `OPENAI_API_KEY`: OpenAI API key for feedback generation.

## Attributions
- **Icons**: 
  - KiranShastry from flaticon.com
  - freepik from flaticon.com
  - HAJICON from flaticon.com
    