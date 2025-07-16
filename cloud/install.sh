#!/bin/bash

set -euo pipefail

PROJECT_NAME="codexion"
COMPOSE_FILE="docker.yml"

echo ""
echo "Stopping and removing existing containers, volumes, images..."
docker compose -f "$COMPOSE_FILE" -p "$PROJECT_NAME" down -v --remove-orphans || true

echo ""
echo "Pruning unused Docker images, containers, volumes..."
docker system prune -af
docker volume prune -f

echo ""
echo "Rebuilding and starting containers..."
docker compose -f "$COMPOSE_FILE" -p "$PROJECT_NAME" up --build -d

echo ""
echo "Showing container status..."
docker ps --filter "name=$PROJECT_NAME"
