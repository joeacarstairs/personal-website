.PHONY: install_crontab
install_crontab: /etc/periodic/daily/joeac.net

.PHONY: reinstall_crontab
reinstall_crontab: /etc/periodic/daily/joeac.net

.PHONY: uninstall_crontab
uninstall_crontab:
	sudo rm -f /etc/periodic/daily/joeac.net

/etc/periodic/daily/joeac.net: update.sh
	sudo cp update.sh /etc/periodic/daily/joeac.net
	sudo chmod +x /etc/periodic/daily/joeac.net
