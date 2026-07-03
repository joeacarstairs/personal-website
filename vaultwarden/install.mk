.PHONY: install
install: $(VAULTWARDEN_DATA_DIR)

.PHONY: reinstall
reinstall: $(VAULTWARDEN_DATA_DIR)

$(VAULTWARDEN_DATA_DIR):
	sudo mkdir -p $(VAULTWARDEN_DATA_DIR)
	VAULTWARDEN_USER=$(whoami) && sudo chown $$VAULTWARDEN_USER:$$VAULTWARDEN_USER $(VAULTWARDEN_DATA_DIR)

.PHONY: uninstall
uninstall:
	$(info Nothing to do)
