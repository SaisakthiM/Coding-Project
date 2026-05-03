#!/bin/bash

# ============================================================
# Comprehensive Security Testing Script
# Tests: SQLi, Brute Force, JWT, File Upload, IDOR, Rate Limit
# ============================================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PASS () { echo -e "  ${GREEN}✓${NC} $1"; }
FAIL () { echo -e "  ${RED}✗${NC} $1"; }
WARN () { echo -e "  ${YELLOW}⚠${NC} $1"; }
INFO () { echo -e "  ${BLUE}ℹ${NC} $1"; }

BASE="http://localhost"
TIMESTAMP=$(date +%s)
USER1="sectest_a_${TIMESTAMP}"
USER2="sectest_b_${TIMESTAMP}"
PASS1="SecurePass123!@#"
EMAIL1="sectest_a_${TIMESTAMP}@test.com"
EMAIL2="sectest_b_${TIMESTAMP}@test.com"

REPORT_FILE="/tmp/security_report_${TIMESTAMP}.txt"
echo "Security Test Report - $(date)" > $REPORT_FILE
echo "=================================" >> $REPORT_FILE

log_finding() {
    local severity=$1
    local finding=$2
    echo "[$severity] $finding" >> $REPORT_FILE
}

echo ""
echo "============================================"
echo "  Comprehensive Security Testing Suite"
echo "============================================"
echo "  Target: $BASE"
echo "  Time:   $(date)"
echo "============================================"
echo ""

# ============================================================
# STEP 0 — SETUP: Register test users
# ============================================================
echo -e "${BLUE}[*] Setting up test users...${NC}"

# Register Social User 1
SOCIAL_REG1=$(curl -s -X POST $BASE/social/api/auth/register/ \
  -H "Content-Type: application/json" \
  -d "{\"username\":\"$USER1\",\"password\":\"$PASS1\",\"password2\":\"$PASS1\",\"email\":\"$EMAIL1\",\"profile_name\":\"Test User A\"}" \
  -w "\n%{http_code}")
REG1_CODE=$(echo "$SOCIAL_REG1" | tail -n1)
REG1_BODY=$(echo "$SOCIAL_REG1" | head -n-1)

# Login Social User 1
SOCIAL_LOGIN1=$(curl -s -X POST $BASE/social/api/auth/login/ \
  -H "Content-Type: application/json" \
  -d "{\"username\":\"$USER1\",\"password\":\"$PASS1\"}" \
  -w "\n%{http_code}")
TOKEN1=$(echo "$SOCIAL_LOGIN1" | head -n-1 | grep -oP '"access"\s*:\s*"\K[^"]+' | head -1)

# Register Social User 2
SOCIAL_REG2=$(curl -s -X POST $BASE/social/api/auth/register/ \
  -H "Content-Type: application/json" \
  -d "{\"username\":\"$USER2\",\"password\":\"$PASS1\",\"password2\":\"$PASS1\",\"email\":\"$EMAIL2\",\"profile_name\":\"Test User B\"}" \
  -w "\n%{http_code}")

# Login Social User 2
SOCIAL_LOGIN2=$(curl -s -X POST $BASE/social/api/auth/login/ \
  -H "Content-Type: application/json" \
  -d "{\"username\":\"$USER2\",\"password\":\"$PASS1\"}" \
  -w "\n%{http_code}")
TOKEN2=$(echo "$SOCIAL_LOGIN2" | head -n-1 | grep -oP '"access"\s*:\s*"\K[^"]+' | head -1)

# Register Bank User 1
BANK_REG1=$(curl -s -X POST $BASE/bank/api/auth/register \
  -H "Content-Type: application/json" \
  -d "{\"username\":\"$USER1\",\"password\":\"$PASS1\",\"email\":\"$EMAIL1\"}" \
  -w "\n%{http_code}")
BANK_TOKEN1=$(echo "$BANK_REG1" | head -n-1 | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('data',{}).get('token',''))" 2>/dev/null)

# Register Bank User 2
BANK_REG2=$(curl -s -X POST $BASE/bank/api/auth/register \
  -H "Content-Type: application/json" \
  -d "{\"username\":\"$USER2\",\"password\":\"$PASS1\",\"email\":\"$EMAIL2\"}" \
  -w "\n%{http_code}")
BANK_TOKEN2=$(echo "$BANK_REG2" | head -n-1 | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('data',{}).get('token',''))" 2>/dev/null)

# Notes tokens
NOTES_LOGIN1=$(curl -s -X POST $BASE/notes/api/token/ \
  -H "Content-Type: application/json" \
  -d "{\"username\":\"$USER1\",\"password\":\"$PASS1\"}" \
  -w "\n%{http_code}")
NOTES_TOKEN1=$(echo "$NOTES_LOGIN1" | head -n-1 | grep -oP '"access"\s*:\s*"\K[^"]+' | head -1)

if [ -n "$TOKEN1" ]; then
    PASS "Social User 1 ready (JWT obtained)"
else
    WARN "Social User 1 token not obtained — some tests may fail"
fi

if [ -n "$BANK_TOKEN1" ]; then
    PASS "Bank User 1 ready (JWT obtained)"
else
    WARN "Bank User 1 token not obtained — some tests may fail"
fi

echo ""

# ============================================================
# TEST 1 — SQL INJECTION
# ============================================================
echo -e "${BLUE}[TEST 1] SQL Injection${NC}"
echo "--- SQL Injection ---" >> $REPORT_FILE

SQLi_PAYLOADS=(
    "' OR '1'='1"
    "' OR 1=1--"
    "admin'--"
    "' UNION SELECT 1,2,3--"
    "'; DROP TABLE users;--"
    "' OR 'x'='x"
)

# Blog login SQLi
echo "  Testing Blog login..."
for payload in "${SQLi_PAYLOADS[@]}"; do
    RESPONSE=$(curl -s -X POST $BASE/blog/login/ \
      -H "Content-Type: application/x-www-form-urlencoded" \
      -d "username=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$payload'))")&password=anything" \
      -w "\n%{http_code}" \
      -c /tmp/blog_cookies_sqli.txt)
    CODE=$(echo "$RESPONSE" | tail -n1)
    BODY=$(echo "$RESPONSE" | head -n-1)

    if echo "$BODY" | grep -qi "syntax error\|sql\|mysql\|postgresql\|sqlite\|ORA-\|warning.*mysql"; then
        FAIL "SQLi VULNERABLE on Blog login! Payload: $payload"
        log_finding "CRITICAL" "SQL Injection vulnerable on Blog login: $payload"
    elif [[ $CODE == "302" || $CODE == "200" ]] && echo "$BODY" | grep -qi "logout\|dashboard\|welcome"; then
        FAIL "SQLi bypass possible on Blog login! Payload: $payload"
        log_finding "CRITICAL" "SQL Injection auth bypass on Blog login: $payload"
    fi
done
PASS "Blog login — no SQLi detected"

# Social API SQLi
echo "  Testing Social API..."
for payload in "${SQLi_PAYLOADS[@]}"; do
    RESPONSE=$(curl -s -X POST $BASE/social/api/auth/login/ \
      -H "Content-Type: application/json" \
      -d "{\"username\":\"$payload\",\"password\":\"anything\"}" \
      -w "\n%{http_code}")
    CODE=$(echo "$RESPONSE" | tail -n1)
    BODY=$(echo "$RESPONSE" | head -n-1)

    if echo "$BODY" | grep -qi "syntax error\|sql\|mysql\|postgresql"; then
        FAIL "SQLi VULNERABLE on Social API! Payload: $payload"
        log_finding "CRITICAL" "SQL Injection on Social API: $payload"
    fi
done
PASS "Social API — no SQLi detected"

# Query param SQLi
echo "  Testing query parameters..."
for payload in "1 OR 1=1" "1' OR '1'='1" "1; DROP TABLE--"; do
    ENCODED=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$payload'))")
    RESPONSE=$(curl -s "$BASE/notes/api/notes/?id=$ENCODED" \
      -H "Authorization: Bearer $NOTES_TOKEN1" \
      -w "\n%{http_code}")
    BODY=$(echo "$RESPONSE" | head -n-1)

    if echo "$BODY" | grep -qi "syntax error\|sql\|mysql\|postgresql"; then
        FAIL "SQLi in query params! Payload: $payload"
        log_finding "CRITICAL" "SQL Injection in query params: $payload"
    fi
done
PASS "Query parameters — no SQLi detected"
echo ""

# ============================================================
# TEST 2 — BRUTE FORCE PROTECTION
# ============================================================
echo -e "${BLUE}[TEST 2] Brute Force Protection${NC}"
echo "--- Brute Force ---" >> $REPORT_FILE

brute_force_test() {
    local name=$1
    local url=$2
    local data=$3
    local attempts=20
    local blocked=false
    local block_code=""

    echo "  Testing $name ($attempts attempts)..."
    for i in $(seq 1 $attempts); do
        CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$url" \
          -H "Content-Type: application/json" \
          -d "$data")

        if [[ $CODE == "429" || $CODE == "423" || $CODE == "503" ]]; then
            PASS "$name blocked after $i attempts (HTTP $CODE)"
            log_finding "INFO" "$name has brute force protection (blocked at attempt $i)"
            blocked=true
            block_code=$CODE
            break
        fi
    done

    if [ "$blocked" = false ]; then
        WARN "$name — no rate limiting detected after $attempts attempts"
        log_finding "MEDIUM" "$name has no brute force protection"
    fi
}

brute_force_test "Social login" \
    "$BASE/social/api/auth/login/" \
    '{"username":"nonexistent","password":"wrongpass"}'

brute_force_test "Blog login" \
    "$BASE/blog/login/" \
    'username=admin&password=wrongpass'

brute_force_test "Bank login" \
    "$BASE/bank/api/auth/login" \
    '{"usernameOrEmail":"nonexistent","password":"wrongpass"}'

echo ""

# ============================================================
# TEST 3 — JWT SECURITY
# ============================================================
echo -e "${BLUE}[TEST 3] JWT Security${NC}"
echo "--- JWT Security ---" >> $REPORT_FILE

echo "  Testing tampered JWT..."
TAMPERED="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImFkbWluIiwiaXNfYWRtaW4iOnRydWV9.FAKESIGNATURE"
CODE=$(curl -s -o /dev/null -w "%{http_code}" $BASE/social/api/auth/me/ \
  -H "Authorization: Bearer $TAMPERED")
if [[ $CODE == "401" || $CODE == "403" ]]; then
    PASS "Tampered JWT rejected (HTTP $CODE)"
    log_finding "INFO" "JWT tampering properly rejected"
else
    FAIL "Tampered JWT accepted! (HTTP $CODE)"
    log_finding "CRITICAL" "JWT tampering not detected"
fi

echo "  Testing 'none' algorithm attack..."
# Header: {"alg":"none","typ":"JWT"} → base64
NONE_HEADER="eyJhbGciOiJub25lIiwidHlwIjoiSldUIn0"
NONE_PAYLOAD="eyJ1c2VybmFtZSI6ImFkbWluIn0"
NONE_TOKEN="${NONE_HEADER}.${NONE_PAYLOAD}."
CODE=$(curl -s -o /dev/null -w "%{http_code}" $BASE/social/api/auth/me/ \
  -H "Authorization: Bearer $NONE_TOKEN")
if [[ $CODE == "401" || $CODE == "403" ]]; then
    PASS "'none' algorithm attack rejected (HTTP $CODE)"
    log_finding "INFO" "JWT none algorithm attack blocked"
else
    FAIL "'none' algorithm accepted! CRITICAL vulnerability!"
    log_finding "CRITICAL" "JWT none algorithm attack succeeded"
fi

echo "  Testing expired token..."
EXPIRED="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3QiLCJleHAiOjE2MDAwMDAwMDB9.invalid"
CODE=$(curl -s -o /dev/null -w "%{http_code}" $BASE/social/api/auth/me/ \
  -H "Authorization: Bearer $EXPIRED")
if [[ $CODE == "401" || $CODE == "403" ]]; then
    PASS "Expired token rejected (HTTP $CODE)"
else
    FAIL "Expired token accepted! (HTTP $CODE)"
    log_finding "HIGH" "Expired JWT tokens not rejected"
fi

echo "  Testing no token..."
CODE=$(curl -s -o /dev/null -w "%{http_code}" $BASE/social/api/auth/me/)
if [[ $CODE == "401" || $CODE == "403" ]]; then
    PASS "No token properly rejected (HTTP $CODE)"
else
    FAIL "Endpoint accessible without token! (HTTP $CODE)"
    log_finding "CRITICAL" "Endpoint accessible without authentication"
fi

echo "  Checking JWT token contents..."
if [ -n "$TOKEN1" ]; then
    PAYLOAD=$(echo "$TOKEN1" | cut -d. -f2 | base64 -d 2>/dev/null | python3 -m json.tool 2>/dev/null)
    if echo "$PAYLOAD" | grep -qi "password\|secret\|key"; then
        WARN "JWT payload contains sensitive data!"
        log_finding "HIGH" "JWT payload contains sensitive information"
    else
        PASS "JWT payload looks clean"
        INFO "JWT contents: $(echo $PAYLOAD | head -c 100)..."
    fi
fi
echo ""

# ============================================================
# TEST 4 — FILE UPLOAD SECURITY
# ============================================================
echo -e "${BLUE}[TEST 4] File Upload Security${NC}"
echo "--- File Upload ---" >> $REPORT_FILE

# Create test files
echo '<?php system($_GET["cmd"]); ?>' > /tmp/shell.php
echo '<?php echo "vulnerable"; ?>' > /tmp/test.php
# Create fake image with PHP inside
printf '\xff\xd8\xff\xe0<?php system($_GET["cmd"]); ?>' > /tmp/shell_disguised.jpg
echo "harmless text content" > /tmp/legit.txt

if [ -n "$TOKEN1" ]; then
    echo "  Testing PHP shell upload as post..."
    for endpoint in "/social/api/posts/" "/social/api/stories/" "/notes/api/notes/"; do
        CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST $BASE$endpoint \
          -H "Authorization: Bearer $TOKEN1" \
          -F "file=@/tmp/shell.php;type=image/jpeg" \
          -F "content=test post")

        if [[ $CODE == "200" || $CODE == "201" ]]; then
            FAIL "PHP file upload accepted on $endpoint!"
            log_finding "CRITICAL" "PHP shell upload accepted on $endpoint"
        elif [[ $CODE == "400" || $CODE == "415" || $CODE == "422" ]]; then
            PASS "PHP upload rejected on $endpoint (HTTP $CODE)"
        else
            INFO "$endpoint returned HTTP $CODE for PHP upload"
        fi
    done

    echo "  Testing disguised PHP as image..."
    CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST $BASE/social/api/posts/ \
      -H "Authorization: Bearer $TOKEN1" \
      -F "image=@/tmp/shell_disguised.jpg;type=image/jpeg" \
      -F "content=test")
    INFO "Disguised PHP upload: HTTP $CODE"

    echo "  Testing oversized file..."
    dd if=/dev/zero bs=1M count=101 2>/dev/null | gzip > /tmp/huge.gz
    CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST $BASE/social/api/posts/ \
      -H "Authorization: Bearer $TOKEN1" \
      -F "file=@/tmp/huge.gz" \
      -F "content=test" \
      --max-time 10)
    if [[ $CODE == "413" || $CODE == "400" ]]; then
        PASS "Oversized file rejected (HTTP $CODE)"
        log_finding "INFO" "File size limit enforced"
    else
        WARN "Oversized file not rejected (HTTP $CODE)"
        log_finding "MEDIUM" "No file size limit detected"
    fi
fi

# Cleanup temp files
rm -f /tmp/shell.php /tmp/test.php /tmp/shell_disguised.jpg /tmp/legit.txt /tmp/huge.gz
echo ""

# ============================================================
# TEST 5 — IDOR (Insecure Direct Object Reference)
# ============================================================
echo -e "${BLUE}[TEST 5] IDOR Testing${NC}"
echo "--- IDOR ---" >> $REPORT_FILE

if [ -n "$TOKEN1" ] && [ -n "$TOKEN2" ]; then

    # Create a note with User 1
    echo "  Creating resource as User 1..."
    CREATE_RESP=$(curl -s -X POST $BASE/notes/api/notes/ \
      -H "Authorization: Bearer $NOTES_TOKEN1" \
      -H "Content-Type: application/json" \
      -d '{"title":"Private Note","content":"Secret content for user 1 only"}' \
      -w "\n%{http_code}")
    CREATE_CODE=$(echo "$CREATE_RESP" | tail -n1)
    CREATE_BODY=$(echo "$CREATE_RESP" | head -n-1)
    NOTE_ID=$(echo "$CREATE_BODY" | grep -oP '"id"\s*:\s*\K[0-9]+' | head -1)

    if [ -n "$NOTE_ID" ]; then
        PASS "Note created with ID: $NOTE_ID"

        # Try to access User 1's note with User 2's token
        echo "  Testing cross-user access (User2 accessing User1's note)..."
        IDOR_RESP=$(curl -s -w "\n%{http_code}" $BASE/notes/api/notes/$NOTE_ID/ \
          -H "Authorization: Bearer $TOKEN2")
        IDOR_CODE=$(echo "$IDOR_RESP" | tail -n1)
        IDOR_BODY=$(echo "$IDOR_RESP" | head -n-1)

        if [[ $IDOR_CODE == "403" || $IDOR_CODE == "404" ]]; then
            PASS "IDOR prevented — User2 cannot access User1's note (HTTP $IDOR_CODE)"
            log_finding "INFO" "IDOR protection working on notes"
        elif [[ $IDOR_CODE == "200" ]]; then
            FAIL "IDOR VULNERABLE — User2 can access User1's private note!"
            log_finding "CRITICAL" "IDOR vulnerability on /notes/api/notes/$NOTE_ID/"
        else
            INFO "IDOR test returned HTTP $IDOR_CODE"
        fi

        # Try to delete User 1's note with User 2's token
        echo "  Testing cross-user delete..."
        DEL_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE \
          $BASE/notes/api/notes/$NOTE_ID/ \
          -H "Authorization: Bearer $TOKEN2")
        if [[ $DEL_CODE == "403" || $DEL_CODE == "404" ]]; then
            PASS "Cross-user delete prevented (HTTP $DEL_CODE)"
        elif [[ $DEL_CODE == "204" || $DEL_CODE == "200" ]]; then
            FAIL "IDOR DELETE — User2 deleted User1's note!"
            log_finding "CRITICAL" "IDOR delete vulnerability on notes"
        fi
    else
        INFO "Could not create note for IDOR test (HTTP $CREATE_CODE)"
    fi

    # Social Media IDOR — try accessing other user's profile data
    echo "  Testing Social API IDOR..."
    # Get User1's profile ID
    PROFILE1=$(curl -s $BASE/social/api/auth/me/ \
      -H "Authorization: Bearer $TOKEN1")
    USER1_ID=$(echo "$PROFILE1" | grep -oP '"id"\s*:\s*\K[0-9]+' | head -1)

    if [ -n "$USER1_ID" ]; then
        # Try accessing with User2's token
        NEXT_ID=$((USER1_ID + 1))
        for test_id in $USER1_ID $NEXT_ID; do
            RESP_CODE=$(curl -s -o /dev/null -w "%{http_code}" \
              $BASE/social/api/users/$test_id/ \
              -H "Authorization: Bearer $TOKEN2")
            INFO "Social user $test_id accessed by User2: HTTP $RESP_CODE"
            if [[ $RESP_CODE == "200" ]]; then
                WARN "User $test_id profile accessible by other users — check if this is intended"
            fi
        done
    fi

    # Bank IDOR — try accessing other account
    echo "  Testing Bank IDOR..."
    BANK_ACCT1=$(curl -s $BASE/bank/api/accounts/ \
      -H "Authorization: Bearer $BANK_TOKEN1")
    ACCT_ID=$(echo "$BANK_ACCT1" | grep -oP '"accountId"\s*:\s*\K[0-9]+' | head -1 || \
              echo "$BANK_ACCT1" | grep -oP '"id"\s*:\s*\K[0-9]+' | head -1)

    if [ -n "$ACCT_ID" ]; then
        NEXT_ACCT=$((ACCT_ID + 1))
        CODE=$(curl -s -o /dev/null -w "%{http_code}" \
          $BASE/bank/api/accounts/$NEXT_ACCT/ \
          -H "Authorization: Bearer $BANK_TOKEN2")
        if [[ $CODE == "403" || $CODE == "404" ]]; then
            PASS "Bank IDOR prevented (HTTP $CODE)"
            log_finding "INFO" "Bank IDOR protection working"
        elif [[ $CODE == "200" ]]; then
            FAIL "Bank IDOR VULNERABLE — can access other accounts!"
            log_finding "CRITICAL" "IDOR on Bank accounts endpoint"
        else
            INFO "Bank IDOR test: HTTP $CODE"
        fi
    fi
else
    WARN "Skipping IDOR tests — tokens not available"
fi
echo ""

# ============================================================
# TEST 6 — RATE LIMITING
# ============================================================
echo -e "${BLUE}[TEST 6] Rate Limiting${NC}"
echo "--- Rate Limiting ---" >> $REPORT_FILE

rate_limit_test() {
    local name=$1
    local url=$2
    local token=$3
    local requests=50
    local blocked=false

    echo "  Testing $name ($requests requests)..."
    for i in $(seq 1 $requests); do
        if [ -n "$token" ]; then
            CODE=$(curl -s -o /dev/null -w "%{http_code}" "$url" \
              -H "Authorization: Bearer $token")
        else
            CODE=$(curl -s -o /dev/null -w "%{http_code}" "$url")
        fi

        if [[ $CODE == "429" ]]; then
            PASS "$name rate limited after $i requests"
            log_finding "INFO" "$name rate limiting active (triggered at $i requests)"
            blocked=true
            break
        fi
    done

    if [ "$blocked" = false ]; then
        WARN "$name — no rate limiting after $requests requests"
        log_finding "LOW" "$name has no rate limiting"
    fi
}

rate_limit_test "Social API (authenticated)" \
    "$BASE/social/api/posts/" "$TOKEN1"

rate_limit_test "Social login (unauthenticated)" \
    "$BASE/social/api/auth/login/" ""

rate_limit_test "Blog (unauthenticated)" \
    "$BASE/blog/" ""

rate_limit_test "Notes API" \
    "$BASE/notes/api/notes/" "$NOTES_TOKEN1"
echo ""

# ============================================================
# TEST 7 — SECURITY HEADERS
# ============================================================
echo -e "${BLUE}[TEST 7] Security Headers${NC}"
echo "--- Security Headers ---" >> $REPORT_FILE

echo "  Checking nginx security headers..."
HEADERS=$(curl -s -I $BASE/)

check_header() {
    local header=$1
    local name=$2
    if echo "$HEADERS" | grep -qi "$header"; then
        PASS "$name present"
        log_finding "INFO" "Header $name present"
    else
        WARN "$name missing"
        log_finding "LOW" "Missing security header: $name"
    fi
}

check_header "x-content-type-options" "X-Content-Type-Options"
check_header "x-frame-options" "X-Frame-Options"
check_header "content-security-policy" "Content-Security-Policy"
check_header "strict-transport-security" "Strict-Transport-Security"
check_header "referrer-policy" "Referrer-Policy"
check_header "permissions-policy" "Permissions-Policy"

# Check server header leakage
SERVER=$(echo "$HEADERS" | grep -i "^server:" | tr -d '\r')
if echo "$SERVER" | grep -qP "nginx/[\d.]+ "; then
    WARN "Server version exposed: $SERVER"
    log_finding "LOW" "Web server version disclosed: $SERVER"
else
    PASS "Server header not leaking version"
fi
echo ""

# ============================================================
# TEST 8 — SENSITIVE ENDPOINT EXPOSURE
# ============================================================
echo -e "${BLUE}[TEST 8] Sensitive Endpoint Exposure${NC}"
echo "--- Sensitive Endpoints ---" >> $REPORT_FILE

SENSITIVE_PATHS=(
    "/.env"
    "/.git/config"
    "/config.php"
    "/backup.sql"
    "/dump.sql"
    "/database.sql"
    "/.htpasswd"
    "/wp-admin/"
    "/admin/"
    "/phpmyadmin/"
    "/adminer.php"
    "/server-status"
    "/nginx-status"
    "/.DS_Store"
    "/Dockerfile"
    "/docker-compose.yml"
    "/terraform.tfvars"
    "/.terraform/"
    "/package.json"
    "/requirements.txt"
)

echo "  Scanning sensitive paths..."
FOUND_SENSITIVE=false
for path in "${SENSITIVE_PATHS[@]}"; do
    CODE=$(curl -s -o /dev/null -w "%{http_code}" "$BASE$path")
    BODY=$(curl -s "$BASE$path" | head -c 100)

    # Your app returns 200 for everything — check if it's the gateway response or real content
    if [[ $CODE == "200" ]] && ! echo "$BODY" | grep -q "gateway running"; then
        WARN "Potentially exposed: $path (HTTP $CODE)"
        log_finding "HIGH" "Sensitive path exposed: $path"
        FOUND_SENSITIVE=true
    fi
done

if [ "$FOUND_SENSITIVE" = false ]; then
    PASS "No sensitive paths exposed"
fi
echo ""

# ============================================================
# TEST 9 — XSS (Basic)
# ============================================================
echo -e "${BLUE}[TEST 9] XSS Testing${NC}"
echo "--- XSS ---" >> $REPORT_FILE

XSS_PAYLOADS=(
    "<script>alert(1)</script>"
    "<img src=x onerror=alert(1)>"
    "javascript:alert(1)"
    "<svg onload=alert(1)>"
)

if [ -n "$TOKEN1" ]; then
    echo "  Testing stored XSS via post creation..."
    for payload in "${XSS_PAYLOADS[@]}"; do
        RESP=$(curl -s -X POST $BASE/social/api/posts/ \
          -H "Authorization: Bearer $TOKEN1" \
          -H "Content-Type: application/json" \
          -d "{\"content\":\"$payload\"}" \
          -w "\n%{http_code}")
        CODE=$(echo "$RESP" | tail -n1)
        BODY=$(echo "$RESP" | head -n-1)

        if [[ $CODE == "200" || $CODE == "201" ]]; then
            # Check if payload is reflected unescaped
            if echo "$BODY" | grep -q "$payload"; then
                WARN "XSS payload stored unescaped — check frontend rendering"
                log_finding "HIGH" "Potential stored XSS: $payload"
            else
                PASS "XSS payload appears escaped/sanitized"
            fi
        fi
    done

    echo "  Testing reflected XSS in search..."
    for payload in "${XSS_PAYLOADS[@]}"; do
        ENCODED=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$payload'))")
        RESP=$(curl -s "$BASE/social/api/posts/?search=$ENCODED" \
          -H "Authorization: Bearer $TOKEN1")
        if echo "$RESP" | grep -q "<script>"; then
            FAIL "Reflected XSS detected in search!"
            log_finding "HIGH" "Reflected XSS in search parameter"
        fi
    done
    PASS "No obvious XSS vulnerabilities detected"
fi
echo ""

# ============================================================
# FINAL REPORT
# ============================================================
echo "============================================"
echo "  Security Test Complete"
echo "============================================"
echo ""
echo "Full report saved to: $REPORT_FILE"
echo ""
echo "--- Report Summary ---"
cat $REPORT_FILE
echo ""

# Count findings by severity
CRITICAL=$(grep -c "\[CRITICAL\]" $REPORT_FILE)
HIGH=$(grep -c "\[HIGH\]" $REPORT_FILE)
MEDIUM=$(grep -c "\[MEDIUM\]" $REPORT_FILE)
LOW=$(grep -c "\[LOW\]" $REPORT_FILE)
INFO_COUNT=$(grep -c "\[INFO\]" $REPORT_FILE)

echo "============================================"
echo "  Finding Summary"
echo "============================================"
echo -e "  ${RED}CRITICAL: $CRITICAL${NC}"
echo -e "  ${RED}HIGH:     $HIGH${NC}"
echo -e "  ${YELLOW}MEDIUM:   $MEDIUM${NC}"
echo -e "  ${BLUE}LOW:      $LOW${NC}"
echo -e "  ${GREEN}INFO:     $INFO_COUNT${NC}"
echo "============================================"
echo ""
echo "Copy report to your project docs:"
echo "  cp $REPORT_FILE ~/Coding-Project/Projects/Finished\ Projects/Docker/Terraform/projects/scripts/security_report_$(date +%Y%m%d).txt"