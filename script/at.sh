
export PATH=$PATH:/home/pi/atinout
MODEM_DEVICE=/dev/$1
echo $MODEM_DEVICE

MODEM_OUTPUT=`timeout 5s atinout ../data/input.txt $MODEM_DEVICE ../data/out.txt`
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
