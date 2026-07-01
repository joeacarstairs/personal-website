.PHONY: install_nginx
install_nginx: /etc/nginx/nginx.joeac.net-backup /etc/nginx/nginx.conf

.PHONY: reinstall_nginx
reinstall_nginx: /etc/nginx/nginx.joeac.net-backup /etc/nginx/nginx.conf

.PHONY: uninstall_nginx
uninstall_nginx: uninstall_dyndns
ifeq ($(shell test -d /etc/nginx/nginx.joeac.net-backup && echo 1 || echo 0),0)
	$(warn No nginx backup config detected: doing nothing)
else
	sudo mv /etc/nginx/nginx.joeac.net-backup /etc/nginx/nginx.conf
	sudo rc-service nginx restart
endif

/etc/nginx/nginx.joeac.net-backup:
	sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.joeac.net-backup

/etc/nginx/nginx.conf: nginx/nginx.conf /etc/nginx/nginx.joeac.net-backup
	sudo cp $< $@
	sudo rc-service nginx restart
