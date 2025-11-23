# ------------------ EXECUTION POLICY ------------------
# Bypass execution policy for this session
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# ------------------ CONFIG ------------------
$usbDriveLetter = "D:"        # Your USB drive
$efiPartitionLetter = "Z"     # Temporary EFI partition
$efiFolder = "$env:TEMP\EFI"  # Temp folder to build EFI
# --------------------------------------------

Write-Host "⚠ WARNING: This will ERASE all data on $usbDriveLetter" -ForegroundColor Yellow
Pause

# ------------------ CLEAN AND FORMAT USB ------------------
$drive = Get-Partition -DriveLetter ($usbDriveLetter.Replace(":", "")) | Get-Disk
$diskNumber = $drive.Number

Write-Host "🧹 Cleaning USB Drive..."
$diskpartScript = @"
select disk $diskNumber
clean
convert gpt
create partition primary size=300
format fs=fat32 quick label=EFI
assign letter=$efiPartitionLetter
exit
"@
$diskpartScript | diskpart

# ------------------ CREATE TEMP FOLDER ------------------
if (Test-Path $efiFolder) { Remove-Item $efiFolder -Recurse -Force }
New-Item -ItemType Directory -Path $efiFolder
New-Item -ItemType Directory -Path "$efiFolder\OC"
New-Item -ItemType Directory -Path "$efiFolder\OC\Drivers"
New-Item -ItemType Directory -Path "$efiFolder\OC\Kexts"

# ------------------ DOWNLOAD KEXTS ------------------
Write-Host "⬇ Downloading kexts and OpenCore drivers..."

$kexts = @{
    "Lilu.kext" = "https://github.com/acidanthera/Lilu/releases/download/1.6.2/Lilu.kext.zip"
    "WhateverGreen.kext" = "https://github.com/acidanthera/WhateverGreen/releases/download/1.6.4/WhateverGreen.kext.zip"
    "VirtualSMC.kext" = "https://github.com/acidanthera/VirtualSMC/releases/download/2.2.9/VirtualSMC.kext.zip"
    "SMCProcessor.kext" = "https://github.com/acidanthera/VirtualSMC/releases/download/2.2.9/SMCProcessor.kext.zip"
    "SMCSuperIO.kext" = "https://github.com/acidanthera/VirtualSMC/releases/download/2.2.9/SMCSuperIO.kext.zip"
    "NVMeFix.kext" = "https://github.com/acidanthera/NVMeFix/releases/download/1.0.9/NVMeFix.kext.zip"
    "AirportItlwm.kext" = "https://github.com/OpenIntelWireless/itlwm/releases/download/v2.2.0/AirportItlwm.kext.zip"
    "IntelBluetoothFirmware.kext" = "https://github.com/OpenIntelWireless/IntelBluetoothFirmware/releases/download/v2.5.0/IntelBluetoothFirmware.kext.zip"
    "IntelBluetoothInjector.kext" = "https://github.com/OpenIntelWireless/IntelBluetoothInjector/releases/download/v2.5.0/IntelBluetoothInjector.kext.zip"
}

foreach ($kext in $kexts.GetEnumerator()) {
    $zipPath = "$env:TEMP\$($kext.Key).zip"
    Write-Host "Downloading $($kext.Key)..."
    Invoke-WebRequest -Uri $kext.Value -OutFile $zipPath -UseBasicParsing
    Expand-Archive -LiteralPath $zipPath -DestinationPath "$efiFolder\OC\Kexts\$($kext.Key)"
}

# ------------------ DOWNLOAD OPENCORE DRIVERS ------------------
$ocVersion = "0.9.2"  # adjust if newer
$ocZip = "$env:TEMP\OpenCore.zip"
Invoke-WebRequest -Uri "https://github.com/acidanthera/OpenCorePkg/releases/download/$ocVersion/OpenCore-$ocVersion-RELEASE.zip" -OutFile $ocZip -UseBasicParsing
Expand-Archive -LiteralPath $ocZip -DestinationPath "$env:TEMP\OpenCore"

# Copy Drivers
$drivers = @("OpenRuntime.efi","OpenCanopy.efi","OpenHfsPlus.efi")
foreach ($drv in $drivers) {
    Copy-Item "$env:TEMP\OpenCore/X64/EFI/OC/Drivers/$drv" "$efiFolder\OC\Drivers\"
}

# ------------------ CREATE TEMPLATE CONFIG.PLIST ------------------
Write-Host "📄 Creating template config.plist..."
$plistContent = @"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>ACPI</key><dict></dict>
    <key>Booter</key><dict></dict>
    <key>DeviceProperties</key>
    <dict>
        <key>Add</key>
        <dict>
            <key>PciRoot(0x0)/Pci(0x2,0x0)</key>
            <dict>
                <key>AAPL,ig-platform-id</key>
                <data>AwA2AQA=</data> <!-- Intel UHD spoofed as Iris Plus 10th Gen -->
                <key>device-id</key>
                <data>AzYCAA==</data>
            </dict>
        </dict>
    </dict>
    <key>KextsToPatch</key><array></array>
    <key>SMBIOS</key><dict>
        <key>SystemProductName</key><string>MacBookPro17,1</string>
        <key>SystemSerialNumber</key><string>C02XXXXXGHTV</string>
    </dict>
</dict>
</plist>
"@

$plistPath = "$efiFolder\OC\config.plist"
$plistContent | Out-File -FilePath $plistPath -Encoding UTF8

# ------------------ COPY EFI TO USB ------------------
Write-Host "📁 Copying EFI to USB..."
Copy-Item -Path "$efiFolder\*" -Destination "{$efiPartitionLetter}:\" -Recurse -Force

Write-Host "✅ Done! Your USB is ready for macOS installation via OpenCore."
Write-Host "➡ Boot your HP Victus from USB and select OpenCore Bootloader."
