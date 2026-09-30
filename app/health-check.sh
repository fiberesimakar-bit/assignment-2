#!/bin/bash

if ./app/diagnostic.sh help > /dev/null 2>&1; then
    echo "Health check: OK"
    exit 0
else
    echo "Health check: FAILED"
    exit 1
fi
