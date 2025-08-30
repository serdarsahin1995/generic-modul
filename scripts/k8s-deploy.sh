#!/bin/bash

# Kubernetes deployment script for Raspberry Pi
# Usage: ./k8s-deploy.sh [PI_IP] [USERNAME]

PI_IP=${1:-"192.168.1.100"}
PI_USER=${2:-"pi"}
PROJECT_NAME="generic-modul"

echo "🚀 Deploying $PROJECT_NAME to Kubernetes on Pi..."

# Copy files to Pi
rsync -avz k8s/ "$PI_USER@$PI_IP:/home/$PI_USER/k8s-manifests/"

# Deploy to Kubernetes
ssh "$PI_USER@$PI_IP" << 'EOF'
    echo "🐳 Building Docker image..."
    cd /home/pi/generic-modul
    docker build -t generic-modul:latest .
    
    echo "☸️  Applying Kubernetes manifests..."
    cd /home/pi/k8s-manifests
    
    # Apply manifests
    kubectl apply -f namespace.yaml
    kubectl apply -f deployment.yaml
    kubectl apply -f service.yaml
    kubectl apply -f ingress.yaml
    
    echo "📊 Waiting for pods to be ready..."
    kubectl wait --for=condition=ready pod -l app=generic-modul -n generic-modul --timeout=300s
    
    echo "📋 Current status:"
    kubectl get all -n generic-modul
    
    echo ""
    echo "🌐 Access points:"
    echo "   - NodePort: http://$(hostname -I | awk '{print $1}'):30080"
    echo "   - Cluster IP: kubectl port-forward svc/generic-modul-service 8080:80 -n generic-modul"
    
    echo ""
    echo "🔍 Testing application..."
    kubectl port-forward svc/generic-modul-service 8080:80 -n generic-modul &
    FORWARD_PID=$!
    sleep 5
    curl -s http://localhost:8080/api/v1/messages || echo "Service not ready yet"
    kill $FORWARD_PID 2>/dev/null
EOF

echo ""
echo "✅ Kubernetes deployment completed!"
echo "🔗 Access: http://$PI_IP:30080/"