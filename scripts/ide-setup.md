# IDE Remote Development Setup

## IntelliJ IDEA Remote Debugging

### 1. Remote Debug Configuration
1. **Run** → **Edit Configurations**
2. **Add New** → **Remote JVM Debug**
3. **Configuration:**
   - Name: `Pi Development`
   - Host: `192.168.1.100` (Pi IP)
   - Port: `30082`
   - Use module classpath: `generic-modul`

### 2. Remote File Sync (Optional)
1. **Tools** → **Deployment** → **Configuration**
2. **Add Server** → **SFTP**
3. **Connection:**
   - Host: `192.168.1.100`
   - Username: `pi`
   - Password/Key: (Pi credentials)
   - Root path: `/home/pi/generic-modul`

### 3. Development Workflow
1. Make code changes locally
2. Run `./scripts/sync-code.sh` to sync changes
3. Set breakpoints in IDE
4. Start remote debugging session
5. Test at `http://192.168.1.100:30081`

## VS Code Remote Development

### 1. Install Extensions
- Remote - SSH
- Extension Pack for Java
- Spring Boot Extension Pack

### 2. Connect to Pi
1. **Ctrl+Shift+P** → **Remote-SSH: Connect to Host**
2. Add: `pi@192.168.1.100`
3. Open folder: `/home/pi/generic-modul`

### 3. Debug Configuration (.vscode/launch.json)
```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "type": "java",
            "name": "Attach to Pi",
            "request": "attach",
            "hostName": "localhost",
            "port": 30082,
            "projectName": "generic-modul"
        }
    ]
}
```

## Eclipse Remote Debugging

### 1. Remote Debug Configuration
1. **Run** → **Debug Configurations**
2. **Remote Java Application** → **New**
3. **Settings:**
   - Name: `Pi Remote Debug`
   - Project: `generic-modul`
   - Host: `192.168.1.100`
   - Port: `30082`

## Development Commands

```bash
# Setup development environment
./scripts/dev-mode.sh 192.168.1.100 pi

# Sync code changes (auto-watch)
./scripts/sync-code.sh 192.168.1.100 pi

# View remote logs
./scripts/remote-logs.sh 192.168.1.100 pi

# Manual one-time sync
rsync -avz src/ pi@192.168.1.100:/home/pi/generic-modul/src/
```

## Port Forwarding (Alternative)

If you want to access services locally:

```bash
# Forward application port
kubectl port-forward svc/generic-modul-dev-service 8080:80 -n generic-modul

# Forward debug port
kubectl port-forward svc/generic-modul-dev-service 5005:5005 -n generic-modul

# Then connect IDE to localhost:5005
```