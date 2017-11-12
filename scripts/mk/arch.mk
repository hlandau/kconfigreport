### Arch.
##############################################################################
ARCH_MIRROR=https://www.mirrorservice.org/sites/ftp.archlinux.org/core/os/

$(NETCACHE_DIR)/linux-%.pkg.tar.xz:
	mkdir -p "$(NETCACHE_DIR)"; \
	VER="$(patsubst $(NETCACHE_DIR)/linux-%.pkg.tar.xz,%,$@)"; \
	ARCH="$$(echo "$$VER" | sed 's/^.*-\([^-]\+\)$$/\1/')"; \
	wget -O "$@" \
	  "$(ARCH_MIRROR)/$$ARCH/linux-$$VER.pkg.tar.xz"

$(KCACHE_DIR)/arch-%: $(NETCACHE_DIR)/linux-%.pkg.tar.xz
	mkdir -p "$(CONFIGS_DIR)"; \
	VER="$(patsubst $(KCACHE_DIR)/arch-%,%,$@)"; \
	VERNUM="$$(echo "$$VER" | sed 's/^\([0-9]\+\.[0-9]\+\.[0-9]\+-[0-9]\+\)-.*$$/\1/')"; \
	( DIR="$$(mktemp -d ./tmp.XXXXXXXXXX)"; cd "$$DIR"; \
	  tar xvf "../$<"; \
		mv "usr/lib/modules/$$VERNUM-ARCH/build/vmlinux" "../$@"; \
		cd ..; \
		rm -rf "$$DIR"; )

.PRECIOUS: $(NETCACHE_DIR)/linux-%.pkg.tar.xz

_CONFIGS+= arch-4.13.11-1-x86_64
