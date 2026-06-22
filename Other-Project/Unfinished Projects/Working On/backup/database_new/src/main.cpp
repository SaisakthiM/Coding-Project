#include "Interface.hpp"
#include "FileData.hpp"
#include "ThreadPool.hpp"
#include <iostream>
#include <filesystem>
#include <mutex>

// ── Per-connection handler ────────────────────────────────────────────────────
// Each worker thread gets its own Interface (socket ops) but shares one
// FileData (guarded by dbMutex) so BTree + file state stay consistent.
static void handleClient(int clientFd,
                          FileData&   db,
                          std::mutex& dbMutex)
{
    // Build a minimal Interface just to read/write on this fd
    Interface iface;
    iface.clientSocket = clientFd;

    HttpRequest req = iface.readRequest();
    Route       r   = Interface::route(req);

    std::cout << "[thread " << std::this_thread::get_id() << "] "
              << req.method << " " << req.path << "\n";

    std::string response;
    {
        // Lock for the duration of the DB operation (BTree + file I/O)
        std::lock_guard<std::mutex> lock(dbMutex);

        switch (r) {
            case Route::CREATE: {
                Json body = iface.parseBody(req);
                response  = db.handleCreate(body);
                break;
            }
            case Route::INSERT: {
                Json body = iface.parseBody(req);
                response  = db.handleInsert(body);
                break;
            }
            case Route::SEARCH: {
                Json query = iface.parseQuery(req);
                response   = db.handleSearch(query);
                break;
            }
            case Route::FIELD_SEARCH: {
                Json query = iface.parseQuery(req);
                response   = db.handleFieldSearch(query);
                break;
            }
            case Route::UNKNOWN: {
                response = "";   // send error below
                break;
            }
        }
    }

    if (r == Route::UNKNOWN)
        iface.sendError("Unknown route: " + req.method + " " + req.path);
    else
        iface.sendOk(response);

    iface.closeClient();
}

int main() {
    std::filesystem::create_directories("data");

    FileData   db;
    std::mutex dbMutex;

    // ── Accept loop on the main thread; dispatch to pool ─────────────────
    Interface   listener;
    ThreadPool  pool(4);   // 4 worker threads

    listener.startConnection();
    std::cout << "[info] 4-thread pool running\n";

    while (true) {
        listener.acceptConnection();           // blocks until next client
        int fd = listener.clientSocket;
        listener.clientSocket = -1;            // pool owns the fd now

        pool.submit([fd, &db, &dbMutex]{
            handleClient(fd, db, dbMutex);
        });
    }

    return 0;
}
