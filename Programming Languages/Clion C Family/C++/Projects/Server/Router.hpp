#include <functional>
#include <string>
#include "HttpRequest.hpp"
#include "HttpResponse.hpp"

struct Router {
    std::map<std::string, std::function<HttpResponse(HttpRequest)>> getRoutes;

    void addGet(const std::string& path,
                std::function<HttpResponse(HttpRequest)> handler) {
        getRoutes[path] = handler;
    }

    HttpResponse handle(HttpRequest req) {
        if (req.method == "GET") {
            if (getRoutes.count(req.path)) {
                return getRoutes[req.path](req);
            }
        }

        HttpResponse res;
        res.statusCode = 404;
        res.contentType = "text/plain";
        res.body = "Not Found";
        return res;
    }
};