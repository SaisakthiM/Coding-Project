"""
Division Example :  if 5/3 output is 1.66

in // or floor division it rounds off and shows the number
 if 5/3 output is 1
  if 5/3 output is 1.66

Modulo ( it is used to print remainder ) : # eg : a = 100
# b = 30
# print(a%b)

format :

# eg : letter = "my name is {} i am from {}"
# name = str(input("ENTER YOUR NAME"))
# country = str(input("ENTER YOUR COUNTRY"))
# print(letter.format(name, country))

__ doc __ :

# eg : def square(n):
#     "hi"
#     print(n**2)
# square(5)
# print(square.__doc__)

lower or upper :

# eg : watch = "titan rolex fasttrack"
# print(watch.lower/upper())

islower / isupper :

# in eg 2 , islower/isupper it checks whether value have lower case/upper case throught and ends result as true or false
# eg 2 : watch = "titan rolex fasttrack"
# print(watch.islower/isupper())

count : #  eg 1 :watch = "titan rolex fasttrack"
# print(watch.count("t"))

# eg 2 : watch = "titan rolex fasttrack"
# print(watch.count("titan"))

# in ex 3 , we can specify the count ara using array digits ("str",start,end)
# eg 3 : watch = "titan rolex fasttrack"
# print(watch.count("u",0,3))


tuples :

concantation :

# eg : v = (1,2,3,4,5,6)
# b = (7,8,9,10,11,12)
# print(v + b)

repetition :

# format : print(a*number of times to repeat)
# eg : v = (1,2,3,4,5,6)
# b = (7,8,9,10,11,12)
# print(v * 3)

in / not in : # eg : v = (1,2,3,4,5,6)
# print(3 in / not in v)

sets :

union() :

# eg : a = {1, 2, 3, 4, 5,}
# b = {5, 6, 7, 8, 9}
# print(a.union(b))

intersection :

# eg : a = {1, 2, 3, 4, 5,}
# b = {5, 6, 7, 8, 9}
# print(a.intersection(b))

difference :

# eg : a = {1, 2, 3, 6, 5,}
# b = {5, 6, 7, 8, 9}
# print(b.difference(a))

dictionary :

items() :

# eg : user = {
#     'name': 'saisakthi',
#     'age': 17,
#     'isalive': True,
#     'height': 14.5
# }
# print(user.items())

keys() :

# eg : user = {
#     'name': 'saisakthi', ['keys' : 'values'
#     'age': 17,
#     'isalive': True,
#     'height': 14.5
# }
# print(user.keys())

values() :

# eg : user = {
#     'name': 'saisakthi',
#     'age': 17,
#     'isalive': True,
#     'height': 14.5
# }
# print(user.values())

get() :

# eg : user = {
#     'name': 'saisakthi',
#     'age': 17,
#     'isalive': True,
#     'height': 14
# print(user.get('name'))

update() :

# eg :
#  user = {
#     'name': 'saisakthi',
#     'age': 17,
#     'isalive': True,
#     'height': 14.5
# }
# user.update(city='chennai')
# print(user)

pop() :

# eg :user = {
#     'name': 'saisakthi',
#     'age': 17,
#      'isalive': True,
#     'height': 14.5
#  }
# user.pop("name")
# print(user)

popitem () :

# eg : user = {
#     'name': 'saisakthi',
#     'age': 17,
#      'isalive': True,
#     'height': 14.5
#  }
# user.popitem()
# print(user)

copy() :

# eg :user = {
#     'name': 'saisakthi',
#     'age': 17,
#     'isalive': True,
#     'height': 14.5
# }
# user1= user.copy()
# print(user1)

fromkeys() :

# eg : name=("sai","sakthi")
# val= ("nil")
# empty = {}
# empty.fromkeys(name,val)
# print(empty)


def roll_dice():
    min_value = 1
    max_value = 6
    roll = random.randint(min_value, max_value)
    return roll


value = roll_dice()
print(value)

while True:
    players = input("Enter number of players: (2 to 4) ")
    if players.isdigit():
        players = int(players)
        if 2 <= players <= 4:
            break
        else:
            print("Please enter a number between 2 to 4")
    else:
        print("Invalid input")
        break

max_score = 50
player_score = [0 for _ in range(players)]
print(player_score)

while max(player_score) < max_score:
    global current_score
    global should_roll
    global player_idx
    while True:
        for player_idx in range(players):
            print("\n Player number", player_idx + 1, "turn has just started!\n")
            current_score = 0
            should_roll = input("Do you want to roll again? (y/n) ")
        if should_roll.lower() != "y":
            break

        value = roll_dice()
        if value == 1:
            print("You rolled a 1! turn done! ")
            current_score = 0
        else:
            current_score += value
            print(f"You rolled a {value}! turn done! ")

        print(f"Your current score is {current_score}")
    player_score[player_idx] += current_score
    print(f"Your Total Score Is {player_score[player_idx]}")


class Solution(object):
    @staticmethod
    def tictactoe(moves):

        tic_tac_toe = [
            ['','',''],
            ['','',''],
            ['','',''],
        ]
        A = [[],[]]
        B = []

        for x, y in enumerate(moves):
            if x % 2 == 0:
                tic_tac_toe[y[0]][y[1]] += 'X'
            else:
                tic_tac_toe[y[0]][y[1]] += 'O'

        result_horizontal = [set(tic_tac_toe[0]),set(tic_tac_toe[1]),set(tic_tac_toe[2])]
        result_vertical = [[set(tic_tac_toe[0][0]),set(tic_tac_toe[1][0]),set(tic_tac_toe[2][0])],
                           [set(tic_tac_toe[0][1]),set(tic_tac_toe[1][1]),set(tic_tac_toe[2][1])],
                           [set(tic_tac_toe[0][2]),set(tic_tac_toe[1][2]),set(tic_tac_toe[2][2])]]

        result_diagonal = [[set(tic_tac_toe[0][0]),set(tic_tac_toe[1][1]),set(tic_tac_toe[2][2])],
                           [set(tic_tac_toe[0][2]),set(tic_tac_toe[1][1]),set(tic_tac_toe[2][0])]]

        result1 = [str(x) for x in  result_horizontal if x == 1]
        result2 = []
        for u in result_vertical:
            for i in u:
                if len(i) == 1:
                    if i == 'X':
                        result2.append("X")
                    else:
                        result2.append("O")
        result3 = []
        for v in result_vertical:
            for a in v:
                if len(a) == 1:
                    if a == 'X':
                        result2.append("X")
                    else:
                        result2.append("O")

        return result1,result2,result3



t = Solution()
o = t.tictactoe([[0,0],[2,0],[1,1],[2,1],[2,2]])
print(o)


"""