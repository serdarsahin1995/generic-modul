#!/bin/bash

# Development mode script for Kubernetes
# Usage: ./dev-mode.sh [PI_IP] [USERNAME]

PI_IP=${1:-"192.168.1.100"}
PI_USER=${2:-"pi"}
PROJECT_NAME="generic-modul"
REMOTE_DIR="/home/$PI_USER/$PROJECT_NAME"

echo "🛠️  Setting up development environment on Pi..."

# Sync files to Pi
echo "📤 Syncing files to Pi..."
rsync -avz --exclude=target --exclude=.git . "$PI_USER@$PI_IP:$REMOTE_DIR/"

# Setup development environment on Pi
ssh "$PI_USER@$PI_IP" << EOF
    cd $REMOTE_DIR
    
    echo "🐳 Building development Docker image..."
    docker build -f Dockerfile.dev -t generic-modul:dev .
    
    echo "☸️  Deploying to Kubernetes development..."
    kubectl apply -f k8s/namespace.yaml
    kubectl apply -f k8s/dev-deployment.yaml
    kubectl apply -f k8s/dev-service.yaml
    
    echo "⏳ Waiting for pod to be ready..."
    kubectl wait --for=condition=ready pod -l app=generic-modul-dev -n generic-modul --timeout=300s
    
    echo "📊 Development environment status:"
    kubectl get all -n generic-modul
    
    echo ""
    echo "🌐 Access points:"
    echo "   - Application: http://$PI_IP:30081"
    echo "   - Debug port: $PI_IP:30082"
    
    echo ""
    echo "📋 Development setup completed!"
EOF

echo ""
echo "✅ Development environment ready!"
echo ""
echo "🔧 IDE Configuration:"
echo "   - Remote Debug Host: $PI_IP"
echo "   - Remote Debug Port: 30082"
echo "   - Application URL: http://$PI_IP:30081"
echo ""
echo "📝 Next steps:"
echo "   1. Configure your IDE for remote debugging"
echo "   2. Use ./scripts/sync-code.sh to sync code changes"
echo "   3. Use ./scripts/remote-logs.sh to view logs"