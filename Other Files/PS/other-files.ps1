# Set repo root — change this to your repo folder if needed
$repoRoot = "C:\Coding Project"

# Move to repo root
Set-Location $repoRoot

# Define file extensions for each language/framework
$extensions = @{
    "JavaScript" = @("*.js","*.jsx")
    "CSS/HTML"   = @("*.css","*.html")
    "Python"     = @("*.py")
    "Rust"       = @("*.rs")
    "Go"         = @("*.go")
    "Ruby"       = @("*.rb")
    "Assembly"   = @("*.asm","*.s")
    "C++"        = @("*.cpp","*.hpp","*.h")
    "C"          = @("*.c","*.h")
    "SQL"        = @("*.sql")
    "MongoDB"    = @("*.json","*.bson") # often used for Mongo collections
    "Docker"     = @("Dockerfile","docker-compose*.yml")
}

Write-Host "`nFile count by language/framework:`n"

foreach ($lang in $extensions.Keys) {
    $count = 0
    foreach ($ext in $extensions[$lang]) {
        # Correctly recurse through all subfolders
        $files = Get-ChildItem -Path $repoRoot -Recurse -File -Filter $ext -ErrorAction SilentlyContinue
        $count += $files.Count
    }
    Write-Host "$lang`t: $count"
}

# Total files in repo
$total = (Get-ChildItem -Path $repoRoot -Recurse -File).Count
Write-Host "`nTotal files in repo:`t$total"
