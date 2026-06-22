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
	sudo podman-compose build $(module)
endef

define push_module_rule =
.PHONY: push_$(module)
push_$(module): login_registry build_$(module)
	sudo podman push $(container_image_name)
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
	sudo podman login $(REGISTRY_DOMAIN)

.PHONY: clean
clean:
	$(foreach module,$(MODULES),$(MAKE) --directory=$(module) clean;)
