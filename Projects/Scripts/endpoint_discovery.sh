#!/bin/bash
echo "=== Endpoint Discovery ==="

echo "--- NOTES ---"
for ep in "login/" "auth/login/" "token/" "api-token-auth/" "users/login/" "auth/token/"; do
    CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
        http://localhost/notes/api/$ep \
        -H "Content-Type: application/json" \
        -d '{"username":"test","password":"test"}')
    [[ $CODE != "404" && $CODE != "000" ]] && echo "  FOUND: /notes/api/$ep → $CODE"
done

echo "--- BANK ---"
for ep in "accounts/" "account/" "users/" "dashboard/" "profile/"; do
    CODE=$(curl -s -o /dev/null -w "%{http_code}" \
        http://localhost/bank/api/$ep \
        -H "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0ZXN0IiwiaWF0IjoxNzc3NzgyOTU2LCJleHAiOjE3Nzc4NjkzNTZ9.aDdvB5GblaOg14hjQCNvPNhLWDrLFaWGh8PyT93ni_o")
    [[ $CODE != "404" && $CODE != "000" ]] && echo "  FOUND: /bank/api/$ep → $CODE"
done