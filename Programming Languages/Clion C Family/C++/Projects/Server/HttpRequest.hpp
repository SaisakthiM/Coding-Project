#include <map>
#include <string>
#pragma once

struct HttpRequest {
    std::string method;
    std::string path;
    std::string query;
    std::string version;
    std::map<std::string, std::string> headers;
    std::string body;
    std::string language;   // extracted by middleware
    std::string code;       // extracted by middleware
};