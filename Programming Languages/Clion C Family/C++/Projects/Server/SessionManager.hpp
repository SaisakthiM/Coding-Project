
#include <string>
#include <random>
#include <unordered_map>
#pragma once
class SessionManager {

private:
    std::unordered_map<
        std::string,
        std::string
    > sessions;

public:


std::string generateToken() {

    static const std::string chars =
        "0123456789"
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        "abcdefghijklmnopqrstuvwxyz";

    std::random_device rd;
    std::mt19937 gen(rd());

    std::uniform_int_distribution<> dist(
        0,
        chars.size() - 1
    );

    std::string token;

    for(int i = 0; i < 32; i++) {
        token += chars[dist(gen)];
    }

    return token;
}

    std::string createSession(
        const std::string& username
    ) {

        std::string token =
            generateToken();

        sessions[token] =
            username;

        return token;
    }

    bool exists(
        const std::string& token
    ) {

        return sessions.count(token);
    }

    std::string getUser(
        const std::string& token
    ) {

        return sessions[token];
    }
};