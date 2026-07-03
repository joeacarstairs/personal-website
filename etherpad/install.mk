.PHONY: install
install: $(ETHERPAD_DATA_DIR)

.PHONY: reinstall
reinstall: $(ETHERPAD_DATA_DIR)

$(ETHERPAD_DATA_DIR):
	sudo mkdir -p $(ETHERPAD_DATA_DIR)

.PHONY: uninstall
uninstall:
	$(info Nothing to do)
