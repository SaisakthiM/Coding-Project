#pragma once
#include <string>
#include "Router.hpp"
#include "HttpRequest.hpp"
#include "HttpResponse.hpp"
#include "Json.hpp"
#include "Auth.hpp"
#include "AuthService.hpp"
#include "SessionManager.hpp"
#include "CodeRunner.hpp"

static std::string escapeJson(const std::string& s) {
    std::string out;
    for (char c : s) {
        switch (c) {
            case '"':  out += "\\\""; break;
            case '\\': out += "\\\\"; break;
            case '\n': out += "\\n";  break;
            case '\r': out += "\\r";  break;
            case '\t': out += "\\t";  break;
            default:   out += c;
        }
    }
    return out;
}

inline void registerRoutes(Router&         router,
                            AuthService&    auth,
                            SessionManager& sessions)
{
    // Capture pointers so every lambda shares the SAME auth/sessions objects
    AuthService*    pAuth     = &auth;
    SessionManager* pSessions = &sessions;

    // ── POST /register ──────────────────────────────────────────────────────
    router.post("/register", [pAuth](const HttpRequest& req) {
        JsonParser parser;
        Json json = parser.parse(req.body);

        AuthRequest ar;
        ar.username = json.values["username"];
        ar.password = json.values["password"];

        AuthResponse res = pAuth->registerUser(ar);

        if (!res.success)
            return HttpResponse::badRequest(res.message);

        std::string body =
            "{\"message\":\"" + escapeJson(res.message) + "\","
            " \"token\":\""   + escapeJson(res.token)   + "\"}";

        return HttpResponse::created(body);
    });

    // ── POST /login ─────────────────────────────────────────────────────────
    router.post("/login", [pAuth](const HttpRequest& req) {
        JsonParser parser;
        Json json = parser.parse(req.body);

        AuthRequest ar;
        ar.username = json.values["username"];
        ar.password = json.values["password"];

        AuthResponse res = pAuth->login(ar);

        if (!res.success)
            return HttpResponse::unauthorized(res.message);

        std::string body =
            "{\"message\":\"" + escapeJson(res.message) + "\","
            " \"token\":\""   + escapeJson(res.token)   + "\"}";

        return HttpResponse::ok(body);
    });

    // ── POST /code ──────────────────────────────────────────────────────────
    router.post("/code", [pSessions](const HttpRequest& req) {
        // 1. Authenticate
        auto it = req.headers.find("Authorization");
        if (it == req.headers.end())
            return HttpResponse::unauthorized("missing Authorization header");

        const std::string prefix = "Bearer ";
        if (it->second.rfind(prefix, 0) != 0)
            return HttpResponse::unauthorized("invalid Authorization format");

        std::string token = it->second.substr(prefix.size());
        if (!pSessions->exists(token))
            return HttpResponse::unauthorized("invalid or expired token");

        // 2. Parse body
        JsonParser parser;
        Json json = parser.parse(req.body);

        std::string language = json.values["language"];
        std::string code     = json.values["code"];

        if (language.empty() || code.empty())
            return HttpResponse::badRequest("language and code are required");

        // 3. Run code
        CodeRunner runner;
        CodeRunner::Result result = runner.runCode(language, code);

        std::string status = (result.exitCode == 0) ? "success" : "error";
        std::string body =
            "{\"status\":\""  + escapeJson(status)         + "\","
            " \"output\":\""  + escapeJson(result.output)  + "\","
            " \"exitCode\":"  + std::to_string(result.exitCode) + "}";

        return HttpResponse::ok(body);
    });

    // ── GET /health ─────────────────────────────────────────────────────────
    router.get("/health", [](const HttpRequest&) {
        return HttpResponse::ok("{\"status\":\"ok\"}", "application/json");
    });
}
