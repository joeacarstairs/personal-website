is_openrc_module = $(filter $(COMPOSE_SERVICES),$(module))
openrc_module_target = $(if $(is_openrc_module),~/.config/rc/init.d/joeac.net.$(module))

define install_openrc_module_rule =
.PHONY: install_openrc_$(module)
install_openrc_$(module): $(if $(is_openrc_module),$(openrc_module_target) openrc_add_$(module) openrc_start_$(module))

~/.config/rc/init.d/joeac.net.$(module): ~/.config/rc/init.d/joeac.net ~/.config/rc/runlevels/default
	rm -f ~/.config/rc/init.d/joeac.net
	ln -s $(shell realpath ~)/.config/rc/init.d/joeac.net ~/.config/rc/init.d/joeac.net.$(module)
endef

define reinstall_openrc_module_rule =
.PHONY: reinstall_openrc_$(module)
reinstall_openrc_$(module): $(if $(is_openrc_module),$(openrc_module_target) openrc_restart_$(module))
endef

define uninstall_openrc_module_rule =
.PHONY: uninstall_openrc_$(module)
uninstall_openrc_$(module):
	$(if $(is_openrc_module),\
		rc-service -U joeac.net.$(module) stop; \
		rc-update -U del joeac.net.$(module) default; \
		rm -f ~/.config/rc/init.d/joeac.net.$(module); \
	)
endef

define openrc_add_rule =
.PHONY: openrc_add_$(module)
openrc_add_$(module):
	rc-update -U add joeac.net.$(module) default
endef

define openrc_start_rule =
.PHONY: openrc_start_$(module)
openrc_start_$(module):
	rc-service -U joeac.net.$(module) start
endef

define openrc_restart_rule =
.PHONY: openrc_restart_$(module)
openrc_restart_$(module):
	rc-service -U joeac.net.$(module) restart
endef

$(foreach module,$(MODULES),$(eval $(install_openrc_module_rule)))
$(foreach module,$(MODULES),$(eval $(reinstall_openrc_module_rule)))
$(foreach module,$(MODULES),$(eval $(uninstall_openrc_module_rule)))
$(foreach module,$(MODULES),$(eval $(openrc_add_rule)))
$(foreach module,$(MODULES),$(eval $(openrc_start_rule)))
$(foreach module,$(MODULES),$(eval $(openrc_restart_rule)))

~/.config/rc/init.d/joeac.net: openrc/init.d/joeac.net ~/.config/rc/init.d ~/.config/rc/runlevels/default /etc/init.d/user.$(USER) /etc/conf.d/user.$(USER)
	rm -f ~/.config/rc/init.d/joeac.net; \
	mkdir -p ~/.config/rc/init.d; \
	cp openrc/init.d/joeac.net ~/.config/rc/init.d/joeac.net

~/.config/rc/init.d:
	mkdir -p ~/.config/rc/init.d

~/.config/rc/runlevels/default:
	mkdir -p ~/.config/rc/runlevels/default

/etc/init.d/user.$(USER):
	sudo ln -s /etc/init.d/user /etc/init.d/user.$(USER)

/etc/conf.d/user.$(USER): openrc/conf.d/user.$(USER)
	sudo cp openrc/conf.d/user.$(USER) /etc/conf.d/user.$(USER)
	sudo rc-update add user.$(USER) default

.PHONY: uninstall_joeac.net_service
	rm ~/.config/rc/joeac.net
