def get_social_interaction_value():
    print("Please enter the following (estimates are fine):\n")

    messages = int(input("1. Number of WhatsApp/SMS messages per day: "))
    calls = int(input("2. Number of phone calls per day: "))
    social_media = int(input("3. Time spent on social media (in minutes per day): "))
    people_interacted = int(input("4. Number of people you interact with per day: "))

    # Normalize values (assuming reasonable upper limits)
    messages_score = min(messages, 200) / 200 * 30     # Max 30 points
    calls_score = min(calls, 20) / 20 * 20             # Max 20 points
    social_media_score = min(social_media, 300) / 300 * 25  # Max 25 points
    people_score = min(people_interacted, 20) / 20 * 25     # Max 25 points

    # Calculate final score
    total_score = messages_score + calls_score + social_media_score + people_score
    total_score = round(total_score)

    print(f"\n🧠 Estimated Social Interaction Value: {total_score} / 100")

    return total_score


# Run the function
get_social_interaction_value()
