#include <string>
#include "User.hpp"

class UserRepository {
public:
    virtual bool createUser(const User& user) = 0;
    virtual bool userExists(const std::string& username) = 0;
    virtual User findUser(const std::string& username) = 0;
};