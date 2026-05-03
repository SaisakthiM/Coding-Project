#!/bin/bash

# ═══════════════════════════════════════════════════════════════
# Authentication & Authorization Testing Script
# Tests JWT reusability and horizontal privilege escalation
# ═══════════════════════════════════════════════════════════════

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() { echo -e "${BLUE}[*]${NC} $1"; }
log_success() { echo -e "${GREEN}[✓]${NC} $1"; }
log_error() { echo -e "${RED}[✗]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[!]${NC} $1"; }
log_header() { echo -e "\n${BLUE}========== $1 ==========${NC}\n"; }
log_test() { echo -e "${YELLOW}[TEST]${NC} $1"; }
log_result() { 
    if [ "$2" == "PASS" ]; then
        echo -e "${GREEN}[PASS]${NC} $1"
    else
        echo -e "${RED}[FAIL]${NC} $1"
    fi
}

# Results file
RESULTS_FILE="auth_test_results_$(date +%Y%m%d_%H%M%S).txt"
exec 3>&1 1> >(tee "$RESULTS_FILE")

log_header "Authentication & Authorization Test Suite"
log_info "Starting test run at $(date)"
log_info "Results will be saved to: $RESULTS_FILE"

# Configuration
BASE_URL="http://localhost"
USER1_USERNAME="testuser1_$(date +%s)"
USER1_PASSWORD="TestPass123!@#"
USER2_USERNAME="testuser2_$(date +%s)"
USER2_PASSWORD="TestPass456!@#"

log_info "Test User 1: $USER1_USERNAME / $USER1_PASSWORD"
log_info "Test User 2: $USER2_USERNAME / $USER2_PASSWORD"

# Storage for tokens
declare -A TOKENS
declare -A COOKIES
declare -A USER_IDS

# ═══════════════════════════════════════════════════════════════
# Phase 1: Registration & Login
# ═══════════════════════════════════════════════════════════════

log_header "Phase 1: User Registration & Token Collection"

# Helper function to register user
register_user() {
    local app=$1
    local username=$2
    local password=$3
    local email="${username}@test.local"
    
    log_info "Attempting registration on $app..."
    
    case $app in
        blog)
            # Try Django registration
            response=$(curl -s -X POST "$BASE_URL/blog/register/" \
                -H "Content-Type: application/json" \
                -d "{\"username\":\"$username\",\"password\":\"$password\",\"email\":\"$email\"}" \
                -w "\n%{http_code}")
            ;;
        notes)
            response=$(curl -s -X POST "$BASE_URL/notes/register/" \
                -H "Content-Type: application/json" \
                -d "{\"username\":\"$username\",\"password\":\"$password\",\"email\":\"$email\"}" \
                -w "\n%{http_code}")
            ;;
        bank)
            response=$(curl -s -X POST "$BASE_URL/bank/register" \
                -H "Content-Type: application/json" \
                -d "{\"username\":\"$username\",\"password\":\"$password\",\"email\":\"$email\"}" \
                -w "\n%{http_code}")
            ;;
        social)
            response=$(curl -s -X POST "$BASE_URL/register/" \
                -H "Content-Type: application/json" \
                -d "{\"username\":\"$username\",\"password\":\"$password\",\"email\":\"$email\"}" \
                -w "\n%{http_code}")
            ;;
    esac
    
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | head -n-1)
    
    if [[ $http_code == 201 || $http_code == 200 ]]; then
        log_success "$app: User registered successfully"
        return 0
    else
        log_warning "$app: Registration returned $http_code (might already exist, trying login)"
        return 1
    fi
}

# Helper function to login user
login_user() {
    local app=$1
    local username=$2
    local password=$3
    
    log_info "Logging in to $app as $username..."
    
    case $app in
        blog)
            response=$(curl -s -c "/tmp/${app}_cookies_$username.txt" -X POST "$BASE_URL/blog/login/" \
                -H "Content-Type: application/json" \
                -d "{\"username\":\"$username\",\"password\":\"$password\"}" \
                -w "\n%{http_code}")
            ;;
        notes)
            response=$(curl -s -c "/tmp/${app}_cookies_$username.txt" -X POST "$BASE_URL/notes/login/" \
                -H "Content-Type: application/json" \
                -d "{\"username\":\"$username\",\"password\":\"$password\"}" \
                -w "\n%{http_code}")
            ;;
        bank)
            response=$(curl -s -c "/tmp/${app}_cookies_$username.txt" -X POST "$BASE_URL/bank/login" \
                -H "Content-Type: application/json" \
                -d "{\"username\":\"$username\",\"password\":\"$password\"}" \
                -w "\n%{http_code}")
            ;;
        social)
            response=$(curl -s -c "/tmp/${app}_cookies_$username.txt" -X POST "$BASE_URL/login/" \
                -H "Content-Type: application/json" \
                -d "{\"username\":\"$username\",\"password\":\"$password\"}" \
                -w "\n%{http_code}")
            ;;
    esac
    
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | head -n-1)
    
    # Try to extract JWT from response
    if echo "$body" | jq . &>/dev/null; then
        token=$(echo "$body" | jq -r '.token // .access_token // .jwt // empty' 2>/dev/null || echo "")
        
        if [ -n "$token" ] && [ "$token" != "null" ]; then
            TOKENS["${app}_${username}"]="$token"
            log_success "$app: Login successful, JWT token captured"
            echo "Token: ${token:0:50}..."
            return 0
        fi
    fi
    
    # If no JWT, check for session cookie
    if [ -f "/tmp/${app}_cookies_$username.txt" ]; then
        cookie=$(grep "^#HttpOnly" "/tmp/${app}_cookies_$username.txt" 2>/dev/null | head -1 || \
                 grep -v "^#" "/tmp/${app}_cookies_$username.txt" | head -1)
        if [ -n "$cookie" ]; then
            COOKIES["${app}_${username}"]="/tmp/${app}_cookies_$username.txt"
            log_success "$app: Login successful, session cookie captured"
            return 0
        fi
    fi
    
    if [[ $http_code == 200 || $http_code == 201 ]]; then
        log_warning "$app: Login returned $http_code but no token found in response"
        log_info "Response body: $body"
        return 1
    else
        log_error "$app: Login failed with HTTP $http_code"
        log_error "Response: $body"
        return 1
    fi
}

# Register and login User1 on all apps
for app in blog notes bank social; do
    log_test "$app - User1 Registration & Login"
    register_user "$app" "$USER1_USERNAME" "$USER1_PASSWORD" || true
    login_user "$app" "$USER1_USERNAME" "$USER1_PASSWORD"
done

# Register and login User2 on all apps (for IDOR testing)
log_info ""
log_info "Now registering User2 for IDOR testing..."
for app in blog notes bank social; do
    log_test "$app - User2 Registration & Login"
    register_user "$app" "$USER2_USERNAME" "$USER2_PASSWORD" || true
    login_user "$app" "$USER2_USERNAME" "$USER2_PASSWORD"
done

log_info ""
log_info "Collected tokens:"
for key in "${!TOKENS[@]}"; do
    echo "  $key: ${TOKENS[$key]:0:50}..."
done

# ═══════════════════════════════════════════════════════════════
# Phase 2: JWT Reusability Testing
# ═══════════════════════════════════════════════════════════════

log_header "Phase 2: JWT Reusability Testing"
log_info "Testing if JWT from one app works on another app"

test_jwt_reusability() {
    local source_app=$1
    local target_app=$2
    local user=$3
    local endpoint=$4
    
    local token="${TOKENS[${source_app}_${user}]}"
    
    if [ -z "$token" ]; then
        log_warning "No token found for ${source_app}_${user}, skipping test"
        return
    fi
    
    log_test "Using $source_app JWT on $target_app endpoint: $endpoint"
    
    response=$(curl -s -X GET "$BASE_URL$endpoint" \
        -H "Authorization: Bearer $token" \
        -w "\n%{http_code}")
    
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | head -n-1)
    
    if [[ $http_code == 200 || $http_code == 201 ]]; then
        log_result "JWT REUSABLE: $source_app token accepted by $target_app!" "FAIL"
        echo "Response: $body" | head -c 200
        echo ""
    elif [[ $http_code == 401 || $http_code == 403 ]]; then
        log_result "JWT NOT REUSABLE: $source_app token rejected by $target_app" "PASS"
    else
        log_warning "Unexpected response code $http_code"
    fi
}

# Test cross-app JWT reusability
test_jwt_reusability "blog" "notes" "$USER1_USERNAME" "/notes/api/notes/"
test_jwt_reusability "blog" "bank" "$USER1_USERNAME" "/bank/api/accounts"
test_jwt_reusability "blog" "social" "$USER1_USERNAME" "/social/api/posts/"
test_jwt_reusability "notes" "blog" "$USER1_USERNAME" "/blog/api/posts/"
test_jwt_reusability "notes" "bank" "$USER1_USERNAME" "/bank/api/accounts"
test_jwt_reusability "bank" "notes" "$USER1_USERNAME" "/notes/api/notes/"
test_jwt_reusability "social" "blog" "$USER1_USERNAME" "/blog/api/posts/"

# ═══════════════════════════════════════════════════════════════
# Phase 3: Horizontal Privilege Escalation (IDOR)
# ═══════════════════════════════════════════════════════════════

log_header "Phase 3: Horizontal Privilege Escalation (IDOR) Testing"
log_info "Testing if user1 can access/modify user2's data"

test_idor() {
    local app=$1
    local endpoint=$2
    local method=${3:-GET}
    local payload=$4
    
    local token="${TOKENS[${app}_${USER1_USERNAME}]}"
    
    if [ -z "$token" ]; then
        log_warning "No token for $app, skipping IDOR test"
        return
    fi
    
    log_test "$app: Testing $method $endpoint"
    
    if [ "$method" == "GET" ]; then
        response=$(curl -s -X GET "$BASE_URL$endpoint" \
            -H "Authorization: Bearer $token" \
            -w "\n%{http_code}")
    else
        response=$(curl -s -X "$method" "$BASE_URL$endpoint" \
            -H "Authorization: Bearer $token" \
            -H "Content-Type: application/json" \
            -d "$payload" \
            -w "\n%{http_code}")
    fi
    
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | head -n-1)
    
    if [[ $http_code == 200 || $http_code == 201 ]]; then
        log_result "IDOR VULNERABILITY: User1 accessed/modified User2 data!" "FAIL"
        echo "Response preview: ${body:0:150}"
    elif [[ $http_code == 403 || $http_code == 404 ]]; then
        log_result "IDOR protected: Proper access control in place" "PASS"
    else
        log_warning "Unexpected response code: $http_code"
    fi
}

# IDOR tests (adjust endpoints based on actual API structure)
test_idor "notes" "/notes/api/notes/2/" "GET"
test_idor "blog" "/blog/api/posts/2/" "GET"
test_idor "bank" "/bank/api/accounts/2" "GET"
test_idor "social" "/social/api/users/2/" "GET"

# Modify operations
test_idor "notes" "/notes/api/notes/2/" "PUT" '{"title":"Hacked by user1","content":"test"}'
test_idor "blog" "/blog/api/posts/2/" "PUT" '{"title":"Hacked","content":"test"}'

# ═══════════════════════════════════════════════════════════════
# Phase 4: Cookie-Based Authentication
# ═══════════════════════════════════════════════════════════════

log_header "Phase 4: Cookie-Based Authentication Testing"
log_info "Testing if session cookies are properly scoped"

test_cookie_reusability() {
    local source_app=$1
    local target_app=$2
    local user=$3
    local endpoint=$4
    
    local cookie_file="${COOKIES[${source_app}_${user}]}"
    
    if [ -z "$cookie_file" ] || [ ! -f "$cookie_file" ]; then
        log_warning "No cookie file found for ${source_app}_${user}"
        return
    fi
    
    log_test "Using $source_app cookie on $target_app: $endpoint"
    
    response=$(curl -s -X GET "$BASE_URL$endpoint" \
        -b "$cookie_file" \
        -w "\n%{http_code}")
    
    http_code=$(echo "$response" | tail -n1)
    
    if [[ $http_code == 200 || $http_code == 201 ]]; then
        log_result "COOKIE REUSABLE: $source_app cookie accepted by $target_app!" "FAIL"
    elif [[ $http_code == 401 || $http_code == 403 ]]; then
        log_result "COOKIE NOT REUSABLE: Properly scoped to $source_app" "PASS"
    else
        log_warning "Unexpected response code: $http_code"
    fi
}

test_cookie_reusability "blog" "notes" "$USER1_USERNAME" "/notes/api/notes/"
test_cookie_reusability "notes" "blog" "$USER1_USERNAME" "/blog/api/posts/"

# ═══════════════════════════════════════════════════════════════
# Phase 5: Token Expiry & Refresh
# ═══════════════════════════════════════════════════════════════

log_header "Phase 5: Token Validation Testing"

test_token_validation() {
    local app=$1
    local endpoint=$2
    
    log_test "$app: Testing with invalid/expired token"
    
    response=$(curl -s -X GET "$BASE_URL$endpoint" \
        -H "Authorization: Bearer invalid.token.here" \
        -w "\n%{http_code}")
    
    http_code=$(echo "$response" | tail -n1)
    
    if [[ $http_code == 401 || $http_code == 403 ]]; then
        log_result "$app properly rejects invalid tokens" "PASS"
    else
        log_result "$app accepts invalid tokens (HTTP $http_code)!" "FAIL"
    fi
}

test_token_validation "blog" "/blog/api/posts/"
test_token_validation "notes" "/notes/api/notes/"
test_token_validation "bank" "/bank/api/accounts"

# ═══════════════════════════════════════════════════════════════
# Cleanup & Summary
# ═══════════════════════════════════════════════════════════════

log_header "Test Summary & Cleanup"

log_info "Test run completed at $(date)"
log_info "Full results saved to: $RESULTS_FILE"

# Count results
passes=$(grep -c "\[PASS\]" "$RESULTS_FILE" || echo 0)
fails=$(grep -c "\[FAIL\]" "$RESULTS_FILE" || echo 0)

log_info ""
log_info "Results: $passes PASS, $fails FAIL"

if [ $fails -gt 0 ]; then
    log_error "Security issues found! Review $RESULTS_FILE for details"
    log_error ""
    grep "\[FAIL\]" "$RESULTS_FILE"
else
    log_success "All security tests passed!"
fi

# Show critical findings
log_info ""
log_info "Critical Findings:"
grep -E "(REUSABLE|IDOR VULNERABILITY)" "$RESULTS_FILE" || log_info "None detected"

# Cleanup temp files
log_info ""
log_info "Cleaning up temporary files..."
rm -f /tmp/*_cookies_*.txt

log_info "Done!"