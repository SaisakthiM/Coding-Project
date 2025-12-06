import time



class Adventure:
    name = input("This is Your Adventure Game. Enter Your Name : ")
    if name.isalnum():
        print(f"Welcome, {name}. This Adventure is a single player mode.")
    else:
        print("You cannot enter Special character in names. Try again")



class Path(Adventure):
    time.sleep(1)
    print("")
    print(f"Hello {Adventure.name}, This is going to be your pathway for adventure. \n"
          "1) Jungle with Animals\n"
          "2) Dessert without water for 2 days \n"
          "3) Warzone without protection \n"
          "4) Urban area without money \n"
          "5) Secret Underground City with final treasure")
    k = input("Can We Start (Type Yes) : ")

class Jungle(Adventure):
    time.sleep(1)
    print("")
    lives = 3
    crossed = 0
    while lives != 0 and crossed != 5:
        print("We are now landed in an jungle. These are the rules : \n"
              "You have 3 lives,\n"
              "if it runs out you have to restart your adventure\n"
              "You will be asked to either kill or run away from an dangerous animal.\n"
              "and either hunt or ignore an domestic animal.\n"
              "You Will be asked 5 Question and after each Question, You will cross 1 km safely.\n"
              "Your Next Destination is after 5 km\n")
        time.sleep(3)
        print("")
        print("")
        o = input(f"Are You Ready, {Adventure.name} (Type Y/N) : ")
        time.sleep(1)
        print("")
        if o.upper() == "Y":
            a = input(f"Your First Question, Mr,{Adventure.name} :\n"
                      "You spotted an lion now,\n"
                      "Do you want to run or throw some food and escape\n"
                      "For option 'run' choose 'R'\n "
                      "For option 'throw', choose 'T'\n"
                      "Enter your option : ")
            if a.upper() == "T":
                print("You are right, \n"
                      "Reason : Lions can run upto 50km/h which make it impossible to escape from running.\n"
                      "So the wise choice was to distract the lion and escape from its eating gap.\n"
                      "You can proceed to next question\n")
                crossed += 1
            elif a.upper() == "R":
                print("You are wrong, \n"
                      "Reason : Lions can run upto 50km/h which make it impossible to escape from running.\n"
                      "You lost an life, :(\n")
                lives -= 1
            else:
                print("You have entered an wrong option. Please enter right option.")
                continue

            print("")

            time.sleep(1)

            b  = input(f"Your Second Question, Mr,{Adventure.name} :\n"
                          "You spotted an deer now,\n"
                          "Do you want to ignore or hunt and eat some food\n"
                          "For option 'ignore' choose 'I' \n"
                          "For option 'hunt', choose 'H'\n"
                          "Enter your option : ")
            if b.upper() == "H":
                print("You are right, "
                      "Reason : As you fed the lion to escape ,, you are insufficient of food. \n"
                      "So the wise choice was to hunt and eat the deer.\n"
                      "You can proceed to next question\n")
                crossed += 1
            elif b.upper() == "I":
                print("You are wrong, "
                      "Reason : As you fed the lion, if you ignore the food, you would starve for the upcoming path and die."
                      "You lost an life, :(")
                lives -= 1
            else:
                print("You have entered an wrong option. Please enter right option.")
                continue

            print("")

            time.sleep(1)


            c  = input(f"Your Third Question, Mr,{Adventure.name} :\n"
                       "You spotted an domestic dog abandoned now,\n"
                       "Do you want to ignore or pet and make it as a travel partner\n"
                       "For option 'ignore' choose 'I' \n"
                       "For option 'part', choose 'P'\n"
                       "Enter your option : ")
            if c.upper() == "P":
                print("You are right, "
                      "Reason : As you got some bones from the deer from hunting, you will not waste any food . \n"
                      "As dogs have powerful smell, it can lead you in right direction.\n"
                      "You can proceed to next question\n")
                crossed += 1
            elif c.upper() == "I":
                print("You are wrong, "
                      "Reason : As you got some bones from the deer from hunting, you will not waste any food\n"
                      "You ignored an opportunity to use the dog as an powerful tracker to lead you to right direction\n"
                      "You lost an life, :(")
                lives -= 1
            else:
                print("You have entered an wrong option. Please enter right option.")
                continue

            print("")

            time.sleep(1)

            d = input(f"Your Fourth Question, Mr,{Adventure.name} :\n"
                       "You spotted an snake. ,\n"
                       "Do you want to ignore or hunt it using dogs\n"
                       "For option 'ignore' choose 'I' \n"
                       "For option 'hunt', choose 'H'\n"
                       "Enter your option : ")
            if d.upper() == "H":
                print("You are right, "
                      "Reason : As dogs can kill snakes, you dog will not be poisoned in this processed . \n"
                      "As snakes venom is in its sack, it can be cut and used to hunt big animals.\n"
                      "You can proceed to next question\n")
                crossed += 1
            elif d.upper() == "I":
                print("You are wrong, "
                      "Reason : As dogs can kill snakes, you dog will not be poisoned in this processedd\n"
                      "You ignored an opportunity to use venom is in its sack, it can be cut and used to hunt big animals\n"
                      "You lost an life, :(")
                lives -= 1
            else:
                print("You have entered an wrong option. Please enter right option.")
                continue

            print("")

            time.sleep(1)

            e = input(f"Your Final Question, Mr,{Adventure.name} :\n"
                      "You spotted an Leopard. ,\n"
                      "Do you want to run or apply the poison in the dogs mouth and let it bite leopard\n"
                      "For option 'run' choose 'R' \n"
                      "For option 'poison', choose 'P'\n"
                      "Enter your option : ")
            if e.upper() == "P":
                print("You are right, "
                      "Reason : As dogs can survive poison after 12 hours of ingestion, \n"
                      "we can save the dogs if it escapes form leopard . \n"
                      "It can also give time for us to escape but the dog would die\n"
                      "That the law of nature. Hunt or get Hunted\n"
                      "You Finished the Question\n")
                crossed += 1
            elif e.upper() == "R":
                print("You are wrong, "
                      "Reason : Leopard is one of the fastest animals in running\n"
                      "No human can run away from it. You would die\n"
                      "You lost an life, :(")
                lives -= 1
            else:
                print("You have entered an wrong option. Please enter right option.")
                continue

            print(crossed)

            print("")

            time.sleep(1)

        print("")
        print("")
        if lives == 0:
            print(f"You lost the game, {Adventure.name}. Crossed {crossed}km")
        else:
            print(f"Congrats, {Adventure.name}, You crossed {crossed}km and Qualified for next destination")










