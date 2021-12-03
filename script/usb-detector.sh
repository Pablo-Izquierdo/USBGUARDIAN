#!/bin/bash

FICHERO=./usb_default

if [ ! -f $FICHERO ]
then
   echo "El fichero $FICHERO no existe"
   numknown=$(lsusb | wc -l)

        for I in $(seq $numknown)
        do
                usbs=$(lsusb | cut -d":" -f2 | sed -n $I'p')
                usbs1=$(lsusb | cut -d":" -f3 | sed -n $I'p')
                echo $usbs:$usbs1 >> usb_default
        done
else
   #echo "El fichero $FICHERO existe"
   rm ./usb_unknown

   IFS=$'\n'
   my_array=( $(lsusb -v 2>>/tmp/errorgarbage.txt | egrep '([[:alnum:]][[:alnum:]][[:alnum:]][[:alnum:]]:[[:alnum:]][[:alnum:]][[:alnum:]][[:alnum:]]|bInterfaceClass|bInterfaceProtocol)' | egrep -A 2 '([[:alnum:]][[:alnum:]][[:alnum:]][[:alnum:]]:[[:alnum:]][[:alnum:]][[:alnum:]][[:alnum:]])') )
   line=0
   secondextraline=0
   breakinglines=0
   for I in "${my_array[@]}"
   do
        #If the line is -- skip it
        if [ $I != "--" ]; then
                #Check if I need to skip the line
                if [ $breakinglines -eq 0 ]; then
                        #Check if it is a default device and skip lines
                        id=$(echo "${my_array[$line]}" | egrep '([[:alnum:]][[:alnum:]][[:alnum:]][[:alnum:]]:[[:alnum:]][[:alnum:]][[:alnum:]][[:alnum:]])' | cut -d" " -f6)
                        if [[ $(cat ./usb_default | grep $id 2>>/tmp/errorgarbage.txt | wc -l) -eq 0 ]];
                        then
                                #Check if the line has device ID
                                if [ $(echo "${my_array[$line]}" | egrep '([[:alnum:]][[:alnum:]][[:alnum:]][[:alnum:]]:[[:alnum:]][[:alnum:]][[:alnum:]][[:alnum:]])') ];
                                then
                                        #echo "SI TIENE XXXX:XXXX"
                                        usbs=$(echo "${my_array[$line]}" | cut -d":" -f2)
                                        usb1=$(echo "${my_array[$line]}" | cut -d":" -f3)
                                        usb1=${usb1//-/ }
                                        usbs="${usbs/ /}"
                                        usbs=$(echo $usbs:$usb1)

                                else
                                        #Take the second word of attributes of the device
                                        if [ $secondextraline -eq 1 ];
                                        then

                                                usb1=$(echo "${my_array[$line]}"| tr -s " " | cut -d" " -f4)
                                                usb1=${usb1//-/ }
                                                usbs=$(echo $usb1-$usbs)
                                                echo $usbs >> usb_unknown
                                                secondextraline=0
                                        else

                                                #Take the word of attributes of the device
                                                usb1=$(echo "${my_array[$line]}"| tr -s " " | cut -d" " -f4)
                                                usb1=${usb1//-/ }
                                                usb2=$(echo "${my_array[$line]}"| tr -s " " | cut -d" " -f5)
                                                usb2=${usb2//-/ }
                                                usb1=$(echo $usb1 $usb2)
                                                usbs=$(echo $usb1-$usbs)
                                                secondextraline=1
                                        fi
                                fi
                        else
                                breakinglines=2
                        fi
                else
                        breakinglines=$((breakinglines-1))
                fi
        fi

        line=$(($line+1))
   done

fi

##DETECT DIFFERENT DEVICES

Keyboard="$(cat usb_unknown 2>/dev/null | egrep '(-Keyboard|Keyboard-)' | wc -l)"
Mouse="$(cat usb_unknown 2>/dev/null | egrep '(-Mouse|Mouse-)' | wc -l)"
Storage="$(cat usb_unknown 2>/dev/null | egrep '(-Storage|Storage-)' | wc -l)"
Audio="$(cat usb_unknown 2>/dev/null | egrep '(-Audio|Audio-)' | wc -l)"
Hub="$(cat usb_unknown 2>/dev/null | egrep '(-Hub|Hub-)' | wc -l)"

#echo $Keyboard $Mouse $Storage $Audio $Hub

echo "" >>/dev/tty1
echo "" >>/dev/tty1

if [ ! "$Keyboard" -eq 0 ];
then
        echo "Keyboard TRUE,  Keyboard = $Keyboard" >>/dev/tty1
else
        echo "Keyboard false" >>/dev/tty1

fi



if [ ! "$Mouse" -eq 0 ];
then
        echo "Mouse TRUE,  Mouse = $Mouse" >>/dev/tty1
else
        echo "Mouse false" >>/dev/tty1

fi



if [ ! "$Storage" -eq 0 ];
then
        echo "Storage TRUE,  Storage = $Storage" >> /dev/tty1
else
        echo "Storage false" >>/dev/tty1

fi


if [ ! "$Audio" -eq 0 ];
then
        echo "Audio TRUE,  Audio = $Audio" >> /dev/tty1
else
        echo "Audio false" >>/dev/tty1

fi


if [ ! "$Hub" -eq 0 ];
then
        echo "Hub TRUE,  Hub = $Hub" >> /dev/tty1
else
        echo "Hub false" >>/dev/tty1

fi

known=$(($Keyboard+$Mouse+$Storage+$Audio+$Hub))
devices="$(cat usb_unknown 2>/dev/null | wc -l)"
unknown=$(($devices-$known))
#echo $devices $known

if [ "$devices" -gt "$known" ];
then
        echo "Others TRUE, Others = $unknown" >>/dev/tty1
else
        echo "Others false" >>/dev/tty1
fi


