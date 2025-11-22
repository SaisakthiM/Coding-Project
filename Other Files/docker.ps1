# hybrid-docker-load.ps1
# Use for offline/online Docker setup

# -------------------------------
# CONFIGURATION
# -------------------------------
$images = @(
    "node:20-alpine",
    "python:3.12-slim-bookworm",
    "postgres:15",
    "redis:7",
    "wurstmeister/zookeeper",
    "wurstmeister/kafka",
    "nginx:alpine",
    "busybox",
    "hello-world"
)

$offlineDir = "C:\DockerOfflineImages"  # Folder containing .tar files

# -------------------------------
# FUNCTION: Check Docker Connectivity
# -------------------------------
function Test-DockerRegistry {
    try {
        docker pull hello-world | Out-Null
        return $true
    } catch {
        Write-Warning "Cannot reach Docker registry, will attempt offline images..."
        return $false
    }
}

# -------------------------------
# FUNCTION: Load Offline Images
# -------------------------------
function Load-OfflineImages {
    if (-Not (Test-Path $offlineDir)) {
        Write-Error "Offline images directory '$offlineDir' does not exist!"
        exit 1
    }

    $tarFiles = Get-ChildItem -Path $offlineDir -Filter "*.tar"
    foreach ($tar in $tarFiles) {
        Write-Host "Loading offline image: $($tar.Name)..."
        docker load -i $tar.FullName
    }
    Write-Host "All offline images loaded!"
}

# -------------------------------
# MAIN LOGIC
# -------------------------------
if (Test-DockerRegistry) {
    Write-Host "Docker registry reachable. Pulling images online..."
    foreach ($img in $images) {
        Write-Host "Pulling $img..."
        docker pull $img
    }
    Write-Host "All images pulled from registry."
} else {
    Write-Host "Using offline images folder: $offlineDir"
    Load-OfflineImages
}

Write-Host "Docker images setup complete. You can now run docker-compose."
