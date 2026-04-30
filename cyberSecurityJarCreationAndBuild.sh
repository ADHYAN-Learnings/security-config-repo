#!/bin/bash

set -e

BASE_DIR="/Users/aditya/Desktop/Aditya/cyber-workspace"
DOCKER_USER="boklu"

build_service() {
  SERVICE_NAME=$1

  echo "-----------------------------------"
  echo "🚀 Processing: $SERVICE_NAME"
  echo "-----------------------------------"

  cd "$BASE_DIR/$SERVICE_NAME" || {
    echo "❌ Directory not found: $SERVICE_NAME"
    return 1
  }

  echo "📦 Building Maven project..."
  ./mvnw clean package

  echo "🐳 Building Docker image..."
  docker build --no-cache -t $DOCKER_USER/$SERVICE_NAME:latest .

  echo "📤 Pushing to Docker Hub..."
  docker push $DOCKER_USER/$SERVICE_NAME:latest

  echo "✅ Done: $SERVICE_NAME"
}

services=(
  "api-gateway"
  "eureka-server"
  "security-config-server"
  "scanmanagementservice"
  "scanorchestrationservice"
  "riskscoringservice"
)

# 🔥 Logic starts here

if [ "$1" == "all" ]; then
  for service in "${services[@]}"; do
    build_service "$service"
  done

elif [ -n "$1" ]; then
  build_service "$1"

else
  echo "Usage:"
  echo "  ./build.sh all"
  echo "  ./build.sh api-gateway"
  echo "  ./build.sh eureka-server"
fi