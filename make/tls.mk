installed_tls_crontabs = $(wildcard /etc/periodic/daily/tls-*.joeac.net)
installed_tls_crontab_subdomains = $(installed_tls_crontabs:/etc/periodic/daily/tls-%.joeac.net=%)
tls_crontab_subdomains_to_remove = $(filter-out $(SUBDOMAINS),$(installed_tls_crontab_subdomains))
tls_crontabs_to_remove = $(tls_crontab_subdomains_to_remove:%=/etc/periodic/daily/tls-%.joeac.net)

installed_tls_certs = $(wildcard /etc/letsencrypt/live/*.joeac.net)
installed_tls_cert_subdomains = $(installed_tls_certs:/etc/letsencrypt/live/%.joeac.net=%)
tls_cert_subdomains_to_delete = $(filter-out $(SUBDOMAINS),$(installed_tls_cert_subdomains))

tls_crontab = /etc/periodic/daily/tls-$(subdomain).joeac.net
tls_cert = /etc/letsencrypt/live/$(subdomain).joeac.net/fullchain.pem

define install_tls_subdomain_rule =
.PHONY: install_tls_$(subdomain)
install_tls_$(subdomain): $(tls_crontab) $(tls_cert)
endef

define reinstall_tls_subdomain_rule =
.PHONY: reinstall_tls_$(subdomain)
reinstall_tls_$(subdomain): $(tls_crontab) renew_$(tls_cert)
endef

define uninstall_tls_subdomain_rule =
.PHONY: uninstall_tls_$(subdomain)
uninstall_tls_$(subdomain): delete_cert_$(subdomain).joeac.net
	$(if $(shell [ -f $(tls_crontab) ] && echo 1),\
		sudo rm -f $(tls_crontab)
	)
endef

define obtain_or_renew_cert_cmd =
sudo certbot certonly
	--nginx \
	--cert-name $(subdomain) \
	--domain $(subst @.,,$(subdomain).)joeac.net
endef

is_cert_expired = $(shell sudo certbot certificates --cert-name $(subdomain).joeac.net \
	| grep "Expiry Date" | grep -E "(EXPIRED|REVOKED)")
define cert_rule =
$(tls_cert):
	$(obtain_or_renew_cert_cmd)

.PHONY: renew_$(tls_cert)
renew_$(tls_cert):
	$(if $(is_cert_expired),$(obtain_or_renew_cert_cmd))
endef

$(foreach subdomain,$(ALL_SUBDOMAINS), $(eval $(install_tls_subdomain_rule)))
$(foreach subdomain,$(ALL_SUBDOMAINS), $(eval $(reinstall_tls_subdomain_rule)))
$(foreach subdomain,$(ALL_SUBDOMAINS), $(eval $(uninstall_tls_subdomain_rule)))
$(foreach subdomain,$(ALL_SUBDOMAINS), $(eval $(cert_rule)))

.PHONY: remove_/etc/periodic/daily/tls-%.joeac.net
remove_/etc/periodic/daily/tls-%.joeac.net:
	rm -f $(@:remove_%=%)

.PHONY: delete_cert_%
delete_cert_%:
	sudo certbot delete --cert-name $(@:delete_cert_%=%).joeac.net

/etc/periodic/daily/tls-%joeac.net:
	echo "#!/bin/sh" > crontab.tmp
	echo "certbot renew --cert-name $(subdomain) --non-interactive" >> crontab.tmp
	sudo mv crontab.tmp $@
	sudo chmod +x $@

.PHONY: reinstall_tls
reinstall_tls: $(addprefix remove_,$(tls_crontabs_to_remove)) $(addprefix delete_cert_,$(tls_cert_subdomains_to_delete)) $(foreach subdomain,$(installed_tls_cert_subdomains),renew_$(tls_cert))

.PHONY: uninstall_tls
uninstall_tls: $(foreach subdomain,$(ALL_SUBDOMAINS),$(uninstall_tls_$(subdomain)))

.PHONY: install_certbot
install_certbot: /usr/bin/certbot /usr/bin/python /usr/lib/$(shell ls /usr/bin | grep python[0-9]\\.)/certbot_nginx

/usr/bin/certbot /usr/bin/python:
	sudo apk add certbot

/usr/lib/python%/certbot_nginx:
	sudo apk add certbot-nginx
