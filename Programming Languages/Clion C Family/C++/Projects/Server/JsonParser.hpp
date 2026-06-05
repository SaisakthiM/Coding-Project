#include <string>
#include <map>
#include <cctype>
#include "Json.hpp"
#pragma once

struct JsonParser {
    void skipSpaces(const std::string& s, size_t& i) {
        while (i < s.size() && std::isspace(s[i])) i++;
    };
    std::string parseString(const std::string& s, size_t& i) {
        std::string result;
        if (s[i] == '"') i++; // skip opening quote
        while (i < s.size() && s[i] != '"') {
            result += s[i++];
        }
        if (i < s.size() && s[i] == '"') i++; // skip closing quote
        return result;
    };
    Json parseJson(const std::string& s) {
        Json json;
        size_t i = 0;
        skipSpaces(s, i);
        if (s[i] == '{') i++;
        while (i < s.size()) {
            skipSpaces(s, i);
            if (s[i] == '}') break;
            // key
            std::string key = parseString(s, i);
            skipSpaces(s, i);
            if (s[i] == ':') i++;
            skipSpaces(s, i);
            // value (string only for now)
            std::string value = parseString(s, i);
            json.values[key] = value;
            skipSpaces(s, i);
            if (s[i] == ',') i++;
        }
        return json;
    }
};