#!/bin/bash

# Raspberry Pi Deployment Script
# Usage: ./deploy-to-pi.sh [PI_IP_ADDRESS] [PI_USERNAME]

set -e

PI_IP=${1:-"192.168.1.100"}  # Default Pi IP
PI_USER=${2:-"pi"}           # Default Pi username
PROJECT_NAME="generic-modul"
REMOTE_DIR="/home/$PI_USER/$PROJECT_NAME"

echo "🚀 Deploying $PROJECT_NAME to Raspberry Pi..."
echo "📍 Target: $PI_USER@$PI_IP:$REMOTE_DIR"

# Check if Pi is reachable
echo "🔍 Checking Pi connection..."
if ! ping -c 1 "$PI_IP" > /dev/null 2>&1; then
    echo "❌ Cannot reach Raspberry Pi at $PI_IP"
    exit 1
fi

# Create remote directory
echo "📁 Creating remote directory..."
ssh "$PI_USER@$PI_IP" "mkdir -p $REMOTE_DIR"

# Copy project files
echo "📤 Copying project files..."
rsync -avz --exclude-from='.dockerignore' \
    --exclude='.git' \
    --exclude='target' \
    --exclude='.idea' \
    ./ "$PI_USER@$PI_IP:$REMOTE_DIR/"

# Build and run on Pi
echo "🐳 Building and running Docker container on Pi..."
ssh "$PI_USER@$PI_IP" << EOF
    cd $REMOTE_DIR
    
    # Stop existing container if running
    docker-compose down 2>/dev/null || true
    
    # Build and start
    docker-compose up --build -d
    
    # Show status
    docker-compose ps
    
    echo ""
    echo "✅ Deployment completed!"
    echo "🌐 Application URL: http://$PI_IP:8080"
    echo "📊 Health Check: http://$PI_IP:8080/"
    echo "📡 Messages API: http://$PI_IP:8080/api/v1/messages"
EOF

echo ""
echo "🎉 Deployment to Raspberry Pi completed successfully!"
echo "🔗 You can now access the application from any device on your network:"
echo "   - Health: http://$PI_IP:8080/"
echo "   - API: http://$PI_IP:8080/api/v1/messages"