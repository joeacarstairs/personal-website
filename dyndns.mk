define install_dyndns_module_rule =
.PHONY: install_dyndns_module_$(module)
install_dyndns_module_$(module): $(if $(SUBDOMAIN_$(module)),/etc/periodic/daily/dyndns-$(SUBDOMAIN_$(module)).joeac.net install_dyndns)
endef

define reinstall_dyndns_module_rule =
.PHONY: reinstall_dyndns_module_$(module)
reinstall_dyndns_module_$(module): $(if $(SUBDOMAIN_$(module)),/etc/periodic/daily/dyndns-$(SUBDOMAIN_$(module)).joeac.net reinstall_dyndns)
endef

define uninstall_dyndns_module_rule =
.PHONY: uninstall_dyndns_module_$(module)
uninstall_dyndns_module_$(module):
    $(if $(SUBDOMAIN_$(module)), \
      sudo rm -f /etc/periodic/daily/dyndns-$(SUBDOMAIN_$(module)).joeac.net
    )
endef

$(foreach module,$(ALL_MODULES), $(eval $(install_dyndns_module_rule)))
$(foreach module,$(ALL_MODULES), $(eval $(reinstall_dyndns_module_rule)))
$(foreach module,$(ALL_MODULES), $(eval $(uninstall_dyndns_module_rule)))

/etc/periodic/daily/dyndns-%joeac.net: /usr/local/bin/dyndns.sh ~/.config/dyndns/DIGITALOCEAN_TOKEN
	echo "#!/bin/sh" > crontab.tmp
	echo "                      /usr/local/bin/dyndns.sh 4 $(*F)joeac.net" >> crontab.tmp
	echo "CONN_DEVICE_NAME=eth0 /usr/local/bin/dyndns.sh 6 $(*F)joeac.net" >> crontab.tmp
	sudo mv crontab.tmp $@
	sudo chmod +x $@

.PHONY: uninstall_dyndns
uninstall_dyndns: $(foreach module,$(ALL_MODULES),$(uninstall_dyndns_module_rule))
	sudo rm -rf \
		/usr/local/bin/dyndns.sh \
		/usr/local/bin/get_ip_addr.sh \
		/usr/local/lib/digitalocean_dyndns/ \
		~/.config/dyndns \
		~/.cache/dyndns

/usr/local/bin/dyndns.sh: /usr/local/lib/digitalocean_dyndns/dyndns.sh /usr/local/bin/get_ip_addr.sh
	sudo rm -f /usr/local/bin/dyndns.sh
	sudo cp /usr/local/lib/digitalocean_dyndns/dyndns.sh /usr/local/bin/dyndns.sh

/usr/local/bin/get_ip_addr.sh: /usr/local/lib/digitalocean_dyndns/get_ip_addr.sh
	sudo rm -f /usr/local/bin/get_ip_addr.sh
	sudo cp /usr/local/lib/digitalocean_dyndns/get_ip_addr.sh /usr/local/bin/get_ip_addr.sh

/usr/local/lib/digitalocean_dyndns/%:
	cd /usr/local/lib \
		&& sudo git clone https://git.joeac.net/joeac/digitalocean_dyndns.git

~/.config/dyndns/DIGITALOCEAN_TOKEN: DIGITALOCEAN_TOKEN
	mkdir -p ~/.config/dyndns/
	rm -f ~/.config/dyndns/DIGITALOCEAN_TOKEN
	cp DIGITALOCEAN_TOKEN ~/.config/dyndns/DIGITALOCEAN_TOKEN
