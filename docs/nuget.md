# NuGet
[Home](./readme.md)

.NET (C#) dependencies, known as [NuGet Packages](https://learn.microsoft.com/en-us/nuget/what-is-nuget).

## Hosting NuGet Packages

### Building a NuGet Cache

## Internal NuGet Packages

Internal NuGet packages should be managed and published on an unclassfied network and resolved with all additional external dependencies.

### Publishing NuGet Updates

```bash
dotnet pack -c Release -o ./.nuget/

dotnet nuget push \
    ./.nuget/<Package>.<Version>.nupkg \
    --api-key <key> \
    --source https://api.nuget.org/v3/index.json \
    --skip-duplicate
```

### Automating NuGet Package Deployments

Deployment to NuGet can be automated through GitHub Actions:

```yaml
name: Pack and Push <Package> to NuGet

on:
  push:
    tags:
      - "v[0-9]+.[0-9]+.[0-9]+"
jobs:
  build:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: ./<package-directory>/
    steps:
    - name: Checkout
      uses: actions/checkout@v2
    - name: Set VERSION variable from tag
      run: echo "VERSION=${GITHUB_REF/refs\/tags\/v/}" >> $GITHUB_ENV
    - name: Build
      run: dotnet build -c Release /p:Version=${VERSION}
    - name: Pack
      run: dotnet pack -c Release /p:Version=${VERSION} --no-build --output .
    - name: Push
      run: >
        dotnet nuget push <Package>.${VERSION}.nupkg
            --source https://api.nuget.org/v3/index.json
            --api-key ${{ secrets.NUGET_KEY }}
            --skip-duplicate
```

To initiate an updated version, create a new GitHub Tag (this can be done at: https://github.com/<User>/<Repo>/tags) in the format of `v[0-9].[0-9].[0-9]`. This should be done after an approved pull request.
    
[Home](./readme.md)