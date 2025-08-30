#!/bin/bash

# View remote application logs
# Usage: ./remote-logs.sh [PI_IP] [USERNAME]

PI_IP=${1:-"192.168.1.100"}
PI_USER=${2:-"pi"}

echo "📋 Connecting to remote logs..."

ssh "$PI_USER@$PI_IP" << 'EOF'
    echo "📊 Current pods in development:"
    kubectl get pods -n generic-modul
    
    echo ""
    echo "📋 Following logs (press Ctrl+C to stop):"
    kubectl logs -f deployment/generic-modul-dev -n generic-modul
EOF