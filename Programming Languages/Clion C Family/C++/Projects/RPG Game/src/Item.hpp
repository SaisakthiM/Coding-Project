#include <algorithm>
#include <iostream>
#include <vector>
#pragma once

struct Item {
    virtual std::string getType() const = 0;
    virtual ~Item() = default;
};


