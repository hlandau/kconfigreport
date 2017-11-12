### NixOS.
##############################################################################
NIXOS_REPO=https://d3g5gsiof5omrk.cloudfront.net/nixos

$(NETCACHE_DIR)/nixos-minimal-%-linux.iso:
	mkdir -p "$(NETCACHE_DIR)"
	@VERSTR_ARCH="$(patsubst $(NETCACHE_DIR)/nixos-minimal-%-linux.iso,%,$@)"; \
	VERSTR="$$(echo "$$VERSTR_ARCH" | cut -d- -f1)"; \
	VERMAJOR="$$(echo "$$VERSTR" | sed 's/^\([0-9]\+\.[0-9]\+\)\..*$$/\1/')"; \
	ARCH="$$(echo "$$VERSTR_ARCH" | cut -d- -f2)"; \
	echo $$VERSTR $$ARCH $$VERMAJOR; \
	wget -O "$@" \
	  "$(NIXOS_REPO)/$$VERMAJOR/nixos-$$VERSTR/nixos-minimal-$$VERSTR-$$ARCH-linux.iso"

$(KCACHE_DIR)/nixos-%: $(NETCACHE_DIR)/nixos-minimal-%-linux.iso
	mkdir -p "$(KCACHE_DIR)"
	$(SEVENZIP) e -so "$<" boot/bzImage > "$@"

.PRECIOUS: $(NETCACHE_DIR)/nixos-minimal-%-linux.iso

_CONFIGS+= nixos-17.09.2034.78eed74497-x86_64
