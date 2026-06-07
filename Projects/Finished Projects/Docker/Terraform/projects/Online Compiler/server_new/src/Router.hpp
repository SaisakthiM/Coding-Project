#pragma once
#include <map>
#include <string>
#include <functional>
#include "HttpRequest.hpp"
#include "HttpResponse.hpp"

class Router {
    using Handler = std::function<HttpResponse(const HttpRequest&)>;

    std::map<std::string, Handler> getRoutes_;
    std::map<std::string, Handler> postRoutes_;

public:
    void get (const std::string& path, Handler h) { getRoutes_[path]  = h; }
    void post(const std::string& path, Handler h) { postRoutes_[path] = h; }

    HttpResponse handle(const HttpRequest& req) const {
        const auto* table =
            (req.method == "GET")  ? &getRoutes_  :
            (req.method == "POST") ? &postRoutes_ : nullptr;

        if (table) {
            auto it = table->find(req.path);
            if (it != table->end())
                return it->second(req);
        }

        return HttpResponse::notFound();
    }
};
