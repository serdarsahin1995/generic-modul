#!/bin/bash

# Check Raspberry Pi application status
# Usage: ./check-pi-status.sh [PI_IP_ADDRESS] [PI_USERNAME]

PI_IP=${1:-"192.168.1.100"}
PI_USER=${2:-"pi"}
PROJECT_NAME="generic-modul"

echo "📊 Checking $PROJECT_NAME status on Raspberry Pi..."

# Check if Pi is reachable
if ! ping -c 1 "$PI_IP" > /dev/null 2>&1; then
    echo "❌ Cannot reach Raspberry Pi at $PI_IP"
    exit 1
fi

# Check Docker status on Pi
ssh "$PI_USER@$PI_IP" << EOF
    echo "🐳 Docker Container Status:"
    docker ps --filter "name=generic-modul"
    
    echo ""
    echo "📋 Docker Compose Status:"
    cd /home/$PI_USER/$PROJECT_NAME 2>/dev/null && docker-compose ps || echo "Project not found"
    
    echo ""
    echo "🔍 Application Logs (last 20 lines):"
    docker logs generic-modul-app --tail 20 2>/dev/null || echo "Container not running"
EOF

echo ""
echo "🌐 Testing endpoints from local machine..."

# Test health endpoint
echo "Testing health endpoint..."
if curl -s -f "http://$PI_IP:8080/" > /dev/null; then
    echo "✅ Health endpoint: OK"
else
    echo "❌ Health endpoint: FAILED"
fi

# Test messages endpoint
echo "Testing messages endpoint..."
if curl -s -f "http://$PI_IP:8080/api/v1/messages" > /dev/null; then
    echo "✅ Messages endpoint: OK"
    echo "📄 Sample response:"
    curl -s "http://$PI_IP:8080/api/v1/messages" | head -c 200
    echo "..."
else
    echo "❌ Messages endpoint: FAILED"
fi