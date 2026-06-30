LN_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

.PHONY: install
install: /var/ln.joeac.net/public

/var/ln.joeac.net/public: $(LN_DIR)/public
	sudo rm -rf /var/ln.joeac.net/public
	sudo mkdir -p /var/ln.joeac.net/
	sudo cp -r $(LN_DIR)/public/ /var/ln.joeac.net/public/

.PHONY: uninstall
uninstall:
	sudo rm -rf /var/ln.joeac.net
