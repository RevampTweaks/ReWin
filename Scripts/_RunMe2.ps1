if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))  
{  
  $arguments = "& '" +$myinvocation.mycommand.definition + "'"
  Start-Process powershell -Verb runAs -ArgumentList $arguments
  Break
}

Write-Host "Started Revamp script as administrator succesfully"

# Disable smartscreen process

Stop-Process -Name smartscreen -Force -ErrorAction SilentlyContinue
takeown /f C:\Windows\System32\smartscreen.exe
icacls C:\Windows\System32\smartscreen.exe /grant *S-1-5-32-544:F
Rename-Item -Path C:\Windows\System32\smartscreen.exe -NewName smartscreen.exe.old -Force

# Remove Uneeded Power Plans

powercfg -delete a1841308-3541-4fab-bc81-f71556f20b4a
powercfg -delete 381b4222-f694-41f0-9685-ff5bb260df2e
powercfg -delete 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg -delete e9a42b02-d5df-448d-aa00-03f14749eb61

Write-Host "Removed Uneeded Power Plans"

# Disable memory compression

Disable-MMAgent -MemoryCompression

Write-Host "Disabled Memory Compression"

#Disable reserved storage

DISM /Online /Set-ReservedStorageState /State:Disabled

Write-Host "Disabled Reserved Storage"

#Disable recovery partition

reagentc /disable

Write-Host "Disabled Recovery Partition"

#Disable Data Execution Prevention

Start-Process bcdedit.exe -ArgumentList '/set {current} nx AlwaysOff' -Verb RunAs

Write-Host "Disabled Data Execution Prevention"

#Disable hibernation

powercfg -h off

Write-Host "Disabled Hibernation"

# Disable power saving for drivers

Get-WmiObject MSPower_DeviceEnable -Namespace root\wmi | ForEach-Object { $_.enable = $false; $_.psbase.put(); }

Write-Host "Disabled Power Saving For All Devices"

# Disable netbios over tcp ip

Get-CimInstance -ClassName 'Win32_NetworkAdapterConfiguration' | Where-Object -Property 'TcpipNetbiosOptions' -ne $null | ForEach-Object {
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\services\NetBT\Parameters\interfaces\tcpip_*" -name NetBiosOptions -value 2
}

Write-Host "Disabled NetBios Over TCP IP"

# Disable network adapter extra features (including ipv6 and teredo)

Get-NetAdapter | ForEach-Object {
    $adapter = $_
    Get-NetAdapterBinding -Name $adapter.Name | Where-Object {
        $_.DisplayName -in @("Client for Microsoft Networks", "File and Printer Sharing for Microsoft Networks", "Microsoft LLDP Protocol Driver", "Link-Layer Topology Discovery Responder", "Link-Layer Topology Discovery Mapper I/O Driver")
    } | ForEach-Object {
        Disable-NetAdapterBinding -Name $adapter.Name -DisplayName $_.DisplayName -Confirm:$false
    }
}

#Turn off network discovery
Set-NetFirewallRule -Group '*-32752*' -Enabled 'False'

netsh interface teredo set state disable

# Disabling Nagle's Algorithm for better gaming latency
$tcpipPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"

# Select only GUID-named interface keys
$tcpInterfaces = Get-ChildItem -Path $tcpipPath | Where-Object { $_.PSChildName -match '^\{?[0-9A-Fa-f]{8}(-[0-9A-Fa-f]{4}){3}-[0-9A-Fa-f]{12}\}?$' }

foreach ($tcpInterface in $tcpInterfaces) {
    $path = $tcpInterface.PSPath

    $properties = @{
        "TCPNoDelay"      = 1
        "TcpAckFrequency" = 1
        "TcpDelAckTicks"  = 0
    }

    foreach ($name in $properties.Keys) {
        $value = $properties[$name]
        # Create or update as DWORD
        if (Get-ItemProperty -Path $path -Name $name -ErrorAction SilentlyContinue) {
            Set-ItemProperty -Path $path -Name $name -Value $value -Type DWord
        } else {
            New-ItemProperty -Path $path -Name $name -Value $value -PropertyType DWord | Out-Null
        }
    }
}


Write-Host "Disabled Extra Network Features"

#Disable hypervisor boot

bcdedit /set hypervisorlaunchtype off

Write-Host "Disabled Hypervisor Boot"

#Disable dynamic tick

bcdedit /set disabledynamictick yes

Write-Host "Disabled Dynamic Tick"

#Disable HPET

bcdedit /deletevalue useplatformclock

Get-PnpDevice -FriendlyName "High precision event timer" | Disable-PnpDevice -Confirm:$false

Write-Host "Disabled HPET"

#Align svchost according to memory (services)
$ram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "SvcHostSplitThresholdInKB" -Type DWord -Value $ram -Force

Write-Host "Aligned Svchost With System Memory"

# Unload unwanted drivers in device manager

Get-PnpDevice -FriendlyName "Microsoft Hyper-V Virtualization Infrastructure Driver" | Disable-PnpDevice -Confirm:$false

Get-PnpDevice -FriendlyName "Microsoft Virtual Drive Enumerator" | Disable-PnpDevice -Confirm:$false

Get-PnpDevice -FriendlyName "NDIS Virtual Network Adapter Enumerator" | Disable-PnpDevice -Confirm:$false

Get-PnpDevice -FriendlyName "Remote Desktop Device Redirector Bus" | Disable-PnpDevice -Confirm:$false

Get-PnpDevice -FriendlyName "Microsoft GS Wavetable Synth" | Disable-PnpDevice -Confirm:$false

Get-PnpDevice -FriendlyName "Microsoft RRAS Root Enumerator" | Disable-PnpDevice -Confirm:$false

Write-Host "Unloaded unwanted drivers in device manager"

#Remove unwanted features & capabilites

$optRemove=@('Recall','TFTP','TIFFIFilter','Containers','MediaPlayback','SimpleTCP','WorkFolders-Client','Client-ProjFS','MicrosoftWindowsPowerShellV2','MicrosoftWindowsPowerShellV2Root','TelnetClient','SearchEngine-Client-Package','Printing-XPSServices-Features','Windows-Defender-Default-Definitions','Printing-PrintToPDFServices-Features','DirectoryServices-ADAM-Client','SmbDirect','MSRDC-Infrastructure','Printing-Foundation-Features','Printing-Foundation-InternetPrinting-Client','Microsoft-RemoteDesktopConnection')
$capPatterns=@('*InternetExplorer*','*StepsRecorder*','*WindowsMediaPlayer*','*Wallpapers*','*Print*','*MathRecognizer*','*PowerShell*','*QuickAssist*','*OneCoreUAP*','*LA57*','*Ralink*','*Virtual*','*TCP*','*Hello*','*Theme*','*Edge*','*Search*','*Defender*','*Hyper-V*','*Hypervisor*','*VirtualMachine*','*Virtualization*')

if(-not([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)){Write-Error 'Run as Administrator.';exit 1}

foreach($f in $optRemove){
  try{
    $i=Get-WindowsOptionalFeature -Online -FeatureName $f -ErrorAction Stop
    if($i.State -eq 'Enabled'){Disable-WindowsOptionalFeature -Online -FeatureName $f -Remove -NoRestart -ErrorAction Stop;Write-Output "Removed: $f"} else {Write-Output "Skipped (not enabled): $f"}
  }catch{Write-Output "Error (opt): $f - $($_.Exception.Message)"}
}

foreach($p in $capPatterns){
  try{
    Get-WindowsCapability -Online | Where-Object { $_.Name -like $p -and $_.State -eq 'Installed' } | ForEach-Object {
      try{Remove-WindowsCapability -Online -Name $_.Name -ErrorAction Stop;Write-Output "Removed capability: $($_.Name)"}catch{Write-Output "Error (cap): $($_.Name) - $($_.Exception.Message)"}
    }
  }catch{Write-Output "Error (cap lookup): $p - $($_.Exception.Message)"}
}

Write-Host "Removed unwanted features & capabilities"

#Disable unnecessary scheduled tasks

Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\ProgramDataUpdater" 
Disable-ScheduledTask -TaskName "Microsoft\Windows\Autochk\Proxy" 
Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" 
Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" 
Disable-ScheduledTask -TaskName "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" 
Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClient"  
Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload"  
Disable-ScheduledTask -TaskName "Microsoft\Windows\Windows Error Reporting\QueueReporting" 
Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\MareBackup"  
Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\StartupAppTask"  
Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\PcaPatchDbTask"  
Disable-ScheduledTask -TaskName "Microsoft\Windows\Maps\MapsUpdateTask" 
Disable-ScheduledTask -TaskName "Microsoft\Windows\Defrag\ScheduledDefrag"
Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser Exp"

Write-Host "Disabled Unnecessary Scheduled Tasks"

#Remove prefetch folder
rm -r -fo C:\Windows\Prefetch


Write-Host "Operation completed."

exit










