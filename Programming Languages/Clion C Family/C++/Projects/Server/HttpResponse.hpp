#include <string>
#include "AuthRequest.hpp"
#include "HttpRequest.hpp"
#include "Json.hpp"
#include "Status.hpp"
#include "JsonParser.hpp"
#pragma once

struct HttpResponse {
    int statusCode;
    std::string body;
    std::string contentType = "text/plain";

    std::string toString() const {
        std::string response;

        response += "HTTP/1.1 " + std::to_string(statusCode) + " ";
        response += Status::reasonPhrase(statusCode) + "\r\n";

        response += "Content-Type: " + contentType + "\r\n";
        response += "Content-Length: " +
                    std::to_string(body.size()) + "\r\n";

        response += "Connection: close\r\n";
        response += "\r\n";

        response += body;

        return response;
    }
};