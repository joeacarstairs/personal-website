.PHONY: install_crontab
install_crontab: /etc/periodic/daily/joeac.net

.PHONY: reinstall_crontab
reinstall_crontab: /etc/periodic/daily/joeac.net

.PHONY: uninstall_crontab
uninstall_crontab:
	sudo rm -f /etc/periodic/daily/joeac.net

/etc/periodic/daily/joeac.net:
	echo "#!/bin/sh" > crontab.tmp
	echo "git -C /usr/local/lib/joeac.net pull && $(MAKE) --directory /usr/local/lib/joeac.net && rc-service joeac.net restart" \
		>> crontab.tmp
	sudo mv crontab.tmp /etc/periodic/daily/joeac.net
	sudo chmod +x /etc/periodic/daily/joeac.net

