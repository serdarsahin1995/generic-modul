#!/bin/bash

# Scale application script for Raspberry Pi
# Usage: ./scale-app.sh [PI_IP] [USERNAME] [SCALE_COUNT]

PI_IP=${1:-"192.168.1.100"}
PI_USER=${2:-"pi"}
SCALE_COUNT=${3:-3}
PROJECT_NAME="generic-modul"
REMOTE_DIR="/home/$PI_USER/$PROJECT_NAME"

echo "🚀 Scaling $PROJECT_NAME to $SCALE_COUNT instances on Pi..."

ssh "$PI_USER@$PI_IP" << EOF
    cd $REMOTE_DIR
    
    echo "🔄 Scaling application to $SCALE_COUNT instances..."
    docker-compose up --scale generic-modul=$SCALE_COUNT -d
    
    echo "📊 Current containers:"
    docker-compose ps
    
    echo ""
    echo "🌐 Access points:"
    echo "   - Load Balancer (Nginx): http://$PI_IP/"
    echo "   - Direct instances: http://$PI_IP:8080-808X"
    
    echo ""
    echo "🔍 Testing load balancer..."
    for i in {1..5}; do
        echo "Request \$i:"
        curl -s http://localhost/api/v1/messages | head -c 100
        echo ""
        sleep 1
    done
EOF

echo ""
echo "✅ Scaling completed!"
echo "🔗 Load balanced access: http://$PI_IP/"