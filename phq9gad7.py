def run_mental_health_assessment():
    """Run both PHQ-9 and GAD-7 assessments sequentially."""
    print("Mental Health Assessment")
    
    # PHQ-9 Assessment
    print("\n----- PHQ-9 Depression Screening Questionnaire -----")
    print("Over the last 2 weeks, how often have you been bothered by any of the following problems?")
    print("0: Not at all")
    print("1: Several days")
    print("2: More than half the days")
    print("3: Nearly every day\n")
    
    phq9_questions = [
        "Little interest or pleasure in doing things",
        "Feeling down, depressed, or hopeless",
        "Trouble falling or staying asleep, or sleeping too much",
        "Feeling tired or having little energy",
        "Poor appetite or overeating",
        "Feeling bad about yourself - or that you are a failure or have let yourself or your family down",
        "Trouble concentrating on things, such as reading the newspaper or watching television",
        "Moving or speaking so slowly that other people could have noticed. Or the opposite - being so "
        "fidgety or restless that you have been moving around a lot more than usual",
        "Thoughts that you would be better off dead, or of hurting yourself in some way"
    ]
    
    phq9_responses = []
    for i, question in enumerate(phq9_questions):
        while True:
            try:
                response = int(input(f"{i+1}. {question}: "))
                if response not in [0, 1, 2, 3]:
                    print("Please enter 0, 1, 2, or 3")
                    continue
                phq9_responses.append(response)
                break
            except ValueError:
                print("Please enter a valid number (0-3)")
    
    phq9_score = sum(phq9_responses)
    
    # Determine PHQ-9 severity level
    if phq9_score <= 4:
        phq9_severity = "Minimal or none"
    elif phq9_score <= 9:
        phq9_severity = "Mild"
    elif phq9_score <= 14:
        phq9_severity = "Moderate"
    elif phq9_score <= 19:
        phq9_severity = "Moderately severe"
    else:
        phq9_severity = "Severe"
    
    # GAD-7 Assessment
    print("\n----- GAD-7 Anxiety Screening Questionnaire -----")
    print("Over the last 2 weeks, how often have you been bothered by any of the following problems?")
    print("0: Not at all")
    print("1: Several days")
    print("2: More than half the days")
    print("3: Nearly every day\n")
    
    gad7_questions = [
        "Feeling nervous, anxious, or on edge",
        "Not being able to stop or control worrying",
        "Worrying too much about different things",
        "Trouble relaxing",
        "Being so restless that it's hard to sit still",
        "Becoming easily annoyed or irritable",
        "Feeling afraid, as if something awful might happen"
    ]
    
    gad7_responses = []
    for i, question in enumerate(gad7_questions):
        while True:
            try:
                response = int(input(f"{i+1}. {question}: "))
                if response not in [0, 1, 2, 3]:
                    print("Please enter 0, 1, 2, or 3")
                    continue
                gad7_responses.append(response)
                break
            except ValueError:
                print("Please enter a valid number (0-3)")
    
    gad7_score = sum(gad7_responses)
    
    # Determine GAD-7 severity level
    if gad7_score <= 4:
        gad7_severity = "Minimal anxiety"
    elif gad7_score <= 9:
        gad7_severity = "Mild anxiety"
    elif gad7_score <= 14:
        gad7_severity = "Moderate anxiety"
    else:
        gad7_severity = "Severe anxiety"
    
    # Display results
    print("\n----- Assessment Results -----")
    print(f"PHQ-9 Score: {phq9_score} - {phq9_severity}")
    if phq9_score >= 10:
        print("Note: PHQ-9 score of 10 or above suggests further evaluation may be needed.")
    if phq9_responses[8] > 0:
        print("Note: Any score above 0 on question 9 needs further evaluation for suicide risk.")
    
    print(f"\nGAD-7 Score: {gad7_score} - {gad7_severity}")
    if gad7_score >= 10:
        print("Note: GAD-7 score of 10 or above suggests further evaluation may be needed.")
    
    return {
        "phq9": {"score": phq9_score, "severity": phq9_severity},
        "gad7": {"score": gad7_score, "severity": gad7_severity}
    }


if __name__ == "__main__":
    run_mental_health_assessment()