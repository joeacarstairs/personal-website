define install_nginx_module_rule =
.PHONY: install_nginx_module_rule
install_nginx_module_rule: $(if $(SUBDOMAIN_$(module)),/etc/nginx/http.d/$(SUBDOMAIN_$(module)).joeac.net.conf)
endef

define reinstall_nginx_module_rule =
.PHONY: reinstall_nginx_module_rule
reinstall_nginx_module_rule: $(if $(SUBDOMAIN_$(module)),/etc/nginx/http.d/$(SUBDOMAIN_$(module)).joeac.net.conf)
endef

define uninstall_nginx_module_rule =
.PHONY: uninstall_nginx_module_rule
uninstall_nginx_module_rule:
	$(if $(SUBDOMAIN_$(module)),rm -f /etc/nginx/http.d/$(SUBDOMAIN_$(module)).joeac.net.conf)
endef

$(foreach module,$(MODULES),$(eval $(install_nginx_module_rule)))

/etc/nginx/http.d/%.joeac.net.conf: nginx/http.d/%.joeac.net.conf /etc/nginx/http.d $(NGINX_CONFIG)
	sudo cp $< $@
	$(RESTART_NGINX)

/etc/nginx/http.d:
	sudo mkdir -p /etc/nginx/http.d
