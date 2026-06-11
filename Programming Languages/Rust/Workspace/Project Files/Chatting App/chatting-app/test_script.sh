#!/usr/bin/env bash

set -e

BASE_URL="http://localhost:3000"

echo "===== 1. Health check (GET /) ====="
curl -s "$BASE_URL/" 
echo -e "\n"

echo "===== 2. Create User ====="
USER_RESPONSE=$(curl -s -X POST "$BASE_URL/users" \
  -H "Content-Type: application/json" \
  -d '{"username": "testuser_'"$RANDOM"'"}')

echo "$USER_RESPONSE"
USER_ID=$(echo "$USER_RESPONSE" | jq -r '.id')
echo "Created user_id = $USER_ID"
echo

echo "===== 3. Create Room ====="
ROOM_RESPONSE=$(curl -s -X POST "$BASE_URL/room" \
  -H "Content-Type: application/json" \
  -d '{"name": "test_room_'"$RANDOM"'"}')

echo "$ROOM_RESPONSE"
ROOM_ID=$(echo "$ROOM_RESPONSE" | jq -r '.id')
echo "Created room_id = $ROOM_ID"
echo

echo "===== 4. Join Room ====="
curl -s -X POST "$BASE_URL/room/join" \
  -H "Content-Type: application/json" \
  -d '{"room_id": "'"$ROOM_ID"'", "user_id": "'"$USER_ID"'"}'
echo -e "\n"

echo "===== 5. Create Message ====="
MESSAGE_RESPONSE=$(curl -s -X POST "$BASE_URL/message" \
  -H "Content-Type: application/json" \
  -d '{"room_id": "'"$ROOM_ID"'", "sender_id": "'"$USER_ID"'", "content": "hello world"}')

echo "$MESSAGE_RESPONSE"
MESSAGE_ID=$(echo "$MESSAGE_RESPONSE" | jq -r '.id')
echo "Created message_id = $MESSAGE_ID"
echo

echo "===== 6. Get Messages ====="
curl -s -X GET "$BASE_URL/message" \
  -H "Content-Type: application/json" \
  -d '{"room_id": "'"$ROOM_ID"'", "user_id": "'"$USER_ID"'"}'
echo -e "\n"

echo "===== Done ====="
echo "user_id=$USER_ID"
echo "room_id=$ROOM_ID"
echo "message_id=$MESSAGE_ID"