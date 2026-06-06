#include <string>
#pragma once

struct AuthResponse {
    bool success;
    std::string message;
    std::string token;
};