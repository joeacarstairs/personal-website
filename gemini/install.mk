GEMINI_COMITIUM_DATA_FILES := $(addprefix $(GEMINI_COMITIUM_DATA_DIR)/,$(notdir $(wildcard comitium-data/*)))

.PHONY: install
install: $(GEMINI_CERTIFICATES_DIR) $(GEMINI_COMITIUM_DATA_FILES)

.PHONY: reinstall
reinstall: $(GEMINI_CERTIFICATES_DIR) $(GEMINI_COMITIUM_DATA_FILES)

$(GEMINI_CERTIFICATES_DIR):
	sudo mkdir -p $(GEMINI_CERTIFICATES_DIR)
	$(let gemini_user,$(shell whoami),sudo chown $(gemini_user):$(gemini_user) $(GEMINI_CERTIFICATES_DIR))

$(GEMINI_COMITIUM_DATA_DIR)/%: comitium-data/% $(GEMINI_COMITIUM_DATA_DIR)
	sudo cp $< $@
	$(let gemini_user,$(shell whoami),sudo chown $(gemini_user):$(gemini_user) $(GEMINI_COMITIUM_DATA_DIR))

$(GEMINI_COMITIUM_DATA_DIR):
	sudo mkdir -p $(GEMINI_COMITIUM_DATA_DIR)

.PHONY: uninstall
uninstall:
	sudo rm -rf $(GEMINI_COMITIUM_DATA_DIR)
