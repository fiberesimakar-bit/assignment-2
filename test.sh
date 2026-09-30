#!/bin/bash

echo "======================================"
echo " Assignment 2 Tests"
echo "======================================"
echo

echo "Test 1: help"
docker compose run --rm diagnostic help
if [ $? -eq 0 ]; then
    echo "PASS: help works"
else
    echo "FAIL: help did not work"
fi
echo

echo "Test 2: system"
docker compose run --rm diagnostic system
if [ $? -eq 0 ]; then
    echo "PASS: system works"
else
    echo "FAIL: system did not work"
fi
echo

echo "Test 3: disk"
docker compose run --rm diagnostic disk
if [ $? -eq 0 ]; then
    echo "PASS: disk works"
else
    echo "FAIL: disk did not work"
fi
echo

echo "Test 4: invalid command"
docker compose run --rm diagnostic invalid
if [ $? -ne 0 ]; then
    echo "PASS: invalid command was rejected"
else
    echo "FAIL: invalid command was accepted"
fi
