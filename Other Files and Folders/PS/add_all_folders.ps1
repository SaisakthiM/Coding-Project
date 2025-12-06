# Set the branch name
$branchName = "Coding-Project"

# List of folders to add (adjust if needed)
$folders = @(
    "AI",
    "Assembly",
    "Clion",
    "Cloud Computing",
    "Computer Architecture",
    "Configurations and Scripts",
    "Database",
    "Git",
    "Go",
    "Hacking",
    "Intellij",
    "JavaScript",
    "My SQL",
    "Other Files",
    "Programming",
    "Projects",
    "Pycharm",
    "Ruby",
    "Rust",
    "Sai_Project",
    "Testing",
    "Web Storm"
)

# Optional: individual files to add
$files = @(
    ".continue",
    ".continueignore",
    ".htmlhintrc",
    ".vscodeignore",
    "egrep",
    "run-asm.ps1",
    "package.json",
    "package-lock.json"
)

# Create and switch to the new branch
git checkout -b $branchName

# Add folders one by one and commit
foreach ($folder in $folders) {
    if (Test-Path $folder) {
        git add "$folder"
        git commit -m "Add folder: $folder"
    } else {
        Write-Host "Folder not found: $folder"
    }
}

# Add individual files one by one
foreach ($file in $files) {
    if (Test-Path $file) {
        git add "$file"
        git commit -m "Add file: $file"
    } else {
        Write-Host "File not found: $file"
    }
}

# Push the branch to remote
git push -u origin $branchName

Write-Host "All folders and files have been added and pushed to branch $branchName."
