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
install: install_service install_crontab next_steps

.PHONY: uninstall
uninstall: uninstall_service uninstall_crontab

.PHONY: install_service
install_service: ~/.config/rc/init.d/joeac.net

~/.config/rc/init.d/joeac.net: openrc/joeac.net
	rm -f ~/.config/rc/init.d/joeac.net; \
	mkdir -p ~/.config/rc/init.d; \
	cp openrc/joeac.net ~/.config/rc/init.d/joeac.net \
		&& rc-update -U add joeac.net default \
		&& rc-service -U joeac.net start; \

.PHONY: uninstall_service
uninstall_service:
	rc-service -U joeac.net stop \
		&& rc-update -U del joeac.net default \
		&& rm -f ~/.config/rc/init.d/joeac.net; \

.PHONY: install_crontab
install_crontab: /etc/periodic/daily/joeac.net

.PHONY: uninstall_crontab
uninstall_crontab:
	sudo rm -f /etc/periodic/daily/joeac.net

/etc/periodic/daily/joeac.net:
	echo "@daily $(shell whoami) git -C /usr/local/lib/joeac.net pull && $(MAKE) --directory /usr/local/lib/joeac.net && rc-service joeac.net restart" \
		> crontab.tmp
	sudo mv crontab.tmp /etc/periodic/daily/joeac.net

.PHONY: next_steps
next_steps:
	@echo "Make sure that your user's default runlevel is triggered by OpenRC. If this isn't already happening, edit openrc/user-default-runlevel with your username, copy it to /etc/init.d, and add it to the system's default runlevel with \`rc-service add <SERVICE> default\`."

.PHONY: clean
clean:
	$(foreach module,$(MODULES),$(MAKE) --directory=$(module) clean;)
