capitalise = $(shell echo "$(1)" | tr '[:lower:]' '[:upper:]')

USER := $(shell whoami)
HOSTNAME := $(shell cat /etc/hostname)
HOSTNAMES := pi-broughton blade-canongate
IP_ADDR_pi-broughton := 192.168.178.54
IP_ADDR_blade-canongate := 192.168.178.75
MASTER_NODE := blade-canongate
IS_MASTER_NODE := $(filter $(MASTER_NODE),$(HOSTNAME))
MODULES_pi-broughton := http smtp vaultwarden ln
MODULES_blade-canongate := etherpad gemini
ALL_NGINX_MODULES := http vaultwarden ln etherpad
NGINX_MODULES := $(if $(IS_MASTER_NODE),$(ALL_NGINX_MODULES))
MODULES := $(MODULES_$(HOSTNAME))
ALL_MODULES := $(sort $(foreach hostname,$(HOSTNAMES),$(MODULES_$(hostname))))
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

PUBLIC_ROOT_DIR_ln := /var/ln.joeac.net/public

export ETHERPAD_DATA_DIR := /var/etherpad/var
export GEMINI_CERTIFICATES_DIR := /var/joeac.net-gemini/certificates
export GEMINI_COMITIUM_DATA_DIR := /var/joeac.net-gemini/comitium-data
export VAULTWARDEN_DATA_DIR := /var/vaultwarden/data

ALPINE_VERSION := 3.23
ETHERPAD_VERSION := 3.3.2

$(foreach module,$(ALL_MODULES),$(if $(PORT_$(module)),$(eval \
	export $(call capitalise,$(module))_PORT := $(PORT_$(module)))))
$(foreach hostname,$(HOSTNAMES),$(foreach module,$(MODULES_$(hostname)),$(eval \
	export HOST_$(module) := $(if $(filter $(HOSTNAME),$(hostname)),127.0.0.1,$(IP_ADDR_$(hostname))))))

SUBDOMAINS := $(foreach module,$(MODULES),$(SUBDOMAIN_$(module)))
NGINX_SUBDOMAINS := $(foreach module,$(NGINX_MODULES),$(SUBDOMAIN_$(module)))

ENV_RULES := $(foreach module,$(MODULES),$(module)/.env)
MAKE_RULES := $(foreach module,$(MAKE_MODULES),make_$(module))
BUILD_RULES := $(foreach module,$(filter $(COMPOSE_SERVICES),$(MODULES)),build_$(module))
PUSH_RULES := $(foreach module,$(filter $(COMPOSE_SERVICES),$(MODULES)),push_$(module))
INSTALL_RULES := $(foreach module,$(MODULES),install_$(module))
REINSTALL_RULES := $(foreach module,$(MODULES),reinstall_$(module))
UNINSTALL_RULES := $(foreach module,$(MODULES),uninstall_$(module))

COMPOSE_CMD := \
	ALPINE_VERSION="$(ALPINE_VERSION)" \
	IMAGE_PREFIX="$(IMAGE_PREFIX)" \
	GEMINI_CERTIFICATES_DIR="$(GEMINI_CERTIFICATES_DIR)" \
	GEMINI_COMITIUM_DATA_DIR="$(GEMINI_COMITIUM_DATA_DIR)" \
	ETHERPAD_DATA_DIR="$(ETHERPAD_DATA_DIR)" \
	ETHERPAD_VERSION="$(ETHERPAD_VERSION)" \
	VAULTWARDEN_DATA_DIR="$(VAULTWARDEN_DATA_DIR)" \
	LOCAL_SMTP_PORT=$(PORT_smtp) \
	$(foreach module,$(ALL_MODULES),$(call capitalise,$(module))_PORT=$(PORT_$(module))) \
	podman-compose

$(foreach module,$(ALL_NGINX_MODULES), \
	$(if $(SUBDOMAIN_$(module)),, \
		$(error $(module) is declared as an nginx module, but SUBDOMAIN_$(module) is not set)))
$(foreach module,$(ALL_NGINX_MODULES), \
	$(if $(PORT_$(module)) $(HOST_$(module)),,$(if $(PUBLIC_ROOT_DIR_$(module)),, \
		$(error $(module) is declared as an nginx module, but neither PUBLIC_ROOT_DIR_$(module), nor both PORT_$(module) and HOST_$(module), are set))))
