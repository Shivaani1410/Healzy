def ask_question(question, option_a, option_b):
    print("\n" + question)
    print("A:", option_a)
    print("B:", option_b)
    while True:
        answer = input("Your answer (A/B): ").strip().upper()
        if answer in ['A', 'B']:
            return answer
        else:
            print("Please choose A or B.")

def main():
    print("🧸 Welcome to Healzy's Fun Personality Quiz!")
    print("Just choose the answer that sounds more like you.\n")

    # Initialize counters
    E, I, S, N, T, F, J, P = 0, 0, 0, 0, 0, 0, 0, 0

    # Extrovert vs Introvert
    if ask_question("1. When you're tired, what helps you feel better?",
                    "Talking to someone or playing with friends",
                    "Being alone, reading, or watching something quietly") == 'A':
        E += 1
    else:
        I += 1

    if ask_question("2. At a birthday party, you usually...",
                    "Talk to lots of people and have fun everywhere",
                    "Stick with a few close friends or play by yourself") == 'A':
        E += 1
    else:
        I += 1

    if ask_question("3. In a group game, you like to...",
                    "Be the leader or take charge",
                    "Help quietly or play your own part") == 'A':
        E += 1
    else:
        I += 1

    # Sensing vs Intuition
    if ask_question("4. Do you like stories that are...",
                    "Real and simple",
                    "Full of imagination or magic") == 'A':
        S += 1
    else:
        N += 1

    if ask_question("5. When learning something new, you like...",
                    "Step by step with examples",
                    "Big ideas and fun facts") == 'A':
        S += 1
    else:
        N += 1

    if ask_question("6. You mostly talk about...",
                    "What’s happening now",
                    "What could happen or cool dreams") == 'A':
        S += 1
    else:
        N += 1

    # Thinking vs Feeling
    if ask_question("7. When you solve a problem, you use...",
                    "Your brain – what makes sense",
                    "Your heart – how people feel") == 'A':
        T += 1
    else:
        F += 1

    if ask_question("8. If someone is sad, you...",
                    "Help them fix the problem",
                    "Try to make them feel better") == 'A':
        T += 1
    else:
        F += 1

    if ask_question("9. People say you are...",
                    "Smart and fair",
                    "Kind and caring") == 'A':
        T += 1
    else:
        F += 1

    # Judging vs Perceiving
    if ask_question("10. Do you like to...",
                    "Plan everything ahead",
                    "Do things when you feel like it") == 'A':
        J += 1
    else:
        P += 1

    if ask_question("11. Homework time is...",
                    "Now. I do it early",
                    "Later. I’ll do it when I feel ready") == 'A':
        J += 1
    else:
        P += 1

    if ask_question("12. Going on a trip, you...",
                    "Pack your bag and make a plan",
                    "Just go! Figure it out as you go") == 'A':
        J += 1
    else:
        P += 1

    # Determine MBTI
    mbti = ""
    mbti += "E" if E > I else "I"
    mbti += "S" if S > N else "N"
    mbti += "T" if T > F else "F"
    mbti += "J" if J > P else "P"

    print("\n🎉 All done! You are a:", mbti)
    show_description(mbti)

def show_description(mbti):
    descriptions = {
        "INTJ": "🧠 The Mastermind – You like to think deeply and make plans.",
        "INTP": "💡 The Thinker – You enjoy solving puzzles and asking 'why'.",
        "ENTJ": "🚀 The Leader – You like organizing and getting things done.",
        "ENTP": "🎭 The Explorer – You're curious and full of ideas.",
        "INFJ": "🌈 The Helper – You care a lot and want to make the world better.",
        "INFP": "🎨 The Dreamer – You feel deeply and imagine big things.",
        "ENFJ": "🤗 The Cheerleader – You lift others up and spread kindness.",
        "ENFP": "🌟 The Free Spirit – You’re fun, energetic, and full of dreams.",
        "ISTJ": "📘 The Organizer – You like order, rules, and doing things right.",
        "ISFJ": "🛡️ The Protector – You take care of others and stay loyal.",
        "ESTJ": "📋 The Boss – You like leading and keeping things on track.",
        "ESFJ": "💖 The Caregiver – You enjoy helping and being with people.",
        "ISTP": "🔧 The Fixer – You like building or figuring out how stuff works.",
        "ISFP": "🎵 The Artist – You’re quiet, kind, and love beauty and peace.",
        "ESTP": "🎮 The Doer – You act fast and enjoy adventure.",
        "ESFP": "🎉 The Entertainer – You love fun, friends, and excitement!",
    }

    print(descriptions.get(mbti, "You're awesome, whatever your type is! 😊"))

if __name__ == "__main__":
    main()
