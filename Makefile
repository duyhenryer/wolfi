current_dir = $(shell pwd)

ARCH ?= $(shell uname -m)

ifeq (${ARCH}, arm64)
	ARCH = aarch64
endif

ifeq (${ARCH}, x86_64)
	DEB_ARCH = amd64
else ifeq (${ARCH}, aarch64)
	DEB_ARCH = arm64
else
	DEB_ARCH = $(ARCH)
endif

TARGETDIR = packages/${ARCH}

MELANGE ?= $(shell which melange)

MELANGE_OPTS += --repository-append packages/
MELANGE_OPTS += --keyring-append wolfi-melange.rsa.pub
MELANGE_OPTS += --signing-key wolfi-melange.rsa
MELANGE_OPTS += --arch ${ARCH}
MELANGE_OPTS += --repository-append https://packages.wolfi.dev/os
MELANGE_OPTS += --keyring-append https://packages.wolfi.dev/os/wolfi-signing.rsa.pub
MELANGE_OPTS += --repository-append https://wolfi.duyne.me
MELANGE_OPTS += --keyring-append https://wolfi.duyne.me/wolfi-melange.rsa.pub
MELANGE_OPTS += --git-repo-url=https://github.com/duyhenryer/wolfi
MELANGE_OPTS += --git-commit=$(shell git rev-parse HEAD)
MELANGE_OPTS += ${MELANGE_EXTRA_OPTS}

MELANGE_TEST_OPTS += --repository-append packages/
MELANGE_TEST_OPTS += --keyring-append wolfi-melange.rsa.pub
MELANGE_TEST_OPTS += --arch ${ARCH}
MELANGE_TEST_OPTS += --repository-append https://packages.wolfi.dev/os
MELANGE_TEST_OPTS += --keyring-append https://packages.wolfi.dev/os/wolfi-signing.rsa.pub
MELANGE_TEST_OPTS += --repository-append https://wolfi.duyne.me
MELANGE_TEST_OPTS += --keyring-append https://wolfi.duyne.me/wolfi-melange.rsa.pub
MELANGE_TEST_OPTS += --test-package-append wolfi-base
MELANGE_TEST_OPTS += --debug
MELANGE_TEST_OPTS += ${MELANGE_EXTRA_OPTS}

clean:
	rm -rf packages/${ARCH}

init:
	melange keygen wolfi-melange.rsa

package/%:
	$(eval pkgname := $*)
	$(eval yamlfile := $(pkgname)/$(pkgname).yaml)
	@if [ ! -f "$(yamlfile)" ]; then \
		echo "Error: could not find yaml file at $(yamlfile)"; exit 1; \
	else \
		echo "Building package $(pkgname) from $(yamlfile)"; \
	fi
	$(eval pkgver := $(shell $(MELANGE) package-version $(yamlfile)))
	@printf "Building package $(pkgname) with version $(pkgver) from file $(yamlfile)\n"
	$(MAKE) yamlfile=$(yamlfile) pkgname=$(pkgname) packages/$(ARCH)/$(pkgver).apk

packages/$(ARCH)/%.apk:
	@mkdir -p ./$(pkgname)/
	$(eval SOURCE_DATE_EPOCH ?= $(shell git log -1 --pretty=%ct --follow $(yamlfile)))
	$(info SOURCE_DATE_EPOCH=$(SOURCE_DATE_EPOCH) $(MELANGE) build $(yamlfile) $(MELANGE_OPTS) --source-dir ./$(pkgname)/)
	@SOURCE_DATE_EPOCH=$(SOURCE_DATE_EPOCH) $(MELANGE) build $(yamlfile) $(MELANGE_OPTS) --source-dir ./$(pkgname)/

build:
	@if [ -z "$(package)" ]; then \
		echo "Error: package variable is required. Usage: make build package=php-8.4"; exit 1; \
	fi
	@mkdir -p ./$(package)/
	melange build \
		$(package)/$(package).yaml \
		-r packages/ \
		-k wolfi-melange.rsa.pub \
		-r https://packages.wolfi.dev/os \
		-k https://packages.wolfi.dev/os/wolfi-signing.rsa.pub \
		-r https://wolfi.duyne.me \
		-k https://wolfi.duyne.me/wolfi-melange.rsa.pub \
		--signing-key wolfi-melange.rsa \
		--git-repo-url=https://github.com/duyhenryer/wolfi \
		--git-commit=$(shell git rev-parse HEAD) \
		--source-dir ./$(package)/ \
		--arch ${ARCH}

test/%:
	@mkdir -p ./$(*)/
	$(eval pkgname := $*)
	$(eval yamlfile := $(pkgname)/$(pkgname).yaml)
	@if [ ! -f "$(yamlfile)" ]; then \
		echo "Error: could not find yaml file at $(yamlfile)"; exit 1; \
	else \
		echo "Testing package $(pkgname) from $(yamlfile)"; \
	fi
	$(eval pkgver := $(shell $(MELANGE) package-version $(yamlfile)))
	@printf "Testing package $(pkgname) with version $(pkgver) from file $(yamlfile)\n"
	$(MELANGE) test $(yamlfile) $(MELANGE_TEST_OPTS) --source-dir ./$(pkgname)/

shell:
	echo "https://packages.wolfi.dev/os" > repositories
	echo "/packages" >> repositories
	docker \
	run \
	--rm \
	-v $(current_dir)/packages:/packages \
	-v $(current_dir)/repositories:/etc/apk/repositories \
	-v $(current_dir)/wolfi-melange.rsa.pub:/etc/apk/keys/wolfi-melange.rsa.pub \
	-it cgr.dev/chainguard/wolfi-base

.PHONY: clean init build shell
