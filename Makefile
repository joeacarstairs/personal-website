include config.mk

#############
# VARIABLES #
#############

HOSTNAME := $(shell cat /etc/hostname)
HOSTNAMES := pi-broughton blade-canongate
MODULES_pi-broughton := http gemini smtp vaultwarden ln
MODULES_blade-canongate := etherpad
ALL_MODULES := $(sort $(foreach hostname,$(HOSTNAMES),$(MODULES_$(hostname))))
MASTER_NODE := pi-broughton
IS_MASTER_NODE := $(filter $(MASTER_NODE),$(HOSTNAME))
MODULES := $(MODULES_$(HOSTNAME))
SUBDOMAINS := $(foreach module,$(MODULES),$(SUBDOMAIN_$(module)))
COMPOSE_SERVICES := $(shell podman-compose config \
	| yq ".services | keys" --output-format csv --csv-separator " ")
MAKE_MODULES := $(foreach module,$(MODULES),\
	$(shell [ -f $(module)/Makefile ] && echo $(module)))


#############
# FUNCTIONS #
#############

install_submake_file = $(shell [ -f "$(module)/install.mk" ] && echo "$(module)/install.mk")

define make_module_rule =
.PHONY: make_$(module)
make_$(module): $(module)/.env
	$(MAKE) --directory=$(module)
endef

define module_env_rule =
$(module)/.env: .env
	cp .env $(module)/.env
endef

define install_module_rule =
.PHONY: install_$(module)
install_$(module): install_openrc_$(module) install_nginx_module_$(module) install_dyndns_module_$(module) $(install_submake_file)
	$(if $(install_submake_file),$(MAKE) --makefile=$(notdir $(install_submake_file)) --directory=$(dir $(install_submake_file)) install)
endef

define reinstall_module_rule =
.PHONY: reinstall_$(module)
reinstall_$(module): reinstall_openrc_$(module) reinstall_nginx_module_$(module) reinstall_dyndns_module_$(module) $(install_submake_file)
	$(if $(install_submake_file),$(MAKE) --makefile=$(notdir $(install_submake_file)) --directory=$(dir $(install_submake_file)) reinstall)
endef

define uninstall_module_rule =
.PHONY: uninstall_$(module)
uninstall_$(module): uninstall_openrc_$(module) uninstall_nginx_$(module) uninstall_dyndns_module_$(module)
	$(if $(install_submake_file),\
		$(MAKE) --makefile=$(notdir (install_submake_file)) --directory $(dir $(install_submake_file)) uninstall
	)
endef


#########
# RULES #
#########

.SILENT: usage
.PHONY: usage
usage:
	echo "usage:"
	echo "	make install"
	$(foreach module,$(MODULES),echo "	make install_$(module)")
	echo "	make reinstall"
	$(foreach module,$(MODULES),echo "	make reinstall_$(module)")
	echo "	make uninstall"
	$(foreach module,$(MODULES),echo "	make uninstall_$(module)")

$(foreach module,$(MAKE_MODULES),$(eval $(call make_module_rule)))
$(foreach module,$(MODULES),$(eval $(call module_env_rule)))

.PHONY: install
install: $(foreach module,$(MODULES),install_$(module)) install_crontab

.PHONY: uninstall
uninstall: uninstall_nginx uninstall_dyndns uninstall_joeac.net_service $(foreach module,$(MODULES),uninstall_$(module)) uninstall_crontab

.PHONY: uninstall_joeac.net_service
	rm ~/.config/rc/joeac.net

$(foreach module,$(MODULES),$(eval $(install_module_rule)))
$(foreach module,$(MODULES),$(eval $(reinstall_module_rule)))
$(foreach module,$(MODULES),$(eval $(uninstall_module_rule)))

include container.mk
include openrc.mk
include nginx.mk
include crontab.mk
include dyndns.mk

.PHONY: clean
clean:
	$(foreach module,$(MAKE_MODULES),$(MAKE) --directory=$(module) clean;)
