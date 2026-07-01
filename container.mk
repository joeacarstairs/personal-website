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

$(foreach module,$(COMPOSE_SERVICES),$(eval $(call build_module_rule)))
$(foreach module,$(COMPOSE_SERVICES),$(eval $(call push_module_rule)))

.PHONY: login_registry
login_registry:
	podman login $(REGISTRY_DOMAIN)
