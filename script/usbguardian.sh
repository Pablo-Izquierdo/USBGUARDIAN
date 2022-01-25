#!/bin/bash
#Installer that generate udev rules
echo 'SUBSYSTEMS=="usb", DRIVERS=="usbhid", ACTION=="add", ATTR{authorized}="0"' >> /etc/udev/rules.d/81-disable-usb-devices.rules
echo 'SUBSYSTEM=="usb", ACTION=="add", ENV{DEVTYPE}=="usb_device", RUN+="/usr/local/sbin/usb-detector.sh"' >> /etc/udev/rules.d/80-execute-script.rules
echo 'SUBSYSTEM=="usb", ACTION=="remove", ENV{DEVTYPE}=="usb_device", RUN+="/usr/local/sbin/usb-detector.sh"' >> /etc/udev/rules.d/80-execute-script.rules

