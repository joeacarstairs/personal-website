include make/vars.mk


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
install_$(module): install_openrc_$(module) install_dyndns_$(module) $(install_submake_file)
	$(if $(install_submake_file),$(MAKE) --makefile=$(notdir $(install_submake_file)) --directory=$(dir $(install_submake_file)) install)
endef

define reinstall_module_rule =
.PHONY: reinstall_$(module)
reinstall_$(module): reinstall_openrc_$(module) reinstall_dyndns_$(module) $(install_submake_file)
	$(if $(install_submake_file),$(MAKE) --makefile=$(notdir $(install_submake_file)) --directory=$(dir $(install_submake_file)) reinstall)
endef

define uninstall_module_rule =
.PHONY: uninstall_$(module)
uninstall_$(module): uninstall_openrc_$(module) uninstall_dyndns_$(module)
	$(if $(install_submake_file),\
		$(MAKE) --makefile=$(notdir (install_submake_file)) --directory $(dir $(install_submake_file)) uninstall
	)
endef


#########
# RULES #
#########

.PHONY: all
all: $(ENV_RULES) $(MAKE_RULES) $(BUILD_RULES) $(PUSH_RULES)

$(foreach module,$(MAKE_MODULES),$(eval $(call make_module_rule)))
$(foreach module,$(MODULES),$(eval $(call module_env_rule)))

.PHONY: install
install: install_nginx $(ENV_RULES) $(INSTALL_RULES) install_crontab

.PHONY: reinstall
reinstall: reinstall_nginx $(ENV_RULES) $(REINSTALL_RULES) reinstall_crontab

.PHONY: uninstall
uninstall: uninstall_nginx uninstall_dyndns uninstall_joeac.net_service $(UNINSTALL_RULES) uninstall_crontab

$(foreach module,$(MODULES),$(eval $(install_module_rule)))
$(foreach module,$(MODULES),$(eval $(reinstall_module_rule)))
$(foreach module,$(MODULES),$(eval $(uninstall_module_rule)))

include make/container.mk
include make/openrc.mk
include make/nginx.mk
include make/crontab.mk
include make/dyndns.mk

.PHONY: clean
clean:
	$(foreach module,$(MAKE_MODULES),$(MAKE) --directory=$(module) clean;)
