==========
 mopidyir
==========

IR-control of a Mopidy server running on a host with IR receiver.

It's made of two simple components:

1. A systemd oneshot unit to configure the infrared cell of the
   running host.

2. A systemd unit to listen to kernel input events and translate them
   to Mopidy commands.

The first components is based on a trivial Bash script. It uses
``ir-keytable`` thus nothing special is required with recent
kernels.

The event translator and consumer is written in Python3 using
``python-evdev`` and ``aiohttp``.

How-to configure and install
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Start by fetching this repository::

  $ git clone https://github.com/orontee/mopidyir.git

Then install dependencies at system level::

  $ sudo apt install -y git ir-keytable python3-evdev python3-aiohttp

About the IR receiver
`````````````````````

Make sure there's a fix path to the IR receiver device: Eg using an udev rule::

  $ echo 'KERNELS=="input[0-9]*", SUBSYSTEMS=="input", ATTRS{name}=="gpio_ir_recv", SYMLINK+="input/ir-recv", ENV{SYSTEMD_WANTS}+="setup-ir.service"' | sudo tee /etc/udev/rules.d/99-gpio_ir_recv.rules
  $ sudo udevadm control --reload
  $ sudo udevadm trigger


About the remote control
````````````````````````

A remote control keymap must be configured for IR scancodes to be
converted to Linux keycode. This keymap depends on the remote control
that will be used.  ⚠️ **There's no automatic way to know what remote
control will be used!**

This configuration must be done in the `setup-ir.sh </setup-ir.sh>`_
script where the ``KEYMAP_PATH`` value is expected to match the path to
a remote control keymap describing the remote control that will be
used.

💡 The default value of ``KEYMAP_PATH`` match the remote control of a
`s.m.s.l A8 <https://www.smsl-audio.com>`_ amplifier.

Mapping keycodes to Mopidy commands
```````````````````````````````````

The file `mopidyir.yaml </mopidyir.yaml>`_ contains:

* The configuration of the Mopidy server (currently, only the URL can
  be configured)

* The path of the IR receiver device to listen events from
  
* The mapping from Linux keycodes to Mopidy actions.

  Actions are identified by names: ``next_track``, ``previous_track``,
  ``scan_forward``, ``scan_backward``, ``pause_or_resume``,
  ``play_favorite_stream``, ``play_random_album``, ``mute_unmute``,
  ``volume_up``, ```volume_down``.

The default configuration and action names should be self explanatory… 

Install
```````

Finally run::

  $ pushd mopidyir
  mopidyir$ sudo make install

and check::

  mopidyir$ sudo systemctl status setup-ir.service

Makefile targets are defined to install single components; See ``make
help`` for details.

Debug
~~~~~

One must first stop the service (if installed)::

  mopidyir$ sudo systemctl stop ir-event-listening

Then simply::

  mopidyir$ sudo ./mopidyir --debug --config mopidyir.yaml

For a list of supported command line arguments and defaults::

  mopidyir$ ./mopidyir --help
