install: install-keymaps install-executables install-services

install-keymaps:
	cp rc_keymaps/* /etc/rc_keymaps/

install-executables:
	cp argosir /usr/local/bin/ && chown root:root /usr/local/bin/argosir
	cp setup-ir.sh /usr/local/bin/ && chown root:root /usr/local/bin/argosir

install-services:
	cp services/*.service /etc/systemd/system/
	systemctl daemon-reload
	systemctl enable ir-event-listening.service
	systemctl enable setup-ir.service
