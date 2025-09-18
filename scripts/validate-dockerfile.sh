#!/bin/bash

# dockerfile validation script
# checks docker best practices and assignment requirements

set -e

DOCKERFILE="Dockerfile"

if [ ! -f "$DOCKERFILE" ]; then
    echo "ERROR: dockerfile not found"
    exit 1
fi

echo "validating Dockerfile..."

# check 1: multi-stage build (multiple FROM instructions)
FROM_COUNT=$(grep -c "^FROM" "$DOCKERFILE" || echo 0)
if [ "$FROM_COUNT" -ge 2 ]; then
    echo "multi-stage build: PASS (found $FROM_COUNT stages)"
else
    echo "multi-stage build: FAIL (found $FROM_COUNT stages, expected 2 or more)"
    exit 1
fi

# check 2: python 3.12 base image
if grep -q "FROM python:3.12-slim" "$DOCKERFILE"; then
    echo "python 3.12 base image: PASS"
else
    echo "python 3.12 base image: FAIL (expected 'FROM python:3.12' or variant)"
    exit 1
fi

# check 3: uv installation
if grep -q "uv" "$DOCKERFILE"; then
    echo "uv package manager: PASS"
else
    echo "uv package manager: FAIL (uv installation not found)"
    exit 1
fi

# check 4: CMD instruction present
if grep -q "^CMD" "$DOCKERFILE"; then
    echo "CMD instruction: PASS"
else
    echo "CMD instruction: FAIL (CMD instruction not found)"
    exit 1
fi

# check 5: .dockerignore exists
if [ -f ".dockerignore" ]; then
    echo "dockerignore file: PASS"
else
    echo "dockerignore file: FAIL (.dockerignore not found)"
    exit 1
fi

echo ""
echo "dockerfile validation completed successfully"
echo "all required elements found"