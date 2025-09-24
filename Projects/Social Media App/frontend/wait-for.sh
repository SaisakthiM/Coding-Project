#!/bin/sh

# wait-for.sh host:port [...] -- command args
TIMEOUT=60

# iterate over arguments until '--'
while [ "$1" != "--" ]; do
  hostport="$1"
  host=$(echo "$hostport" | cut -d: -f1)
  port=$(echo "$hostport" | cut -d: -f2)
  i=0
  until nc -z "$host" "$port"; do
    sleep 1
    i=$((i+1))
    if [ $i -ge $TIMEOUT ]; then
      echo "Timeout waiting for $host:$port"
      exit 1
    fi
  done
  shift
done

# remove '--'
shift

# execute command
exec "$@"
