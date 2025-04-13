import pandas as pd
import numpy as np

# Sample data for a single user
data = {
    'date': [
        '2025-04-01', '2025-04-02', '2025-04-03',
        '2025-04-04', '2025-04-05', '2025-04-06',
        '2025-04-07', '2025-04-08'
    ],
    'emotion_score': [-0.23, -0.51, -0.10, -0.30, -0.45, -0.35, -0.25, -0.20],
    'sentiment_score': [0.2, 0.1, 0.15, 0.18, 0.13, 0.12, 0.16, 0.17]
}

# Convert to DataFrame
df = pd.DataFrame(data)
df['date'] = pd.to_datetime(df['date'])

# Sort by date just in case
df = df.sort_values(by='date')

# Calculate mood consistency over the last 7 days
def mood_consistency_last_7_days(df):
    last_7 = df.tail(7).copy()
    
    # Calculate average absolute day-to-day change
    last_7['emotion_diff'] = last_7['emotion_score'].diff().abs()
    last_7['sentiment_diff'] = last_7['sentiment_score'].diff().abs()

    # Drop NaNs from first diff row
    mood_consistency = (last_7['emotion_diff'].dropna().mean() + last_7['sentiment_diff'].dropna().mean()) / 2

    return mood_consistency

# Call function
consistency_score = mood_consistency_last_7_days(df)
print("Mood Consistency (last 7 days):", consistency_score)
