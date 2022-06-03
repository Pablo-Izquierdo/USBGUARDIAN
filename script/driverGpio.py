import RPi.GPIO as gpio
import time
import sys

gpio.setwarnings(False)
gpio.setmode(gpio.BOARD)
gpio.setup(11, gpio.OUT)
gpio.setup(13, gpio.OUT)
gpio.setup(15, gpio.OUT)
gpio.setup(19, gpio.OUT)
gpio.setup(21, gpio.OUT)
gpio.setup(23, gpio.OUT)


##Optencion de parametros de entrada
def main():
	luces = ["green", "yellow", "red", "all"]
	texto = None
	accion = None
	# Comprobación de seguridad, ejecutar sólo si se reciben 2
	# argumentos realemente
	if len(sys.argv) == 3:
		texto = sys.argv[1]
		accion = int(sys.argv[2])
		if not texto in luces:
			print ("ERROR: Introdujo una luz incorrecta")
			print ("SOLUCIÓN: Introduce los argumentos correctamente")
			print ('Ejemplo: driverGpio.py green/yellow/red/all 0/1')
			return -1
	else:
		print ("ERROR: Introdujo uno (1) o más de dos (2) argumentos")
		print ("SOLUCIÓN: Introduce los argumentos correctamente")
		print ('Ejemplo: driverGpio.py green/yellow/red/all 0/1')
		return -1

	if accion == 1:
		encender(texto)
	elif accion == 0:
		apagar(texto)
	else:
		print ("ERROR: Introdujo una accion incorrecta")
		print ("SOLUCIÓN: Introduce los argumentos correctamente")
		print ('Ejemplo: driverGpio.py green/yellow/red/all 0/1')
		return -1

def encender(texto):
	if texto == "green":
		gpio.output(13, True)
		gpio.output(15, True)
	elif texto == "yellow":
		gpio.output(11, True)
		gpio.output(23, True)
	elif texto == "red":
		gpio.output(19, True)
		gpio.output(21, True)
	else:
		gpio.output(13, True)
		gpio.output(15, True)
		gpio.output(11, True)
		gpio.output(23, True)
		gpio.output(19, True)
		gpio.output(21, True)
	return

def apagar(texto):
	if texto == "green":
		gpio.output(13, False)
		gpio.output(15, False)
	elif texto == "yellow":
		gpio.output(11, False)
		gpio.output(23, False)
	elif texto == "red":
		gpio.output(19, False)
		gpio.output(21, False)
	else:
		gpio.output(13, False)
		gpio.output(15, False)
		gpio.output(11, False)
		gpio.output(23, False)
		gpio.output(19, False)
		gpio.output(21, False)
	return

main()
