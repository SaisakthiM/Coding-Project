#pragma once
#include <iostream>
#include <mutex>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>

#include "HttpParser.hpp"
#include "HttpResponse.hpp"
#include "Router.hpp"
#include "ThreadPool.hpp"

class Connection {
    int         server_fd_ = -1;
    sockaddr_in addr_{};
    Router&     router_;
    int         port_;
    int         numThreads_;

    // Router::handle is called from worker threads — guard it.
    // (SessionManager map inside AuthService is accessed here)
    std::mutex  routerMutex_;

public:
    Connection(Router& router, int port = 8080, int numThreads = 4)
        : router_(router), port_(port), numThreads_(numThreads) {}

    ~Connection() {
        if (server_fd_ != -1) close(server_fd_);
    }

    bool start() {
        server_fd_ = socket(AF_INET, SOCK_STREAM, 0);
        if (server_fd_ == -1) {
            std::cerr << "[error] socket() failed\n";
            return false;
        }

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
        std::cout << "[info] server listening on port " << port_
                  << " (" << numThreads_ << " threads)\n";
        return true;
    }

    void run() {
        ThreadPool pool(numThreads_);
        HttpParser parser;

        while (true) {
            int client_fd = accept(server_fd_, nullptr, nullptr);
            if (client_fd < 0) {
                std::cerr << "[warn] accept() failed\n";
                continue;
            }

            // Capture client_fd by value; router_ and mutex by reference
            pool.submit([client_fd, &parser, this] {
                HttpRequest req = parser.parseRequest(client_fd);

                std::cout << "[thread " << std::this_thread::get_id() << "] "
                          << req.method << " " << req.path << "\n";

                HttpResponse res;
                {
                    std::lock_guard<std::mutex> lock(routerMutex_);
                    res = router_.handle(req);
                }

                std::string raw = res.toString();
                send(client_fd, raw.c_str(), raw.size(), 0);
                close(client_fd);
            });
        }
    }
};
