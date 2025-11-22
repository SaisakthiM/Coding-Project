#include <iostream>
#include <string>
#include <random>
#include <ctime>
typedef std::string String;


class RPS_Game{
    public:
        String User_Selection;
        void User_Print(){
            std::cout << "*******************************" << std::endl;
            std::cout << "This is Rock Paper Scissor Game" << std::endl;
            std::cout << "*******************************" << std::endl;
            printf(" ");
            std::cout << "Options are,: " << std::endl;
            std::cout << "1. Rock" << std::endl;
            std::cout << "2. Paper" << std::endl;
            std::cout << "3. Scissor" << std::endl;
            printf(" ");

        }
        String Get_User_Choice(){
            
            printf("Please enter your choice : ");
            std::cin >> User_Selection;

            return User_Selection;

        }
        String Computer_Choice(){
            srand(time(nullptr));
            String Computer_Choice;

            int choice = rand() % 3;

            switch (choice){
                case 1:
                    return "Rock";
                    break;
                case 2:
                    return "Paper";
                    break;
                case 3:
                    return "Scissor";
                    break;
            }
        }
        void Result(){

            String User = User_Selection;
            String Computer = Computer_Choice();
            std::cout << "User Choice: " << User << std::endl;
            std::cout << "Computer Choice: " << Computer << std::endl;

            if (User == Computer){
                std::cout << "It's a Tie!" << std::endl;
            } else if ((User == "Rock" && Computer == "Scissor") || (User == "Paper" && Computer == "Rock") || (User == "Scissor" && Computer == "Paper")){
                std::cout << "You Win!" << std::endl;
            } else if ((User == "Rock" && Computer == "Paper") || (User == "Paper" && Computer == "Scissor") || (User == "Scissor" && Computer == "Rock")){
                std::cout << "You Lose!" << std::endl;
            } else {
                std::cout << "Invalid Input!" << std::endl;
            }

    }
};

int main(){
    RPS_Game game;
    game.User_Print();
    game.Get_User_Choice();
    game.Computer_Choice();
    game.Result();
    
}

