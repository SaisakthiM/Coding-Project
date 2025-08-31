import random

num = random.randint(1,10)
k = int(input("This is guessing game. Enter a Number (1-10) : "))
guesses = 0

while k != num:
    guesses += 1
    print(f"""You guessed it wrong . the number you guessed : {k}
    The number Computer guessed : {num}""")

    k = int(input("This is guessing game. Enter a Number (1-10) : "))
    num = random.randint(1,10)

print(f"""You guessed it right . the number you guessed : {k}
The number Computer guessed : {num}
The number of guesses took : {guesses}""")
