.PHONY: install_dyndns
install_dyndns: /usr/local/bin/dyndns.sh ~/.config/dyndns/DIGITALOCEAN_TOKEN

.PHONY: reinstall_dyndns
reinstall_dyndns: /usr/local/bin/dyndns.sh ~/.config/dyndns/DIGITALOCEAN_TOKEN

.PHONY: uninstall_dyndns
uninstall_dyndns:
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

/etc/periodic/daily/dyndns-%joeac.net: /usr/local/bin/dyndns.sh
	echo "#!/bin/sh" > crontab.tmp
	echo "                      /usr/local/bin/dyndns.sh 4 $(*F)joeac.net" >> crontab.tmp
	echo "CONN_DEVICE_NAME=eth0 /usr/local/bin/dyndns.sh 6 $(*F)joeac.net" >> crontab.tmp
	sudo mv crontab.tmp $@
	sudo chmod +x $@
