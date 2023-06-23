# Manage Ubuntu

## Snap Packages

```bash
# download <package>.snap and <package>.assert to <dir>
$ snap download --target-directory=<dir> <package>
Fetching snap "<package>"
Fetching assertions for "<package>"

# acknowledge assertion
$ sudo snap ack <dir>/<assert-file>

# install snap package
$ sudo snap install <dir>/<snap-file>

# verify installation
$ snap list
```

## Apt Packages

```bash
# initialize required packages
packages="apt-offline git nodejs"

: '
download .deb for package + dependencies
to the current directory
'
apt-get download \
    $(apt-cache depends \
        --recurse \
        --no-recommends \
        --no-suggests \
        --no-conflicts \
        --no-breaks \
        --no-replaces \
        --no-enhances \
        --no-pre-depends \
        ${packages} \
        | grep "^\w"
    )

: '
to execute a code block in a different directory
and return to the initial directory when finished
'
(
    # change to target directory
    cd "<directory>"
    apt-download "<packages>"
)
# returns back to the initial directory

# install all .deb files in a directory
sudo apt install /path/to/packages/*
```

## Azure CLI apt Source

```bash
echo "deb [arch=$(dpkg --print-architecture)] https://packages.microsoft.com/repos/azure-cli/ jammy main" | sudo tee -a /etc/apt/sources.list.d/azure-cli.list

sudo apt update

sudo apt install azure-cli -y
```

## Links

* [Ubuntu packages](https://packages.ubuntu.com/)
* [Ubuntu package mirror](https://mirrors.edge.kernel.org/ubuntu/pool/)