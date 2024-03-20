# Notes

## Optimizing Transfer Bundles

Compressing the directories to be transferred in `.tar.gz` format is faster and more efficient than using the native Windows zip feature. In PowerShell, use the following:

**Compress**  

```pwsh
tar -czvf [directory].tar.gz -C [directory] .
```

**Extract**

```pwsh
mkdir -p [directory]
tar -xvf [directory].tar.gz -C [directory]
```

## Load All Docker Images

On the air-gapped network, load all Docker images with the following:

```pwsh
Get-ChildItem -Filter *.tar | foreach { docker load -i $_ }
```

## WSL Linux Kernel Updates

The URL in the [Build-WslCache](./scripts/Build-WslCache.ps1) script does not point to the latest kernel required by Docker Desktop.

This [GitHub Issue Comment](https://github.com/microsoft/WSL/issues/5650#issuecomment-765825503) identifies how to obtain the latest version:

For users coming here from a Google search for WSL2 Kernel Upgrade:

* Download the latest kernel from here: https://www.catalog.update.microsoft.com/Search.aspx?q=wsl

* Open and extract the update to your desktop

* Load a command prompt with elevated privileges (Start --> cmd --> Right-click --> Run as Administrator)

* Run these commands in the command prompt:

    ```pwsh
    cd C:\Users\your_username\Desktop\

    wsl --shutdown

    wsl_update_x64.msi

    wsl

    uname -r
    ```

This should update the kernel and show you the latest running version.