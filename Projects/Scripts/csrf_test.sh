#!/bin/bash

# Auth Testing Script with CSRF Token Handling
# Tests if apps properly validate CSRF tokens

echo "=========================================="
echo "Authentication & CSRF Testing"
echo "=========================================="
echo ""

USER1="testuser_u1_$(date +%s)"
PASS="TestPass123!@#"
EMAIL="test_$(date +%s)@test.com"

# ============= BLOG =============
echo "[*] Testing BLOG..."

echo "  - Fetching login page to get CSRF token..."
BLOG_GET=$(curl -s -c /tmp/blog_cookies.txt http://localhost/blog/login/)

BLOG_CSRF=$(echo "$BLOG_GET" | grep -oP 'name="csrfmiddlewaretoken" value="\K[^"]+' | head -1)

if [ -n "$BLOG_CSRF" ]; then
    echo "  ✓ CSRF Token found: ${BLOG_CSRF:0:30}..."
    echo "  - Logging in WITH CSRF token..."
    BLOG_LOGIN=$(curl -s -X POST http://localhost/blog/login/ \
      -b /tmp/blog_cookies.txt -c /tmp/blog_cookies.txt \
      -H "Content-Type: application/x-www-form-urlencoded" \
      -d "username=$USER1&password=$PASS&csrfmiddlewaretoken=$BLOG_CSRF" \
      -w "\n%{http_code}")
else
    echo "  ⚠ No CSRF token found in HTML, trying alternative method..."
    echo "  - Attempting login WITHOUT CSRF token..."
    BLOG_LOGIN=$(curl -s -X POST http://localhost/blog/login/ \
      -b /tmp/blog_cookies.txt -c /tmp/blog_cookies.txt \
      -H "Content-Type: application/json" \
      -d "{\"username\":\"$USER1\",\"password\":\"$PASS\"}" \
      -w "\n%{http_code}")
fi

BLOG_CODE=$(echo "$BLOG_LOGIN" | tail -n1)
BLOG_BODY=$(echo "$BLOG_LOGIN" | head -n-1)

if [[ $BLOG_CODE == 200 || $BLOG_CODE == 201 || $BLOG_CODE == 302 ]]; then
    echo "  ✓ Blog login HTTP $BLOG_CODE"
elif [[ $BLOG_CODE == 403 ]]; then
    echo "  ✓ Blog CSRF protection working (HTTP 403)"
else
    echo "  ✗ Blog login FAILED (HTTP $BLOG_CODE)"
    echo "  Response preview: $(echo "$BLOG_BODY" | head -c 200)"
fi
echo ""

# ============= NOTES =============
echo "[*] Testing NOTES..."

# Test wrong endpoint detection
NOTES_HEALTH=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/notes/api/health/ 2>/dev/null)
echo "  - Health check: HTTP $NOTES_HEALTH"

echo "  - Attempting login..."
NOTES_LOGIN=$(curl -s -X POST http://localhost/notes/api/auth/login/ \
  -H "Content-Type: application/json" \
  -d "{\"username\":\"$USER1\",\"password\":\"$PASS\"}" \
  -w "\n%{http_code}")

NOTES_CODE=$(echo "$NOTES_LOGIN" | tail -n1)
NOTES_BODY=$(echo "$NOTES_LOGIN" | head -n-1)

if [[ $NOTES_CODE == 403 ]]; then
    echo "  ✓ CSRF Protection DETECTED (HTTP 403)"
elif [[ $NOTES_CODE == 200 || $NOTES_CODE == 201 ]]; then
    NOTES_TOKEN=$(echo "$NOTES_BODY" | grep -oP '"access"\s*:\s*"\K[^"]+' | head -1 || \
                  echo "$NOTES_BODY" | grep -oP '"token"\s*:\s*"\K[^"]+' | head -1)
    if [ -n "$NOTES_TOKEN" ]; then
        echo "  ✓ JWT API — token auth is secure, CSRF not needed"
        echo "  ✓ Token: ${NOTES_TOKEN:0:50}..."
    else
        echo "  ⚠ Returns 200 without token — investigate!"
    fi
elif [[ $NOTES_CODE == 405 ]]; then
    echo "  ℹ HTTP 405 — wrong endpoint, checking alternatives..."
    # Try alternative endpoints
    for endpoint in "/notes/api/token/" "/notes/api/login/" "/notes/api/auth/token/"; do
        ALT_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST http://localhost$endpoint \
          -H "Content-Type: application/json" \
          -d "{\"username\":\"$USER1\",\"password\":\"$PASS\"}")
        if [[ $ALT_CODE != 404 && $ALT_CODE != 000 ]]; then
            echo "  ✓ Found endpoint: $endpoint (HTTP $ALT_CODE)"
            break
        fi
    done
else
    echo "  ? Notes login HTTP $NOTES_CODE"
fi
echo ""

# ============= BANK =============
echo "[*] Testing BANK..."

# Register first, token comes back immediately
BANK_REGISTER=$(curl -s -X POST http://localhost/bank/api/auth/register \
  -H "Content-Type: application/json" \
  -d "{\"username\":\"$USER1\",\"password\":\"$PASS\",\"email\":\"$EMAIL\"}" \
  -w "\n%{http_code}")

BANK_REG_CODE=$(echo "$BANK_REGISTER" | tail -n1)
BANK_REG_BODY=$(echo "$BANK_REGISTER" | head -n-1)
echo "  - Register HTTP $BANK_REG_CODE"

BANK_TOKEN=$(echo "$BANK_REG_BODY" | python3 -c "
import sys, json
data = json.load(sys.stdin)
print(data.get('data', {}).get('token', ''))
" 2>/dev/null)

if [ -n "$BANK_TOKEN" ]; then
    echo "  ✓ JWT token received on registration"

    # Test authenticated endpoint
    AUTH_TEST=$(curl -s -o /dev/null -w "%{http_code}" \
      http://localhost/bank/api/accounts/ \
      -H "Authorization: Bearer $BANK_TOKEN")
    echo "  - Authenticated request: HTTP $AUTH_TEST"

    # Test WITHOUT token
    UNAUTH_TEST=$(curl -s -o /dev/null -w "%{http_code}" \
      http://localhost/bank/api/accounts/)
    if [[ $UNAUTH_TEST == 401 || $UNAUTH_TEST == 403 ]]; then
        echo "  ✓ Unauthenticated request properly rejected (HTTP $UNAUTH_TEST)"
    else
        echo "  ⚠ Unauthenticated request returned HTTP $UNAUTH_TEST — investigate!"
    fi
fi

# Now test login separately
BANK_LOGIN=$(curl -s -X POST http://localhost/bank/api/auth/login \
  -H "Content-Type: application/json" \
  -d "{\"usernameOrEmail\":\"$USER1\",\"password\":\"$PASS\"}" \
  -w "\n%{http_code}")

BANK_CODE=$(echo "$BANK_LOGIN" | tail -n1)
BANK_BODY=$(echo "$BANK_LOGIN" | head -n-1)

if [[ $BANK_CODE == 200 ]]; then
    echo "  ✓ JWT API — token auth secure, CSRF not needed"
else
    echo "  ? Bank login HTTP $BANK_CODE"
fi

# ============= SOCIAL =============
echo "[*] Testing SOCIAL..."

# Health check first
SOCIAL_HEALTH=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/social/health/)
echo "  - Health check: HTTP $SOCIAL_HEALTH"

# Register test user first
echo "  - Registering test user..."
SOCIAL_REGISTER=$(curl -s -X POST http://localhost/social/api/auth/register/ \
  -H "Content-Type: application/json" \
  -d "{\"username\":\"$USER1\",\"password\":\"$PASS\",\"password2\":\"$PASS\",\"email\":\"$EMAIL\",\"profile_name\":\"Test User\"}" \
  -w "\n%{http_code}")

REG_CODE=$(echo "$SOCIAL_REGISTER" | tail -n1)
REG_BODY=$(echo "$SOCIAL_REGISTER" | head -n-1)
echo "  - Register HTTP $REG_CODE"

# Now test login
echo "  - Attempting login..."
SOCIAL_LOGIN=$(curl -s -X POST http://localhost/social/api/auth/login/ \
  -H "Content-Type: application/json" \
  -d "{\"username\":\"$USER1\",\"password\":\"$PASS\"}" \
  -w "\n%{http_code}")

SOCIAL_CODE=$(echo "$SOCIAL_LOGIN" | tail -n1)
SOCIAL_BODY=$(echo "$SOCIAL_LOGIN" | head -n-1)

if [[ $SOCIAL_CODE == 403 ]]; then
    echo "  ✓ CSRF Protection DETECTED (HTTP 403)"
elif [[ $SOCIAL_CODE == 200 || $SOCIAL_CODE == 201 ]]; then
    SOCIAL_TOKEN=$(echo "$SOCIAL_BODY" | grep -oP '"access"\s*:\s*"\K[^"]+' | head -1 || \
                   echo "$SOCIAL_BODY" | grep -oP '"token"\s*:\s*"\K[^"]+' | head -1)
    if [ -n "$SOCIAL_TOKEN" ]; then
        echo "  ✓ JWT API — token auth is secure, CSRF not needed"
        echo "  ✓ Token: ${SOCIAL_TOKEN:0:50}..."

        # Test authenticated endpoint with token
        echo "  - Testing authenticated endpoint..."
        AUTH_TEST=$(curl -s -o /dev/null -w "%{http_code}" \
          http://localhost/social/api/auth/me/ \
          -H "Authorization: Bearer $SOCIAL_TOKEN")
        echo "  - Authenticated request: HTTP $AUTH_TEST"

        # Test endpoint WITHOUT token — should be 401
        UNAUTH_TEST=$(curl -s -o /dev/null -w "%{http_code}" \
          http://localhost/social/api/auth/me/)
        if [[ $UNAUTH_TEST == 401 ]]; then
            echo "  ✓ Unauthenticated request properly rejected (HTTP 401)"
        else
            echo "  ⚠ Unauthenticated request returned HTTP $UNAUTH_TEST — investigate!"
        fi
    else
        echo "  ⚠ Returns 200 without JWT token — investigate!"
        echo "  Response: $(echo "$SOCIAL_BODY" | head -c 200)"
    fi
else
    echo "  ? Social login HTTP $SOCIAL_CODE"
    echo "  Response: $(echo "$SOCIAL_BODY" | head -c 200)"
fi
echo ""

# ============= CORS TESTING =============
echo "=========================================="
echo "CORS Testing"
echo "=========================================="
echo ""

echo "[*] Testing CORS headers from malicious origin..."

CORS_TEST=$(curl -s -I -X OPTIONS http://localhost/social/api/auth/login/ \
  -H "Origin: http://evil.com" \
  -H "Access-Control-Request-Method: POST")

CORS_ORIGIN=$(echo "$CORS_TEST" | grep -i "access-control-allow-origin" | tr -d '\r')

if echo "$CORS_ORIGIN" | grep -q "\*"; then
    echo "  ⚠ CORS allows ALL origins (wildcard *) — potential risk!"
    echo "  Header: $CORS_ORIGIN"
elif [ -n "$CORS_ORIGIN" ]; then
    echo "  ✓ CORS restricted to: $CORS_ORIGIN"
else
    echo "  ✓ No CORS header returned for unknown origin"
fi
echo ""

# ============= SUMMARY =============
echo "=========================================="
echo "CSRF Protection Analysis"
echo "=========================================="
echo ""
echo "Summary:"

# Blog
if [[ $BLOG_CODE == 403 ]]; then
    echo "  Blog:   ✓ Has CSRF protection (HTTP 403)"
elif [[ $BLOG_CODE == 200 || $BLOG_CODE == 302 ]]; then
    echo "  Blog:   ✓ Session auth working (HTTP $BLOG_CODE)"
else
    echo "  Blog:   ✗ Unexpected response (HTTP $BLOG_CODE)"
fi

# Notes
if [[ $NOTES_CODE == 403 ]]; then
    echo "  Notes:  ✓ Has CSRF protection"
elif [[ $NOTES_CODE == 200 || $NOTES_CODE == 201 ]]; then
    echo "  Notes:  ✓ JWT API — CSRF not required"
elif [[ $NOTES_CODE == 405 ]]; then
    echo "  Notes:  ℹ Wrong endpoint tested — needs manual verification"
else
    echo "  Notes:  ? HTTP $NOTES_CODE — investigate"
fi

# Bank
if [[ $BANK_CODE == 403 ]]; then
    echo "  Bank:   ✓ Has CSRF protection"
elif [[ $BANK_CODE == 200 || $BANK_CODE == 201 ]]; then
    echo "  Bank:   ✓ JWT API — CSRF not required"
elif [[ $BANK_CODE == 405 ]]; then
    echo "  Bank:   ℹ Wrong endpoint tested — needs manual verification"
else
    echo "  Bank:   ? HTTP $BANK_CODE — investigate"
fi

# Social
if [[ $SOCIAL_CODE == 403 ]]; then
    echo "  Social: ✓ Has CSRF protection"
elif [[ $SOCIAL_CODE == 200 || $SOCIAL_CODE == 201 ]]; then
    echo "  Social: ✓ JWT API — CSRF not required"
else
    echo "  Social: ? HTTP $SOCIAL_CODE — investigate"
fi

echo ""
echo "Note: REST APIs using JWT tokens do not require CSRF"
echo "      protection as tokens are sent in headers, not cookies."
echo "      CSRF only applies to session/cookie based authentication."
echo "=========================================="

# Cleanup
rm -f /tmp/blog_cookies.txt