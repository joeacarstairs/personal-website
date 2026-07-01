include config.mk

#############
# VARIABLES #
#############

CPU_ARCH := $(if $(shell which arch 2>/dev/null),\
	$(shell arch),\
	$(shell lscpu | grep ^Architecture: | sed "s/^Architecture:[[:space:]]*\([[:alnum:][:punct:]]\+\).*/\1/"))
HOSTNAME := $(shell cat /etc/hostname)
IMAGE_PREFIX := $(if $(filter armv7%,$(CPU_ARCH)),armv7/)
REGISTRY_DOMAIN := git.joeac.net
REGISTRY_USER := joeac
MODULES_pi-broughton := http gemini smtp vaultwarden ln
MODULES_blade-canongate := etherpad
MODULES := $(MODULES_$(HOSTNAME))
COMPOSE_SERVICES := $(shell podman-compose config \
	| yq ".services | keys" --output-format csv --csv-separator " ")
MAKE_MODULES := $(foreach module,$(MODULES),\
	$(shell [ -f $(module)/Makefile ] && echo $(module)))
RESTART_NGINX := sudo rc-service nginx restart


#############
# FUNCTIONS #
#############

container_image_name = $(REGISTRY_DOMAIN)/$(REGISTRY_USER)/joeac.net-$(module)
nginx_module_target = $(if $(SUBDOMAIN_$(module)),/etc/nginx/http.d/$(SUBDOMAIN_$(module)).joeac.net.conf)
dyndns_module_target = $(if $(SUBDOMAIN_$(module)),/etc/periodic/daily/dyndns-$(SUBDOMAIN_$(module)).joeac.net)
openrc_module_target = $(if $(filter $(COMPOSE_SERVICES),$(module)),~/.config/rc/init.d/joeac.net.$(module))
install_submake_file = $(shell [ -f "$(module)/install.mk" ] && echo "$(module)/install.mk")

define build_module_rule =
.PHONY: build_$(module)
build_$(module): make_$(module) $(module).Dockerfile
	podman-compose build $(module)
endef

define push_module_rule =
.PHONY: push_$(module)
push_$(module): login_registry build_$(module)
	podman push $(container_image_name)
endef

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
install_$(module): install_openrc_$(module) $(nginx_module_target) $(dyndns_module_target) $(install_submake_file)
	$(if $(install_submake_file),$(MAKE) --makefile=$(install_submake_file) install)
endef

define install_openrc_module_rule =
.PHONY: install_openrc_$(module)
install_openrc_$(module): $(openrc_module_target) openrc_add_$(module) openrc_start_$(module)

~/.config/rc/init.d/joeac.net.$(module): ~/.config/rc/init.d/joeac.net ~/.config/rc/runlevels/default
	ln -s $(shell realpath ~)/.config/rc/init.d/joeac.net ~/.config/rc/init.d/joeac.net.$(module)
endef

define reinstall_module_rule =
.PHONY: reinstall_$(module)
reinstall_$(module): reinstall_openrc_$(module) $(nginx_module_target) $(dyndns_module_target) $(install_submake_file)
	$(if $(install_submake_file),$(MAKE) --makefile=$(install_submake_file) reinstall)
endef

define reinstall_openrc_module_rule =
.PHONY: reinstall_openrc_$(module)
reinstall_openrc_$(module): $(openrc_module_target) openrc_restart_$(module)
endef

define uninstall_module_rule =
.PHONY: uninstall_$(module)
uninstall_$(module):
	$(if $(openrc_module_target),\
		rc-service -U joeac.net.$(module) stop \
		rc-update -U del joeac.net.$(module) default \
		rm ~/.config/rc/init.d/joeac.net.$(module) \
	)
	$(if $(SUBDOMAIN_$(module)),\
		sudo rm -f /etc/nginx/http.d/$(SUBDOMAIN_$(module)).joeac.net.conf; \
		$(RESTART_NGINX); \
		sudo rm -f /etc/periodic/daily/dyndns-$(SUBDOMAIN_$(module)).joeac.net; \
	)
	$(if $(install_submake_file),\
		$(MAKE) --makefile $(install_submake_file) uninstall
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

$(foreach module,$(COMPOSE_SERVICES),$(eval $(call build_module_rule)))
$(foreach module,$(COMPOSE_SERVICES),$(eval $(call push_module_rule)))
$(foreach module,$(MAKE_MODULES),$(eval $(call make_module_rule)))
$(foreach module,$(MODULES),$(eval $(call module_env_rule)))

.PHONY: login_registry
login_registry:
	podman login $(REGISTRY_DOMAIN)

.PHONY: install
install: $(foreach module,$(MODULES),install_$(module)) install_crontab

.PHONY: uninstall
uninstall: uninstall_nginx uninstall_joeac.net_service $(foreach module,$(MODULES),uninstall_$(module)) uninstall_crontab

.PHONY: uninstall_joeac.net_service
	rm ~/.config/rc/joeac.net

nginx_src := $(shell find -L nginx -type f)
nginx_target := $(addprefix /etc/,$(nginx_src))
NGINX_CONFIG_SRC := nginx/nginx.conf
NGINX_CONFIG := /etc/nginx/nginx.conf
NGINX_CONFIG_BACKUP := /etc/nginx/nginx.joeac.net-backup
nginx_config_backup_exists = $(shell test -d $(NGINX_CONFIG_BACKUP) && echo 1 || echo 0)
.PHONY: install_nginx
install_nginx: $(NGINX_CONFIG_BACKUP) $(NGINX_CONFIG) install_dyndns

$(NGINX_CONFIG_BACKUP):
ifeq ($(nginx_config_backup_exists),0)
	sudo mv $(NGINX_CONFIG) $(NGINX_CONFIG_BACKUP)
endif

$(NGINX_CONFIG): $(NGINX_CONFIG_SRC)
	sudo cp $< $@
	$(RESTART_NGINX)

.PHONY: uninstall_nginx
uninstall_nginx: uninstall_dyndns
ifeq ($(nginx_config_backup_exists),0)
	@echo "No nginx backup config detected: doing nothing"
else
	sudo rm -f $(NGINX_CONFIG)
	sudo mv $(NGINX_CONFIG_BACKUP) $(NGINX_CONFIG)
	$(RESTART_NGINX)
endif

$(foreach module,$(MODULES),$(eval $(install_module_rule)))
$(foreach module,$(MODULES),$(eval $(reinstall_module_rule)))
$(foreach module,$(MODULES),$(eval $(uninstall_module_rule)))
$(foreach module,$(MODULES),$(eval $(install_openrc_module_rule)))
$(foreach module,$(MODULES),$(eval $(reinstall_openrc_module_rule)))
$(foreach module,$(MODULES),$(eval $(openrc_add_rule)))
$(foreach module,$(MODULES),$(eval $(openrc_start_rule)))
$(foreach module,$(MODULES),$(eval $(openrc_restart_rule)))

~/.config/rc/init.d/joeac.net: openrc/init.d/joeac.net ~/.config/rc/init.d ~/.config/rc/runlevels/default /etc/init.d/user.$(shell whoami) /etc/conf.d/user.$(shell whoami)
	rm -f ~/.config/rc/init.d/joeac.net; \
	mkdir -p ~/.config/rc/init.d; \
	cp openrc/init.d/joeac.net ~/.config/rc/init.d/joeac.net

~/.config/rc/init.d:
	mkdir -p ~/.config/rc/init.d

~/.config/rc/runlevels/default:
	mkdir -p ~/.config/rc/runlevels/default

/etc/init.d/user.$(shell whoami):
	sudo ln -s /etc/init.d/user /etc/init.d/user.$(shell whoami)

/etc/conf.d/user.$(shell whoami): openrc/conf.d/user.$(shell whoami)
	sudo cp openrc/conf.d/user.$(shell whoami) /etc/conf.d/user.$(shell whoami)
	sudo rc-update add user.$(shell whoami) default

/etc/nginx/http.d/%joeac.net.conf: nginx/http.d/%joeac.net.conf install_nginx /etc/nginx/http.d
	sudo cp $< $@
	$(RESTART_NGINX)

/etc/nginx/http.d:
	sudo mkdir -p /etc/nginx/http.d

include crontab.mk
include dyndns.mk

.PHONY: clean
clean:
	$(foreach module,$(MAKE_MODULES),$(MAKE) --directory=$(module) clean;)
