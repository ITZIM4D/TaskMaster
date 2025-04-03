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
import math

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
    },
    {
        "task_name": "Grocery Shopping",
        "subtasks": ["1. Make shopping list", "2. Go to store", "3. Put groceries away"]
    },
    {
        "task_name": "Pay Bills",
        "subtasks": ["1. Check bank balance", "2. Review bills", "3. Schedule payments"]
    },
    {
        "task_name": "Exercise",
        "subtasks": ["1. Warm up", "2. Main workout", "3. Cool down"]
    },
    {
        "task_name": "Prepare Tax Documents",
        "subtasks": ["1. Gather income statements", "2. Collect expense receipts", "3. Organize deduction paperwork", "4. Review for completeness"]
    },
    {
        "task_name": "Plan Family Vacation",
        "subtasks": ["1. Research destinations", "2. Compare prices", "3. Book accommodations", "4. Create itinerary"]
    },
    {
        "task_name": "Home Maintenance",
        "subtasks": ["1. Clean gutters", "2. Replace air filters", "3. Check smoke detectors", "4. Inspect plumbing"]
    },
    {
        "task_name": "Write Blog Post",
        "subtasks": ["1. Research topic", "2. Create outline", "3. Write draft", "4. Edit and publish"]
    },
    {
        "task_name": "Car Maintenance",
        "subtasks": ["1. Schedule appointment", "2. Change oil", "3. Rotate tires", "4. Check fluid levels"]
    },
    {
        "task_name": "Clean Kitchen",
        "subtasks": ["1. Wash dishes", "2. Wipe counters", "3. Clean appliances", "4. Sweep and mop floor"]
    },
    {
        "task_name": "Update Resume",
        "subtasks": ["1. Review current skills", "2. Add recent accomplishments", "3. Update job history", "4. Proofread final version"]
    },
    {
        "task_name": "Meal Prep for Week",
        "subtasks": ["1. Plan recipes", "2. Cook base ingredients", "3. Portion into containers", "4. Label and refrigerate"]
    },
    {
        "task_name": "Apply for Job",
        "subtasks": ["1. Customize resume", "2. Write cover letter", "3. Complete application", "4. Follow up with recruiter"]
    },
    {
        "task_name": "Schedule Doctor Appointments",
        "subtasks": ["1. Check insurance coverage", "2. Find in-network providers", "3. Call for availability", "4. Confirm appointments"]
    }
]

moods = ["Happy", "Sad", "Stressed", "Anxious", "Calm"]

def generate_user_adoption_pattern(start_date, end_date):
    """
    Generates a dictionary with dates as keys and number of tasks completed as values,
    following a realistic adoption pattern with occasional dips
    """
    
    total_days = (end_date - start_date).days + 1
    usage_pattern = {}

    # Generate dates between start and end date
    current_date = start_date
    while current_date <= end_date:
        usage_pattern[current_date] = 0
        current_date += timedelta(days = 1)
    
    # Define the type of person the user is randomly
    user_type = random.choice(["consistent", "intermittent", "late_adopter", "early_adopter"])

    # Give a base probablity of the user using the app each day based on user_type
    if user_type == "consistent":
        base_probability = 0.7
    elif user_type == "intermittent":
        base_probability = 0.5
    elif user_type == "late_adopter":
        base_probability = 0.3
    else:  
        base_probability = 0.8

    # Set up variables for user taking a break from app
    break_probability = 0.00
    in_break = False
    break_length = 0

    # Generate the pattern of activity by day by day
    for day in range(total_days):
        current_date = start_date + timedelta(days = day)

        # The growht factor depending on the user_type (possibly add date ratio too?)
        progress_ratio = day / total_days

        # Change growth curve for different user type
        if user_type == "consistent":
            growth_factor = 1.0 + progress_ratio
        elif user_type == "intermittent":
            growth_factor = 1.0 + progress_ratio * 1.5
        elif user_type == "late_adopter":
            growth_factor = 0.5 + (progress_ratio ** 2) * 2.5
        else:
            growth_factor = 1.5 - (progress_ratio ** 2) * 0.5

        # Handle breaks
        if in_break:
            break_length -= 1
            if break_length < 1:
                in_break = False
                growth_factor *= 1.2 # Productivity bump
            else:
                continue
            
        # Check if should go into break mode
        elif random.random() < break_probability:
            in_break = True
            break_length = random.randint(1,7)
            continue
        
        # Determine if the user is active on current day
        daily_probability = min(base_probability * growth_factor, 0.95) # 95% chance of them being active if actual probability is too high
        if random.random() < daily_probability:
            # Determine number of tasks completed that day
            max_tasks = int(2 + progress_ratio * 3) # Increase the max tasks over time
            tasks_completed = random.randint(0, max_tasks)

            # Maybe add noise in the future for natural variability??
            noise_factor = random.uniform(0.8, 1.2)
            tasks_completed = max(0, int(tasks_completed * noise_factor))

            usage_pattern[current_date] = tasks_completed

    return usage_pattern



def generate_random_past_date(weeks = 4):
    # Generate a random number of days between 1 and (weeks * 7)
    random_days = random.randint(1, weeks * 7)
    # Subtract that many days from the current date to get a random date in the past
    return datetime.now() - timedelta(days = random_days)

# Populate the tables
def populate_tables(connection):
    cursor = connection.cursor()

    # Define the date range 
    end_date = datetime.now()
    start_date = end_date - timedelta(days = random.randint(90, 365))

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
        # generate the adoption pattern of the user
        adoption_pattern = generate_user_adoption_pattern(start_date, end_date)

        # Track total tasks
        total_completed_tasks = 0
        total_pending_tasks = 0

        # Create tasks based on adoption pattern
        for day_date, (tasks_count) in adoption_pattern.items():
            for i in range(tasks_count + 3):
                task = random.choice(tasks_data)
                task_name = task["task_name"]

                # Randomize task creation and completion dates
                task_created_at = day_date - timedelta(days = random.randint(0, 7))

                # Set task deadline
                task_deadline = task_created_at + timedelta(days = random.randint(1, 14))

                # Determine task status
                task_status = random.choices(["Completed", "In Progress"], weights = [0.85, 0.15])[0]

                if (task_status == "Completed"):
                    completed_at = day_date
                else:
                    completed_at = None

                cursor.execute("INSERT INTO Tasks (userID, taskName, taskDeadline, taskStatus, createdAt, completedAt) VALUES (%s, %s, %s, %s, %s, %s)",
                               (user_id, task_name, task_deadline, task_status, task_created_at, completed_at))
                task_id = cursor.lastrowid

                # Add to progress table
                if task_status == "Completed":
                    total_completed_tasks += 1
                else:
                    total_pending_tasks += 1

                # Realistic subtask patterns
                subtask_count = len(task["subtasks"])
                for i, subtask_name in enumerate(task["subtasks"]):
                    # If tasks is completed, complete subtasks sequentially
                    if task_status == "Completed":
                        subtask_completed_at = completed_at - timedelta(hours = random.randint(1, 24) * (subtask_count - i))
                    else:
                        # Otherwise complete subctasks by making earlier ones more likely to be done
                        completion_chance = 0.8 - (i / subtask_count * 0.8)
                        subtask_status = random.choices(["Completed", "In Progress"], weights = [completion_chance, 1 - completion_chance])[0]
                        if (subtask_status == "Completed"):
                            subtask_completed_at = day_date - timedelta(hours = random.randint(1, 12))
                        else:
                            subtask_completed_at = None

                        cursor.execute("INSERT INTO Subtasks (taskID, subtaskName, taskStatus, CompletedAt) VALUES (%s, %s, %s, %s)",
                                       (task_id, subtask_name, subtask_status, subtask_completed_at))

        # Add a random sentiment for each user
        mood = random.choice(moods)
        cursor.execute("INSERT INTO Sentiments (userID, mood) VALUES (%s, %s)", (user_id, mood))

        cursor.execute("INSERT INTO Progress (userID, completedTasks, pendingTasks) VALUES (%s, %s, %s)",
                       (user_id, total_completed_tasks, total_pending_tasks))

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