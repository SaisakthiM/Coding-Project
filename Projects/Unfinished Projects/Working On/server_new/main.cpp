#include <iostream>
#include <sqlite3.h>

#include "src/SQLiteUserRepository.hpp"
#include "src/CustomDBUserRepository.hpp"
#include "src/SessionManager.hpp"
#include "src/AuthService.hpp"
#include "src/Router.hpp"
#include "src/Routes.hpp"
#include "src/Connection.hpp"
#include "src/HistoryClient.hpp"

int main() {
    // ── 1. SQLite backup ──────────────────────────────────────────────────
    sqlite3* db = nullptr;
    if (sqlite3_open("users.db", &db) != SQLITE_OK) {
        std::cerr << "[fatal] cannot open SQLite: " << sqlite3_errmsg(db) << "\n";
        return 1;
    }
    SQLiteUserRepository sqliteRepo(db);
    sqliteRepo.initSchema();

    // ── 2. Custom DB as primary user store ────────────────────────────────
    CustomDBUserRepository::Config dbCfg;
    dbCfg.dbHost    = "127.0.0.1";
    dbCfg.dbPort    = 8080;
    dbCfg.dbName    = "auth";
    dbCfg.tableName = "users";
    CustomDBUserRepository repo(dbCfg, sqliteRepo);

    // ── 3. History client (also talks to DB server on 8080) ───────────────
    HistoryClient::Config hCfg;
    hCfg.host = "127.0.0.1";
    hCfg.port = 8080;
    HistoryClient history(hCfg);

    // ── 4. Auth + session ─────────────────────────────────────────────────
    SessionManager sessions;
    AuthService    auth(repo, sessions);

    // ── 5. Routes ─────────────────────────────────────────────────────────
    Router router;
    registerRoutes(router, auth, sessions, history);

    // ── 6. Start (auth server on 9090, DB server on 8080) ─────────────────
    Connection server(router, 9090, 4);
    if (!server.start()) return 1;

    std::cout << "[info] auth server :9090 | custom DB :8080 | SQLite backup: users.db\n";
    server.run();

    sqlite3_close(db);
    return 0;
}
