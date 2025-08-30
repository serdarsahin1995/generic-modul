#!/bin/bash

# Development startup script with hot reload
echo "🚀 Starting development mode with hot reload..."

# Function to build and restart
build_and_restart() {
    echo "📦 Building application..."
    mvn compile -q
    if [ $? -eq 0 ]; then
        echo "✅ Build successful, restarting..."
        if [ ! -z "$APP_PID" ]; then
            kill $APP_PID 2>/dev/null
            wait $APP_PID 2>/dev/null
        fi
        
        # Start application in background
        mvn spring-boot:run \
            -Dspring-boot.run.jvmArguments="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005" \
            -q &
        APP_PID=$!
        echo "🎯 Application started with PID: $APP_PID"
        echo "🐛 Debug port: 5005"
    else
        echo "❌ Build failed, keeping previous version running"
    fi
}

# Initial build and start
build_and_restart

# Watch for file changes
echo "👀 Watching for file changes in src/..."
inotifywait -m -r -e modify,create,delete src/ --format '%w%f %e' | while read FILE EVENT; do
    echo "🔄 File changed: $FILE ($EVENT)"
    sleep 2  # Debounce
    build_and_restart
done &

# Keep script running
wait