import random
from huggingface_hub import HfFolder
import os
import argparse
from transformers import pipeline
import warnings
import transformers

# Set Hugging Face authentication token
HfFolder.save_token("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")

# Suppress transformer warnings
warnings.filterwarnings('ignore')
transformers.logging.set_verbosity_error()

# Suppress device messages
os.environ["PYTORCH_ENABLE_MPS_FALLBACK"] = "1"

'''
Steps to use:
  1. Create the class
  2. Call set_challenge_text to set the text that you want to analyze
  3. Call analyze_sentiment
  4. Call categorize classification (maybe only if sentiment is positive? or maybe have classify_feedback also add a positive possibility so no need to call)
  5. Call generate_reccomendations with the difficulty and category from categorize_classification (Maybe add variables and setters/getters for difficulty and category)
'''


class FeedbackAnalyser:
    def __init__(self):
      self.generic_challenge = ""
      self.challenge_text = ""
      self.challenge_difficulty = 0
      self.give_positive_reinforcement = False
      self.zero_shot_classifier = pipeline("zero-shot-classification", model = "facebook/bart-large-mnli", revision = "d7645e1")
      self.text_classifier = pipeline("text-classification", model = "distilbert/distilbert-base-uncased-finetuned-sst-2-english", revision = "714eb0f")
      self.challenge_categories = [
        # Time Management [0-7]
        "Procrastination", "Poor planning", "Missed deadlines", "Overcommitting", "Lack of prioritization",
        "Underestimating task duration", "Distractions",

        # Motivation [7-14]
        "Lack of motivation", "Low energy", "Burnout", "Feeling overwhelmed", "Lack of focus", "Indecision",
        "No sense of accomplishment",

        # Environment [14-19]
        "Noisy environment", "Lack of workspace", "Poor lighting", "Uncomfortable workspace", "Lack of tools or resources",

        # Personal Habits [19-26]
        "Frequent multitasking", "Overthinking", "Perfectionism", "Forgetfulness", "Poor sleep", "Skipping breaks",
        "Poor time tracking",

        # External Factors [26-33]
        "Interruptions by others", "Family responsibilities", "Workload from other projects", "Unexpected events",
        "Illness or fatigue", "Limited access to resources", "Unclear instructions",

        # Communication [33-38]
        "Miscommunication with team", "Lack of feedback", "Difficulty asking for help", "Team conflicts", "Unclear expectations",

        # Task-Specific Challenges [38-45]
        "Task too complex", "Lack of knowledge", "Unfamiliar technology", "Lack of experience", "Difficulty breaking tasks into subtasks",
        "Changing task requirements", "Dependency on others",

        # Emotional Challenges [45-51]
        "Stress", "Anxiety", "Fear of failure", "Perceived incompetence", "Frustration", "Lack of confidence",

        # Distractions [51-57]
        "Social media", "Notifications", "TV or entertainment", "Household chores", "Browsing the internet", "Daydreaming",

        # Cognitive Load [57-62]
        "Too many tasks at once", "Difficulty switching tasks", "Information overload", "Forgetting previous tasks",
        "Lack of clarity on objectives",

        # Task Engagement [62]
        "Boring tasks", "Lack of interest", "Monotonous work", "Lack of rewards", "Unnecessary tasks"
      ]

      self.positive_reinforcement_messages = [
        "Great job! Keep up the fantastic work!",
        "You're doing amazing—keep it up!",
        "Excellent effort, you're on the right track!",
        "Nice work! You're making steady progress.",
        "Well done! You're doing better every day.",
        "You're really pushing forward—keep going!",
        "Impressive work! You're getting better and better.",
        "Fantastic job! Your hard work is paying off.",
        "You're doing great, keep up the positive momentum!",
        "Awesome progress! You're really moving forward.",
        "You're making great strides—keep up the good work!",
        "Your effort is truly paying off. Keep going!",
        "Nice job! You're on the right path.",
        "You're making incredible progress—keep it up!",
        "You're staying focused and it shows. Great work!",
        "Awesome effort! You're really putting in the work.",
        "You're doing great, don’t stop now!",
        "Great work! You're getting closer to your goals every day.",
        "Keep up the good work, you're doing amazing!",
        "You're making fantastic progress—well done!",
        "Your persistence is impressive, keep it up!",
        "You're getting stronger with every step—great job!",
        "You're moving in the right direction. Keep going!",
        "Excellent job! You’re really on top of things.",
        "Keep going! You’re making incredible strides.",
        "You're showing amazing dedication. Keep it up!",
        "Well done! Your hard work is really shining through.",
        "You're doing wonderfully—keep that energy going!"
    ]

    # Determines wheter the challenge text is positive or negative determines whether I should give positive feedback or constructive feedback
    def analyze_sentiment(self,):
      result = self.text_classifier(self.challenge_text)

      if result[0]["label"] == "POSITIVE" and result[0]["score"] > .7:
        self.give_positive_reinforcement = True
      else:
        self.give_positive_reinforcement = False

      return result[0]["label"]

    # Classifies the feedback into a specific category of challenge
    def classify_feedback(self):
      result = self.zero_shot_classifier(self.challenge_text, self.challenge_categories)

      return result["labels"][0], result["scores"][0]

    # Categorizes whatever the classify_feedback function returns to a generic type of challenge
    def categorize_classification(self):
      feedback, _ = self.classify_feedback()
      self.generic_challenge = ""

      # If statements for setting the generic challenge based on index
      if feedback in self.challenge_categories[:7]:
        self.generic_challenge = "Time Management"
      elif feedback in self.challenge_categories[7:14]:
        self.generic_challenge = "Motivation"
      elif feedback in self.challenge_categories[14:19]:
        self.generic_challenge = "Environment"
      elif feedback in self.challenge_categories[19:26]:
        self.generic_challenge = "Personal Habits"
      elif feedback in self.challenge_categories[26:33]:
        self.generic_challenge = "External Factors"
      elif feedback in self.challenge_categories[33:38]:
        self.generic_challenge = "Communication"
      elif feedback in self.challenge_categories[38:45]:
        self.generic_challenge = "Task-Specific Challenges"
      elif feedback in self.challenge_categories[45:51]:
        self.generic_challenge = "Emotionaal Challenges"
      elif feedback in self.challenge_categories[51:57]:
        self.generic_challenge = "Distractions"
      elif feedback in self.challenge_categories[57:62]:
        self.generic_challenge = "Cognitive Load"
      elif feedback in self.challenge_categories[62]:
        self.generic_challenge = "Task Engagement"

      return self.generic_challenge

    # Generates the reccomendation to give to the user that changes depending on if they require positive or constructive feedback
    def generate_reccomendations(self):
      if (self.give_positive_reinforcement):
        return self.positive_reinforcement_messages[random.randint(0, len(self.positive_reinforcement_messages) - 1)]
      else:
        # Give reccomendations based on difficulty and category
        recommendations = {
          1: {
            "Time Management": "Try creating a simple, structured schedule to help you stay organized.",
            "Motivation": "Set small, achievable goals to build momentum and confidence.",
            "Environment": "Optimize your workspace with basic organization and minimal distractions.",
            "Personal Habits": "Focus on establishing basic, consistent routines.",
            "External Factors": "Practice basic time-blocking to manage unexpected interruptions.",
            "Communication": "Start with clear, direct communication with team members.",
            "Task-Specific Challenges": "Break down tasks into very small, manageable steps.",
            "Emotional Challenges": "Practice basic mindfulness and positive self-talk.",
            "Distractions": "Use simple techniques like the Pomodoro method to stay focused.",
            "Cognitive Load": "Prioritize one task at a time and avoid multitasking.",
            "Task Engagement": "Find small ways to make tasks more interesting or rewarding."
          },
          2: {
            "Time Management": "Develop more advanced planning techniques like time-blocking.",
            "Motivation": "Set more challenging personal goals and track your progress.",
            "Environment": "Create a more intentional workspace with better tools and organization.",
            "Personal Habits": "Start implementing more sophisticated productivity techniques.",
            "External Factors": "Develop strategies for proactively managing potential interruptions.",
            "Communication": "Work on providing more detailed and constructive feedback.",
            "Task-Specific Challenges": "Start learning additional skills to address knowledge gaps.",
            "Emotional Challenges": "Begin exploring stress management techniques.",
            "Distractions": "Implement more robust focus strategies and digital detox methods.",
            "Cognitive Load": "Practice task batching and more advanced prioritization.",
            "Task Engagement": "Find ways to connect tasks to larger personal or professional goals."
          },
          3: {
            "Time Management": "Implement advanced productivity systems like GTD or Kanban.",
            "Motivation": "Develop a comprehensive personal development plan.",
            "Environment": "Create an optimized workspace with ergonomic considerations.",
            "Personal Habits": "Deep dive into habit formation and behavior change techniques.",
            "External Factors": "Build robust contingency planning and adaptability skills.",
            "Communication": "Develop advanced communication and collaboration strategies.",
            "Task-Specific Challenges": "Invest in continuous learning and skill development.",
            "Emotional Challenges": "Seek professional coaching or counseling for deeper insights.",
            "Distractions": "Implement comprehensive focus and concentration techniques.",
            "Cognitive Load": "Master advanced task management and cognitive optimization methods.",
            "Task Engagement": "Align tasks with long-term career and personal growth objectives."
          }
      }

      # Adjust difficulty level mapping
      if self.challenge_difficulty <= 2:
          diff_key = 1
      elif self.challenge_difficulty <= 4:
          diff_key = 2
      else:
          diff_key = 3


      return recommendations[diff_key][self.generic_challenge]

    # Setter method for challenge text
    def set_challenge_text(self, new_challenge_text):
      self.challenge_text = new_challenge_text

    # Setter method for challenge_difficulty
    def set_challenge_difficulty(self, new_challenge_difficulty):
      self.challenge_difficulty = new_challenge_difficulty

def main():
  # Argument parser for cmd line
  parser = argparse.ArgumentParser()
  parser.add_argument('--challenge', required = True)
  parser.add_argument('--difficulty', type = int, required = True)
  parser.add_argument('--feedback-id', type = int, required = True)

  args = parser.parse_args()

  # Use feedback analyzer to get reccomendation
  FA = FeedbackAnalyser()
  FA.set_challenge_text(args.challenge)
  FA.set_challenge_difficulty(args.difficulty)
  FA.analyze_sentiment()
  FA.categorize_classification()
  reccomendation = FA.generate_reccomendations()

  print(reccomendation)

main()
'''
In main, send generated reccomendation to new table in feedback(?) or whatever would pair it with
the given task, in the future make a new table that holds feedback for each task, but right now 
just get it into the table and have an api call to this class to run it everytime feedback is 
submitted
'''