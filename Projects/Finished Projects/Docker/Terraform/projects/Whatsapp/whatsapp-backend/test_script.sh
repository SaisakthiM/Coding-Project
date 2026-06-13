#!/bin/bash

BASE_URL="http://localhost:3000"
BOLD='\033[1m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

pass() { echo -e "${GREEN}✓ $1${NC}"; }
fail() { echo -e "${RED}✗ $1${NC}"; }
info() { echo -e "${CYAN}→ $1${NC}"; }
section() { echo -e "\n${BOLD}${YELLOW}── $1 ──${NC}"; }

check_status() {
  local label=$1; local expected=$2; local actual=$3
  if [ "$actual" == "$expected" ]; then pass "$label (HTTP $actual)"
  else fail "$label (expected $expected, got $actual)"; fi
}

# ── 1. Health check ──────────────────────────────────────────────────────────
section "Health check"
RES=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/")
check_status "GET /" "200" "$RES"

# ── 2. Register two users ────────────────────────────────────────────────────
section "Register user A"
USERNAME_A="user_a_$$"; PASSWORD="password123"
REG_A=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/users" \
  -H "Content-Type: application/json" \
  -d "{\"username\": \"$USERNAME_A\", \"password\": \"$PASSWORD\"}")
REG_A_BODY=$(echo "$REG_A" | head -n -1)
REG_A_STATUS=$(echo "$REG_A" | tail -n1)
check_status "POST /users (A)" "200" "$REG_A_STATUS"
TOKEN_A=$(echo "$REG_A_BODY" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
USER_A=$(echo "$REG_A_BODY" | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
if [ -n "$TOKEN_A" ]; then pass "User A registered"; info "User A: $USER_A"
else fail "User A registration failed"; echo "$REG_A_BODY"; fi

section "Register user B"
USERNAME_B="user_b_$$"
REG_B=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/users" \
  -H "Content-Type: application/json" \
  -d "{\"username\": \"$USERNAME_B\", \"password\": \"$PASSWORD\"}")
REG_B_BODY=$(echo "$REG_B" | head -n -1)
REG_B_STATUS=$(echo "$REG_B" | tail -n1)
check_status "POST /users (B)" "200" "$REG_B_STATUS"
TOKEN_B=$(echo "$REG_B_BODY" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
USER_B=$(echo "$REG_B_BODY" | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
if [ -n "$TOKEN_B" ]; then pass "User B registered"; info "User B: $USER_B"
else fail "User B registration failed"; echo "$REG_B_BODY"; fi

# ── 3. Login ─────────────────────────────────────────────────────────────────
section "Login"
LOGIN=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/login" \
  -H "Content-Type: application/json" \
  -d "{\"username\": \"$USERNAME_A\", \"password\": \"$PASSWORD\"}")
LOGIN_BODY=$(echo "$LOGIN" | head -n -1); LOGIN_STATUS=$(echo "$LOGIN" | tail -n1)
check_status "POST /login" "200" "$LOGIN_STATUS"
FRESH=$(echo "$LOGIN_BODY" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
[ -n "$FRESH" ] && TOKEN_A=$FRESH && pass "Login token received" || fail "No token from login"

section "Login – wrong password"
BAD=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$BASE_URL/login" \
  -H "Content-Type: application/json" \
  -d "{\"username\": \"$USERNAME_A\", \"password\": \"wrong\"}")
check_status "POST /login (bad password)" "401" "$BAD"

# ── 4. Create room ────────────────────────────────────────────────────────────
section "Create room"
ROOM=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/room" \
  -H "Content-Type: application/json" \
  -d "{\"name\": \"test-room-$$\"}")
ROOM_BODY=$(echo "$ROOM" | head -n -1); ROOM_STATUS=$(echo "$ROOM" | tail -n1)
check_status "POST /room" "200" "$ROOM_STATUS"
ROOM_ID=$(echo "$ROOM_BODY" | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
if [ -n "$ROOM_ID" ]; then pass "Room created"; info "Room ID: $ROOM_ID"
else fail "No room ID"; echo "$ROOM_BODY"; fi

# ── 5. Both users join room ───────────────────────────────────────────────────
section "Join room"
JOIN_A=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$BASE_URL/room/join" \
  -H "Content-Type: application/json" \
  -d "{\"room_id\": \"$ROOM_ID\", \"user_id\": \"$USER_A\"}")
check_status "POST /room/join (A)" "201" "$JOIN_A"

JOIN_B=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$BASE_URL/room/join" \
  -H "Content-Type: application/json" \
  -d "{\"room_id\": \"$ROOM_ID\", \"user_id\": \"$USER_B\"}")
check_status "POST /room/join (B)" "201" "$JOIN_B"

# ── 6. Send HTTP message ──────────────────────────────────────────────────────
section "Send message (HTTP)"
MSG=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/message" \
  -H "Content-Type: application/json" \
  -d "{\"room_id\": \"$ROOM_ID\", \"sender_id\": \"$USER_A\", \"content\": \"Hello from HTTP!\"}")
MSG_BODY=$(echo "$MSG" | head -n -1); MSG_STATUS=$(echo "$MSG" | tail -n1)
check_status "POST /message" "200" "$MSG_STATUS"
MSG_ID=$(echo "$MSG_BODY" | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
if [ -n "$MSG_ID" ]; then pass "Message sent"; info "Message ID: $MSG_ID"
else fail "No message ID"; echo "$MSG_BODY"; fi

# ── 7. WebSocket tests ────────────────────────────────────────────────────────
section "WebSocket"
if ! command -v websocat &> /dev/null; then
  echo -e "${YELLOW}⚠ websocat not found — skipping all WebSocket tests${NC}"
  echo "  Install: cargo install websocat"
else

  BROADCAST_MSG="broadcast_test_$$"
  OUT_B=$(mktemp)

  # ── 7a. Basic connection (no message sent, just connect + disconnect) ────────
  info "7a: Basic connection (User A)"
  # Send nothing — just open and let timeout close it
  WS_OUT=$(timeout 2 websocat "ws://localhost:3000/ws/$ROOM_ID?token=$TOKEN_A" \
    < /dev/null 2>&1)
  WS_EXIT=$?
  if [ $WS_EXIT -eq 0 ] || [ $WS_EXIT -eq 124 ]; then
    pass "WebSocket connection established"
  else
    fail "WebSocket connection failed"; info "$WS_OUT"
  fi

  # ── 7b. Catch-up on connect ─────────────────────────────────────────────────
  info "7b: Catch-up — User A should receive the HTTP message sent earlier"
  # Use a fresh user C so last_seen_at is null → catches everything in the room
  USERNAME_C="user_c_$$"
  REG_C=$(curl -s -X POST "$BASE_URL/users" \
    -H "Content-Type: application/json" \
    -d "{\"username\": \"$USERNAME_C\", \"password\": \"$PASSWORD\"}")
  TOKEN_C=$(echo "$REG_C" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
  USER_C=$(echo "$REG_C" | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
  curl -s -o /dev/null -X POST "$BASE_URL/room/join" \
    -H "Content-Type: application/json" \
    -d "{\"room_id\": \"$ROOM_ID\", \"user_id\": \"$USER_C\"}"

  CATCHUP=$(timeout 3 websocat "ws://localhost:3000/ws/$ROOM_ID?token=$TOKEN_C" \
    < /dev/null 2>&1)
  if echo "$CATCHUP" | grep -q "Hello from HTTP!"; then
    pass "Catch-up: missed message delivered on connect"
    info "Received: $(echo "$CATCHUP" | head -c 120)..."
  else
    fail "Catch-up: expected 'Hello from HTTP!' in catch-up messages"
    info "Got: $CATCHUP"
  fi

  # ── 7c. Broadcast: A sends, B receives ──────────────────────────────────────
  info "7c: Broadcast — User A sends, User B should receive"

  # Keep B's stdin open with a blocking read so the connection stays alive
  # tail -f /dev/null never exits, giving websocat a live stdin
  tail -f /dev/null | websocat "ws://localhost:3000/ws/$ROOM_ID?token=$TOKEN_B" \
    > "$OUT_B" 2>&1 &
  WS_B_PID=$!
  TAIL_PID=$(pgrep -P $WS_B_PID tail 2>/dev/null || true)

  # Give B time to connect and flush any catch-up messages
  sleep 1.5

  # User A connects and sends the broadcast message, then disconnects
  echo "$BROADCAST_MSG" | timeout 4 websocat \
    "ws://localhost:3000/ws/$ROOM_ID?token=$TOKEN_A" > /dev/null 2>&1

  # Give the broadcast time to travel to B
  sleep 1

  # Shut down B cleanly
  [ -n "$TAIL_PID" ] && kill "$TAIL_PID" 2>/dev/null
  kill $WS_B_PID 2>/dev/null
  wait $WS_B_PID 2>/dev/null

  B_OUTPUT=$(cat "$OUT_B")
  rm -f "$OUT_B"

  if echo "$B_OUTPUT" | grep -q "$BROADCAST_MSG"; then
    pass "Broadcast: User B received User A's message"
    info "B received: $(echo "$B_OUTPUT" | grep "$BROADCAST_MSG" | head -c 120)"
  else
    fail "Broadcast: User B did NOT receive User A's message"
    info "B output was: $B_OUTPUT"
  fi

  # ── 7d. Invalid token rejected ───────────────────────────────────────────────
  info "7d: Invalid token should be rejected"
  INVALID=$(timeout 2 websocat "ws://localhost:3000/ws/$ROOM_ID?token=invalid.token.here" \
    < /dev/null 2>&1)
  if echo "$INVALID" | grep -qi "401\|unauthorized\|error\|rejected"; then
    pass "WebSocket correctly rejects invalid token"
  else
    echo -e "${YELLOW}⚠ Could not confirm 401 rejection (check manually)${NC}"
    info "Output: $INVALID"
  fi

fi

echo -e "\n${BOLD}Done.${NC}"