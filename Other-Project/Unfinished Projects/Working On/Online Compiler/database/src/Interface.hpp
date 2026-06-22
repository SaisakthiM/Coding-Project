#include <string>
#include "Base.hpp"
#include "HttpRequest.hpp"
#include <cstring>
#include <iostream>
#include <netinet/in.h>
#include <sys/socket.h>
#include <unistd.h>
#include "HttpParser.hpp"
#include "Json.hpp"

struct Interface {
    private: 
        int serverSocket;
        sockaddr_in serverAddress;
        int clientSocket;
        HttpParser parser;
        JsonParser jsonParser;

    public: 
    void startConnection() {
        this->serverSocket = socket(AF_INET, SOCK_STREAM, 0);
        this->serverAddress.sin_family = AF_INET;
        this->serverAddress.sin_port = htons(8080);
        this->serverAddress.sin_addr.s_addr = INADDR_ANY;
        bind(serverSocket, (struct sockaddr*)&serverAddress,sizeof(serverAddress));
        listen(serverSocket, 5);
    }
    Json getRequest() {
        HttpRequest request = parser.parseRequest(this->clientSocket);
        Json jsonRequest = jsonParser.parse(request.body);
        return jsonRequest;
    }

};