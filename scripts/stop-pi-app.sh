#!/bin/bash

# Stop application on Raspberry Pi
# Usage: ./stop-pi-app.sh [PI_IP_ADDRESS] [PI_USERNAME]

PI_IP=${1:-"192.168.1.100"}
PI_USER=${2:-"pi"}
PROJECT_NAME="generic-modul"

echo "🛑 Stopping $PROJECT_NAME on Raspberry Pi..."

ssh "$PI_USER@$PI_IP" << EOF
    cd /home/$PI_USER/$PROJECT_NAME 2>/dev/null || {
        echo "❌ Project directory not found"
        exit 1
    }
    
    echo "🐳 Stopping Docker containers..."
    docker-compose down
    
    echo "🧹 Cleaning up unused Docker images..."
    docker image prune -f
    
    echo "✅ Application stopped successfully"
EOF

echo "🏁 Stop operation completed!"