### Debian.
##############################################################################
DEBIAN_MIRROR=https://mirrors.kernel.org/debian

$(NETCACHE_DIR)/linux-image-%.deb:
	mkdir -p "$(NETCACHE_DIR)"
	VER="$(patsubst $(NETCACHE_DIR)/linux-image-%.deb,%,$@)"; \
	wget -O "$@" \
		"$(DEBIAN_MIRROR)/pool/main/l/linux/linux-image-$$VER.deb"

$(CONFIGS_DIR)/debian-%: $(NETCACHE_DIR)/linux-image-%.deb
	mkdir -p "$(CONFIGS_DIR)"; \
	VER="$(patsubst $(CONFIGS_DIR)/debian-%,%,$@)"; \
	CVER="$$(echo "$$VER" | cut -d_ -f1)"; \
	( DIR="$$(mktemp -d ./tmp.XXXXXXXXXX)"; cd "$$DIR"; \
		ar x "../$<"; \
		tar -Oxf data.tar.xz "./boot/config-$$CVER" > "../$@.tmp"; \
		cd ..; \
		rm -rf "$$DIR"; )
	mv "$@.tmp" "$@"

.PRECIOUS: $(NETCACHE_DIR)/linux-image-%.deb

_CONFIGS+= debian-4.13.0-1-amd64_4.13.10-1_amd64
