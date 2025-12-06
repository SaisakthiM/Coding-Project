# Stop Docker Desktop WSL integration
wsl --shutdown

# Reset Windows network stack
Write-Host "Resetting Windows network stack..."
netsh winsock reset
netsh int ip reset

# Flush DNS cache
ipconfig /flushdns

# Restart Docker Desktop
Write-Host "Restarting Docker Desktop..."
Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"

# Wait for Docker to initialize
Write-Host "Waiting 20 seconds for Docker to start..."
Start-Sleep -Seconds 20

# Test connectivity inside a container
Write-Host "Testing Docker container connectivity..."
docker run --rm alpine ping -c 4 google.com
docker run --rm alpine nslookup google.com

Write-Host "Docker networking should now work."
