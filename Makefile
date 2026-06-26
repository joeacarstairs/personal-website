#############
# VARIABLES #
#############

CPU_ARCH := $(shell lscpu | grep ^Architecture: | sed "s/^Architecture:[[:space:]]*\([[:alnum:][:punct:]]\+\).*/\1/")
IMAGE_PREFIX := $(if $(filter armv7%,$(CPU_ARCH)),armv7/)
REGISTRY_DOMAIN := git.joeac.net
REGISTRY_USER := joeac
MODULES := http gemini smtp


#############
# FUNCTIONS #
#############

container_image_name = $(REGISTRY_DOMAIN)/$(REGISTRY_USER)/joeac.net-$(module)

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
install_$(module): ~/.config/rc/init.d/joeac.net ~/.config/rc/init.d/joeac.net.$(module)

~/.config/rc/init.d/joeac.net.$(module): ~/.config/rc/init.d/joeac.net ~/.config/rc/runlevels/default
	ln -s $(shell realpath ~/.config/rc/init.d/joeac.net) ~/.config/rc/init.d/joeac.net.$(module)
	rc-update -U add joeac.net.$(module) default
	rc-service -U joeac.net.$(module) start
endef

define uninstall_module_rule =
.PHONY: uninstall_$(module)
uninstall_$(module):
	rc-service -U joeac.net.$(module) stop
	rc-update -U del joeac.net.$(module) default
	rm ~/.config/rc/init.d/joeac.net.$(module)
endef


#########
# RULES #
#########

all: $(foreach module,$(MODULES),push_$(module))

$(foreach module,$(MODULES),$(eval $(call build_module_rule)))
$(foreach module,$(MODULES),$(eval $(call push_module_rule)))
$(foreach module,$(MODULES),$(eval $(call make_module_rule)))
$(foreach module,$(MODULES),$(eval $(call module_env_rule)))

.PHONY: login_registry
login_registry:
	podman login $(REGISTRY_DOMAIN)

.PHONY: install
install: install_nginx $(foreach module,$(MODULES),install_$(module)) install_crontab

.PHONY: uninstall
uninstall: uninstall_nginx uninstall_joeac.net_service $(foreach module,$(MODULES),uninstall_$(module)) uninstall_crontab

.PHONY: uninstall_joeac.net_service
	rm ~/.config/rc/joeac.net

nginx_src := $(shell find -L nginx -type f)
nginx_target := $(addprefix /etc/,$(nginx_src))
NGINX_CONFIG := /etc/nginx
NGINX_CONFIG_BACKUP := /etc/nginx.joeac.net-backup
nginx_config_backup_exists = $(shell test -d $(NGINX_CONFIG_BACKUP) && echo 1 || echo 0)
.PHONY: install_nginx
install_nginx: $(NGINX_CONFIG_BACKUP) $(nginx_target)
	sudo rc-service nginx restart

$(NGINX_CONFIG_BACKUP): $(NGINX_CONFIG)
ifeq ($(nginx_config_backup_exists),1)
	@echo "tried to back up $(NGINX_CONFIG) to $(NGINX_CONFIG_BACKUP), but $(NGINX_CONFIG_BACKUP) already exists: try \`make uninstall_nginx\` and try again?"
	@exit 1
else
	sudo mv $(NGINX_CONFIG) $(NGINX_CONFIG_BACKUP)
endif

/etc/nginx/%: nginx/%
	sudo mkdir -p $$(dirname $@)
	sudo cp $< $@

.PHONY: uninstall_nginx
uninstall_nginx:
ifeq ($(nginx_config_backup_exists),0)
	@echo "No nginx backup config detected: doing nothing"
	@exit 0
else
	sudo rm -rf $(NGINX_CONFIG)
	sudo mv $(NGINX_CONFIG_BACKUP) $(NGINX_CONFIG)
	sudo rc-service nginx restart
endif

$(foreach module,$(MODULES),$(eval $(install_module_rule)))
$(foreach module,$(MODULES),$(eval $(uninstall_module_rule)))

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

.PHONY: install_crontab
install_crontab: /etc/periodic/daily/joeac.net

.PHONY: uninstall_crontab
uninstall_crontab:
	sudo rm -f /etc/periodic/daily/joeac.net

/etc/periodic/daily/joeac.net:
	echo "@daily $(shell whoami) git -C /usr/local/lib/joeac.net pull && $(MAKE) --directory /usr/local/lib/joeac.net && rc-service joeac.net restart" \
		> crontab.tmp
	sudo mv crontab.tmp /etc/periodic/daily/joeac.net

.PHONY: clean
clean:
	$(foreach module,$(MODULES),$(MAKE) --directory=$(module) clean;)
