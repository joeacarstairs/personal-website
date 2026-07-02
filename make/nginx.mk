define install_nginx_module_rule =
.PHONY: install_nginx_$(module)
install_nginx_$(module): $(if $(SUBDOMAIN_$(module)),/etc/nginx/http.d/$(SUBDOMAIN_$(module)).joeac.net.conf)
endef

define reinstall_nginx_module_rule =
.PHONY: reinstall_nginx_$(module)
reinstall_nginx_$(module): $(if $(SUBDOMAIN_$(module)),/etc/nginx/http.d/$(SUBDOMAIN_$(module)).joeac.net.conf)
endef

define uninstall_nginx_module_rule =
.PHONY: uninstall_nginx_$(module)
uninstall_nginx_$(module):
	(if $(SUBDOMAIN_$(module)),rm -f /etc/nginx/http.d/$(SUBDOMAIN_$(module)).joeac.net.conf)
endef

$(foreach module,$(MODULES),$(eval $(install_nginx_module_rule)))
$(foreach module,$(MODULES),$(eval $(reinstall_nginx_module_rule)))
$(foreach module,$(MODULES),$(eval $(uninstall_nginx_module_rule)))

/etc/nginx/http.d/%.joeac.net.conf: nginx/http.d/%.joeac.net.conf /etc/nginx/http.d /etc/nginx/nginx.conf
	sudo cp $< $@
	sudo rc-service nginx restart

/etc/nginx/http.d:
	sudo mkdir -p /etc/nginx/http.d

.PHONY: install_nginx
install_nginx: /etc/nginx/nginx.conf $(add_prefix install_nginx_,$(NGINX_MODULES))

.PHONY: reinstall_nginx
reinstall_nginx: /etc/nginx/nginx.conf $(add_prefix reinstall_nginx_,$(NGINX_MODULES))

.PHONY: uninstall_nginx
uninstall_nginx: $(foreach module,$(NGINX_MODULES),uninstall_nginx_$(module))
ifeq ($(shell test -d /etc/nginx/nginx.joeac.net-backup && echo 1 || echo 0),0)
	$(warn No nginx backup config detected: doing nothing)
else
	sudo mv /etc/nginx/nginx.joeac.net-backup /etc/nginx/nginx.conf
	sudo rc-service nginx restart
endif

/etc/nginx/nginx.conf: nginx/nginx.conf /etc/nginx/nginx.joeac.net-backup
	sudo cp $< $@
	sudo rc-service nginx restart

/etc/nginx/nginx.joeac.net-backup:
	sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.joeac.net-backup
