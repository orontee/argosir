help:
	@echo "install	Install keymaps, executables and services"

install: install-keymaps install-executables install-services

install-keymaps:
	mkdir -p /etc/rc_keymaps/
	cp rc_keymaps/* /etc/rc_keymaps/

install-executables: install_mopidyir install_setup-ir.sh

install_mopidyir: mopidyir
	cp mopidyir /usr/local/bin/ && chown root:root /usr/local/bin/mopidyir

install_setup-ir.sh: setup-ir.sh
	cp setup-ir.sh /usr/local/bin/ && chown root:root /usr/local/bin/setup-ir.sh

install-services:
	cp services/*.service /etc/systemd/system/
	cp mopidyir.yaml /etc/
	systemctl daemon-reload
	systemctl enable setup-ir.service
	systemctl enable ir-event-listening.service
	systemctl start setup-ir.service
	systemctl start ir-event-listening.service

