.PHONY: install
install: $(PUBLIC_ROOT_DIR_ln)

.PHONY: reinstall
reinstall: install

$(PUBLIC_ROOT_DIR_ln): public
	sudo rm -rf $(PUBLIC_ROOT_DIR_ln)
	sudo mkdir -p $(PUBLIC_ROOT_DIR_ln)
	sudo cp -r public/ $(PUBLIC_ROOT_DIR_ln)/

.PHONY: uninstall
uninstall:
	sudo rm -rf $(PUBLIC_ROOT_DIR_ln)
