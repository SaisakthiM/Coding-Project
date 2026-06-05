#include "HttpRequest.hpp"
#include <functional>
#include <vector>
#include "Json.hpp"
#include "JsonParser.hpp"


using Middleware = std::function<void(HttpRequest&)>;
JsonParser parser;

Middleware jsonMiddleware = [](HttpRequest& req) {
    Json json = parser.parseJson(req.body);

    if (json.values.count("language"))
        req.language = json.values["language"];

    if (json.values.count("code"))
        req.code = json.values["code"];
};

Middleware validateMiddleware = [](HttpRequest& req) {
    if (req.language.empty() || req.code.empty()) {
        req.language = "";
        req.code = "";
    }
};

Middleware executionMiddleware = [](HttpRequest& req) {
    if (req.language == "python") {
        req.body = "EXECUTED PYTHON OUTPUT HERE";
    }
};
