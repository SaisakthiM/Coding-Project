#pragma once
#include "Interface.hpp"
#include "Json.hpp"
#include "Table.hpp"
#include "JsonTable.hpp"
#include "Base.hpp"
#include "MetaManager.hpp"
#include <fstream>
#include <filesystem>
#include <string>
#include <iostream>

struct FileData {
    SchemaParser     schemaParser;
    SchemaJsonBuilder schemaBuilder;
    BaseParser       baseParser;
    RowBuilder       rowBuilder;
    MetaManager      manager;

    // ── POST /create ──────────────────────────────────────────────────────
    // Body: { "database_name":"x", "table_name":"y", "columns":"col:type,..." }
    std::string handleCreate(const Json& request) {
        ParseResult result = baseParser.baseParse(request);
        if (!result.response.status)
            return errorJson(result.response.message);

        TableSchema schema   = schemaParser.parse(result.request);
        std::string schemaJson = schemaBuilder.build(schema);

        std::string table_path =
            "data/" + result.request.database_name +
            "/" + result.request.table_name;

        std::filesystem::create_directories(table_path);

        // schema.json
        {
            std::ofstream f(table_path + "/schema.json");
            f << schemaJson;
        }
        // _meta.json
        {
            std::ofstream f(table_path + "/_meta.json");
            f << "{\n  \"next_id\": 1\n}";
        }

        std::cout << "[CREATE] " << table_path << "\n";
        return "{\"status\":true,\"message\":\"Table created\","
               "\"table\":\"" + result.request.table_name + "\"}";
    }

    // ── POST /insert ──────────────────────────────────────────────────────
    // Body: { "database_name":"x", "table_name":"y", "col1":"val", ... }
    std::string handleInsert(const Json& request) {
        auto db = request.values.find("database_name");
        auto tb = request.values.find("table_name");
        if (db == request.values.end() || tb == request.values.end())
            return errorJson("Missing database_name or table_name");

        std::string table_path = "data/" + db->second + "/" + tb->second;

        if (!std::filesystem::exists(table_path))
            return errorJson("Table does not exist: " + tb->second);

        int id = manager.getNextId(table_path);

        RowBuilder::RowResult row = rowBuilder.build(table_path, request, id);
        if (!row.ok)
            return errorJson(row.error);

        std::string row_path = table_path + "/" + std::to_string(id) + ".json";
        {
            std::ofstream f(row_path);
            f << row.json;
        }
        manager.setNextId(table_path, id + 1);

        std::cout << "[INSERT] id=" << id << " → " << row_path << "\n";
        return "{\"status\":true,\"message\":\"Row inserted\",\"id\":" +
               std::to_string(id) + "}";
    }

    // ── GET /search?database_name=x&table_name=y&id=N ────────────────────
    std::string handleSearch(const Json& query) {
        auto db = query.values.find("database_name");
        auto tb = query.values.find("table_name");
        auto id = query.values.find("id");

        if (db == query.values.end() || tb == query.values.end() || id == query.values.end())
            return errorJson("Missing database_name, table_name, or id");

        std::string file_path =
            "data/" + db->second + "/" + tb->second +
            "/" + id->second + ".json";

        std::ifstream f(file_path);
        if (!f.is_open())
            return errorJson("Row not found: id=" + id->second);

        std::string content, line;
        while (std::getline(f, line)) content += line + "\n";

        std::cout << "[SEARCH] id=" << id->second << "\n";
        return "{\"status\":true,\"data\":" + content + "}";
    }

private:
    static std::string errorJson(const std::string& msg) {
        // escape quotes
        std::string e;
        for (char c : msg) {
            if (c == '"') e += "\\\"";
            else e += c;
        }
        return "{\"status\":false,\"message\":\"" + e + "\"}";
    }
};
