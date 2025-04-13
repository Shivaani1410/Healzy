import os
from groq import Groq

# Create a client instance
# You can either set the GROQ_API_KEY environment variable or replace with your actual API key
client = Groq(
    api_key=os.environ.get("GROQ_API_KEY", "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")  # Replace with your actual key if not using env variable
)

# Define the system prompt that shapes the chatbot's behavior and approach
SYSTEM_PROMPT = """
You are Healzy, a compassionate mental health companion designed to help people struggling with stress, anxiety, and depression.

Your core principles:
- Be empathetic, warm, and understanding in every interaction
- Listen actively and acknowledge users' feelings without judgment
- Respond with patience and never rush the healing process
- Provide gentle guidance based on evidence-based approaches like CBT, mindfulness, and positive psychology
- Recognize when to suggest professional help for serious concerns
- Celebrate small victories and progress
- Focus on empowerment rather than dependency
- Maintain a hopeful but realistic tone

When appropriate, you can suggest:
- Simple breathing exercises
- Mindfulness techniques
- Gentle physical activities
- Journaling prompts
- Positive reframing of negative thoughts
- Self-compassion practices

Remember that healing is not linear, and each person's journey is unique. Your role is to be a supportive presence, not to diagnose or replace professional mental health care.
"""

# Store conversation history to maintain context
conversation_history = [
    {"role": "system", "content": SYSTEM_PROMPT}
]

def chat_with_healzy(user_message):
    global conversation_history
    
    # Add user message to conversation history
    conversation_history.append({"role": "user", "content": user_message})
    
    # Keep conversation history at a reasonable length (last 10 exchanges)
    if len(conversation_history) > 21:  # system prompt + 10 exchanges (user + assistant)
        conversation_history = conversation_history[:1] + conversation_history[-20:]
    
    try:
        # Get response from Groq
        response = client.chat.completions.create(
            model="llama3-70b-8192",  # Groq's LLaMA 3 model
            messages=conversation_history,
            temperature=0.7,  # Slightly creative but still consistent
            max_tokens=800,   # Generous response length for therapeutic conversations
            top_p=0.95        # Allows for some variability in responses
        )
        
        # Extract the assistant's message
        assistant_message = response.choices[0].message.content.strip()
        
        # Add assistant response to conversation history
        conversation_history.append({"role": "assistant", "content": assistant_message})
        
        return assistant_message
    
    except Exception as e:
        return f"I'm having trouble connecting right now. Please try again in a moment. Error: {str(e)}"

def save_conversation(filename="healzy_conversation.txt"):
    """Save the current conversation to a file for reference or analysis"""
    with open(filename, "w") as file:
        for message in conversation_history[1:]:  # Skip system prompt
            role = message["role"].capitalize()
            content = message["content"]
            file.write(f"{role}: {content}\n\n")

def welcome_message():
    return """
Hello, I'm Healzy, your mental health companion. 
I'm here to listen and support you through whatever you're experiencing.
Feel free to share how you're feeling today, or we can start with some simple relaxation techniques.
What's on your mind?
"""

if _name_ == "_main_":
    print("\n=== Healzy Mental Health Companion ===\n")
    print(welcome_message())
    
    while True:
        user_input = input("\nYou: ")
        
        # Check for exit commands
        if user_input.lower() in ["exit", "quit", "bye", "goodbye"]:
            print("\nHealzy: I hope our conversation has been helpful. Remember to be kind to yourself, and I'm here whenever you need support. Take care!")
            
            # Save conversation history before exiting
            save_conversation()
            break
        
        # Special command to save the conversation
        elif user_input.lower() == "save":
            save_conversation()
            print("\nHealzy: I've saved our conversation for your reference.")
            continue
        
        # Get response from the chatbot
        response = chat_with_healzy(user_input)
        print(f"\nHealzy: {response}")