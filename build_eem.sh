#!/bin/bash

sudo apt install bison flex libssl-dev python2

# check rpi-source
if [ -z "$(which rpi-source)" ]; then
	sudo apt install bc
	sudo wget https://raw.githubusercontent.com/notro/rpi-source/master/rpi-source -O /usr/bin/rpi-source && sudo chmod +x /usr/bin/rpi-source && /usr/bin/rpi-source -q --tag-update
fi

# Unfortunately the rpi-source script only runs for python2 so we need to make sure it runs with python2
sed -i "s+#!/usr/bin/env python+#!/usr/bin/env python2+g" .config

# around 150 Mo
rpi-source --nomake
cd /lib/modules/$(uname -r)/source

# enabling USB EEM module in config
sed -i "s/# CONFIG_USB_ETH_EEM is not set/CONFIG_USB_ETH_EEM=y/" .config

# building module
make  drivers/usb/gadget/function/usb_f_eem.ko
# installing module
sudo mv drivers/usb/gadget/function/usb_f_eem.ko /lib/modules/$(uname -r)/kernel/drivers/usb/gadget/function/
sudo depmod
cd -

