
Unregister-ScheduledTask -TaskName "StartCN" -Confirm:$false


Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "AMDNoiseSuppression" -Force


Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce" -Name "StartRSX" -Force

pause