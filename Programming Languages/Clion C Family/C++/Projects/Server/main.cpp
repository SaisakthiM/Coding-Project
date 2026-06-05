#include <cstring>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>

int main() {
    int server_fd = socket(AF_INET, SOCK_STREAM, 0);
    sockaddr_in addr{};
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = INADDR_ANY;
    addr.sin_port = htons(8080);
    bind(server_fd,
     (sockaddr*)&addr,
     sizeof(addr));
    listen(server_fd, SOMAXCONN);
    int client_fd = accept(
    server_fd,
    nullptr,
    nullptr
);
    char buffer[4096];

int bytes =
    recv(client_fd,
         buffer,
         sizeof(buffer),
         0);
    const char* response =
    "HTTP/1.1 200 OK\r\n"
    "Content-Type: text/plain\r\n"
    "\r\n"
    "Hello World";
    send(
    client_fd,
    response,
    strlen(response),
    0
);
close(client_fd);
}