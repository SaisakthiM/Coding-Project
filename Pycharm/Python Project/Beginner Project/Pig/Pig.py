import time
import random

class Instructions:
    @staticmethod
    def instructions():
        k = """This is a game called Pig.
        In this Game, A player can choose how much times he wants to roll the dice
        There will be an counter which add the score when you hit number other than 1
        If you hit 1 , the counter resets to 0
        This game can be played by multiple players.
        Whoever has the highers score among players wins"""
        return k

class Pig(Instructions):
    max_score = 0
    player_count = 0
    def game(self):
        player_score = 0
        print(Pig.instructions())
        s = int(input("How many players you want : "))
        time.sleep(1)
        for x in range(1,s+1):
            l = f"This is player {x}, How many times do you want to roll the dice : "
            t = int(input(l))
            time.sleep(1)
            for y in range(s+1):
                dies = random.randint(1,6)
                if dies == 1:
                    player_score = 0
                    time.sleep(0.7)
                    print("You are Restarting...")
                    time.sleep(0.7)
                    print(f"Your Current Score is {player_score}")
                else:
                    player_score += dies
                    print(f"Your number is : {dies}")
                    time.sleep(0.7)
                    print(f"Your Current Score is {player_score}")
                    time.sleep(0.7)
            if player_score > self.max_score:
                self.max_score = player_score
                self.player_count = x
            time.sleep(1)
        time.sleep(2)
        print(f"The current player with the max score is : {self.max_score}")
        print(f"""The winner of the game player no : {self.player_count}
The Highest Score is : {self.max_score}""")

game = Pig()
game.game()