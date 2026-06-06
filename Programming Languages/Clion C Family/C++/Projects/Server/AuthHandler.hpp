#include "AuthRequest.hpp"
#include "HttpRequest.hpp"
#include "Json.hpp"
#include "HttpResponse.hpp"
#include "AuthResponse.hpp"
#include "JsonParser.hpp"
#include "AuthService.hpp"

struct AuthHandler {
    JsonParser parser;
    AuthService auth;

    HttpResponse registerHandler(HttpRequest& req) {

    Json json = parser.parseJson(req.body);

    AuthRequest authReq;

    authReq.username = json.values["username"];
    authReq.password = json.values["password"];

    AuthResponse authRes =
        auth.registerUser(authReq);

    HttpResponse res;

    if (authRes.success) {
        res.statusCode = 201;
        res.body = "User created";
    }
    else {
        res.statusCode = 400;
        res.body = authRes.message;
    }

    return res;
}
};