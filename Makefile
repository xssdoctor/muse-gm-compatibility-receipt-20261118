.PHONY: install clean

OUTPUT_DIR ?= output
RECEIPT ?= $(OUTPUT_DIR)/compatibility.txt
SAMPLE ?= $(OUTPUT_DIR)/sample.png

install:
	@mkdir -p "$(OUTPUT_DIR)"
	@set -eu; \
		gm_path="$$(readlink -f "$$(command -v gm)")"; \
		libc_path="$$(ldd "$$gm_path" | awk '$$1 == "libc.so.6" { print $$3; exit }')"; \
		{ \
			printf 'gm_path=%s\n' "$$gm_path"; \
			gm version | sed -n '1p'; \
			dpkg-query -W -f='graphicsmagick_package=$${Version} $${Architecture}\n' graphicsmagick 2>/dev/null || true; \
			printf 'gm_sha256='; sha256sum "$$gm_path" | awk '{ print $$1 }'; \
			if command -v readelf >/dev/null 2>&1; then \
				readelf -n "$$gm_path" | awk '/Build ID:/ { print "gm_build_id=" $$3; exit }'; \
			fi; \
			ldd --version | sed -n '1s/^/ldd_version=/p'; \
			dpkg-query -W -f='libc6_package=$${Version} $${Architecture}\n' libc6; \
			printf 'libc_path=%s\n' "$$libc_path"; \
			printf 'libc_sha256='; sha256sum "$$libc_path" | awk '{ print $$1 }'; \
			if command -v readelf >/dev/null 2>&1; then \
				readelf -n "$$libc_path" | awk '/Build ID:/ { print "libc_build_id=" $$3; exit }'; \
			fi; \
			uname -srmo | sed 's/^/kernel=/' ; \
		} > "$(RECEIPT)"
	@gm convert assets/sample.ppm "PNG:$(SAMPLE)"

clean:
	@rm -f "$(RECEIPT)" "$(SAMPLE)"
