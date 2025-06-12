#!/bin/bash

# Run the Python script and capture the output
PYTHON_OUTPUT=$(python3 /home/ubuntu/License-Scripts/license_creation.py)

# Check if the Python script executed successfully
if [ $? -ne 0 ]; then
    echo "Python script execution failed."
    exit 1
fi

# Define the API endpoint
API_URL="${mlangles_mlops_dev_url_https}:9092/License"

# Define the custom key and construct the JSON payload
JSON_PAYLOAD=$(jq -n --arg output "$PYTHON_OUTPUT" '{licence_key: $output}')

echo $PYTHON_OUTPUT
#Execute the curl command with the JSON payload
curl -X POST "$API_URL" \
     -H "Content-Type: application/json" \
     -d "$JSON_PAYLOAD"