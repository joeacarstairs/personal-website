CPU_ARCH := $(if $(shell which arch 2>/dev/null),\
	$(shell arch),\
	$(shell lscpu | grep ^Architecture: | sed "s/^Architecture:[[:space:]]*\([[:alnum:][:punct:]]\+\).*/\1/"))
IMAGE_PREFIX := $(if $(filter armv7%,$(CPU_ARCH)),armv7/)
COMPOSE_CMD := IMAGE_PREFIX="$(IMAGE_PREFIX)" podman-compose
REGISTRY_DOMAIN := git.joeac.net
REGISTRY_USER := joeac

container_image_name = $(shell $(COMPOSE_CMD) config | yq ".services.$(module).image")
is_containerised = $(filter $(COMPOSE_SERVICES),$(module))
has_dockerfile = $(shell test -f $(module).Dockerfile)

define build_module_rule =
.PHONY: build_$(module)
build_$(module): $(if $(is_containerised),make_$(module) $(if $(has_dockerfile),$(module).Dockerfile))
	$(if $(is_containerised),\
		$(COMPOSE_CMD) build $(module))
endef

define push_module_rule =
.PHONY: push_$(module)
push_$(module): $(if $(is_containerised),login_registry)
	$(if $(is_containerised),\
		podman push $(container_image_name))
endef

$(foreach module,$(MODULES),$(eval $(call build_module_rule)))
$(foreach module,$(MODULES),$(eval $(call push_module_rule)))

.PHONY: login_registry
login_registry:
	podman login $(REGISTRY_DOMAIN)
