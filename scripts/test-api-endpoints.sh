#!/bin/bash

# API Endpoint Testing Script
# test CRUD

set -e

BASE_URL="http://localhost:8000"

echo "Testing API endpoints at $BASE_URL"

# test 1
echo "Testing root endpoint (GET /)"
RESPONSE=$(curl -s -w "%{http_code}" -o /tmp/response.json "$BASE_URL/")
HTTP_CODE="${RESPONSE: -3}"
if [ "$HTTP_CODE" -eq 200 ]; then
    echo "Root endpoint test passed"
else
    echo "Root endpoint test failed (HTTP $HTTP_CODE)"
    exit 1
fi

# test 2
echo "Testing create task (POST /tasks/)"
TASK_RESPONSE=$(curl -s -X POST "$BASE_URL/tasks/" \
    -H "Content-Type: application/json" \
    -d '{"title": "Test Task", "description": "Integration test task", "completed": false}')
TASK_ID=$(echo $TASK_RESPONSE | python3 -c "import sys, json; print(json.load(sys.stdin)['id'])")

if [ -n "$TASK_ID" ] && [ "$TASK_ID" -gt 0 ]; then
    echo "Create task test passed (Task ID: $TASK_ID)"
else
    echo "Create task test failed"
    echo "Response: $TASK_RESPONSE"
    exit 1
fi

# test 3
echo "Testing get tasks (GET /tasks/)"
RESPONSE=$(curl -s -w "%{http_code}" -o /tmp/tasks.json "$BASE_URL/tasks/")
HTTP_CODE="${RESPONSE: -3}"
if [ "$HTTP_CODE" -eq 200 ]; then
    TASK_COUNT=$(python3 -c "import sys, json; print(len(json.load(open('/tmp/tasks.json'))))")
    echo "Get tasks test passed (Found $TASK_COUNT tasks)"
else
    echo "Get tasks test failed (HTTP $HTTP_CODE)"
    exit 1
fi

# test 4
echo "Testing update task (PUT /tasks/$TASK_ID/)"
UPDATE_RESPONSE=$(curl -s -X PUT "$BASE_URL/tasks/$TASK_ID/" \
    -H "Content-Type: application/json" \
    -d '{"title": "Updated Task", "description": "Updated description", "completed": true}')

UPDATED_TITLE=$(echo $UPDATE_RESPONSE | python3 -c "import sys, json; print(json.load(sys.stdin)['title'])")
if [ "$UPDATED_TITLE" = "Updated Task" ]; then
    echo "Update task test passed"
else
    echo "Update task test failed"
    echo "Response: $UPDATE_RESPONSE"
    exit 1
fi

# test 5
echo "testing delete task (DELETE /tasks/$TASK_ID/)"
DELETE_RESPONSE=$(curl -s -X DELETE "$BASE_URL/tasks/$TASK_ID/")
DELETE_MESSAGE=$(echo $DELETE_RESPONSE | python3 -c "import sys, json; print(json.load(sys.stdin)['message'])")

if [[ "$DELETE_MESSAGE" == *"deleted successfully"* ]]; then
    echo "Delete task test passed"
else
    echo "Delete task test failed"
    echo "Response: $DELETE_RESPONSE"
    exit 1
fi

echo ""
echo "All API endpoint tests passed successfully"
echo "Results:"
echo "  - Root endpoint: PASS"
echo "  - Create task: PASS" 
echo "  - Get tasks: PASS"
echo "  - Update task: PASS"
echo "  - Delete task: PASS"