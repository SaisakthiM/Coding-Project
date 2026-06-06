#include "Router.hpp"

#pragma once

#include "HttpRequest.hpp"
#include "HttpResponse.hpp"
#include "JsonParser.hpp"
#include "AuthService.hpp"
#include "SessionManager.hpp"
#include "AuthRequest.hpp"

struct Routes {
private:
    AuthService& auth;
    SessionManager& session;
    JsonParser parser;

public:
    Routes(
        AuthService& auth,
        SessionManager& session
    )
        : auth(auth),
          session(session) {}

    HttpResponse registerHandler(HttpRequest& req);

    HttpResponse loginHandler(HttpRequest& req);

    HttpResponse runHandler(HttpRequest& req);
};