#pragma once
#include <iostream>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>

#include "HttpParser.hpp"
#include "HttpResponse.hpp"
#include "Router.hpp"

class Connection {
    int          server_fd_ = -1;
    sockaddr_in  addr_{};
    HttpParser   parser_;
    Router&      router_;
    int          port_;

public:
    Connection(Router& router, int port = 8080)
        : router_(router), port_(port) {}

    ~Connection() {
        if (server_fd_ != -1) close(server_fd_);
    }

    // Returns false if binding/listen fails
    bool start() {
        server_fd_ = socket(AF_INET, SOCK_STREAM, 0);
        if (server_fd_ == -1) {
            std::cerr << "[error] socket() failed\n";
            return false;
        }

        // Allow reuse of port immediately after restart
        int opt = 1;
        setsockopt(server_fd_, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));

        addr_.sin_family      = AF_INET;
        addr_.sin_addr.s_addr = INADDR_ANY;
        addr_.sin_port        = htons(static_cast<uint16_t>(port_));

        if (bind(server_fd_, reinterpret_cast<sockaddr*>(&addr_), sizeof(addr_)) < 0) {
            std::cerr << "[error] bind() failed on port " << port_ << "\n";
            return false;
        }

        listen(server_fd_, SOMAXCONN);
        std::cout << "[info] server listening on port " << port_ << "\n";
        return true;
    }

    void run() {
        while (true) {
            int client_fd = accept(server_fd_, nullptr, nullptr);
            if (client_fd < 0) {
                std::cerr << "[warn] accept() failed\n";
                continue;
            }

            HttpRequest  req = parser_.parseRequest(client_fd);
            std::cout << "[req] " << req.method << " " << req.path << "\n";

            HttpResponse res = router_.handle(req);
            std::string  raw = res.toString();

            send(client_fd, raw.c_str(), raw.size(), 0);
            close(client_fd);
        }
    }
};
