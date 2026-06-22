#include "Interface.hpp"
#include "Json.hpp"
#include "Table.hpp"
#include <bits/stdc++.h>
#include <fstream>
#include "Base.hpp"
#include <filesystem>
#include <ostream>
#include <string>
#include "MetaManager.hpp"

struct FileData {
    Interface interface;
    SchemaParser parser;
    SchemaJsonBuilder builder;
    BaseParser baseParser;
    JsonParser jsonParser;
    int count;
    MetaManager manager;

    void createTable() {
        Json request = interface.getRequest();

        ParseResult result =
            baseParser.baseParse(request);

        if (!result.response.status) {
            std::cout
                << result.response.message
                << '\n';
            return;
        }

        TableSchema schema =
            parser.parse(result.request);

        std::string schema_json =
            builder.build(schema);

        std::string table_path =
            "data/" +
            result.request.database_name +
            "/" +
            result.request.table_name;

        std::filesystem::create_directories(
            table_path
        );

        // Create schema.json
        {
            std::ofstream schema_file(
                table_path + "/schema.json"
            );

            schema_file << schema_json;
        }

        // Create _meta.json
        {
            std::ofstream meta_file(
                table_path + "/_meta.json"
            );

            meta_file <<
                "{\n"
                "  \"next_id\": 1\n"
                "}";
        }

        std::cout
            << "Table created\n";
    }
    void insertRow(const std::string& table_path,const std::string& row_json) {
        int id = manager.getNextId(table_path);

        std::string row_path =
            table_path +
            "/" +
            std::to_string(id) +
            ".json";

        {
            std::ofstream row_file(row_path);
            row_file << row_json;
        }

        manager.setNextId(table_path,id + 1);

        std::cout
            << "Inserted row "
            << id
            << '\n';
    }
    std::string searchData(int id, std::string table_name, std::string database_name) {
        std::string file_path =
            "data/" +
            database_name +
            "/" +
            table_name +
            "/" +
            std::to_string(id) +
            ".json";
        std::string content;
        std::string line;
        std::ifstream file(file_path);
        while (std::getline(file,line)) {
            content += line;
        }
        return content;
    }
};