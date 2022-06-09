export PATH=$PATH:/usr/local/sbin/usbguardian/atinout

python driverGpio.py all 0
python driverGpio.py yellow 1
#Crear lista de puertos vulnerables
ListaPuertos=$(ls /dev/ | grep ttyUSB)
Add=$(ls /dev/ | grep ttyACM)
ListaPuertos+=$Add
#echo $ListaPuertos
ROJO=0

#bucle que comprueba cada puerto
for I in $ListaPuertos
do
	echo $I
	MODEM_OUTPUT=`timeout 5s atinout /usr/local/lib/usbguardian/atinout-input.txt $MODEM_DEVICE /usr/local/lib/usb/guardian/atinout-output.txt`
	case $MODEM_OUTPUT
	in
	        *OK*)
#                	echo "Hurray, modem is up and running :)"
        	        ;;
	        *)
			ROJO=$((ROJO + 1))
#                	echo "Oh no! Something is not working :("
        	        ;;
	esac

done

#echo $ROJO
sleep 1
python driverGpio.py yellow 0
if [ $ROJO -eq 0 ]
then
	python driverGpio.py green 1

else
	python driverGpio.py red 1

fi

