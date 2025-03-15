#!/bin/bash

TEMPLATE="template.txt"

SUBJECT=$(grep -m 1 '^Subject:' "$TEMPLATE" | sed 's/^Subject: //')

CC="cc@example.com"
SUBJECT="Example subject"
export REPLYTO="replyto@example.com"

while IFS=, read -r name email; do
    TEMP_EMAIL=$(mktemp)
    {
        sed "s/{{NAME}}/$name/g" "$TEMPLATE" | sed '/^Subject:/d'
    } > "$TEMP_EMAIL"
    neomutt -s "$SUBJECT" -c "$CC" -- "$email" < "$TEMP_EMAIL"
    rm "$TEMP_EMAIL"
done < recipients.txt
