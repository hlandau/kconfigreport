### Alpine.
##############################################################################
ALPINE_MIRROR=https://nl.alpinelinux.org/alpine/latest-stable/main/x86_64

$(NETCACHE_DIR)/linux-vanilla-%.apk:
	mkdir -p "$(NETCACHE_DIR)"; \
	VER="$(patsubst $(NETCACHE_DIR)/linux-vanilla-%.apk,%,$@)"; \
	wget -O "$@" \
	  "$(ALPINE_MIRROR)/linux-vanilla-$$VER.apk"

$(CONFIGS_DIR)/alpine-%: $(NETCACHE_DIR)/linux-vanilla-%.apk
	mkdir -p "$(CONFIGS_DIR)"; \
	( DIR="$$(mktemp -d ./tmp.XXXXXXXXXX)"; cd "$$DIR"; \
	  tar xf "../$<" 2>&1 | grep -v 'Ignoring unknown extended header'; \
		mv boot/config "../$@"; \
		touch "../$@"; \
		cd ..; \
		rm -rf "$$DIR"; )

.PRECIOUS: $(NETCACHE_DIR)/linux-vanilla-%.apk

_CONFIGS+= alpine-4.9.33-r0
