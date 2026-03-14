print("Hello i am a simple chatbot")
print("Type 'bye' to stop the chat" )
while True:
      user = input("You: ")
      if user == "Hi":
            print("Bot: Hello what can i do for u")
      elif user == "Good Morning":
           print("Bot: Good Morning")
      elif user == "Bye":
            print("Bot: Bye")
            break
      else:
            print("Bot: I don't Understand")
