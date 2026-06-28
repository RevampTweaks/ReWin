Write-Host "Triggering AMD MSI Uninstaller Silently..."

$productName = "AMD Install Manager"

# Find installed MSI products whose DisplayName matches
$product = Get-CimInstance Win32_Product |
  Where-Object { $_.Name -like "*$productName*" } |
  Select-Object -First 1

if (-not $product) {
  throw "Could not find an installed MSI product matching name: $productName"
}

# Convert MSI Product GUID from IdentifyingNumber
$productCode = $product.IdentifyingNumber

$arguments = "/X $productCode /qn /norestart"
Start-Process -FilePath "msiexec.exe" -ArgumentList $arguments -Wait -Verb RunAs
Write-Host "Cleaning up registry folders entry..."

$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\Folders"
$ValuesToRemove = @(
    "C:\Program Files\AMD\AMDInstallManager\"
    "C:\Program Files\AMD\AMDInstallManager\localization\uk_UA\"
    "C:\Program Files\AMD\AMDInstallManager\localization\"
    "C:\Program Files\AMD\AMDInstallManager\localization\ko_KR\"
    "C:\Program Files\AMD\AMDInstallManager\localization\nl_NL\"
    "C:\Program Files\AMD\AMDInstallManager\localization\hu_HU\"
    "C:\Program Files\AMD\AMDInstallManager\localization\el_GR\"
    "C:\Program Files\AMD\AMDInstallManager\localization\cs\"
    "C:\Program Files\AMD\AMDInstallManager\localization\ru_RU\"
    "C:\Program Files\AMD\AMDInstallManager\localization\th\"
    "C:\Program Files\AMD\AMDInstallManager\localization\ja\"
    "C:\Program Files\AMD\AMDInstallManager\localization\da_DK\"
    "C:\Program Files\AMD\AMDInstallManager\localization\de\"
    "C:\Program Files\AMD\AMDInstallManager\localization\es_ES\"
    "C:\Program Files\AMD\AMDInstallManager\localization\fi_FI\"
    "C:\Program Files\AMD\AMDInstallManager\localization\it_IT\"
    "C:\Program Files\AMD\AMDInstallManager\localization\pl\"
    "C:\Program Files\AMD\AMDInstallManager\localization\tr_TR\"
    "C:\Program Files\AMD\AMDInstallManager\localization\zh_TW\"
    "C:\Program Files\AMD\AMDInstallManager\localization\zh_CN\"
    "C:\Program Files\AMD\AMDInstallManager\localization\fr_FR\"
    "C:\Program Files\AMD\AMDInstallManager\localization\no\"
    "C:\Program Files\AMD\AMDInstallManager\localization\pt_BR\"
    "C:\Program Files\AMD\AMDInstallManager\localization\sv_SE\"
)

foreach ($Value in $ValuesToRemove) {
    if (Get-ItemProperty -Path $RegPath -Name $Value -ErrorAction SilentlyContinue) {
        Remove-ItemProperty -Path $RegPath -Name $Value -Force -ErrorAction SilentlyContinue
    }
}

Write-Host "Cleanup completed. You can close this window now."

pause
