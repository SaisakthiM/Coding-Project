#include <sqlite3.h>
#include "UserRepository.hpp"

class SQLiteUserRepository : public UserRepository {
private:
    sqlite3* db;

public:
    SQLiteUserRepository(sqlite3* db)
        : db(db) {}

    bool createUser(const User& user);

    bool userExists(const std::string& username);

    User findUser(const std::string& username);
};