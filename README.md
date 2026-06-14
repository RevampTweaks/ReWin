# ReWin- Windows Optimization Guide
### This project aims to maximize your Windows performance by minimizing system overhead.
Note: This repository strictly covers OS and software-level optimizations; it does not involve hardware tuning, BIOS modifications, overclocking, or RAM tightening.

## Table of Contents
- [Choosing The Edition](#choosing-the-edition)
  - [Why not Server?](#why-not-server)
- [Required Files & Utilities](#required-files--utilities)
- [Installation](#installation)
- [Post-Installation](#post-installation)


## Choosing The Edition
- We will start by clean installing Windows 11 IoT LTSC.
- Doesn't have the latest CPU scheduling updates for AMD Ryzen 9 X3D chips so follow this [guide](https://www.youtube.com/watch?v=O_tL7JJOBFw&t=701s) to override the scheduler.


## Why not Server?

<details>
<summary> Drivers issues.</summary>

- You have to modify the ".inf" files of the drivers, enable test signing, disable integrity checking, and on top of that, when you manage to install the driver, it is "unverified," which results to compatibility issues with some anti-cheats.

</details>

<details>
<summary> Missing Xbox components.</summary>

- No native controllers support (Missing drivers)  

- No native Microsoft Store support.  

- No native Xbox apps support as the "Xbox Core" component handles Game Bar, Game Mode, and various online Xbox connectivity services is missing in Server Edition.  

- DirectX-11 games using Easy Anti-Cheat (ex- Fortnite, Predecessor, etc) will not work in Fullscreen Exclusive even after disabling Fullscreen Optimizations because of the missing [Microsoft.XboxGamingOverlay (Game Bar)] and [Microsoft.XboxGameOverlay (Xbox Game Bar Plugin)] packges as no new registry keys or values will be made & registered under [HKEY_CURRENT_USER\System\GameConfigStore\Children] & [HKEY_CURRENT_USER\System\GameConfigStore\Parents] directory. (Also, it would be ineffective if you tried to import a registry key for a game whose "flags" value works to force Exclusive Fullscreen on another Windows installation for example.)  

- In IoT LTSC, the "Xbox Core" component is already present, so we just have to install some Xbox UWP packages for the Exclusive Fullscreen to work correctly in DirectX-11 games using Easy Anti-Cheat.

</details>


## Essential Files We Need

Have them saved before proceeding.

### Drivers

* **Network Driver**

  * Description: Download the specific LAN or Wi-Fi driver installer for your motherboard before installation to ensure network access.
* **GPU Driver**

  * Description: Download the official installer matching your graphics hardware.
  
  * Source (NVIDIA): [NVIDIA Drivers](https://www.nvidia.com/Download/index.aspx)

  * Source (AMD): [AMD Drivers](https://www.amd.com/en/support/download/drivers.html)

  * Source (Intel): [Intel Drivers](https://www.intel.com/content/www/us/en/search.html#sortCriteria=@lastmodifieddt%20descending&cf-tabfilter=Downloads&cf-downloadsppth=Graphics)

* **Snappy Driver Installer Origin (SDIO)**

  * Credits: Glenn Delahoy

  * Source: [Official Website](https://www.glenn.delahoy.com/snappy-driver-installer-origin/)

### Remove Unnecessary Windows Baked-in Stuff

* **Remove MS Edge**

  * Description: A script designed to completely uninstall and remove Microsoft Edge.

  * Credits: [@ShadowWhisperer](https://github.com/ShadowWhisperer)

  * Source: [GitHub Repository](https://github.com/ShadowWhisperer/Remove-MS-Edge)

* **Windows Defender Remover**

  * Description: A specialized tool to turn off, disable, or completely remove Windows Defender.

  * Credits: [@ionuttbara](https://github.com/ionuttbara)

  * Source: [GitHub Repository](https://github.com/ionuttbara/windows-defender-remover)

### Power Plans

* **Custom Power Plans**

  * Description: Download and import the community-optimized power profiles corresponding to your processor manufacturer.

  * Source (Intel): [Intel Custom Power Plans for Windows](https://www.overclock.net/threads/intel-custom-power-plans-for-windows.1802309/)

  * Source (AMD): [Ryzen Custom Power Plans for Windows](https://www.overclock.net/threads/ryzen-custom-power-plans-for-windows-10-balanced-and-ultimate.1776353/)

### Essentials

* **My Custom Scripts** [Feel free to analyze the files beforehand.]

 * Source: Download the scripts directly from [Scripts](Scripts) folder.

* **Choice of Browser (e.g., Firefox, Ungoogled Chromium)**

  * Source (Firefox): [Mozilla Firefox](https://www.mozilla.org/firefox/new/)

  * Source (Ungoogled Chromium): [GitHub Repository](https://github.com/ungoogled-software/ungoogled-chromium-windows)

* **Choice of Media Player (e.g., mpv.net)**

  * Credits: [@mpvnet-player](https://github.com/mpvnet-player)

  * Source: [GitHub Repository](https://github.com/mpvnet-player/mpv.net)

* **StartAllBack**

  * Description: Lightweight shell modification tool to restore and optimize taskbar, start menu, and explorer performance.

  * Source: [Official Website](https://www.startallback.com/)

* **TimerResolution**

  * Description: A utility to tune the default Windows timer resolution for reduced input latency. Read this [Documentation](https://github.com/valleyofdoom/PC-Tuning/blob/main/docs/research.md#fixing-timing-precision-in-windows-after-the-great-rule-change) on fixing Windows timing precision following platform update architectural changes.

  * Credits: [@valleyofdoom](https://github.com/valleyofdoom)

  * Source: [GitHub Repository](https://github.com/valleyofdoom/TimerResolution)

* **7-Zip**

  * Credits: Igor Pavlov

  * Source: [Official Download Page](https://www.7-zip.org/download.html)

* **Autoruns**

  * Credits: Microsoft Sysinternals

  * Source: [Microsoft Learn Official Download](https://learn.microsoft.com/en-us/sysinternals/downloads/autoruns)

* **Visual C++ Redistributable Runtimes AIO Repack**

  * Credits: [@abbodi1406](https://github.com/abbodi1406)

  * Source: [GitHub Repository](https://github.com/abbodi1406/vcredist)

* **Microsoft DirectX End-User Runtimes**

  * Credits: Microsoft

  * Source: [Microsoft Download Center](https://www.microsoft.com/en-us/download/details.aspx?id=8109)

* **PowerRun**

  * Description: A lightweight, portable utility designed to launch files and registry keys with TrustedInstaller or NT AUTHORITY\SYSTEM privileges, bypassing standard administrator blocks.

  * Credits: Sordum

  * Source: [Official Product Page](https://www.sordum.org/9416/powerrun-v1-8-run-with-highest-privileges/)

### Optional

* **Microsoft Edge WebView2 (Optional - Only if your set of apps or use case requires it)**

  * Credits: Microsoft

  * Source: [Microsoft Developer Portal](https://developer.microsoft.com/en-us/microsoft-edge/webview2?form=MA13LH)



## Installation

1. Flash the ISO file of Windows 11 IoT LTSC to your USB drive using a tool like [Rufus](https://rufus.ie/en/#download) or [Ventoy](https://www.ventoy.net/en/download.html).

2. Unplug your ethernet cable or ensure you have no active internet connection before proceeding.

3. Boot from your installation USB, perform a clean install by explicitly selecting **Windows 11 IoT Enterprise LTSC** from the OS variants list, and open the command prompt by pressing `Shift + F10` when on the OOBE screen.

4. Run:

```cmd
net user Administrator /active:yes
shutdown /r /t 0
```
5. After the PC reboots, select your region and language settings and if you see a prompt for entring a username, again run the same commands in Step 4. It should then boot straight up into the desktop after configuring the regional and language options without asking for a username this time.

6. Don't connect to the internet just yet.

7. Run `DefenderRemover.exe` and execute `[Y] Remove Windows Defender Antivirus + Windows Security App`. PC will reboot.

8. After the reboot, repeat Step 7 once again to ensure proper removal as sometimes it doesn't fully process it in the first run.

9. Run `DefenderRemover.exe` for the last time and execute `[S] Remove Defender Files (if you removed antivirus first)`.

10. Run `Remove-EdgeWeb.exe` or `Remove-Edge.exe`.
>`Remove-EdgeWeb.exe` removes Edge & WebView both. Whereas `Remove-Edge.exe` only remove Edge

11. Reboot the PC.

12. Run the `_RunMe1.reg` file, confirm. It would give import error, ignore it.

13. Now open `PowerRun_x64.exe` & go to File> Allow Command Line and enable it.

14. Exit `PowerRun_x64.exe`.

15. Drag the `_RunMe1.reg` file to `PowerRun_x64.exe` to run it with the highest privileges, confirm.

16. Reboot the PC.

17. Connect to the internet.
> Install your previously saved network driver if windows doesn't show one right now.

18. **Activate Windows**: Open PowerShell and execute the following command to permanently activate Windows for free:
  ```powershell
  irm https://get.activated.win | iex
  ```
  * Credits & More Info: [Massgrave](https://massgrave.dev/)

19. Open PowerShell and Run
```powershell
wsreset-i
```
>This installs the Windows Store & the required dependencies and frameworks like Store Experience Host, Xbox Identity Provider, etc. (Important for games like Forza Horizon 6 which requires the new Gaming Services app).


20. Repeat Step 12 & Step 15.

21. Right click on your `Intel/AMD PowerPlan.pow` file and Import it. Go to the Control Panel> Hardware & Sound> Power Options and select it as default.

22. Install
- Visual C++ Redistributable Runtimes `VisualCppRedist_AIO_x86_x64.exe`

- 7-Zip `7z****-x64.exe`

- Microsoft DirectX End-User Runtimes `directx_Jun2010_redist.exe`

- Your Choice of Browser

- Your Choice of Media Player

- StartAllBack 

23. Install the GPU Driver ([AMD GPU Driver Guide](GPU%20Driver%20Guide/AMD%20GPU%20Driver.md))

24. Use Snappy Driver Installer Origin (SDIO) to check for driver updates (i.e. Network,etc) & optionally install and update your chipset drivers.
> I personally recommend installing AMD Chipset Drivers & yes from here and not the offical AMD website. I don't recommend installing Intel Chipset drivers though although you are free to test for yourself.

25. Reboot. (The Store & UWP Frameworks would have been installed by now too).

26. Repeat Step 12 & Step 15.
> If you have an AMD CPU then disable Intel(R) Power Engine Plug-in Driver via running this in PowerShell. Don't run if you are an Intel user.
 ```powershell
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\intelpep" -Name "Start" -Value 4 -Type DWord
```

27. Right click on `_RunMe2.ps1` & Run with PowerShell.

28. After it is executed and closed, run it again but this time by dragging it to `PowerRun_x64`.

29. Disable every Power Saving feature like Energy Efficient Ethernet, etc on your network driver by going into the Device Manager> Network Adapters> *Realtek/Intel/Etc*> Properties> Advanced.

30. Reboot.

31. Configure the Timer Resolution we downloaded earlier by following its respective documentation which I linked above.

- I Perosonally don't create a scheduled task, rather I place my shortcut in the windows startup directory.
  ```cmd
  shell:startup
  ```
32. Install your apps and games, enjoy!

## Cleanup

1. Disable System Restore Points for all drives via:
```cmd
systempropertiesprotection
```

2. Run Disk Cleaup via:
```cmd
cleanmgr.exe /sageset:1
```

3. Delete their contents.
```cmd
temp
```
```cmd
%temp%
```

4. Use `Autoruns64.exe` to cleanup any residual files if present.
