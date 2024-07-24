#!/bin/bash

# Check if docker-compose.yml exists
if [ ! -f docker-compose.yaml ]; then
  echo "docker-compose.yaml not found!"
  exit 1
fi

echo "Stopping Docker Compose services..."
docker-compose down

echo "Building Docker Compose services..."
docker-compose build

echo "Starting Docker Compose services..."
docker-compose up -d

if [ $? -eq 0 ]; then
  echo "Services restarted successfully!"
else
  echo "Failed to restart services!"
  exit 1
fi