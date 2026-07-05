installed_dyndns_crontabs = $(wildcard /etc/periodic/daily/dyndns-*.joeac.net)
installed_dyndns_subdomains = $(installed_dyndns_crontabs:/etc/periodic/daily/dyndns-%.joeac.net=%)
dyndns_subdomains_to_remove = $(filter-out $(SUBDOMAINS),$(installed_dyndns_subdomains))
dyndns_crontabs_to_remove = $(dyndns_subdomains_to_remove:%=/etc/periodic/daily/dyndns-%.joeac.net)

define install_dyndns_module_rule =
.PHONY: install_dyndns_$(module)
install_dyndns_module_$(module): $(if $(SUBDOMAIN_$(module)),/etc/periodic/daily/dyndns-$(SUBDOMAIN_$(module)).joeac.net)
endef

define reinstall_dyndns_module_rule =
.PHONY: reinstall_dyndns_$(module)
reinstall_dyndns_$(module): $(if $(SUBDOMAIN_$(module)),/etc/periodic/daily/dyndns-$(SUBDOMAIN_$(module)).joeac.net reinstall_dyndns)
endef

define uninstall_dyndns_module_rule =
.PHONY: uninstall_dyndns_$(module)
uninstall_dyndns_$(module):
	$(if $(SUBDOMAIN_$(module)), \
		sudo rm -f /etc/periodic/daily/dyndns-$(SUBDOMAIN_$(module)).joeac.net
	)
endef

$(foreach module,$(ALL_MODULES), $(eval $(install_dyndns_module_rule)))
$(foreach module,$(ALL_MODULES), $(eval $(reinstall_dyndns_module_rule)))
$(foreach module,$(ALL_MODULES), $(eval $(uninstall_dyndns_module_rule)))

.PHONY: remove_/etc/periodic/daily/dyndns-%.joeac.net
remove_/etc/periodic/daily/dyndns-%.joeac.net:
	rm -f $(@:remove_%=%)

/etc/periodic/daily/dyndns-%joeac.net: ~/digitalocean_dyndns/dyndns.sh ~/.config/dyndns/DIGITALOCEAN_TOKEN
	echo "#!/bin/sh" > crontab.tmp
	echo "                      $(shell realpath ~)/digitalocean_dyndns/dyndns.sh 4 $(*F)joeac.net" >> crontab.tmp
	echo "CONN_DEVICE_NAME=eth0 $(shell realpath ~)/digitalocean_dyndns/dyndns.sh 6 $(*F)joeac.net" >> crontab.tmp
	sudo mv crontab.tmp $@
	sudo chmod +x $@

.PHONY: reinstall_dyndns
reinstall_dyndns: $(addprefix remove_,$(dyndns_crontabs_to_remove))

.PHONY: uninstall_dyndns
uninstall_dyndns: $(foreach module,$(ALL_MODULES),$(uninstall_dyndns_$(module)))
	sudo rm -rf \
		~/digitalocean_dyndns/ \
		~/.config/dyndns \
		~/.cache/dyndns

~/digitalocean_dyndns/%:
	git clone https://git.joeac.net/joeac/digitalocean_dyndns.git ~/digitalocean_dyndns

~/.config/dyndns/DIGITALOCEAN_TOKEN: DIGITALOCEAN_TOKEN
	mkdir -p ~/.config/dyndns/
	rm -f ~/.config/dyndns/DIGITALOCEAN_TOKEN
	cp DIGITALOCEAN_TOKEN ~/.config/dyndns/DIGITALOCEAN_TOKEN
