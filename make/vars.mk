capitalise = $(shell _v="$(1)"; echo $${_v^^})

HOSTNAME := $(shell cat /etc/hostname)
HOSTNAMES := pi-broughton blade-canongate
MASTER_NODE := pi-broughton
MODULES_pi-broughton := http gemini smtp vaultwarden ln
MODULES_blade-canongate := etherpad
MODULES := $(MODULES_$(HOSTNAME))
ALL_MODULES := $(sort $(foreach hostname,$(HOSTNAMES),$(MODULES_$(hostname))))
IS_MASTER_NODE := $(filter $(MASTER_NODE),$(HOSTNAME))
NGINX_MODULES := $(if $(IS_MASTER_NODE),$(ALL_MODULES))
COMPOSE_SERVICES := $(shell podman-compose config \
	| yq ".services | keys" --output-format csv --csv-separator " ")
MAKE_MODULES := $(foreach module,$(MODULES),\
	$(shell [ -f $(module)/Makefile ] && echo $(module)))

SUBDOMAIN_http := @
SUBDOMAIN_vaultwarden := pwd
SUBDOMAIN_etherpad := docs
SUBDOMAIN_ln := ln

PORT_etherpad := 9001
PORT_http := 8080
PORT_gemini := 1965
PORT_smtp := 2500
PORT_vaultwarden := 9000

$(foreach module,$(ALL_MODULES),$(if $(PORT_$(module)),$(eval \
	export $(call capitalise,$(module))_PORT := $(PORT_$(module)))))

SUBDOMAINS := $(foreach module,$(MODULES),$(SUBDOMAIN_$(module)))
NGINX_SUBDOMAINS := $(foreach module,$(NGINX_MODULES),$(SUBDOMAIN_$(module)))

ENV_RULES := $(foreach module,$(MODULES),$(module)/.env)
MAKE_RULES := $(foreach module,$(MAKE_MODULES),make_$(module))
BUILD_RULES := $(foreach module,$(filter $(COMPOSE_SERVICES),$(MODULES)),build_$(module))
PUSH_RULES := $(foreach module,$(filter $(COMPOSE_SERVICES),$(MODULES)),push_$(module))
INSTALL_RULES := $(foreach module,$(MODULES),install_$(module))
REINSTALL_RULES := $(foreach module,$(MODULES),reinstall_$(module))
UNINSTALL_RULES := $(foreach module,$(MODULES),uninstall_$(module))
