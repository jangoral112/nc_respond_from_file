#!/bin/bash

trap "echo 'Exiting...'; exit" SIGINT

# Define the port to listen on.
PORT=3000

# Define the JSON body in a human-readable format using a here-document.
JSON_FILE="file_name.json"

# Load JSON body from file.
JSON_BODY=$(cat "$JSON_FILE")

# Convert Unix newlines (\n) to HTTP CRLF (\r\n) using awk.
JSON_BODY_CRLF=$(echo "$JSON_BODY" | awk '{printf "%s\r\n", $0}')

# Calculate the byte length of the JSON body.
CONTENT_LENGTH=$(echo -n "$JSON_BODY" | wc -c)

# Infinite loop to respond to incoming connections.
while true; do
  # Create the full HTTP response.
  RESPONSE=$(printf "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\nContent-Length: %d\r\n\r\n%s" "$CONTENT_LENGTH" "$JSON_BODY")
  
  # Pipe the response to netcat.
  echo -ne "$RESPONSE" | nc -l $PORT
done
