# Minimal AMD GPU Driver Installation Guide

This guide walks you through the process of stripping away the unnecessary telemetry, background services, and bloatware from the official AMD Radeon drivers, leaving you with only whats required.

## Step 1: Download the Driver

Download the official installer matching your graphics hardware directly from the official AMD site.

* Source: [AMD Drivers Portal](https://www.amd.com/en/support/download/drivers.html)

## Step 2: Isolating & Installing the Display Driver


1. Right-click the downloaded `whql-amd-software-***.exe` file.

2. Hover over **7-Zip** and select **Extract to "[Driver_Name]\"**.

3. Navigate into the extracted driver directory:
   `whql-amd-software-***\Packages\Drivers\Display`

4. Inside the `Display` folder, locate the directory named **`****_INF`**.

5. Copy the **`****_INF`** folder and paste it into a separate location.

6. Once safely copied, delete the old extracted folder.

7. Inside your new separate folder, **delete everything except** the following essential files:
   * `B******` (Main driver data folder)
   * `*.cat` (Security catalog file)
   * `*.inf` (Setup information file)
   * `amdpcibridge` *(Keep only if present)*
   * `amdvlk` *(Keep only if present)*
   * `amdogl` *(Keep only if present)*
   * `amdocl` *(Keep only if present)*

8. Go inside the `B******` folder, locate the `ccc2_install.exe` file, and extract it to a separate location using 7-Zip. Once extracted, delete the original `.exe` file.

9. Navigate into the newly extracted folder path: `ccc2_install\CN\cnext\cnext64`.

10. Locate and copy out the **`ccc-next64.msi`** file to your main installation directory, then safely delete the rest of the `ccc2_install` folder.

11. Now naviagte to the `****_INF` folder, right click on the `*.inf` and click Install. After the screen comes back up from flickering,  it means the driver has been installed along with `amdocl` , `amdogl` , `amdvlk` , `amdpcibridge` if present.

## Step 3: Post-Install Cleanup

1. Run `AMD GPU Driver Post Cleanup.ps1` to remove remaining driver bloatware.

2. Press `Win + R`, type `services.msc`, and press **Enter**.

3. Locate the **AMD External Events Utility** service.

4. Right-click it, select **Properties**, and change the *Startup type* to **Disabled**.

> **FreeSync Users Note:** If you use AMD FreeSync/ Adaptive-Sync on your monitor, **do not disable this service**. The *AMD External Events Utility* service is required for it to function correctly. If you do not use FreeSync, it can be safely disabled.


## Step 4: Installing the Control Panel (Optional but Recommended)

1. Locate the **`ccc-next64.msi`** file that you isolated and copied out in Step 2.

2. Double-click and run the installer to complete the minimal control panel setup.

## Step 5: Control Panel Post-Installation Cleanup

1. Run `AMD Control Panel Post Cleanup.ps1` to remove unnecessary AMD Control Panel registery entries and scheduled tasks. (Only if you installed the Control Panel)

## Step 6: Configure Control Panel

Follow the screenshots attached:

- Disable check for updates

<img width="1728" height="1000" alt="5" src="https://github.com/user-attachments/assets/96715286-7448-4def-942c-e1e0a3e64313" />

- Disable all metrics logging

<img width="2023" height="1036" alt="4" src="https://github.com/user-attachments/assets/f98bdde0-6049-4a09-ae77-781194046c11" />

- All preferences off/ disabled

<img width="2023" height="1036" alt="3" src="https://github.com/user-attachments/assets/3367f2d1-cfe3-4fe7-a329-6e29e29c5465" />

- Disable hotkeys

<img width="2023" height="1036" alt="2" src="https://github.com/user-attachments/assets/7ed9f1bf-7daa-4f3b-9890-55585a8f50bc" />

- Disable HDCP Support
>Only if you don't watch DRM protected content like Netflix, etc.

<img width="2023" height="1036" alt="1" src="https://github.com/user-attachments/assets/37259e0e-bacd-49ea-9270-d9d04860f431" />

- Incase HDCP toggle isn't present in the AMD Control Panel Settings then run this in PowerShell:
```powershell
  New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" -Name "RMHdcpKeyglobZero" -Value 1 -PropertyType DWORD -Force
```
