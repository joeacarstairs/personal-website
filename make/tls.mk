installed_tls_crontabs = $(wildcard /etc/periodic/daily/tls-*.joeac.net)
installed_tls_crontab_subdomains = $(installed_tls_crontabs:/etc/periodic/daily/tls-%.joeac.net=%)
tls_crontab_subdomains_to_remove = $(filter-out $(SUBDOMAINS),$(installed_tls_crontab_subdomains))
tls_crontabs_to_remove = $(tls_crontab_subdomains_to_remove:%=/etc/periodic/daily/tls-%.joeac.net)

installed_tls_certs = $(wildcard /etc/letsencrypt/live/*.joeac.net)
installed_tls_cert_subdomains = $(installed_tls_certs:/etc/letsencrypt/live/%.joeac.net=%)
tls_cert_subdomains_to_delete = $(filter-out $(SUBDOMAINS),$(installed_tls_cert_subdomains))

tls_crontab = /etc/periodic/daily/tls-$(SUBDOMAIN_$(module)).joeac.net
tls_cert = /etc/letsencrypt/live/$(SUBDOMAIN_$(module)).joeac.net/fullchain.pem

define install_tls_module_rule =
.PHONY: install_tls_$(module)
install_tls_module_$(module): $(if $(SUBDOMAIN_$(module)),$(tls_crontab) $(tls_cert))
endef

define reinstall_tls_module_rule =
.PHONY: reinstall_tls_$(module)
reinstall_tls_$(module): $(if $(SUBDOMAIN_$(module)),$(tls_crontab) renew_$(tls_cert))
endef

define uninstall_tls_module_rule =
.PHONY: uninstall_tls_$(module)
uninstall_tls_$(module): delete_cert_$(SUBDOMAIN_$(module)).joeac.net
	$(if $(SUBDOMAIN_$(module)), \
		sudo rm -f $(tls_crontab)
	)
endef

define obtain_or_renew_cert_cmd =
sudo certbot certonly
	--nginx \
	--cert-name $(SUBDOMAIN_$(module)) \
	--domain $(subst @.,,$(SUBDOMAIN_$(module)).)joeac.net
endef

is_cert_expired = $(shell sudo certbot certificates --cert-name $(SUBDOMAIN_$(module)).joeac.net \
	| grep "Expiry Date" | grep -E "(EXPIRED|REVOKED)")
define cert_rule =
$(tls_cert):
	$(obtain_or_renew_cert_cmd)

.PHONY: renew_$(tls_cert)
renew_$(tls_cert):
	$(if $(is_cert_expired),$(obtain_or_renew_cert_cmd))
endef

$(foreach module,$(ALL_MODULES), $(eval $(install_tls_module_rule)))
$(foreach module,$(ALL_MODULES), $(eval $(reinstall_tls_module_rule)))
$(foreach module,$(ALL_MODULES), $(eval $(uninstall_tls_module_rule)))
$(foreach module,$(ALL_MODULES), $(eval $(cert_rule)))

.PHONY: remove_/etc/periodic/daily/tls-%.joeac.net
remove_/etc/periodic/daily/tls-%.joeac.net:
	rm -f $(@:remove_%=%)

.PHONY: delete_cert_%.joeac.net
delete_cert_%.joeac.net:
	sudo certbot delete --cert-name $(@:delete_cert_%=%)

/etc/periodic/daily/tls-%joeac.net:
	echo "#!/bin/sh" > crontab.tmp
	echo "certbot renew --cert-name $(SUBDOMAIN_$(module)) --non-interactive" >> crontab.tmp
	sudo mv crontab.tmp $@
	sudo chmod +x $@

.PHONY: reinstall_tls
reinstall_tls: $(addprefix remove_,$(tls_crontabs_to_remove)) $(addprefix delete_cert_,$(tls_cert_subdomains_to_delete)) $(foreach subdomain,$(installed_tls_cert_subdomains),renew_$(tls_cert))

.PHONY: uninstall_tls
uninstall_tls: $(foreach module,$(ALL_MODULES),$(uninstall_tls_$(module)))

.PHONY: install_certbot
install_certbot: /usr/bin/certbot /usr/bin/python /usr/lib/$(shell ls /usr/bin | grep python[0-9]\\.)/certbot_nginx

/usr/bin/certbot /usr/bin/python:
	sudo apk add certbot

/usr/lib/python%/certbot_nginx:
	sudo apk add certbot-nginx
