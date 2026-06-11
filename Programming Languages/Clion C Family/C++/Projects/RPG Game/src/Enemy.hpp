#include <iostream>
#include "Entity.hpp"
#include "Weapon.hpp"

struct Enemy: public Entity {
    int lives; 
    std::string name;
};

struct Goblin : public Enemy {
    Goblin() {
        health = 10;
        lives = 1;
        attack = 5;
        defense = 5;
        name = "Goblin";
    }
};