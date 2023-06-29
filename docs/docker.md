# Docker
[Home](./index.md)

Docker images can be cached via the [Build-DockerCache.ps1](./scripts/Build-DockerCache.md) script.

## Cache and Restore Images

1. Pull the image you want to cache:

    ```bash
    docker pull mcr.microsoft.com/dotnet/sdk:latest
    ```

2. List available images to verify:

    ```bash
    docker images
    ```

    **Output:**

    > Only relevant table columns displayed for brevity

    Repository | Tag
    -----------|----
    node | latest
    mcr.microsoft.com/dotnet/sdk | latest
    mcr.microsoft.com/dotnet/aspnet | latest
    samples/postgres | latest
    redis | 6
    daprio/dapr | 1.10.4
    openzipkin/zipkin | latest

2. Save the image:

    ```bash
    docker save <repository>:<tag> -o <name>-<tag>.tar

    #example
    docker save mcr.microsoft.com/dotnet/sdk:latest -o dotnet-sdk-latest.tar
    ```

3. Load the saved image:

    ```bash
    docker load -i <name>-<tag>.tar

    #example
    docker load -i dotnet-sdk-latest.tar
    ```

4. Create and run the image:

    ```bash
    docker create mcr.microsoft.com/dotnet/sdk:latest

    docker run -d ... mcr.microsoft.com/dotnet/sdk:latest
    ```

## .NET Images

**Dockerfile**

```dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["<Project>.Api/<Project>.Api.csproj", "<Project>.Api/"]
RUN dotnet restore "<Project>.Api/<Project>.Api.csproj"
COPY . .
WORKDIR "/src/<Project>.Api"
RUN dotnet build "<Project>.Api.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "<Project>.Api.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "<Project>.Api.dll"]
```

**.dockerignore**  

```
.dockerignore
.env
.git
.gitignore
.vs
.vscode
*/bin
*/obj
**/.toolstarget
```

## Node Images

**Dockerfile**  

```dockerfile
FROM node:latest as build
WORKDIR /usr/local/app
COPY ./ /usr/local/app/
RUN npm install
RUN npm run build

FROM nginx:latest
COPY --from=build /usr/local/app/dist/core-spa /usr/share/nginx/html
EXPOSE 80
```

**.dockerignore**  

```
.angular
.env
.git
.vscode
node_modules
.dockerignore
.gitignore
README.md
```

## Commands

```bash
# view images in the local Docker image registry
docker images

# pull a Docker image
docker pull mcr.microsoft.com/dotnet/sdk:7.0
docker pull mcr.microsoft.com/dotnet/aspnet:7.0

# remove an image from the local Docker image registry
docker rmi <tag>:<version>

# place a container in the run state
docker run -d tmp-ubuntu

# run a .NET Web ApI container on port 5000
docker run -it --rm -p 5000:80 <image>

# place a container in the pause state
docker pause happy_wilbur

# unpause a container
docker unpause happy_wilbur

# restart a container
docker restart happy_wilbur

# place a container in the stopped state
docker stop happy_wilbur

# terminate a container
docker kill happy_wilbur

# remove one or more containers
docker rm happy_wilbur

# list running containers in all states
docker ps -a

# login to Docker Hub
docker login

# re-tag Docker image under username
docker tag <image> <username>/<image>

# push image to Docker Hub
docker push <username>/<image>

# build from docker-compose.yml
docker-compose build

# run orchestrated images
docker-compose up
```

[Home](./index.md)