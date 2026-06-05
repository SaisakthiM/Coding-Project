#include "HttpRequest.hpp"
#include <vector>
#include "Middleware.hpp"

struct MiddlewareManager {
    std::vector<Middleware> middlewares;

    void use(Middleware m) {
        middlewares.push_back(m);
    }

    void run(HttpRequest& req) {
        for (auto& mw : middlewares) {
            mw(req);
        }
    }
};