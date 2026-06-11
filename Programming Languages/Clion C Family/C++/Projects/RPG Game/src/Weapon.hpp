#pragma once
#include <string>
#include "Item.hpp"

struct Weapon : public Item {
    virtual ~Weapon() = default;
    virtual int getAttackBoost() const = 0;
};

struct Sword : public Weapon {
    int attackBoost = 5;

    int getAttackBoost() const override {
        return attackBoost;
    }
};

struct Axe : public Weapon {
    int attackBoost = 9;

    int getAttackBoost() const override {
        return attackBoost;
    }
};

struct Bow : public Weapon {
    int attackBoost = 3;

    int getAttackBoost() const override {
        return attackBoost;
    }
};

