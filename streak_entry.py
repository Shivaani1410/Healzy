import pandas as pd

# Sample data for a single user
import pandas as pd

# Sample data
data = {
    'user_id': [1, 1, 1, 1, 1, 2, 2, 2, 2],
    'date': [
        '2025-04-01', '2025-04-02', '2025-04-03', '2025-04-05', '2025-04-06',
        '2025-04-01', '2025-04-03', '2025-04-04', '2025-04-05'
    ]
}

df = pd.DataFrame(data)
df['date'] = pd.to_datetime(df['date'])

# Convert to DataFrame
df = pd.DataFrame(data)
df['date'] = pd.to_datetime(df['date'])

# Assuming df has 'user_id' and 'date' columns
df['date'] = pd.to_datetime(df['date'])

def calculate_entry_streak(group):
    group = group.sort_values('date')
    streak = 0
    streaks = []
    prev_date = None
    
    for curr_date in group['date']:
        if prev_date is not None and (curr_date - prev_date).days == 1:
            streak += 1
        else:
            streak = 1
        streaks.append(streak)
        prev_date = curr_date
    
    group['entry_streak'] = streaks
    return group

df = df.groupby('user_id', group_keys=False).apply(calculate_entry_streak, include_groups=False)
print(df)
