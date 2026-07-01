CPU_ARCH := $(if $(shell which arch 2>/dev/null),\
	$(shell arch),\
	$(shell lscpu | grep ^Architecture: | sed "s/^Architecture:[[:space:]]*\([[:alnum:][:punct:]]\+\).*/\1/"))
IMAGE_PREFIX := $(if $(filter armv7%,$(CPU_ARCH)),armv7/)
REGISTRY_DOMAIN := git.joeac.net
REGISTRY_USER := joeac

container_image_name = $(REGISTRY_DOMAIN)/$(REGISTRY_USER)/$(CONTAINER_PREFIX)joeac.net-$(module)

define build_module_rule =
.PHONY: build_$(module)
build_$(module): make_$(module) $(module).Dockerfile
	IMAGE_PREFIX="$(IMAGE_PREFIX)" podman-compose build $(module)
endef

define push_module_rule =
.PHONY: push_$(module)
push_$(module): login_registry build_$(module)
	podman push $(container_image_name)
endef

$(foreach module,$(COMPOSE_SERVICES),$(eval $(call build_module_rule)))
$(foreach module,$(COMPOSE_SERVICES),$(eval $(call push_module_rule)))

.PHONY: login_registry
login_registry:
	podman login $(REGISTRY_DOMAIN)
