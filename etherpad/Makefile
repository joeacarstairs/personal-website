ETHERPAD_VERSION := 3.3.2
SRC_DIR := etherpad-$(ETHERPAD_VERSION)

.PHONY: all
all: download_etherpad install_deps

.PHONY: download_etherpad
download_etherpad: $(SRC_DIR)

$(SRC_DIR):
	wget -O- https://github.com/ether/etherpad/archive/refs/tags/v3.3.2.tar.gz | tar -xz

.PHONY: install_deps
install_deps: $(SRC_DIR)/node_modules

$(SRC_DIR)/node_modules: $(SRC_DIR) $(SRC_DIR)/settings.json $(SRC_DIR)/package.json $(SRC_DIR)/pnpm-lock.yaml
	cd $(SRC_DIR) && pnpm install

$(SRC_DIR)/settings.json: $(SRC_DIR) settings.json
	cp settings.json $(SRC_DIR)/settings.json

clean:
	rm -rf etherpad-*/
