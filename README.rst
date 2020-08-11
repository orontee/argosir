========
argosir
========

Control a Mopidy server through an s.m.s.l A8 remote control.

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

Run::

  sudo make install

Targets are defined to install singles components; See ``Makefile``.

Debug
~~~~~

One must first stop the service if installed::

  sudo systemctl stop ir-event-listening

Then simply::

  poetry shell
  poetry install
  ./argosir --debug

For a list of supported command line arguments and defaults::

  ./argosir --help
