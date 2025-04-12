
from twilio.rest import Client
import time

# Twilio credentials
account_sid = 'AC9a91bacb3180b891414cb9f6dfaba112'
auth_token = '9e4a96c59414b632e820cba7fab3a193'
client = Client(account_sid, auth_token)

# Numbers
to_number = '+91 7806934534'       # The friend's/family's number (must be verified on trial)
from_number = '+15153556602'  # Your Twilio number (SMS + voice enabled)

# Step 1: Send SMS Notification
sms = client.messages.create(
    body="You’ve been chosen as a trusted emergency contact by someone who uses our mental wellness platform.We want to inform you that you’ll be receiving an  international call shortly to discuss their well-being.Thank you for being there for them.— Team Healzy",
    from_=from_number,
    to=to_number
)

print("SMS sent:", sms.sid)

# Optional: Wait 10 seconds before making the call
time.sleep(10)

# Step 2: Make the Call
message = "Hi there. You're receiving this call from Healzy.Right now, they may be going through a difficult moment.We kindly urge you to please check on them in person as soon as possible and ensure they are safe.Your support can make a big difference."



twiml_response = f"""<Response>
    <Say voice="alice" language="en-US">{message}</Say>
</Response>"""

call = client.calls.create(
    twiml=twiml_response,
    to=to_number,
    from_=from_number
)

print("Call initiated:", call.sid)


