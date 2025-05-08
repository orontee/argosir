#!/usr/bin/env bash

KEYMAP_PATH="/etc/rc_keymaps/smsl_a8"
# Must match the remote control to be used, see rc_keymap man page

ir-keytable -c -w "${KEYMAP_PATH}"
