# Nginx Package

High performance web server for Wolfi-OS.

## Package Information

- **Package Name**: `nginx`
- **Version**: See [nginx.yaml](./nginx.yaml) for current version
- **License**: BSD-2-Clause

## Installation

```bash
apk add nginx
```

## Features

This package includes:
- HTTP/HTTPS server
- HTTP/2 support
- SSL/TLS support
- Reverse proxy capabilities
- Load balancing
- Mail proxy
- Stream module for TCP/UDP proxying

## Configuration

Nginx configuration files are located in `/etc/nginx/`:
- Main config: `/etc/nginx/nginx.conf`
- Additional configs: `/etc/nginx/conf.d/`

## Usage

Start nginx:
```bash
nginx
```

Test configuration:
```bash
nginx -t
```

Reload configuration:
```bash
nginx -s reload
```

## Links

- [Nginx Official Website](https://nginx.org/)
- [Package Definition](./nginx.yaml)

