SEVENZIP ?= 7z
REPO=hlandau/kconfigreport

BUILD_DIR=build
NETCACHE_DIR=$(BUILD_DIR)/cache/net
KCACHE_DIR=$(BUILD_DIR)/cache/kernel
CONFIGS_DIR=$(BUILD_DIR)/configs
REPORT_DIR=$(BUILD_DIR)/report

.PHONY: all clean send

all: $(REPORT_DIR)/index.xhtml

clean:
	rm -rf "$(BUILD_DIR)"


### General operations.
##############################################################################
$(CONFIGS_DIR)/%: $(KCACHE_DIR)/%
	mkdir -p "$(CONFIGS_DIR)"
	./scripts/extract-ikconfig "$<" > "$@.tmp"
	mv "$@.tmp" "$@"


### Include distro-specific methods.
##############################################################################
_CONFIGS=
include scripts/mk/nixos.mk
include scripts/mk/debian.mk
include scripts/mk/fedora.mk
include scripts/mk/arch.mk
include scripts/mk/alpine.mk

ALL_CONFIGS := $(foreach x,$(_CONFIGS),$(CONFIGS_DIR)/$(x)) $(CONFIGS)


### Collation.
##############################################################################
$(BUILD_DIR)/configs.db: $(ALL_CONFIGS)
	./scripts/collate "$(BUILD_DIR)/configs.db" "$(CONFIGS_DIR)"


### Output generation.
##############################################################################
$(REPORT_DIR)/index.xhtml: $(BUILD_DIR)/configs.db ./scripts/mkreport
	mkdir -p "$(REPORT_DIR)/option"
	./scripts/mkreport "$(BUILD_DIR)/configs.db" "$(REPORT_DIR)"


### Upload to github.
##############################################################################
send: $(REPORT_DIR)/index.xhtml
	( DIR="$$(mktemp -d ./send.XXXXXXXXX)"; \
		git clone . "$$DIR"; \
		cd "$$DIR"; \
		git checkout --orphan send-1; \
		git rm -rf .; \
		rsync -a "../$(BUILD_DIR)/report/" .; \
		rsync -a "../$(BUILD_DIR)/configs/" configs; \
		git add .; \
		git commit -m gh-pages; \
		git push --force "git@github.com:$(REPO).git" send-1:gh-pages; \
		cd ..; \
		rm -rf "$$DIR"; \
	)
