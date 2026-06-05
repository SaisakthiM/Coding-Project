#include <string>
#include "HttpRequest.hpp"
#include <sstream>
#include <sys/socket.h>

struct HttpParser {
    HttpRequest parseRequest(int client_fd) {
        char buffer[4096];
        std::string raw;

        int bytes = recv(client_fd, buffer, sizeof(buffer), 0);
        raw.append(buffer, bytes);

        size_t header_end = raw.find("\r\n\r\n");
        std::string header_part = raw.substr(0, header_end);
        std::string body_part = raw.substr(header_end + 4);

        HttpRequest req;

        std::istringstream stream(header_part);
        std::string line;

        // request line
        std::getline(stream, line);
        if (!line.empty() && line.back() == '\r')
            line.pop_back();

        std::istringstream rl(line);
        std::string target;
        rl >> req.method >> target >> req.version;

        size_t q = target.find('?');
        if (q != std::string::npos) {
            req.path = target.substr(0, q);
            req.query = target.substr(q + 1);
        } else {
            req.path = target;
        }

        int content_length = 0;

        // headers
        while (std::getline(stream, line)) {
            if (line.empty() || line == "\r") break;

            if (line.back() == '\r')
                line.pop_back();

            size_t colon = line.find(':');
            std::string key = line.substr(0, colon);
            std::string value = line.substr(colon + 1);

            if (!value.empty() && value[0] == ' ')
                value.erase(0, 1);

            req.headers[key] = value;

            if (key == "Content-Length") {
                content_length = std::stoi(value);
            }
        }

        // body
        if (content_length > 0) {
            req.body = body_part;

            while (req.body.size() < (size_t)content_length) {
                int n = recv(client_fd, buffer, sizeof(buffer), 0);
                req.body.append(buffer, n);
            }

            req.body = req.body.substr(0, content_length);
        }

        return req;
    }
};