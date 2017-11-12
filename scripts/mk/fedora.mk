### Fedora.
##############################################################################
FEDORA_MIRROR=https://mirrors.kernel.org/fedora

#4.11.8-300.fc26.x86_64
$(NETCACHE_DIR)/kernel-core-%.rpm:
	mkdir -p "$(NETCACHE_DIR)"; \
	VER="$(patsubst $(NETCACHE_DIR)/kernel-core-%.rpm,%,$@)"; \
	FCNUM="$$(echo "$$VER" | sed 's/^.*\.fc\([0-9]\+\)\..*$$/\1/')"; \
	ARCH="$$(echo "$$VER" | sed 's/^.*\.\([^.]\+\)$$/\1/')"; \
	wget -O "$@" \
		"$(FEDORA_MIRROR)/releases/$$FCNUM/Workstation/$$ARCH/os/Packages/k/kernel-core-$$VER.rpm"

$(CONFIGS_DIR)/fedora-%: $(NETCACHE_DIR)/kernel-core-%.rpm
	mkdir -p "$(CONFIGS_DIR)"; \
	VER="$(patsubst $(CONFIGS_DIR)/fedora-%,%,$@)"; \
	( DIR="$$(mktemp -d ./tmp.XXXXXXXXXX)"; cd "$$DIR"; \
		7z x "../$<"; \
		7z x "$(patsubst $(NETCACHE_DIR)/%.rpm,%.cpio,$<)"; \
		mv lib/modules/$$VER/config "../$@"; \
		touch "../$@"; \
		cd ..; \
		rm -rf "$$DIR"; )

.PRECIOUS: $(NETCACHE_DIR)/kernel-core-%.rpm

_CONFIGS+= fedora-4.11.8-300.fc26.x86_64
