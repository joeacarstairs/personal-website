.PHONY: install_nginx
install_nginx: $(NGINX_CONFIG_BACKUP) $(NGINX_CONFIG)

.PHONY: reinstall_nginx
reinstall_nginx: $(NGINX_CONFIG_BACKUP) $(NGINX_CONFIG)

.PHONY: uninstall_nginx
uninstall_nginx: uninstall_dyndns
ifeq ($(shell test -d $(NGINX_CONFIG_BACKUP) && echo 1 || echo 0),0)
	$(warn No nginx backup config detected: doing nothing)
else
	sudo mv $(NGINX_CONFIG_BACKUP) $(NGINX_CONFIG)
	$(RESTART_NGINX)
endif

$(NGINX_CONFIG_BACKUP):
	sudo mv $(NGINX_CONFIG) $(NGINX_CONFIG_BACKUP)

$(NGINX_CONFIG): $(NGINX_CONFIG_SRC) $(NGINX_CONFIG_BACKUP)
	sudo cp $< $@
	$(RESTART_NGINX)

/etc/nginx/http.d/%joeac.net.conf: nginx/http.d/%joeac.net.conf /etc/nginx/http.d $(NGINX_CONFIG)
	sudo cp $< $@
	$(RESTART_NGINX)

/etc/nginx/http.d:
	sudo mkdir -p /etc/nginx/http.d
