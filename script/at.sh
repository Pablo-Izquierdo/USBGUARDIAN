
export PATH=$PATH:/usr/local/sbin/usbguardian/atinout
MODEM_DEVICE=/dev/$1
echo $MODEM_DEVICE

MODEM_OUTPUT=`timeout 5s atinout /usr/local/lib/usbguardian/atinout-input.txt $MODEM_DEVICE /usr/local/lib/usb/guardian/atinout-output.txt`
#echo $MODEM_OUTPUT
case $MODEM_OUTPUT
in
        *OK*)
                echo "Hurray, modem is up and running :)"
                ;;
        *)
                echo "Oh no! Something is not working :("
                ;;
esac
