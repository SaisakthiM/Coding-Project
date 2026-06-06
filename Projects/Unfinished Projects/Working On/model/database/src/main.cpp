#include "Interface.hpp"
#include "FileData.hpp"
#include <iostream>
#include <filesystem>

int main() {
    // ensure data/ root exists
    std::filesystem::create_directories("data");

    Interface iface;
    FileData  db;

    iface.startConnection();

    while (true) {
        iface.acceptConnection();

        HttpRequest req  = iface.readRequest();
        Route       r    = Interface::route(req);

        std::cout << req.method << " " << req.path << "\n";

        std::string response;

        switch (r) {
            case Route::CREATE: {
                Json body = iface.parseBody(req);
                response  = db.handleCreate(body);
                iface.sendOk(response);
                break;
            }
            case Route::INSERT: {
                Json body = iface.parseBody(req);
                response  = db.handleInsert(body);
                iface.sendOk(response);
                break;
            }
            case Route::SEARCH: {
                Json query = iface.parseQuery(req);
                response   = db.handleSearch(query);
                iface.sendOk(response);
                break;
            }
            case Route::UNKNOWN: {
                iface.sendError("Unknown route: " + req.method + " " + req.path);
                break;
            }
        }

        iface.closeClient();
    }

    return 0;
}
