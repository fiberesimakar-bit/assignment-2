#!/bin/bash

echo "================================="
echo " Assignment 2 Grader"
echo "================================="

passed=0
failed=0

pass() {
    echo "PASS: $1"
    passed=$((passed + 1))
}

fail() {
    echo "FAIL: $1"
    failed=$((failed + 1))
}

echo
echo "Checking required files..."

for file in README.md app/diagnostic.sh app/health-check.sh Dockerfile compose.yaml .dockerignore test.sh grade.sh
do
    if [ -f "$file" ]; then
        pass "$file exists"
    else
        fail "$file missing"
    fi
done

echo
echo "Checking executable permissions..."

for file in app/diagnostic.sh app/health-check.sh test.sh grade.sh
do
    if [ -x "$file" ]; then
        pass "$file executable"
    else
        fail "$file not executable"
    fi
done

echo
echo "Checking Bash syntax..."

for file in app/diagnostic.sh app/health-check.sh test.sh grade.sh
do
    if bash -n "$file"; then
        pass "$file syntax"
    else
        fail "$file syntax"
    fi
done

echo
echo "Checking diagnostic commands..."

if ./app/diagnostic.sh help >/dev/null 2>&1; then
    pass "help command"
else
    fail "help command"
fi

if ./app/diagnostic.sh system >/dev/null 2>&1; then
    pass "system command"
else
    fail "system command"
fi

if ./app/diagnostic.sh disk >/dev/null 2>&1; then
    pass "disk command"
else
    fail "disk command"
fi

if ./app/diagnostic.sh network google.com >/dev/null 2>&1; then
    pass "network command"
else
    fail "network command"
fi

echo
echo "Checking invalid command..."

./app/diagnostic.sh invalid >/dev/null 2>&1
code=$?

if [ "$code" -eq 2 ]; then
    pass "invalid command returns exit code 2"
else
    fail "invalid command returned $code instead of 2"
fi

echo
echo "Checking missing network argument..."

./app/diagnostic.sh network >/dev/null 2>&1
code=$?

if [ "$code" -eq 2 ]; then
    pass "missing network argument returns exit code 2"
else
    fail "missing network argument returned $code"
fi

echo
echo "Checking Dockerfile..."

if grep -q "FROM alpine" Dockerfile; then
    pass "lightweight Alpine base image"
else
    fail "Alpine base image missing"
fi

if grep -q "COPY app" Dockerfile; then
    pass "application copied into image"
else
    fail "application COPY missing"
fi

if grep -q "ENTRYPOINT" Dockerfile || grep -q "CMD" Dockerfile; then
    pass "container entrypoint/CMD configured"
else
    fail "container entrypoint/CMD missing"
fi

echo
echo "Checking .dockerignore..."

if grep -q ".git" .dockerignore; then
    pass ".git excluded"
else
    fail ".git not excluded"
fi

echo
echo "Checking Docker build..."

if docker build -t diagnostic-tool . >/dev/null; then
    pass "Docker build"
else
    fail "Docker build"
fi

echo
echo "Checking Docker commands..."

if docker run --rm diagnostic-tool help >/dev/null; then
    pass "Docker help"
else
    fail "Docker help"
fi

if docker run --rm diagnostic-tool system >/dev/null; then
    pass "Docker system"
else
    fail "Docker system"
fi

if docker run --rm diagnostic-tool disk >/dev/null; then
    pass "Docker disk"
else
    fail "Docker disk"
fi

echo
echo "Checking Docker invalid command..."

docker run --rm diagnostic-tool invalid >/dev/null 2>&1
code=$?

if [ "$code" -eq 2 ]; then
    pass "Docker invalid command returns exit code 2"
else
    fail "Docker invalid command returned $code"
fi

echo
echo "Checking Docker Compose..."

if docker compose config >/dev/null 2>&1; then
    pass "Docker Compose configuration"
else
    fail "Docker Compose configuration"
fi

echo
echo "Checking student tests..."

if ./test.sh >/dev/null 2>&1; then
    pass "test.sh"
else
    fail "test.sh"
fi

echo
echo "Checking Git history..."

if git log --oneline -1 >/dev/null 2>&1; then
    pass "Git history available"
else
    fail "Git history"
fi

echo
echo "================================="
echo "Passed: $passed"
echo "Failed: $failed"
echo "================================="

if [ "$failed" -eq 0 ]; then
    echo "Assignment 2 grader: PASS"
    exit 0
else
    echo "Assignment 2 grader: FAIL"
    exit 1
fi
