#include "Interface.hpp"
#include "Table.hpp"
#include <bits/stdc++.h>
#include <fstream>
#include "Base.hpp"
#include <filesystem>

struct FileData {
    Interface interface;
    SchemaParser parser;
    SchemaJsonBuilder builder;
    BaseParser baseParser;

    void createDatabase() {
        Json request = interface.getRequest();
        ParseResult result = baseParser.baseParse(request);
        if (!result.response.status) {
            std::cout
                << result.response.message
                << '\n';
            return;
        }
        TableSchema schema = parser.parse(result.request);
        std::string json = builder.build(schema);
        std::string path =
            "data/" +
            result.request.database_name +
            "/" +
            result.request.table_name +
            ".json";
        
        std::filesystem::create_directories("data/" + result.request.database_name);
        std::ofstream file(path);

        if (!file.is_open()) {
            std::cout << "Failed to create table\n";
            return;
        }

        file << json;
        
    }
};