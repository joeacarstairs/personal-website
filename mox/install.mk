.PHONY: install
install: install_unbound install_mox

.PHONY: install_unbound
install_unbound: /usr/sbin/unbound /etc/resolv.conf /var/lib/unbound/root.key install_unbound_anchor_crontab /etc/unbound/unbound.conf.d/dnssec.conf

/usr/sbin/unbound:
	sudo apk add unbound
	sudo rc-update add unbound default
	sudo rc-service unbound start

/etc/resolv.conf: resolv.conf /etc/resolv.conf.joeac.net-backup
	sudo cp resolv.conf /etc/resolv.conf

/etc/resolv.conf.joeac.net-backup:
	sudo mv /etc/resolv.conf /etc/resolv.conf.joeac.net-backup

/var/lib/unbound/root.key:
	sudo mkdir -p /var/lib/unbound && sudo unbound-anchor -a /var/lib/unbound/root.key

UNBOUND_ANCHOR_CRONTAB_ENTRY := @reboot unbound-anchor -a /var/lib/unbound/root.key # managed by joeac.net
IS_CRONTAB_UP_TO_DATE := $(sudo grep "$(UNBOUND_ANCHOR_CRONTAB_ENTRY)" /etc/crontabs/root)
.PHONY: install_unbound_anchor_crontab
install_unbound_anchor_crontab:
	$(if $(IS_CRONTAB_UP_TO_DATE),,\
		sudo crontab -l > crontab.tmp; \
		sed -i "s/.*unbound-anchor.*# managed by joeac.net//" crontab.tmp; \
		echo "$(UNBOUND_ANCHOR_CRONTAB_ENTRY)" >> crontab.tmp; \
		sudo crontab crontab.tmp; \
		rm crontab.tmp; \
	)

/etc/unbound/unbound.conf.d/dnssec.conf: dnssec.conf
	sudo mkdir -p $(dir $@) && sudo cp $< $@

DKIM_PRIVATE_KEY_A := ~/mox/config/dkim/2026a._domainkey.mail.joeac.net.20260705T163220.rsa2048.privatekey.pkcs8.pem
DKIM_PRIVATE_KEY_B := ~/mox/config/dkim/2026b._domainkey.mail.joeac.net.20260705T163220.rsa2048.privatekey.pkcs8.pem
DKIM_PRIVATE_KEYS := $(DKIM_PRIVATE_KEY_A) $(DKIM_PRIVATE_KEY_B)
.PHONY: install_mox
install_mox: /usr/local/bin/mox ~/mox/config/adminpasswd $(DKIM_PRIVATE_KEYS)

MOX_PLATFORM := $(if $(filter armv7% arm32%,$(CPU_ARCH)),arm,amd64)
MOX_VERSION := 0.0.15
MOX_GO_VERSION := 1.26.4
MOX_CHECKSUM_amd64_v0.0.15_go1.26.4 := 09OE-1QkNVgmpoRj53mtX9gxoEmY
MOX_CHECKSUM_arm_v0.0.15_go1.26.4 := 038X9nQx6hhai60Fk1BhcP3r6Mew
MOX_CHECKSUM := $(MOX_CHECKSUM_$(MOX_PLATFORM)_v$(MOX_VERSION)_go$(MOX_GO_VERSION))
MOX_URL_BASE := https://beta.gobuilds.org/github.com/mjl-/mox
MOX_URL := $(MOX_URL_BASE)@v$(MOX_VERSION)/linux-$(MOX_PLATFORM)-go$(MOX_GO_VERSION)/$(MOX_CHECKSUM)
/usr/local/bin/mox:
	wget -O- $(MOX_URL) | gzip -d > mox
	chmod +x mox
	sudo mv mox /usr/local/bin/mox

~/mox/config/%: config/%
	mkdir -p $(dir $@) && cp $< $@
