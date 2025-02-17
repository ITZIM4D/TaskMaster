'''
* Script to populate the database with X amuont of users and values for each user
* To change number of users update the for loop in populate users table
'''

import mysql.connector
from mysql.connector import Error
import random
import string
import os
from datetime import datetime, timedelta

# Connect to mysql database
def create_connection():
    try:
        connection = mysql.connector.connect(
            host = "localhost",
            user = os.getenv("MYSQL_USER"),
            password = os.getenv("MYSQL_PASSWORD"),
            database = "TaskMaster"
        )
        return connection
    except Error as e:
        print(f"Error: {e}")
        return None
    
# Define realistic tasks and subtasks
tasks_data = [
    {
        "task_name": "Finish Project Report",
        "subtasks": ["1. Write Introduction", "2. Compile Data Analysis", "3. Edit and Review"]
    },
    {
        "task_name": "Prepare for Meeting",
        "subtasks": ["1. Create Agenda", "2. Review Previous Minutes", "3. Prepare Presentation"]
    },
    {
        "task_name": "Complete Code Review",
        "subtasks": ["1. Review Pull Requests", "2. Leave Comments", "3. Merge Approved Changes"]
    },
    {
        "task_name": "Plan Marketing Campaign",
        "subtasks": ["1. Research Target Audience", "2. Develop Campaign Strategy", "3. Design Assets"]
    },
    {
        "task_name": "Organize Team Outing",
        "subtasks": ["1. Find Venue", "2. Send Invitations", "3. Arrange Transportation"]
    },
    {
        "task_name": "Do laundry",
        "subtasks": ["1. Put clothes in washer", "2. Move clothes to dryer", "3. Fold and put away clothes"]
    },
    {
        "task_name": "Do homework",
        "subtasks": ["1. Close out of all apps", "2. Get homework out", "3. Do first question", "4. Do rest of questions"]
    }
]

moods = ["Happy", "Sad", "Stressed", "Anxious", "Calm"]

def generate_random_past_date(weeks=4):
    # Generate a random number of days between 1 and (weeks * 7)
    random_days = random.randint(1, weeks * 7)
    # Subtract that many days from the current date to get a random date in the past
    return datetime.now() - timedelta(days=random_days)

# Populate the tables
def populate_tables(connection):
    cursor = connection.cursor()

    # Populate Users table
    user_ids = []
    used_usernames = set()

    for i in range(20):
        while True:  # Loop until a unique username is found
            username = f"user{random.randint(1000, 9999)}"
            if username not in used_usernames:  # Check for uniqueness
                break
    
        used_usernames.add(username)  # Add the username to the set
        password_hash = f"pass{random.randint(1000, 9999)}"
        cursor.execute("INSERT INTO Users (username, passwordHash) VALUES (%s, %s)", (username, password_hash))
        user_ids.append(cursor.lastrowid)
    print("20 users added to the Users table.")

    # Populate Tasks and related tables
    for user_id in user_ids:
        task_ids = []
        # Add tasks for each user
        for _ in range(random.randint(1, 3)):  # Each user has 1-3 tasks
            task = random.choice(tasks_data)
            task_name = task["task_name"]
            task_deadline = datetime.now() + timedelta(days = random.randint(1, 30))
            task_status = random.choice(["In Progress", "Completed"])

            completed_at = None
            if task_status == "Completed":
                completed_at = generate_random_past_date()

            cursor.execute(
                "INSERT INTO Tasks (userID, taskName, taskDeadline, taskStatus, completedAt) VALUES (%s, %s, %s, %s, %s)",
                (user_id, task_name, task_deadline, task_status, completed_at)
            )
            task_id = cursor.lastrowid
            task_ids.append(task_id)

            # Add subtasks for each task
            for subtask_name in task["subtasks"]:
                subtask_status = random.choice(["In Progress", "Completed"])

                subtask_completed_at = None
                if subtask_status == "Completed":
                    # Generate a random completedAt date within the last 4 weeks
                    subtask_completed_at = generate_random_past_date(weeks=4)

                cursor.execute(
                    "INSERT INTO Subtasks (taskID, subtaskName, taskStatus, completedAt) VALUES (%s, %s, %s, %s)",
                    (task_id, subtask_name, subtask_status, completed_at)
                )

        # Add a random sentiment for each user
        mood = random.choice(moods)
        cursor.execute("INSERT INTO Sentiments (userID, mood) VALUES (%s, %s)", (user_id, mood))

        # Add progress for each user
        completed_tasks = random.randint(0, 5)
        pending_tasks = random.randint(0, 5)
        cursor.execute(
            "INSERT INTO Progress (userID, completedTasks, pendingTasks) VALUES (%s, %s, %s)",
            (user_id, completed_tasks, pending_tasks)
        )

    connection.commit()
    print("All tables have been populated with realistic sample data.")
    cursor.close()

# Main function to establish connection and populate the tables
def main():
    connection = create_connection()
    if connection:
        populate_tables(connection)
        connection.close()

main()