.PHONY: install
install: /var/ln.joeac.net/public

.PHONY: reinstall
reinstall: install

/var/ln.joeac.net/public: public
	sudo rm -rf /var/ln.joeac.net/public
	sudo mkdir -p /var/ln.joeac.net/
	sudo cp -r public/ /var/ln.joeac.net/public/

.PHONY: uninstall
uninstall:
	sudo rm -rf /var/ln.joeac.net
