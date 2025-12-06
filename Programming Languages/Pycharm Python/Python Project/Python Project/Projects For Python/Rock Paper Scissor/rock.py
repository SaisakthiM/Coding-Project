import random
import time

o = int(input("This is Rock,Paper,Scissor Game. Enter How many times you want to play : "))

def rock_paper_scissor_game(p):
    score_user = 0
    score_comp = 0

    while p > 0:
        time.sleep(1)
        print("")
        k = input("This is Rock,Paper,Scissor Game. Enter your Choice : ")
        res = ["Rock","Paper","Scissor"]
        ans = random.choice(["Rock","Paper","Scissor"])

        k.capitalize()

        while k not in res:
            print("You have entered wrong choice. enter again")
            k = input("This is Rock,Paper,Scissor Game. Enter your Choice : ")
            print("")


        if ans == k:
            print("Its a tie")
            time.sleep(1)


        elif ans == "Rock" and k == "Scissor":
            score_comp += 1
            time.sleep(1)
            print("You lost a point.\n"
                  f"Your ans : {k}\n"
                  f"Computer ans : {ans}")
        elif ans == "Scissor"and k == "Rock":
            score_user += 1
            time.sleep(1)
            print("You won a point.\n"
                  f"Your ans : {k}\n"
                  f"Computer ans : {ans}")


        elif ans == "Paper" and k == "Rock":
            score_comp += 1
            time.sleep(1)
            print("You lost a point.\n"
                  f"Your ans : {k}\n"
                  f"Computer ans : {ans}")
        elif ans == "Rock" and k == "Paper":
            score_user += 1
            time.sleep(1)
            print("You won a point.\n"
                  f"Your ans : {k}\n"
                  f"Computer ans : {ans}")


        elif ans == "Paper" and k == "Scissor":
            score_comp += 1
            time.sleep(1)
            print("You lost a point.\n"
                  f"Your ans : {k}\n"
                  f"Computer ans : {ans}")
        elif ans == "Scissor" and k == "Paper":
            score_user += 1
            time.sleep(1)
            print("You won a point.\n"
                  f"Your ans : {k}\n"
                  f"Computer ans : {ans}")

        p -= 1

    print("")
    print("The Final score. \n"
          f"Your Score agains Computer : {score_comp} \n"
          f"Computer score against You : {score_user}")


rock_paper_scissor_game(o)


