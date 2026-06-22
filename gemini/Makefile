COMITIUM_DATA := comitium-data
TEMPLATES_DIR := templates
MICROLOG_HEADER := $(TEMPLATES_DIR)/microlog-header.gmi
LONGLOG_HEADER := $(TEMPLATES_DIR)/longlog-header.gmi
LOGLOG_HEADER := $(TEMPLATES_DIR)/loglog-header.gmi
MICROLOG_ENTRIES := $(wildcard microlog/*)
LONGLOG_ENTRIES := $(wildcard content/logs/longlog/*)
LOGLOG_TARGET := content/logs/loglog.gmi
FEED_TARGET := $(COMITIUM_DATA)/comitium.json $(COMITIUM_DATA)/feed.gmi $(COMITIUM_DATA)/subscriptions.gmi
FEED_OUTPUTS := $(FEED_TARGET) $(COMITIUM_DATA)/comitium.json $(COMITIUM_DATA)/feed.gmi $(COMITIUM_DATA)/subscriptions.gmi
MICROLOG_TARGET := content/logs/microlog.gmi
MICROLOG_OUTPUTS := $(MICROLOG_TARGET) $(wildcard content/logs/microlog/*)
LONGLOG_TARGET := content/logs/longlog.gmi

.DELETE_ON_ERROR:
all: $(MICROLOG_TARGET) $(MICROLOG_OUTPUTS) $(LONGLOG_TARGET) $(LOGLOG_TARGET) $(FEED_OUTPUTS)

$(MICROLOG_TARGET): $(wildcard microlog/*) $(MICROLOG_HEADER)
	bash ./build_microlog.bash

$(LONGLOG_TARGET): $(LONGLOG_ENTRIES) $(LONGLOG_HEADER)
	bash ./build_longlog.bash

$(LOGLOG_TARGET): $(MICROLOG_TARGET) $(LONGLOG_TARGET) $(LOGLOG_HEADER)
	bash ./build_loglog.bash

$(FEED_TARGET): $(COMITIUM_DATA)/feeds.txt
	rm -f $(FEED_TARGET); \
	while read feed; do \
		comitium add --data "$(COMITIUM_DATA)" $$feed; \
	done <$(COMITIUM_DATA)/feeds.txt

clean:
	rm -rf $(MICROLOG_OUTPUTS) $(LONGLOG_TARGET) $(LOGLOG_TARGET) $(FEED_OUTPUTS)
