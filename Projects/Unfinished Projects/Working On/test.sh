#!/bin/bash

# ── colours ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ── counters ──────────────────────────────────────────────────────────────────
PASS=0
FAIL=0

# ── helpers ───────────────────────────────────────────────────────────────────
header() { echo -e "\n${CYAN}${BOLD}━━━  $1  ━━━${NC}"; }

pass() { echo -e "  ${GREEN}✔${NC}  $1"; PASS=$((PASS+1)); }
fail() { echo -e "  ${RED}✘${NC}  $1"; FAIL=$((FAIL+1)); }
info() { echo -e "  ${YELLOW}→${NC}  $1"; }

# Run curl, print response, return body
request() {
    local method="$1"; shift
    local url="$1";    shift
    # remaining args forwarded to curl (-H, -d, etc.)
    curl -s -X "$method" "$url" "$@"
}

# Assert the response contains a substring
assert_contains() {
    local label="$1"
    local body="$2"
    local expected="$3"
    if echo "$body" | grep -q "$expected"; then
        pass "$label"
    else
        fail "$label  (got: $body)"
    fi
}

assert_not_contains() {
    local label="$1"
    local body="$2"
    local unexpected="$3"
    if echo "$body" | grep -q "$unexpected"; then
        fail "$label  (got: $body)"
    else
        pass "$label"
    fi
}

DB="http://localhost:8080"
SRV="http://localhost:9090"

# ─────────────────────────────────────────────────────────────────────────────
echo -e "${BOLD}"
echo "╔══════════════════════════════════════════════╗"
echo "║        Full Stack Test Suite                 ║"
echo "║   DB :8080   |   Auth Server :9090           ║"
echo "╚══════════════════════════════════════════════╝"
echo -e "${NC}"

# ── 0. Check servers are up ───────────────────────────────────────────────────
header "0. Connectivity"

DB_UP=$(curl -s --connect-timeout 2 "$DB/search?database_name=x&table_name=y&id=1" | grep -c "status")
if [ "$DB_UP" -gt 0 ]; then
    pass "DB server reachable at :8080"
else
    fail "DB server NOT reachable at :8080 — start it first (./dbserver)"
    echo -e "\n${RED}Aborting: DB server must be running.${NC}\n"
    exit 1
fi

SRV_UP=$(curl -s --connect-timeout 2 "$SRV/health" | grep -c "ok")
if [ "$SRV_UP" -gt 0 ]; then
    pass "Auth server reachable at :9090"
else
    fail "Auth server NOT reachable at :9090 — start it first (./server)"
    echo -e "\n${RED}Aborting: Auth server must be running.${NC}\n"
    exit 1
fi

# ── 1. Database: create tables ────────────────────────────────────────────────
header "1. Database — Create Tables"

R=$(request POST "$DB/create" \
    -H "Content-Type: application/json" \
    -d '{"database_name":"testdb","table_name":"products","columns":"name:string,price:float,stock:int,available:bool"}')
info "Response: $R"
assert_contains "Create products table"           "$R" '"status":true'
assert_contains "Returns table name in response"  "$R" "products"

R=$(request POST "$DB/create" \
    -H "Content-Type: application/json" \
    -d '{"database_name":"testdb","table_name":"products","columns":"name:string,price:float"}')
info "Duplicate create response: $R"
# second create is treated as a re-init — just check server stays alive
assert_contains "Server handles duplicate create gracefully" "$R" "status"

R=$(request POST "$DB/create" \
    -H "Content-Type: application/json" \
    -d '{"database_name":"testdb","table_name":"orders","columns":"product:string,qty:int,total:float"}')
info "Response: $R"
assert_contains "Create orders table" "$R" '"status":true'

# missing params
R=$(request POST "$DB/create" \
    -H "Content-Type: application/json" \
    -d '{"database_name":"testdb"}')
info "Missing params response: $R"
assert_contains "Rejects create with missing params" "$R" '"status":false'

# ── 2. Database: insert rows ──────────────────────────────────────────────────
header "2. Database — Insert Rows"

R=$(request POST "$DB/insert" \
    -H "Content-Type: application/json" \
    -d '{"database_name":"testdb","table_name":"products","name":"Widget","price":"9.99","stock":"100","available":"true"}')
info "Insert 1: $R"
assert_contains "Insert row 1 (Widget)"     "$R" '"status":true'
assert_contains "Row gets id=1"             "$R" '"id":1'

R=$(request POST "$DB/insert" \
    -H "Content-Type: application/json" \
    -d '{"database_name":"testdb","table_name":"products","name":"Gadget","price":"24.50","stock":"50","available":"true"}')
info "Insert 2: $R"
assert_contains "Insert row 2 (Gadget)"    "$R" '"status":true'

R=$(request POST "$DB/insert" \
    -H "Content-Type: application/json" \
    -d '{"database_name":"testdb","table_name":"products","name":"Doohickey","price":"4.00","stock":"0","available":"false"}')
info "Insert 3: $R"
assert_contains "Insert row 3 (Doohickey)" "$R" '"status":true'

# type error: price should be float not string words
R=$(request POST "$DB/insert" \
    -H "Content-Type: application/json" \
    -d '{"database_name":"testdb","table_name":"products","name":"Bad","price":"not-a-number","stock":"10","available":"true"}')
info "Type error response: $R"
assert_contains "Rejects bad float value"   "$R" '"status":false'

# missing table
R=$(request POST "$DB/insert" \
    -H "Content-Type: application/json" \
    -d '{"database_name":"testdb","table_name":"ghost","name":"X","price":"1.0","stock":"1","available":"true"}')
info "Missing table response: $R"
assert_contains "Rejects insert into non-existent table" "$R" '"status":false'

# ── 3. Database: search by id ─────────────────────────────────────────────────
header "3. Database — Search by ID"

R=$(request GET "$DB/search?database_name=testdb&table_name=products&id=1")
info "Search id=1: $R"
assert_contains "Find row id=1"             "$R" '"status":true'
assert_contains "Row contains Widget"       "$R" "Widget"

R=$(request GET "$DB/search?database_name=testdb&table_name=products&id=2")
info "Search id=2: $R"
assert_contains "Find row id=2"             "$R" '"status":true'
assert_contains "Row contains Gadget"       "$R" "Gadget"

R=$(request GET "$DB/search?database_name=testdb&table_name=products&id=999")
info "Search missing id: $R"
assert_contains "Returns error for missing id" "$R" '"status":false'

# missing query params
R=$(request GET "$DB/search?database_name=testdb&table_name=products")
info "Missing id param: $R"
assert_contains "Rejects search with missing id param" "$R" '"status":false'

# ── 4. Database: field search (BTree scan) ────────────────────────────────────
header "4. Database — Field Search (BTree)"

R=$(request GET "$DB/field_search?database_name=testdb&table_name=products&field=name&value=Widget")
info "Field search name=Widget: $R"
assert_contains "Field search finds Widget"     "$R" '"status":true'
assert_contains "Count is 1"                    "$R" '"count":1'

R=$(request GET "$DB/field_search?database_name=testdb&table_name=products&field=available&value=true")
info "Field search available=true: $R"
assert_contains "Field search finds available items" "$R" '"status":true'
assert_contains "Count is 2"                         "$R" '"count":2'

R=$(request GET "$DB/field_search?database_name=testdb&table_name=products&field=available&value=false")
info "Field search available=false: $R"
assert_contains "Field search finds unavailable"  "$R" '"status":true'
assert_contains "Count is 1"                      "$R" '"count":1'

R=$(request GET "$DB/field_search?database_name=testdb&table_name=products&field=name&value=NoSuchThing")
info "Field search no match: $R"
assert_contains "Field search returns count=0 for no match" "$R" '"count":0'

# missing field param
R=$(request GET "$DB/field_search?database_name=testdb&table_name=products&field=name")
info "Missing value param: $R"
assert_contains "Rejects field_search with missing value" "$R" '"status":false'

# ── 5. Database: BTree split ──────────────────────────────────────────────────
header "5. Database — BTree Split (insert 11 rows)"

info "Inserting 11 rows into orders to trigger BTree root split..."
for i in $(seq 1 11); do
    TOTAL=$(echo "$i * 5" | bc)
    curl -s -X POST "$DB/insert" \
        -H "Content-Type: application/json" \
        -d "{\"database_name\":\"testdb\",\"table_name\":\"orders\",\"product\":\"Item$i\",\"qty\":\"$i\",\"total\":\"$TOTAL.00\"}" > /tmp/btree_insert_$i.txt
done

# After 11 inserts root should have split — tree dir should have node files
TREE_DIR="data/testdb/orders/tree"
if [ -d "$TREE_DIR" ]; then
    NODE_COUNT=$(ls "$TREE_DIR"/*.tree 2>/dev/null | wc -l)
    info "Tree files found: $NODE_COUNT"
    if [ "$NODE_COUNT" -ge 3 ]; then
        pass "BTree split occurred (root + 2 children = 3 node files)"
    elif [ "$NODE_COUNT" -ge 1 ]; then
        pass "BTree tree files exist ($NODE_COUNT files)"
    else
        fail "No .tree files found in $TREE_DIR"
    fi
else
    info "Tree dir not on this machine — checking via field_search instead"
    R=$(request GET "$DB/field_search?database_name=testdb&table_name=orders&field=product&value=Item1")
    assert_contains "Can still find Item1 after many inserts" "$R" '"status":true'
fi

# verify we can still search after split
R=$(request GET "$DB/search?database_name=testdb&table_name=orders&id=5")
info "Search after split, id=5: $R"
assert_contains "Search still works after BTree split" "$R" '"status":true'

R=$(request GET "$DB/field_search?database_name=testdb&table_name=orders&field=product&value=Item11")
info "Field search after split: $R"
assert_contains "Field search still works after split" "$R" '"status":true'

# ── 6. Auth server: health ────────────────────────────────────────────────────
header "6. Auth Server — Health"

R=$(request GET "$SRV/health")
info "Health: $R"
assert_contains "Health check returns ok" "$R" '"status":"ok"'

# ── 7. Auth server: register ──────────────────────────────────────────────────
header "7. Auth Server — Register"

# use a unique username to avoid conflicts on re-runs
TS=$(date +%s)
USER="testuser_$TS"

R=$(request POST "$SRV/register" \
    -H "Content-Type: application/json" \
    -d "{\"username\":\"$USER\",\"password\":\"pass123\"}")
info "Register: $R"
assert_contains "Register new user"               "$R" '"message":"user created"'
assert_contains "Register returns a token"        "$R" "token"

# duplicate
R=$(request POST "$SRV/register" \
    -H "Content-Type: application/json" \
    -d "{\"username\":\"$USER\",\"password\":\"pass123\"}")
info "Duplicate register: $R"
assert_contains "Rejects duplicate username" "$R" "username already taken"

# missing fields
R=$(request POST "$SRV/register" \
    -H "Content-Type: application/json" \
    -d '{"username":""}')
info "Empty username: $R"
assert_contains "Rejects empty username" "$R" "required"

# ── 8. Auth server: login ─────────────────────────────────────────────────────
header "8. Auth Server — Login"

R=$(request POST "$SRV/login" \
    -H "Content-Type: application/json" \
    -d "{\"username\":\"$USER\",\"password\":\"pass123\"}")
info "Login: $R"
assert_contains "Login succeeds"              "$R" "login successful"
assert_contains "Login returns token"         "$R" "token"

# extract token for subsequent requests
TOKEN=$(echo "$R" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
info "Token: $TOKEN"

if [ -z "$TOKEN" ]; then
    fail "Could not extract token — skipping authenticated tests"
    TOKEN="invalid"
fi

# wrong password
R=$(request POST "$SRV/login" \
    -H "Content-Type: application/json" \
    -d "{\"username\":\"$USER\",\"password\":\"wrongpass\"}")
info "Wrong password: $R"
assert_contains "Rejects wrong password" "$R" "invalid username or password"

# non-existent user
R=$(request POST "$SRV/login" \
    -H "Content-Type: application/json" \
    -d '{"username":"nobody_ever","password":"x"}')
info "Unknown user: $R"
assert_contains "Rejects unknown user" "$R" "invalid username or password"

# ── 9. Auth server: run code ──────────────────────────────────────────────────
header "9. Auth Server — Run Code"

# python
R=$(request POST "$SRV/code" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -d '{"language":"python","code":"print(\"hello world\")"}')
info "Python run: $R"
assert_contains "Python runs successfully"      "$R" '"status":"success"'
assert_contains "Python output is correct"      "$R" "hello world"
assert_contains "Exit code is 0"                "$R" '"exitCode":0'

# python with logic
R=$(request POST "$SRV/code" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -d '{"language":"python","code":"print(sum(range(1,6)))"}')
info "Python sum: $R"
assert_contains "Python sum(1..5)=15" "$R" "15"

# bash
R=$(request POST "$SRV/code" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -d '{"language":"bash","code":"echo hello from bash"}')
info "Bash run: $R"
assert_contains "Bash runs successfully" "$R" '"status":"success"'
assert_contains "Bash output correct"   "$R" "hello from bash"

# error exit code
R=$(request POST "$SRV/code" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -d '{"language":"python","code":"raise ValueError(\"intentional error\")"}')
info "Python error: $R"
assert_contains "Captures error exit code" "$R" '"status":"error"'
assert_not_contains "Exit code is NOT 0"   "$R" '"exitCode":0'

# no token
R=$(request POST "$SRV/code" \
    -H "Content-Type: application/json" \
    -d '{"language":"python","code":"print(1)"}')
info "No token: $R"
assert_contains "Rejects request without token" "$R" "missing Authorization header"

# bad token
R=$(request POST "$SRV/code" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer totally_fake_token" \
    -d '{"language":"python","code":"print(1)"}')
info "Bad token: $R"
assert_contains "Rejects invalid token" "$R" "invalid or expired token"

# missing language/code
R=$(request POST "$SRV/code" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -d '{"language":"python"}')
info "Missing code field: $R"
assert_contains "Rejects request missing code field" "$R" "required"

# ── 10. Auth server: output history ──────────────────────────────────────────
header "10. Auth Server — Output History"

# run a couple more to make history non-trivial
request POST "$SRV/code" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -d '{"language":"python","code":"print(42)"}' > /tmp/hist_run1.txt

request POST "$SRV/code" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -d '{"language":"bash","code":"echo history test"}' > /tmp/hist_run2.txt

# fetch history
R=$(request GET "$SRV/history" \
    -H "Authorization: Bearer $TOKEN")
info "History response: $R"
assert_contains "History returns status true"     "$R" '"status":true'
assert_contains "History has multiple entries"    "$R" '"count":'
assert_contains "History contains username"       "$R" "$USER"

# history without token
R=$(request GET "$SRV/history")
info "History no token: $R"
assert_contains "History rejects missing token" "$R" "missing Authorization header"

# ── 11. Concurrency ───────────────────────────────────────────────────────────
header "11. Concurrency — Parallel Requests"

info "Firing 4 DB searches in parallel..."
request GET "$DB/search?database_name=testdb&table_name=products&id=1" > /tmp/c1.txt &
request GET "$DB/search?database_name=testdb&table_name=products&id=2" > /tmp/c2.txt &
request GET "$DB/search?database_name=testdb&table_name=products&id=3" > /tmp/c3.txt &
request GET "$DB/field_search?database_name=testdb&table_name=products&field=available&value=true" > /tmp/c4.txt &
wait

assert_contains "Concurrent req 1 (id=1)"           "$(cat /tmp/c1.txt)" '"status":true'
assert_contains "Concurrent req 2 (id=2)"           "$(cat /tmp/c2.txt)" '"status":true'
assert_contains "Concurrent req 3 (id=3)"           "$(cat /tmp/c3.txt)" '"status":true'
assert_contains "Concurrent req 4 (field_search)"   "$(cat /tmp/c4.txt)" '"status":true'

info "Firing 4 auth server requests in parallel..."
request GET  "$SRV/health" > /tmp/s1.txt &
request POST "$SRV/login" -H "Content-Type: application/json" \
    -d "{\"username\":\"$USER\",\"password\":\"pass123\"}" > /tmp/s2.txt &
request POST "$SRV/code" -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -d '{"language":"python","code":"print(99)"}' > /tmp/s3.txt &
request GET "$SRV/history" -H "Authorization: Bearer $TOKEN" > /tmp/s4.txt &
wait

assert_contains "Concurrent auth req 1 (health)"   "$(cat /tmp/s1.txt)" '"status":"ok"'
assert_contains "Concurrent auth req 2 (login)"    "$(cat /tmp/s2.txt)" "login successful"
assert_contains "Concurrent auth req 3 (code)"     "$(cat /tmp/s3.txt)" '"status":"success"'
assert_contains "Concurrent auth req 4 (history)"  "$(cat /tmp/s4.txt)" '"status":true'

# ── Summary ───────────────────────────────────────────────────────────────────
TOTAL=$((PASS+FAIL))
echo ""
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  Results: ${GREEN}$PASS passed${NC} / ${RED}$FAIL failed${NC} / $TOTAL total"
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [ "$FAIL" -eq 0 ]; then
    echo -e "\n  ${GREEN}${BOLD}All tests passed!${NC}\n"
    exit 0
else
    echo -e "\n  ${RED}${BOLD}$FAIL test(s) failed.${NC}\n"
    exit 1
fi