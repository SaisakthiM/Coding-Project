#include <cstring>
#include <iostream>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include "HttpResponse.hpp"
#include "HttpRequest.hpp"
#include "HttpParser.hpp"

class Connection {
    private: 
        int server_fd;
        sockaddr_in addr{};
        int client_fd;
        std::string response;
        int bytes;
        HttpParser parser;

    public: 
        void startConnection(sockaddr_in address, unsigned int port) {
            this->server_fd = socket(AF_INET, SOCK_STREAM, 0);
            if (this->server_fd == -1) {
                std::cout << "Socket Failed" << std::endl;
                
            }

            this->addr.sin_addr.s_addr = INADDR_ANY;
            this->addr.sin_port = htons(8080);
            this->addr.sin_family = AF_INET;

            bind(server_fd,(sockaddr*)&addr,sizeof(addr));

            listen(server_fd, SOMAXCONN);
        }

        void acceptAndRespond() {
            this->client_fd = accept(server_fd, nullptr, nullptr);

            HttpRequest req = this->parser.parseRequest(this->client_fd);

            std::cout << "Method: " << req.method << "\n";
            std::cout << "Path: " << req.path << "\n";

            HttpResponse res;
            res.statusCode = 200;
            res.body = "Hello World";
            res.contentType = "text/plain";
            this-> response = res.toString();

            send(client_fd,response.c_str(), response.size(),0);
        }
        void closeConnection() {
            close(this->client_fd);
            close(this->server_fd);
        }
        
};