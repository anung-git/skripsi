EESchema Schematic File Version 4
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
L Device:R R1
U 1 1 5F17A331
P 6200 2950
F 0 "R1" H 6270 2997 50  0000 L CNN
F 1 "Rb" H 6270 2904 50  0000 L CNN
F 2 "" V 6130 2950 50  0001 C CNN
F 3 "~" H 6200 2950 50  0001 C CNN
	1    6200 2950
	1    0    0    -1  
$EndComp
$Comp
L Device:R R2
U 1 1 5F17A390
P 6200 3500
F 0 "R2" H 6270 3547 50  0000 L CNN
F 1 "Ra" H 6270 3454 50  0000 L CNN
F 2 "" V 6130 3500 50  0001 C CNN
F 3 "~" H 6200 3500 50  0001 C CNN
	1    6200 3500
	1    0    0    -1  
$EndComp
Text GLabel 5850 2750 0    50   Input ~ 0
ECHO_PIN
$Comp
L power:GND #PWR01
U 1 1 5F17A400
P 6200 3800
F 0 "#PWR01" H 6200 3550 50  0001 C CNN
F 1 "GND" H 6205 3623 50  0000 C CNN
F 2 "" H 6200 3800 50  0001 C CNN
F 3 "" H 6200 3800 50  0001 C CNN
	1    6200 3800
	1    0    0    -1  
$EndComp
Text GLabel 6550 3250 2    50   Input ~ 0
NodeMCU_GPIO
Wire Wire Line
	6550 3250 6200 3250
Wire Wire Line
	6200 3250 6200 3100
Wire Wire Line
	6200 3800 6200 3650
Wire Wire Line
	6200 3350 6200 3250
Connection ~ 6200 3250
Wire Wire Line
	5850 2750 6200 2750
Wire Wire Line
	6200 2750 6200 2800
Text Label 5850 3200 0    50   ~ 0
i=5mA
Text Label 6250 3200 0    50   ~ 0
Va
Text Label 6250 2750 0    50   ~ 0
Vb=5V
$EndSCHEMATC
