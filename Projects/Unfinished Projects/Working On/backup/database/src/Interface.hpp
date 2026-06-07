#pragma once
#include <string>
#include <cstring>
#include <iostream>
#include <netinet/in.h>
#include <sys/socket.h>
#include <unistd.h>
#include "HttpParser.hpp"
#include "HttpRequest.hpp"
#include "Json.hpp"

// ── Routes ──────────────────────────────────────────────────────────────────
// POST /create  → create database + table
// POST /insert  → insert a row (type-validated)
// GET  /search  → search by id  (?database_name=&table_name=&id=)

enum class Route { CREATE, INSERT, SEARCH, UNKNOWN };

struct Interface {
private:
    int         serverSocket;
    sockaddr_in serverAddress;
    HttpParser  parser;
    JsonParser  jsonParser;

public:
    int clientSocket = -1;  // set each accept loop

    void startConnection() {
        serverSocket = socket(AF_INET, SOCK_STREAM, 0);

        // allow quick restart without "address already in use"
        int opt = 1;
        setsockopt(serverSocket, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));

        serverAddress.sin_family      = AF_INET;
        serverAddress.sin_port        = htons(8080);
        serverAddress.sin_addr.s_addr = INADDR_ANY;
        bind(serverSocket, (struct sockaddr*)&serverAddress, sizeof(serverAddress));
        listen(serverSocket, 5);
        std::cout << "DB server listening on :8080\n";
    }

    // Blocks until next connection arrives; sets clientSocket.
    void acceptConnection() {
        clientSocket = accept(serverSocket, nullptr, nullptr);
    }

    void closeClient() {
        if (clientSocket >= 0) {
            close(clientSocket);
            clientSocket = -1;
        }
    }

    // Parse the incoming HTTP request
    HttpRequest readRequest() {
        return parser.parseRequest(clientSocket);
    }

    // Map path → Route enum
    static Route route(const HttpRequest& req) {
        if (req.path == "/create" && req.method == "POST") return Route::CREATE;
        if (req.path == "/insert" && req.method == "POST") return Route::INSERT;
        if (req.path == "/search" && req.method == "GET")  return Route::SEARCH;
        return Route::UNKNOWN;
    }

    // Parse the JSON body
    Json parseBody(const HttpRequest& req) {
        return jsonParser.parse(req.body);
    }

    // Parse query string key=value&key=value into a Json
    Json parseQuery(const HttpRequest& req) {
        Json json;
        std::string q = req.query;
        size_t i = 0;
        while (i < q.size()) {
            size_t eq  = q.find('=', i);
            if (eq == std::string::npos) break;
            size_t amp = q.find('&', eq);
            std::string key = q.substr(i, eq - i);
            std::string val = (amp == std::string::npos)
                              ? q.substr(eq + 1)
                              : q.substr(eq + 1, amp - eq - 1);
            json.values[key] = val;
            i = (amp == std::string::npos) ? q.size() : amp + 1;
        }
        return json;
    }

    // Send an HTTP 200 JSON response
    void sendOk(const std::string& body) {
        send(body, "200 OK");
    }

    // Send an HTTP 400 JSON response
    void sendError(const std::string& message) {
        std::string body = "{\"status\":false,\"message\":\"" + escape(message) + "\"}";
        send(body, "400 Bad Request");
    }

private:
    static std::string escape(const std::string& s) {
        std::string out;
        for (char c : s) {
            if (c == '"')  out += "\\\"";
            else if (c == '\\') out += "\\\\";
            else out += c;
        }
        return out;
    }

    void send(const std::string& body, const std::string& status) {
        std::string response =
            "HTTP/1.1 " + status + "\r\n"
            "Content-Type: application/json\r\n"
            "Content-Length: " + std::to_string(body.size()) + "\r\n"
            "Connection: close\r\n"
            "\r\n" + body;
        ::send(clientSocket, response.c_str(), response.size(), 0);
    }
};
