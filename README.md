# Wolfi-OS

[![Build Packages](https://github.com/duyhenryer/wolfi/actions/workflows/build.yaml/badge.svg)](https://github.com/duyhenryer/wolfi/actions/workflows/build.yaml)
[![PR Check](https://github.com/duyhenryer/wolfi/actions/workflows/pr.yaml/badge.svg)](https://github.com/duyhenryer/wolfi/actions/workflows/pr.yaml)
[![Docker Images](https://github.com/duyhenryer/wolfi/actions/workflows/docker.yaml/badge.svg)](https://github.com/duyhenryer/wolfi/actions/workflows/docker.yaml)

The repository is hosted with Cloudflare R2 storage.

## Installation of Repository

<details>
  <summary>with Dockerfile</summary>

```docker
FROM cgr.dev/chainguard/wolfi-base

RUN echo "https://wolfi.duyne.me" >> /etc/apk/repositories && \
cat <<EOF > /etc/apk/keys/wolfi-melange.rsa.pub 
-----BEGIN PUBLIC KEY-----
MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA9s0rytmiqI5l6IgwLqiD
ecg3jwDIHWfzVmzfedTen4KW5MkmUVXgFXbmegD/e4arNzqkw2tpqIkYgKO4G5MF
wMvfvx4NP/dDBmEwRkqiq53+TfiaLZQYpotZy1Zrb7GHQBIQ+hK1ekN+WFBOmhd5
fwdPPBLbG1aOjigyydLdriLCDOf7mo7OZq7K42Ima2/Mp/Cdb12JswxIc5XYuJwX
35grsQy7dcli7QUbh20f/teB0hMb70V9RanXf2I8lzZ74djHMlDk6lJ0blBA8Wzl
P0m+yznoGIcSvix18XO78/TlbEajH/m8w4mjrNsgzeRlMeexOz0JO6fn7FtcRh3X
QmgAQ5QRy3ioZ1haEdr+oLlEOGUlmG1xdnpRCPAb8L0Xu7qDJr8Sm7DKPpzM5Jc4
k8/WCHJzsmOYPSV83itxTk6hfiMY5L/IsJsOe9/ZzUxmpiLEY5NSjiS+jSu/I492
PePYfiX/on7GNEzbRRaQzQ9cwKSKswpXxkk8dPQUTDPZ4SGclJzE0Yle/utQ4AJM
vMYK/ceaMC56CvEfoUmH3o2H0Y8MRhEE0hQ7xmIWlTfgJx256ToXG3auNVWs2Ax2
cwcAYarHaBAYoljBMyCqMWW+7nLCXoI0bAb0O4f2X2I6zpD2MsE7obLQA6l6x/X+
og/rYbYh7rDgqPyhAU8tJicCAwEAAQ==
-----END PUBLIC KEY-----
EOF

RUN ...
```

</details>


<details>
  <summary>with apko</summary>

[apko](https://github.com/chainguard-dev/apko)

```diff
contents:
  keyring:
    - https://packages.wolfi.dev/os/wolfi-signing.rsa.pub
+    - https://wolfi.duyne.me/wolfi-melange.rsa.pub
  repositories:
    - https://packages.wolfi.dev/os
+    - https://wolfi.duyne.me
  packages:
    - wolfi-base
    - frankenphp-8.3
```

</details>

afterwards all packages of this repository can be installed with `apk add <package>` or apko.

## Package Organization

This repository organizes packages in a clean directory layout where each package has its own directory at the root level:

```
wolfi/
├── php-8.4/          # Package directories at root
│   ├── php-8.4.yaml
│   └── README.md
├── nginx/
│   ├── nginx.yaml
│   └── README.md
├── minicli/
│   ├── minicli.yaml
│   └── README.md
├── images/           # Docker images
├── Makefile          # Build automation
└── packages/         # Build output (gitignored)
    └── x86_64/       # Architecture-specific .apk files
```

**Structure benefits:**
- ✅ Follows [shyim/wolfi-php](https://github.com/shyim/wolfi-php) and official Wolfi patterns
- ✅ Clear separation between source (tracked) and build output (ignored)
- ✅ Simple workflow patterns without nested path complexity
- ✅ Easy to find and manage packages

Each package directory contains:
- The package definition YAML file (e.g., `nginx.yaml`)
- Optional README.md for package-specific documentation
- Any additional files needed for the package build

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
make package/minicli

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

### Features

- **Reproducible Builds**: Builds use `SOURCE_DATE_EPOCH` for deterministic output
- **Image Signing**: All Docker images are signed with Cosign for supply chain security
- **Auto-updates**: Automated bots check for package updates hourly via GitHub releases and Release Monitor
- **CVE Scanning**: Packages are automatically scanned for vulnerabilities during builds
- **SBOM Generation**: Software Bill of Materials generated for all packages

### Adding a New Package

To add a new package:

1. Create a new directory at the root with your package name:
   ```bash
   mkdir -p my-package
   ```

2. Create the package definition YAML file:
   ```bash
   touch my-package/my-package.yaml
   ```

3. Write your package definition following the [Melange](https://github.com/chainguard-dev/melange) format

4. (Optional) Add a README.md with package documentation:
   ```bash
   touch my-package/README.md
   ```

5. The CI/CD workflows will automatically detect and build your package when you push changes

## Available Packages

There is no web package browser. The easiest way is to use `apk search` to find the package you need.

```bash
docker run --rm -it ghcr.io/duyhenryer/wolfi/base:latest
apk update
apk search <term>
```

## Packages

### PHP

This repository contains PHP packages. Currently available:
- PHP 8.4 (package: `php-8.4`)

### Web Servers

- Nginx (package: `nginx`)

### Tools

- Minicli (package: `minicli`) - Minimalist CLI framework for PHP

## FrankenPHP

This repository contains FrankenPHP for PHP 8.2 and 8.3. The package is called `frankenphp-8.2` and `frankenphp-8.3`.

A basic example to use FrankenPHP in your Dockerfile:

```dockerfile
FROM ghcr.io/duyhenryer/wolfi/base:latest

RUN <<EOF
set -eo pipefail
apk add --no-cache \
    frankenphp-8.2 \
    php-frankenphp-8.2
adduser -u 82 www-data -D
EOF

WORKDIR /var/www/html
USER www-data
EXPOSE 8000

ENTRYPOINT [ "/usr/bin/frankenphp", "run" ]
CMD [ "--config", "/etc/caddy/Caddyfile" ]
```

After building the image, you can run the container with `docker run -p 8000:8000 <image>` and it should show a PHP info page.

To learn more about FrankenPHP, [see here](./images/frankenphp)

## Base images

We provide also base image for ready to start without touching configuration:

- [FrankenPHP](./images/frankenphp)
- [Nginx + PHP-FPM](./images/nginx)
- [Caddy + PHP-FPM](./images/caddy)
- [FPM standalone](./images/fpm)

### Pinning package versions

To pin the version of a package, you can specify the version in the `apk add` command. Example could be:

```shell
apk add --no-cache php-8.2=8.2.17-r0
```

To get the exact current version of a package, you can run `apk info php-8.2`.

### Package updates

[We have a Bot which checks every hour if there is a package update, and opens a PR if there is a new version available.](https://github.com/duyhenryer/wolfi/actions/workflows/wolfictl-update-gh.yaml)
