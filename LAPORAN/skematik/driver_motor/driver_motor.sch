EESchema Schematic File Version 4
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "Driver Motor DC"
Date "2020-07-22"
Rev "0.0.1"
Comp "Anung"
Comment1 "Skripsi "
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Device:R R1
U 1 1 5F178226
P 4650 3900
F 0 "R1" H 4580 3854 50  0000 R CNN
F 1 "220" H 4580 3945 50  0000 R CNN
F 2 "" V 4580 3900 50  0001 C CNN
F 3 "~" H 4650 3900 50  0001 C CNN
	1    4650 3900
	-1   0    0    1   
$EndComp
$Comp
L Isolator:PC817 U1
U 1 1 5F1782C6
P 5050 3550
F 0 "U1" H 5050 3875 50  0000 C CNN
F 1 "PC817" H 5050 3784 50  0000 C CNN
F 2 "Package_DIP:DIP-4_W7.62mm" H 4850 3350 50  0001 L CIN
F 3 "http://www.soselectronic.cz/a_info/resource/d/pc817.pdf" H 5050 3550 50  0001 L CNN
	1    5050 3550
	1    0    0    -1  
$EndComp
$Comp
L power:+12V #PWR03
U 1 1 5F17831D
P 5750 3150
F 0 "#PWR03" H 5750 3000 50  0001 C CNN
F 1 "+12V" H 5765 3323 50  0000 C CNN
F 2 "" H 5750 3150 50  0001 C CNN
F 3 "" H 5750 3150 50  0001 C CNN
	1    5750 3150
	1    0    0    -1  
$EndComp
$Comp
L Device:D D1
U 1 1 5F17834A
P 5750 3600
F 0 "D1" V 5704 3679 50  0000 L CNN
F 1 "1n4002" V 5795 3679 50  0000 L CNN
F 2 "" H 5750 3600 50  0001 C CNN
F 3 "~" H 5750 3600 50  0001 C CNN
	1    5750 3600
	0    1    1    0   
$EndComp
$Comp
L Transistor_FET:IRF3205 Q1
U 1 1 5F1785F7
P 5650 4150
F 0 "Q1" H 5855 4196 50  0000 L CNN
F 1 "IRFZ44" H 5855 4105 50  0000 L CNN
F 2 "Package_TO_SOT_THT:TO-220-3_Vertical" H 5900 4075 50  0001 L CIN
F 3 "http://www.irf.com/product-info/datasheets/data/irf3205.pdf" H 5650 4150 50  0001 L CNN
	1    5650 4150
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR04
U 1 1 5F1786A4
P 5750 4600
F 0 "#PWR04" H 5750 4350 50  0001 C CNN
F 1 "GND" H 5755 4427 50  0000 C CNN
F 2 "" H 5750 4600 50  0001 C CNN
F 3 "" H 5750 4600 50  0001 C CNN
	1    5750 4600
	1    0    0    -1  
$EndComp
$Comp
L Device:R R2
U 1 1 5F17874A
P 5350 3950
F 0 "R2" H 5420 3996 50  0000 L CNN
F 1 "220" H 5420 3905 50  0000 L CNN
F 2 "" V 5280 3950 50  0001 C CNN
F 3 "~" H 5350 3950 50  0001 C CNN
	1    5350 3950
	1    0    0    -1  
$EndComp
$Comp
L Device:R R3
U 1 1 5F1787AA
P 5350 4350
F 0 "R3" H 5420 4396 50  0000 L CNN
F 1 "10k" H 5420 4305 50  0000 L CNN
F 2 "" V 5280 4350 50  0001 C CNN
F 3 "~" H 5350 4350 50  0001 C CNN
	1    5350 4350
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR02
U 1 1 5F1787D4
P 5350 4600
F 0 "#PWR02" H 5350 4350 50  0001 C CNN
F 1 "GND" H 5355 4427 50  0000 C CNN
F 2 "" H 5350 4600 50  0001 C CNN
F 3 "" H 5350 4600 50  0001 C CNN
	1    5350 4600
	1    0    0    -1  
$EndComp
Wire Wire Line
	5350 4600 5350 4500
Wire Wire Line
	5350 4200 5350 4150
Wire Wire Line
	5350 4150 5450 4150
Wire Wire Line
	5350 4100 5350 4150
Connection ~ 5350 4150
Wire Wire Line
	5750 4600 5750 4350
Wire Wire Line
	5350 3650 5350 3800
Wire Wire Line
	5350 3450 5350 3300
Wire Wire Line
	5350 3300 5750 3300
Wire Wire Line
	5750 3300 5750 3150
Wire Wire Line
	5750 3450 5750 3300
Connection ~ 5750 3300
Wire Wire Line
	5750 3750 5750 3850
$Comp
L power:+3.3V #PWR01
U 1 1 5F178B5F
P 4650 3150
F 0 "#PWR01" H 4650 3000 50  0001 C CNN
F 1 "+3.3V" H 4665 3323 50  0000 C CNN
F 2 "" H 4650 3150 50  0001 C CNN
F 3 "" H 4650 3150 50  0001 C CNN
	1    4650 3150
	1    0    0    -1  
$EndComp
Wire Wire Line
	4650 3150 4650 3450
Wire Wire Line
	4650 3450 4750 3450
Wire Wire Line
	4650 3750 4650 3650
Wire Wire Line
	4650 3650 4750 3650
Text GLabel 4500 4400 0    50   Input ~ 0
nodeMCU_GPIO
Wire Wire Line
	4500 4400 4650 4400
Wire Wire Line
	4650 4400 4650 4050
$Comp
L Motor:Motor_DC M1
U 1 1 5F1790CC
P 6300 3550
F 0 "M1" H 6458 3546 50  0000 L CNN
F 1 "Motor_DC" H 6458 3455 50  0000 L CNN
F 2 "" H 6300 3460 50  0001 C CNN
F 3 "~" H 6300 3460 50  0001 C CNN
	1    6300 3550
	1    0    0    -1  
$EndComp
Wire Wire Line
	6300 3350 6300 3300
Wire Wire Line
	6300 3300 5750 3300
Wire Wire Line
	5750 3850 6300 3850
Connection ~ 5750 3850
Wire Wire Line
	5750 3850 5750 3950
$EndSCHEMATC
