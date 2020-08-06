EESchema Schematic File Version 4
LIBS:sensor_flow-cache
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L power:+3.3V #PWR01
U 1 1 5F178DBF
P 4250 3000
F 0 "#PWR01" H 4250 2850 50  0001 C CNN
F 1 "+3.3V" H 4265 3177 50  0000 C CNN
F 2 "" H 4250 3000 50  0001 C CNN
F 3 "" H 4250 3000 50  0001 C CNN
	1    4250 3000
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR02
U 1 1 5F178DF8
P 4250 3750
F 0 "#PWR02" H 4250 3500 50  0001 C CNN
F 1 "GND" H 4255 3573 50  0000 C CNN
F 2 "" H 4250 3750 50  0001 C CNN
F 3 "" H 4250 3750 50  0001 C CNN
	1    4250 3750
	1    0    0    -1  
$EndComp
Text GLabel 4750 3350 2    50   Input ~ 0
nodeMCU_GPIO
Wire Wire Line
	4750 3350 4650 3350
Wire Wire Line
	4250 3000 4250 3050
Wire Wire Line
	4250 3650 4250 3750
$Comp
L Sensor_Current:A1369xUA-24 U1
U 1 1 5F17920F
P 4250 3350
F 0 "U1" H 4021 3397 50  0000 R CNN
F 1 "Sensor Flow" H 4021 3304 50  0000 R CNN
F 2 "Sensor_Current:Allegro_SIP-3" H 4600 3250 50  0001 L CIN
F 3 "http://www.allegromicro.com/~/media/Files/Datasheets/A1369-Datasheet.ashx?la=en" H 4250 3350 50  0001 C CNN
	1    4250 3350
	1    0    0    -1  
$EndComp
$EndSCHEMATC
