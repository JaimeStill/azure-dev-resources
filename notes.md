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