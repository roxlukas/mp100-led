#!/bin/sh
# Instalacja mp100-led. Uruchom: sudo ./install.sh [--enable]
set -e
cd "$(dirname "$0")"
[ "$(id -u)" -eq 0 ] || { echo "Uruchom przez sudo"; exit 1; }

python3 -c "import serial" 2>/dev/null || apt-get install -y python3-serial

install -m 0755 mp100-led /usr/local/bin/mp100-led
install -m 0644 99-mp100-led.rules /etc/udev/rules.d/99-mp100-led.rules
install -m 0644 mp100-led.service /etc/systemd/system/mp100-led.service
[ -e /etc/mp100-led.conf ] || install -m 0644 mp100-led.conf /etc/mp100-led.conf

udevadm control --reload-rules
udevadm trigger --action=add --subsystem-match=tty --property-match=ID_VENDOR_ID=1a86
udevadm settle
systemctl daemon-reload

if [ "$1" = "--enable" ]; then
    systemctl enable --now mp100-led.service
    echo "Usługa mp100-led uruchomiona."
else
    echo "Zainstalowano. Usługę włączysz: sudo systemctl enable --now mp100-led"
fi
ls -l /dev/mp100-led /dev/ttyUSB* 2>/dev/null || true
