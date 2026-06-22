#include <iostream>
#include <sqlite3.h>

#include "src/SQLiteUserRepository.hpp"
#include "src/CustomDBUserRepository.hpp"
#include "src/SessionManager.hpp"
#include "src/AuthService.hpp"
#include "src/Router.hpp"
#include "src/Routes.hpp"
#include "src/Connection.hpp"

int main() {
    // ── 1. Open SQLite (used as fallback/backup) ──────────────────────────
    sqlite3* db = nullptr;
    if (sqlite3_open("users.db", &db) != SQLITE_OK) {
        std::cerr << "[fatal] cannot open SQLite database: "
                  << sqlite3_errmsg(db) << "\n";
        return 1;
    }

    SQLiteUserRepository sqliteRepo(db);
    sqliteRepo.initSchema();   // create table if not exists

    // ── 2. Custom C++ DB as primary, SQLite as fallback ───────────────────
    CustomDBUserRepository::Config dbCfg;
    dbCfg.dbHost    = "127.0.0.1";
    dbCfg.dbPort    = 8080;       // C++ DB server port
    dbCfg.dbName    = "auth";
    dbCfg.tableName = "users";

    // CustomDBUserRepository holds a reference to sqliteRepo for fallback
    CustomDBUserRepository repo(dbCfg, sqliteRepo);

    // ── 3. Build infrastructure ───────────────────────────────────────────
    SessionManager sessions;
    AuthService    auth(repo, sessions);

    // ── 4. Register routes ────────────────────────────────────────────────
    Router router;
    registerRoutes(router, auth, sessions);

    // ── 5. Start HTTP server on port 9090 (DB server uses 8080) ──────────
    Connection server(router, 9090);
    if (!server.start())
        return 1;

    std::cout << "[info] auth server on :9090, custom DB on :8080, SQLite backup: users.db\n";

    server.run();   // blocks forever

    sqlite3_close(db);
    return 0;
}
