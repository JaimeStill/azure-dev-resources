# OS Configuration

## WSL + Ubuntu

https://learn.microsoft.com/en-us/windows/wsl/install-manual

```PowerShell
# enable WSL
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# enable virtual machine feature
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

Download and install the [WSL2 Linux kernel update package for x64 machines](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi).

```PowerShell
# Set WSL2 as your default version
wsl --set-default-version 2
```

> Ubuntu cloud images: https://cloud-images.ubuntu.com/releases

[Download](https://learn.microsoft.com/en-us/windows/wsl/install-manual#downloading-distributions) a Linux Distribution:

```PowerShell
Invoke-WebRequest -Uri https://aka.ms/wslubuntu2204 -OutFile ubuntu.appx -UseBasicParsing

Add-AppxPackage .\ubuntu.appx
```