#!/bin/bash

# 192.168.1.128
hw_server -s tcp::3121 -d -e "set jtag-port-filter 210308A5E9B2"
# 192.168.1.129
hw_server -s tcp::3122 -d -e "set jtag-port-filter 210308A622CC"

# jtag target obtained by
# xsdb
# connect -url tcp:localhost:3121
# jtag targets
# exit
# or opening the target in vivado hardware manager and finding the ID.
