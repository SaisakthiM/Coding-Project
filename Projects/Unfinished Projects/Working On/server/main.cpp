#include <iostream>
#include <sqlite3.h>

#include "src/SQLiteUserRepository.hpp"
#include "src/SessionManager.hpp"
#include "src/AuthService.hpp"
#include "src/Router.hpp"
#include "src/Routes.hpp"
#include "src/Connection.hpp"

int main() {
    // ── 1. Open database ──────────────────────────────────────────────────
    sqlite3* db = nullptr;
    if (sqlite3_open("users.db", &db) != SQLITE_OK) {
        std::cerr << "[fatal] cannot open database: "
                  << sqlite3_errmsg(db) << "\n";
        return 1;
    }

    // ── 2. Build infrastructure ───────────────────────────────────────────
    SQLiteUserRepository repo(db);
    repo.initSchema();           // create table if not exists

    SessionManager sessions;
    AuthService    auth(repo, sessions);

    // ── 3. Register routes ────────────────────────────────────────────────
    Router router;
    registerRoutes(router, auth, sessions);

    // ── 4. Start server ───────────────────────────────────────────────────
    Connection server(router, 8080);
    if (!server.start())
        return 1;

    server.run();   // blocks forever

    sqlite3_close(db);
    return 0;
}
