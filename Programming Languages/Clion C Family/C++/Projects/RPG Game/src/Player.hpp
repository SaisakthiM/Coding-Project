#include <iostream>
#include <memory>
#include <vector>
#include "Entity.hpp"
#include "Weapon.hpp"
#include "Item.hpp"



struct Player : public Entity {
    int health = 100;
    int lives = 3;
    int attack = 10;
    int defense = 10;
    std::string name;
    std::unique_ptr<Weapon> weapon;
    std::vector<std::unique_ptr<Item>> inventory;
};

