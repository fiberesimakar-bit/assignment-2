# Assignment 2 - Dockerized System Diagnostic Tool

## 1. Introduction

This project is a simple Linux system diagnostic tool written in Bash.

The tool can:

- Display system information
- Check disk usage
- Check whether a network host is reachable
- Display help instructions
- Perform a basic health check

The project was also packaged and tested using Docker and Docker Compose.

---

## 2. Project Structure

```text
assignment-2/
├── Dockerfile
├── compose.yaml
├── .dockerignore
├── test.sh
├── README.md
└── app/
    ├── diagnostic.sh
    └── health-check.sh
    