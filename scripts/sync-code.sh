#!/bin/bash

# Sync code changes to Pi and trigger rebuild
# Usage: ./sync-code.sh [PI_IP] [USERNAME]

PI_IP=${1:-"192.168.1.100"}
PI_USER=${2:-"pi"}
PROJECT_NAME="generic-modul"
REMOTE_DIR="/home/$PI_USER/$PROJECT_NAME"

echo "🔄 Syncing code changes to Pi..."

# Watch for changes and sync
if command -v fswatch >/dev/null 2>&1; then
    echo "👀 Watching for file changes (press Ctrl+C to stop)..."
    fswatch -o src/ | while read f; do
        echo "📤 Syncing changes..."
        rsync -avz src/ "$PI_USER@$PI_IP:$REMOTE_DIR/src/"
        
        echo "🔄 Triggering rebuild in pod..."
        ssh "$PI_USER@$PI_IP" "kubectl exec -n generic-modul \$(kubectl get pod -n generic-modul -l app=generic-modul-dev -o jsonpath='{.items[0].metadata.name}') -- touch /app/src/trigger-rebuild"
        
        echo "✅ Code synced and rebuild triggered"
    done
else
    echo "⚠️  fswatch not found. Installing alternatives..."
    echo "Windows: Install Git Bash or WSL"
    echo "Manual sync:"
    
    # One-time sync
    rsync -avz src/ "$PI_USER@$PI_IP:$REMOTE_DIR/src/"
    
    echo "🔄 Triggering rebuild..."
    ssh "$PI_USER@$PI_IP" "kubectl exec -n generic-modul \$(kubectl get pod -n generic-modul -l app=generic-modul-dev -o jsonpath='{.items[0].metadata.name}') -- touch /app/src/trigger-rebuild"
    
    echo "✅ Manual sync completed"
fi