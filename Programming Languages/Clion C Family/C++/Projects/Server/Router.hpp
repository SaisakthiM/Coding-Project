#pragma once

#include <map>
#include <string>
#include <functional>

#include "HttpRequest.hpp"
#include "HttpResponse.hpp"

class Router {
private:
    using Handler = std::function<HttpResponse(HttpRequest&)>;

    std::map<std::string, Handler> getRoutes;
    std::map<std::string, Handler> postRoutes;

public:

    void get(
        const std::string& path,
        Handler handler
    ) {
        getRoutes[path] = handler;
    }

    void post(
        const std::string& path,
        Handler handler
    ) {
        postRoutes[path] = handler;
    }

    HttpResponse handle(HttpRequest& req) {

        if (req.method == "GET") {

            auto it = getRoutes.find(req.path);

            if (it != getRoutes.end()) {
                return it->second(req);
            }
        }

        else if (req.method == "POST") {

            auto it = postRoutes.find(req.path);

            if (it != postRoutes.end()) {
                return it->second(req);
            }
        }

        HttpResponse res;
        res.statusCode = 404;
        res.contentType = "text/plain";
        res.body = "Route Not Found";

        return res;
    }
};