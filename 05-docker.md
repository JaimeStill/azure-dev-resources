# Docker Images

## Cache and Restore Images

1. List available images:

    ```bash
    # list docker images
    docker images
    ```

    **Output:**

    > Only relevant table columns displayed for brevity

    Repository | Tag
    -----------|----
    daprio/daprd | latest
    daprio/dapr | 1.10.4
    redis | 6
    openzipkin/zipkin | latest

2. Save the image:

    ```bash
    docker save <repository>:<tag> -o <name>-<tag>.tar

    #example
    docker save daprio/dapr:1.10.4 -o dapr-1.10.4.tar
    ```

3. Load the saved image:

    ```bash
    docker load -i <name>-<tag>.tar

    #example
    docker load -i dapr-1.10.4.tar
    ```

4. Create and run the image:

    ```bash
    docker create daprio/dapr:1.10.4

    docker run -d ... daprio/dapr:1.10.4
    ```

## .NET Docker