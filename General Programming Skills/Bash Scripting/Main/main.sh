# Start of the program to run my docker container and see if any errors are there

cd "/home/saisakthi/Coding-Project/Projects/Finished Projects/Notes App"
if [ -f find "docker-compose.yml" ]; then
    printf "Missing file"
    exit 1
fi

result=$(docker compose up -d | grep "❌")

if [ -n "$result" ]; then
    echo "Some services failed:"
    echo "$result"
else
    echo "All services are OK"
fi



