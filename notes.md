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