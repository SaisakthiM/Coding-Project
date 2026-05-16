#!/bin/bash

whoami
date
date
uptime
df -h /

count=0
for i in {1..10}; do
  count=$((count + 1))
done

echo $count

for i in {1..10}; do
  touch log$i.log
  touch text$i.txt
done
for file in $(ls -v *.log); do
  echo "Processing $file"
done
for file in $(ls -v *.txt); do
  echo "Processing $file"
done
rm *.txt *.log

touch server.log

if [ -f "server.log" ]; then
  echo "file exists"
else
  echo "file not exists"
fi

if [ -f "main.log" ]; then
  echo "file exists : main.log"
else
  echo "file not exists : main.log"
fi

rm server.log

files=($(touch main.log), $(touch server.log), $(touch k.log))
for i in *.log; do
  echo "${files[i]}"
done
