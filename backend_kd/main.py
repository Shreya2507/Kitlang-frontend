from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# Adding CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  
    allow_credentials=True,
    allow_methods=["*"], 
    allow_headers=["*"],  
)

# Predefined responses for the food ordering process
responses = {
    "welcome": "Hello! Welcome to our restaurant pal! What would you like to order today?",
    "pizza_order": "Sure! What toppings would you like on your pizza?",
    "toppings": "Got it! Your pizza will have {toppings}. Would you like to add any drinks or desserts?",
    "final_confirmation": "You're welcome! Enjoy your meal. Let me know if you need anything else.",
    "default": "Sorry, I didn't quite catch that. Could you please clarify?",
}

# Pydantic model to define the structure of user input
class UserMessage(BaseModel):
    message: str = Field(..., min_length=1, description="The message from the user")

@app.get("/")
async def read_root():
    return {"message": "hello"}

# API Endpoint for food ordering conversation
@app.post("/food-ordering/")
async def food_ordering(user_message: UserMessage):
    # Check for missing or empty message
    user_input = user_message.message.strip().lower()  # Ensure we remove leading/trailing whitespace

    # If the input is empty after stripping, return the welcome message
    if not user_input:
        return {"response": responses["welcome"]}

    # Logic to determine the response based on user input
    if "hello" in user_input or "hi" in user_input:
        return {"response": responses["welcome"]}

    elif "pizza" in user_input:
        return {"response": responses["pizza_order"]}

    elif "toppings" in user_input:
        # Here we don't specify specific toppings but continue the conversation
        toppings = "your selected toppings"  
        return {"response": responses["toppings"].format(toppings=toppings)}

    elif "no" in user_input or "nothing" in user_input:
        return {"response": responses["final_confirmation"]}

    else:
        return {"response": responses["default"]}

# Run the FastAPI app
