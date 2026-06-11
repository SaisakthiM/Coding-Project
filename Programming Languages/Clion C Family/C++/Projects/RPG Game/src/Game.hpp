#include <iostream>
#include "Random.hpp"
#include "Player.hpp"
#include "Enemy.hpp"
#include "Weapon.hpp"
#include <memory>

struct Game {

    Player player;
    Enemy enemy;

    bool instructions() {
        std::cout << "This is a RPG Game." << std::endl;
        std::cout << "You have" << std::endl;
        std::cout << "1) 100 Health" << std::endl;
        std::cout << "2) 3 Lives" << std::endl;
        std::cout << "3) 10 Defense" << std::endl;
        std::cout << "3) 10 Attack" << std::endl;
        std::cout << "These are your starting point. As you progress, You gain more resources and stronger opponents" << std::endl;
        std::cout << "Are You Ready (y/n)" << std::endl;
        std::string result;
        std::cin >> result;
        if (result == "yes" or result == "y") {
            return true;
        }
        else {
            return false;
        }
    }
    std::string getName(bool result) {
        if (!result) {
            return "";
        }
        std::cout << "You are good to start, What is your name: ";
        std::string name;
        std::cin >> name;
        return name;
    }
    std::string quest1() {
        std::cout << "You encounter your first enemy" << std::endl;
        std::cout << "This is a Goblin. So here are the options and consequences" << std::endl;
        std::cout << "1) Fight: 50/50 Win and 50/50 You get a weapon which boost attack by 5" << std::endl;
        std::cout << "2) Defend: You will not lose your health but Defense is reduced by 5" << std::endl;
        std::cout << "3) Run: 50/50 chance of getting caught and losing your health by 20" << std::endl;
        std::cout << "what do you choose : " << std::endl;
        std::string result;
        std::cin >> result;

        Goblin goblin;

        double playerPower =
            player.health +
            player.attack +
            player.defense;

        double enemyPower =
            goblin.health +
            goblin.attack +
            goblin.defense;

        double winrate = playerPower / (playerPower+enemyPower);

        if (result == "Attack" or result == "attack") {
            Random random;
            double number = random.random_double();
            double weapon = random.random_double();
            if (number > winrate) {
                std::cout << "You lost to Goblin.\n";
                player.health -= 10;
            }
            else {
                if (weapon < 0.5) {
                    std::cout << "You won against Goblin but found no weapon.\n";
                }
                else {
                    std::cout << "You won against Goblin and found a sword.\n";
                    int value = Sword().getAttackBoost();
                    player.weapon = std::make_unique<Sword>();
                }
            }
        }
    }
};