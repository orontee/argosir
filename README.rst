========
argosir
========

Control a Mopidy server running on a host with IR receiver through a
s.m.s.l A8 remote control.

It's made of two simple components:

1. A systemd oneshot unit to configure the infrared cell of the
   running host for a s.m.s.l A8 remote control

2. A systemd unit to listen to kernel input events and translate them
   to Mopidy commands.

The first components is based on a trivial Bash script. It uses
``ir-keytable`` thus nothing special is required with recent kernels.

The event translator and consumer is written in Python3 using
``python-evdev`` and ``aiohttp``.

Install
~~~~~~~

Make sure there's a fix path to the IR receiver device: Eg using an udev rule::

  $ echo 'KERNELS=="input[0-9]*", SUBSYSTEMS=="input", ATTRS{name}=="gpio_ir_recv", SYMLINK+="input/ir-recv", ENV{SYSTEMD_WANTS}+="setup-ir.service"' | sudo tee /etc/udev/rules.d/99-gpio_ir_recv.rules

Then install dependencies at system level::

  $ sudo apt install -y git ir-keytable python3-evdev python3-aiohttp

Edit the configuration file ``argosir.yaml`` to match the host
configuration and wanted key map.

Finally run::

  $ git clone https://github.com/orontee/argosir.git
  $ pushd argosir
  argosir$ sudo make install
  argosir$ sudo udevadm control --reload
  argosir$ sudo udevadm trigger

and check::

  argosir$ sudo systemctl status setup-ir.service

Targets are defined to install single components; See ``Makefile`` for details.

Debug
~~~~~

One must first stop the service if installed::

  argosir$ sudo systemctl stop ir-event-listening

Then simply::

  argosir$ sudo ./argosir --debug

For a list of supported command line arguments and defaults::

  argosir$ ./argosir --help
