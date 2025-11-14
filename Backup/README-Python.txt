=== Python Environment Backup ===
Date: 2025-11-14 22:35:39

Files in this backup:
- requirements.txt       : All installed packages with versions
- pip-list.txt          : Human-readable package list
- python-versions.txt   : Python and pip versions used
- python-restore.ps1    : Restoration script for new PC

To restore on new PC:
1. Install Python (preferably the same version as in python-versions.txt)
   Download from: https://www.python.org/downloads/
2. Navigate to your project directory
3. Run: .\Backup\python-restore.ps1

Note: The virtual environment folder (.venv-12) is NOT backed up.
It will be recreated during restoration.
