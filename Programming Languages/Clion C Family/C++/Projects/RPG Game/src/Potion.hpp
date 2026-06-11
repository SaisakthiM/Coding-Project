#include "Item.hpp"
#include <string>

struct Potion : public Item {
    std::string getType() const override {
        return "Potion";
    }
};

