#pragma once
#include <string>
#include <vector>
#include <map>
#include <fstream>
#include <sstream>
#include <filesystem>
#include <iostream>
#include <algorithm>
#include <stdexcept>

// ── BTree Configuration ──────────────────────────────────────────────────────
// ORDER = max keys per node before splitting (i.e. first 10 records fill a
// leaf; on the 11th insert the leaf splits into two children).
static constexpr int BTREE_ORDER = 10;

// ── BTree key/value entry ────────────────────────────────────────────────────
struct BEntry {
    int                              id;
    std::map<std::string,std::string> fields;   // field_name → raw string value
};

// ── Serialisation helpers ─────────────────────────────────────────────────────
// Node file format (human-readable, one entry per line):
//   LEAF|INTERNAL
//   <number of entries>
//   id|field1=val1|field2=val2|...
//   ...
//   <number of children>
//   child_filename
//   ...

namespace btree_io {

inline std::string escapeBar(const std::string& s) {
    std::string out;
    for (char c : s) {
        if (c == '|')  out += "\\|";
        else if (c == '\\') out += "\\\\";
        else out += c;
    }
    return out;
}

inline std::string unescapeBar(const std::string& s) {
    std::string out;
    for (size_t i = 0; i < s.size(); ++i) {
        if (s[i] == '\\' && i + 1 < s.size()) {
            ++i;
            out += s[i];
        } else {
            out += s[i];
        }
    }
    return out;
}

// serialise a single BEntry line
inline std::string serialiseEntry(const BEntry& e) {
    std::string line = std::to_string(e.id);
    for (auto& [k, v] : e.fields) {
        line += "|" + escapeBar(k) + "=" + escapeBar(v);
    }
    return line;
}

// parse a single BEntry line
inline BEntry parseEntry(const std::string& line) {
    BEntry e;
    // split on unescaped '|'
    std::vector<std::string> parts;
    std::string cur;
    for (size_t i = 0; i < line.size(); ++i) {
        if (line[i] == '\\' && i + 1 < line.size()) {
            cur += line[++i];
        } else if (line[i] == '|') {
            parts.push_back(cur); cur.clear();
        } else {
            cur += line[i];
        }
    }
    parts.push_back(cur);

    if (parts.empty()) return e;
    e.id = std::stoi(parts[0]);
    for (size_t i = 1; i < parts.size(); ++i) {
        size_t eq = parts[i].find('=');
        if (eq == std::string::npos) continue;
        e.fields[parts[i].substr(0, eq)] = parts[i].substr(eq + 1);
    }
    return e;
}

} // namespace btree_io

// ── In-memory BTree node ──────────────────────────────────────────────────────
struct BNode {
    bool                 isLeaf = true;
    std::vector<BEntry>  entries;          // sorted by id
    std::vector<std::string> childFiles;  // filenames of children (internal only)
    std::string          filename;         // own .tree file name
};

// ── BTree (one per table) ─────────────────────────────────────────────────────
// Tree files live at:  <table_path>/tree/<filename>.tree
// The root is always:  <table_path>/tree/root.tree
//
// Supports:
//   insert(id, fields)          – insert a new record
//   searchById(id)              – exact id lookup → BEntry or not-found
//   searchByField(f, v)         – linear scan of all leaf entries matching field=value
//   toJson()                    – dump all entries as a JSON array (for debugging)
//
struct BTree {
    std::string treePath;   // <table_path>/tree

    // ── Initialise (call once after table_path is known) ──────────────────
    void init(const std::string& table_path) {
        treePath = table_path + "/tree";
        std::filesystem::create_directories(treePath);
        std::string rootFile = treePath + "/root.tree";
        if (!std::filesystem::exists(rootFile)) {
            BNode root;
            root.isLeaf   = true;
            root.filename = "root.tree";
            saveNode(root);
            std::cout << "[BTREE] initialised at " << treePath << "\n";
        }
    }

    // ── Public: insert ────────────────────────────────────────────────────
    void insert(int id, const std::map<std::string,std::string>& fields) {
        BEntry e; e.id = id; e.fields = fields;

        BNode root = loadNode("root.tree");
        if ((int)root.entries.size() < BTREE_ORDER) {
            // simple case – root still has room
            insertIntoLeafOrNode(root, e);
            saveNode(root);
        } else {
            // root is full – split root first, then insert
            splitRootAndInsert(root, e);
        }
        std::cout << "[BTREE] inserted id=" << id << "\n";
    }

    // ── Public: search by id ──────────────────────────────────────────────
    // Returns found=true + entry, or found=false.
    struct SearchResult { bool found; BEntry entry; };

    SearchResult searchById(int id) const {
        return searchInNode(loadNode("root.tree"), id);
    }

    // ── Public: search by field value ─────────────────────────────────────
    // Walks all leaf nodes and collects matching entries.
    std::vector<BEntry> searchByField(const std::string& fieldName,
                                       const std::string& value) const {
        std::vector<BEntry> results;
        collectLeafMatches(loadNode("root.tree"), fieldName, value, results);
        return results;
    }

    // ── Public: all entries (leaf scan) ───────────────────────────────────
    std::vector<BEntry> allEntries() const {
        std::vector<BEntry> all;
        collectAll(loadNode("root.tree"), all);
        return all;
    }

    // ── Debug: dump tree structure ─────────────────────────────────────────
    void dumpStructure() const {
        dumpNode(loadNode("root.tree"), 0);
    }

private:
    // ── Node serialisation ────────────────────────────────────────────────
    void saveNode(const BNode& node) const {
        std::ofstream f(treePath + "/" + node.filename);
        f << (node.isLeaf ? "LEAF" : "INTERNAL") << "\n";
        f << node.entries.size() << "\n";
        for (auto& e : node.entries)
            f << btree_io::serialiseEntry(e) << "\n";
        f << node.childFiles.size() << "\n";
        for (auto& c : node.childFiles)
            f << c << "\n";
    }

    BNode loadNode(const std::string& filename) const {
        BNode node;
        node.filename = filename;
        std::ifstream f(treePath + "/" + filename);
        if (!f.is_open()) {
            node.isLeaf = true;
            return node;
        }
        std::string typeStr;
        std::getline(f, typeStr);
        node.isLeaf = (typeStr == "LEAF");

        int nEntries;
        f >> nEntries; f.ignore();
        for (int i = 0; i < nEntries; ++i) {
            std::string line;
            std::getline(f, line);
            if (!line.empty()) node.entries.push_back(btree_io::parseEntry(line));
        }
        int nChildren;
        f >> nChildren; f.ignore();
        for (int i = 0; i < nChildren; ++i) {
            std::string line;
            std::getline(f, line);
            if (!line.empty()) node.childFiles.push_back(line);
        }
        return node;
    }

    // ── Unique filename generator ─────────────────────────────────────────
    std::string newNodeFile() const {
        // count existing .tree files to get a unique index
        int count = 0;
        for (auto& p : std::filesystem::directory_iterator(treePath))
            if (p.path().extension() == ".tree") ++count;
        return "node_" + std::to_string(count) + ".tree";
    }

    // ── Insert into a node that still has room (leaf or internal) ─────────
    void insertIntoLeafOrNode(BNode& node, const BEntry& e) {
        // keep entries sorted by id
        auto it = std::lower_bound(node.entries.begin(), node.entries.end(), e,
            [](const BEntry& a, const BEntry& b){ return a.id < b.id; });
        node.entries.insert(it, e);
    }

    // ── Split root: promote median, create two children ───────────────────
    void splitRootAndInsert(BNode& root, const BEntry& newEntry) {
        // Temporarily insert newEntry into root entries for even split
        insertIntoLeafOrNode(root, newEntry);

        int total   = (int)root.entries.size();
        int midIdx  = total / 2;

        BNode left, right;
        left.isLeaf  = root.isLeaf;
        right.isLeaf = root.isLeaf;
        left.filename  = newNodeFile();

        // Save left first so right gets a different name
        for (int i = 0; i < midIdx; ++i)
            left.entries.push_back(root.entries[i]);
        saveNode(left);   // save to disk to register the filename

        right.filename = newNodeFile();

        BEntry median = root.entries[midIdx];

        for (int i = midIdx + 1; i < total; ++i)
            right.entries.push_back(root.entries[i]);

        // Transfer children if internal
        if (!root.isLeaf) {
            int half = (int)root.childFiles.size() / 2;
            for (int i = 0; i <= half; ++i)
                left.childFiles.push_back(root.childFiles[i]);
            for (int i = half + 1; i < (int)root.childFiles.size(); ++i)
                right.childFiles.push_back(root.childFiles[i]);
        }

        saveNode(left);
        saveNode(right);

        // Rebuild root as internal with just the median
        root.isLeaf = false;
        root.entries.clear();
        root.entries.push_back(median);
        root.childFiles.clear();
        root.childFiles.push_back(left.filename);
        root.childFiles.push_back(right.filename);
        saveNode(root);

        std::cout << "[BTREE] root split → median id=" << median.id
                  << " left=" << left.filename
                  << " right=" << right.filename << "\n";
    }

    // ── Recursive id search ────────────────────────────────────────────────
    SearchResult searchInNode(const BNode& node, int id) const {
        for (auto& e : node.entries)
            if (e.id == id) return {true, e};

        if (node.isLeaf) return {false, {}};

        // Descend into appropriate child
        int childIdx = 0;
        for (int i = 0; i < (int)node.entries.size(); ++i) {
            if (id <= node.entries[i].id) { childIdx = i; goto found; }
        }
        childIdx = (int)node.childFiles.size() - 1;
        found:
        if (childIdx < (int)node.childFiles.size())
            return searchInNode(loadNode(node.childFiles[childIdx]), id);
        return {false, {}};
    }

    // ── Leaf scan for field=value ──────────────────────────────────────────
    void collectLeafMatches(const BNode& node,
                             const std::string& field,
                             const std::string& value,
                             std::vector<BEntry>& out) const {
        if (node.isLeaf) {
            for (auto& e : node.entries) {
                auto it = e.fields.find(field);
                if (it != e.fields.end() && it->second == value)
                    out.push_back(e);
            }
            return;
        }
        for (auto& child : node.childFiles)
            collectLeafMatches(loadNode(child), field, value, out);
    }

    // ── Full leaf scan ─────────────────────────────────────────────────────
    void collectAll(const BNode& node, std::vector<BEntry>& out) const {
        if (node.isLeaf) {
            for (auto& e : node.entries) out.push_back(e);
            return;
        }
        for (auto& child : node.childFiles)
            collectAll(loadNode(child), out);
    }

    // ── Debug dump ─────────────────────────────────────────────────────────
    void dumpNode(const BNode& node, int depth) const {
        std::string indent(depth * 2, ' ');
        std::cout << indent << (node.isLeaf ? "LEAF" : "INTERNAL")
                  << " [" << node.filename << "] entries=";
        for (auto& e : node.entries) std::cout << e.id << " ";
        std::cout << "\n";
        for (auto& c : node.childFiles)
            dumpNode(loadNode(c), depth + 1);
    }
};
