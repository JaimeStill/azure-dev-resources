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