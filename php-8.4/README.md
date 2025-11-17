# PHP 8.4 Package

The PHP programming language version 8.4 for Wolfi-OS.

## Package Information

- **Package Name**: `php-8.4`
- **Version**: See [php-8.4.yaml](./php-8.4.yaml) for current version
- **License**: PHP-3.01

## Installation

Install PHP CLI:
```bash
apk add php-8.4
```

Install PHP-FPM:
```bash
apk add php-8.4-fpm
```

Install PHP extensions:
```bash
apk add php-8.4-curl php-8.4-mbstring php-8.4-mysqlnd
```

## Available Subpackages

- `php-8.4` - PHP CLI
- `php-8.4-fpm` - PHP FastCGI Process Manager
- `php-8.4-cgi` - PHP CGI
- `php-8.4-dbg` - PHP Debugger
- `php-8.4-dev` - Development headers
- `php-8.4-doc` - Documentation
- `php-8.4-{extension}` - Various PHP extensions

## Configuration

PHP configuration files:
- Main config: `/etc/php/php.ini`
- Extension configs: `/etc/php/conf.d/`
- FPM config: `/etc/php/php-fpm.conf`
- FPM pool configs: `/etc/php/php-fpm.d/`

## Links

- [PHP Official Website](https://www.php.net/)
- [Package Definition](./php-8.4.yaml)

