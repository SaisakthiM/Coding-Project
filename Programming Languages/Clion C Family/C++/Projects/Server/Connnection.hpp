#include <cstring>
#include <iostream>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>

#include "HttpRequest.hpp"
#include "HttpResponse.hpp"
#include "HttpParser.hpp"
#include "Router.hpp"

class Connection {
private:
    int server_fd;
    sockaddr_in addr{};
    int client_fd;

    HttpParser parser;
    Router router;

    public:

        void startConnection() {
            server_fd = socket(AF_INET,SOCK_STREAM,0);
            if (server_fd == -1) {
                std::cout << "Socket Failed\n";
                return;
            }
            addr.sin_family = AF_INET;
            addr.sin_addr.s_addr = INADDR_ANY;
            addr.sin_port = htons(8080);
            bind(server_fd,(sockaddr*)&addr,sizeof(addr));
            listen(server_fd,SOMAXCONN);
        }

    void acceptAndRespond() {

        client_fd =accept(server_fd,nullptr,nullptr);
        HttpRequest req = parser.parseRequest(client_fd);
        std::cout
            << req.method
            << " "
            << req.path
            << "\n";
        HttpResponse res = router.handle(req);
        std::string response = res.toString();
        send(client_fd,response.c_str(),response.size(),0);
        close(client_fd);
    }

    void run() {
        while (true) {
            acceptAndRespond();
        }
    }

    void closeConnection() {
        close(server_fd);
    }
};