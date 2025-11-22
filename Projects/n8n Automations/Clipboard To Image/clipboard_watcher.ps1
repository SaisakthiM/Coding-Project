Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$lastHash = ""

while ($true) {
    $img = [Windows.Forms.Clipboard]::GetImage()
    if ($img -ne $null) {
        # Compute hash to avoid duplicates
        $ms = New-Object IO.MemoryStream
        $img.Save($ms, [Drawing.Imaging.ImageFormat]::Png)
        $hash = [BitConverter]::ToString((New-Object Security.Cryptography.SHA1Managed).ComputeHash($ms.ToArray()))
        if ($hash -ne $lastHash) {
            $path = "$PSScriptRoot\clipboard.png"
            $img.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
            Write-Host "📸 Saved clipboard image to $path"
            python send_to_n8n.py $path
            $lastHash = $hash
        }
    }
    Start-Sleep -Seconds 2
}
