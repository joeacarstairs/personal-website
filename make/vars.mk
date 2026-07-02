HOSTNAME := $(shell cat /etc/hostname)
HOSTNAMES := pi-broughton blade-canongate
MODULES_pi-broughton := http gemini smtp vaultwarden ln
MODULES_blade-canongate := etherpad
ALL_MODULES := $(sort $(foreach hostname,$(HOSTNAMES),$(MODULES_$(hostname))))
MASTER_NODE := pi-broughton
IS_MASTER_NODE := $(filter $(MASTER_NODE),$(HOSTNAME))
NGINX_MODULES := $(if $(IS_MASTER_NODE),$(ALL_MODULES))
MODULES := $(MODULES_$(HOSTNAME))
SUBDOMAINS := $(foreach module,$(MODULES),$(SUBDOMAIN_$(module)))
COMPOSE_SERVICES := $(shell podman-compose config \
	| yq ".services | keys" --output-format csv --csv-separator " ")
MAKE_MODULES := $(foreach module,$(MODULES),\
	$(shell [ -f $(module)/Makefile ] && echo $(module)))
ENV_RULES := $(foreach module,$(MODULES),$(module)/.env)
MAKE_RULES := $(foreach module,$(MAKE_MODULES),make_$(module))
BUILD_RULES := $(foreach module,$(filter $(COMPOSE_SERVICES),$(MODULES)),build_$(module))
PUSH_RULES := $(foreach module,$(filter $(COMPOSE_SERVICES),$(MODULES)),push_$(module))
INSTALL_RULES := $(foreach module,$(MODULES),install_$(module))
REINSTALL_RULES := $(foreach module,$(MODULES),reinstall_$(module))
UNINSTALL_RULES := $(foreach module,$(MODULES),uninstall_$(module))
SUBDOMAIN_http := @
SUBDOMAIN_vaultwarden := pwd
SUBDOMAIN_etherpad := docs
SUBDOMAIN_ln := ln
