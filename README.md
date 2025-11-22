# Wolfi-OS Custom Repository

[![Build Packages](https://github.com/duyhenryer/wolfi/actions/workflows/build.yaml/badge.svg)](https://github.com/duyhenryer/wolfi/actions/workflows/build.yaml)
[![PR Check](https://github.com/duyhenryer/wolfi/actions/workflows/pr.yaml/badge.svg)](https://github.com/duyhenryer/wolfi/actions/workflows/pr.yaml)
[![Docker Images](https://github.com/duyhenryer/wolfi/actions/workflows/docker.yaml/badge.svg)](https://github.com/duyhenryer/wolfi/actions/workflows/docker.yaml)

Custom Wolfi packages repository with PHP, Nginx, and Docker images. Packages are built automatically and hosted on Cloudflare R2 storage.

## Features

- 🔐 **Reproducible Builds**: All builds use `SOURCE_DATE_EPOCH` for deterministic output
- ✍️ **Image Signing**: Docker images are signed with Cosign for supply chain security
- 🤖 **Auto-updates**: Automated checks for package updates (disabled by default)
- 📦 **APK Repository**: Hosted at https://wolfi.duyne.me
- 🐳 **Docker Images**: Available at ghcr.io/duyhenryer/wolfi

## Installation of Repository

<details>
  <summary>with Dockerfile</summary>

```dockerfile
FROM cgr.dev/chainguard/wolfi-base

RUN echo "https://wolfi.duyne.me" >> /etc/apk/repositories && \
cat <<EOF > /etc/apk/keys/wolfi-melange.rsa.pub 
-----BEGIN PUBLIC KEY-----
MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA5AqGblXA57jN4PbrDgVl
OpTCOlRdT+LVzVBlYiYCRYk6pFCQ2yNXx1f9nmT02mv9G82tMSC3pjc/pij/mdCB
eBCukBMSzgT7LAFejrATnKhGgwzSk38xdRhpKUuQcxrzxSu9pWjasn3Hkkz0AsCz
FM9K9vrNWgX7C0juUqH0IkdpvtMj2AoERbu08h3qSHN5XN0GurhCQM9yyNULwGbS
2CPeIPGpsTwsR5iqR0LrEr8771X3AIdxJVCZro2qwhV7X3+RubZpMtmAdVhoQj5T
IHW1+sq4sgVmn5bJ6MfNDc/zvilFaXyNaTK7vLD7UUU1F3JkHQlGVSPKX9LcBoQ0
aJDJn47L156zc1NmMnb8yFhQ/JE3KwuSbwP5gsKTMTsedmTHmjEj87UIrxcpqhW7
EgknlWanim8lq6JHEn9JY9Y7sjy/KOEEz1l9TUN/tAoTjsesfTS/PXF7mDa9jqVv
sZC1cKLIi+N1orXRiyj4K11qkqHNCnGfSMhvU/OzMry3vc9FMdpw1nEAzONtzQkS
Fxbl8FPwyUal61TdTlTasrmHw+HUIbw3Nmxhz5GmSmp3yssdEJ5BnQV5k9OxIXYP
D1o8paH76f3ieCLfEus0vZwAMsiy2Y6J58cgSbat+MIzlp6coTCX1uGYt5SoSZMa
aPWJdfQ1lfLFRtlQEeZHtPkCAwEAAQ==
-----END PUBLIC KEY-----
EOF

RUN apk add --no-cache php-8.4 nginx
```

</details>

<details>
  <summary>with apko</summary>

[apko](https://github.com/chainguard-dev/apko)

```yaml
contents:
  keyring:
    - https://packages.wolfi.dev/os/wolfi-signing.rsa.pub
    - https://wolfi.duyne.me/wolfi-melange.rsa.pub
  repositories:
    - https://packages.wolfi.dev/os
    - https://wolfi.duyne.me
  packages:
    - wolfi-base
    - php-8.4
    - nginx
```

</details>

All packages of this repository can be installed with `apk add <package>` or apko.

## Package Organization

This repository uses a flat structure where package YAML files are located at the root level:

```
wolfi/
├── php-8.4.yaml      # PHP 8.4 package definition
├── nginx.yaml        # Nginx package definition
├── images/           # Docker images
│   ├── base/         # Base image
│   ├── php/          # PHP-FPM images
│   └── nginx/        # Nginx image
├── Makefile          # Build automation
└── packages/         # Build output (gitignored)
    └── x86_64/       # Architecture-specific .apk files
```

**Benefits:**
- Simple flat structure - all package files at root level
- Clear separation between source (tracked) and build output (ignored)
- Easy to find and manage packages
- Consistent with standard Wolfi patterns

## Available Packages

### PHP

- **php-8.4**: PHP 8.4 with common extensions

### Web Servers

- **nginx**: High-performance web server (version 1.26.0)

### Finding Packages

Use `apk search` to find available packages:

```bash
docker run --rm -it ghcr.io/duyhenryer/wolfi/base:latest
apk update
apk search <term>
```

## Docker Images

Pre-built Docker images are available at `ghcr.io/duyhenryer/wolfi`:

- **base**: Minimal Wolfi base image with repository configured
- **php-fpm**: PHP-FPM ready to use
- **nginx**: Nginx web server

### Usage Example

```dockerfile
FROM ghcr.io/duyhenryer/wolfi/php-fpm:8.4

COPY . /var/www/html
WORKDIR /var/www/html

EXPOSE 9000
CMD ["php-fpm", "-F"]
```

## Local Development

### Prerequisites

- Docker (for Wolfi SDK container)
- Make
- Git

### Building Packages Locally

The repository includes a Makefile for local package development:

```bash
# Initialize signing keys
make init

# Build a specific package
make package/nginx
make package/php-8.4

# Test a specific package
make test/nginx

# Build using direct command (alternative)
make build package=nginx

# Clean build artifacts
make clean

# Open interactive shell with packages
make shell
```

### Makefile Targets

- `make init` - Generate melange signing keypair
- `make package/<name>` - Build a specific package with reproducible builds
- `make test/<name>` - Run package tests
- `make build package=<name>` - Alternative build command
- `make clean` - Remove build artifacts
- `make shell` - Interactive Wolfi base shell with package repository

### Environment Variables

- `ARCH` - Target architecture (default: current system, supports x86_64/aarch64)
- `MELANGE_EXTRA_OPTS` - Additional melange build options

## Adding a New Package

To add a new package:

1. Create the package definition YAML file at the root:
   ```bash
   touch my-package.yaml
   ```

2. Write your package definition following the [Melange](https://github.com/chainguard-dev/melange) format

3. Test locally:
   ```bash
   make package/my-package
   make test/my-package
   ```

4. Push changes - CI/CD workflows will automatically detect and build your package

## Package Updates

Package updates can be done manually by editing the YAML files and creating a pull request. Auto-update workflows are available but disabled by default.

### Pinning Package Versions

To pin the version of a package, specify the version in the `apk add` command:

```shell
apk add --no-cache php-8.4=8.4.0-r0
```

To get the exact current version of a package:

```shell
apk info php-8.4
```

## CI/CD Workflows

### Automated Workflows

- **build.yaml**: Builds and publishes packages to Cloudflare R2 on push to main
- **pr.yaml**: Lints and tests packages on pull requests
- **docker.yaml**: Builds and publishes Docker images

### Manual Workflows

- **wolfictl-update-gh.yaml**: Check for updates from GitHub releases (disabled)
- **wolfictl-update-rm.yaml**: Check for updates from Release Monitor (disabled)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add or modify packages
4. Test locally with `make package/<name>` and `make test/<name>`
5. Create a pull request

All packages are automatically linted and tested in CI.

## License

See individual package definitions for license information.
