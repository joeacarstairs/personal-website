COMITIUM_DATA := comitium-data
TEMPLATES_DIR := templates
MICROLOG_HEADER := $(TEMPLATES_DIR)/microlog-header.gmi
LONGLOG_HEADER := $(TEMPLATES_DIR)/longlog-header.gmi
LOGLOG_HEADER := $(TEMPLATES_DIR)/loglog-header.gmi
MICROLOG_ENTRIES := $(wildcard microlog/*)
LONGLOG_ENTRIES := $(wildcard content/logs/longlog/*)

all: microlog loglog longlog add_feeds

microlog: $(MICROLOG_ENTRIES) $(MICROLOG_HEADER)
	bash ./build_microlog.bash

longlog: $(LONGLOG_ENTRIES) $(LONGLOG_HEADER)
	bash ./build_longlog.bash

loglog: microlog longlog $(LOGLOG_HEADER)
	bash ./build_loglog.bash

add_feeds: $(COMITIUM_DATA)/feeds.txt
	rm -f $(COMITIUM_DATA)/comitium.json
	while read feed; do \
		comitium add --data "$(COMITIUM_DATA)" $$feed; \
	done <$(COMITIUM_DATA)/feeds.txt
