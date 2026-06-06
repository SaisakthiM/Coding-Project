#include "Hash.hpp"
#include "UserRepository.hpp"
#include "AuthRequest.hpp"
#include "AuthResponse.hpp"
#include "SessionManager.hpp"

class AuthService {
private:
    UserRepository& repo;
    SessionManager sessionManager;

public:
    AuthService(UserRepository& repo)
        : repo(repo) {}

    AuthResponse registerUser(AuthRequest req) {
        if (repo.userExists(req.username)) {
            return {
                false,
                "User already exists"
                ,nullptr
            };
        }

        Hash h;

        User user{
            req.username,
            static_cast<int>(
                h.findHash(req.password)
            )
        };

        bool created =
            repo.createUser(user);
        
        std::string token =
        sessionManager.createSession(
            req.username
        );

        if (created) {
            return {
                true,
                "User created",
                token
            };
        }

        return {
            false,
            "Database error",
            ""
        };
    }

    AuthResponse login(AuthRequest req) {
        if (!repo.userExists(req.username))
            return {false ,"username or password wrong",""};

        Hash h;

        User user = repo.findUser(req.username);
        std::string token =
        sessionManager.createSession(
            req.username
        );

        return {user.passwordHash == h.findHash(req.password), "login successful", token};
    }
};