;
; Main configuration file for the U:Kit Attiny 1634 microcontroller firmware
;
; Copyright (c) 2016-2018, Slavey Karadzhov. All rights reserved.
;
;
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License version 2 and
; only version 2 as published by the Free Software Foundation.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
; 02110-1301, USA.
;
; Author(s): Cviatko Delchev <cviatko@attachix.com>
;            Slavey Karadzhov <slav@attachix.com>

;;**** GLOBAL CONSTANTS ****
/*
.EQU	CONTROLA	=0xAA
.EQU	CONTROLA1	=0x55
*/

;*** Rabotni konstanti ***

.EQU	RX_BUF_len	=100	;dyljina na priemniq bufer
.EQU	EndMessChar	=0x0A	;LF --> kraj na syobstenieto

;---------------


#if DEBUG
.message "AVR-APP: Debug ON."
#endif

#if TEST
.message "AVR-APP: TEST code is ON."
#endif

#ifdef TEST_CONFIG

.message "AVR-APP: Using TEST configuration."

;.EQU	Buzzer_block_s	= 240; period za blokirane na zumera [sec] (max 255)
.EQU	Buzzer_block_s	= 30; period za blokirane na zumera [sec] (max 255)
;.EQU	Buzzer_SMOKE_s	= 240; period za dejstvie na zumera pri dim [sec] (max 255)
.EQU	Buzzer_SMOKE_s	= 30; period za dejstvie na zumera pri dim [sec] (max 255)
;.EQU	Buzzer_PIR_s	= 240; period za dejstvie na zumera pri dvijenie [sec] (max 255)
.EQU	Buzzer_PIR_s	= 30; period za dejstvie na zumera pri dvijenie [sec] (max 255)
;.EQU	Buzzer_pulse_s	= 45; period za dejstvie na zumera v rejim pulse [sec] (max 255)
.EQU	Buzzer_pulse_s	= 15; period za dejstvie na zumera v rejim pulse [sec] (max 255)

;.EQU	LED_BatteryLow_s	= 45; period na premigvane na svetodioda pri nisko nivo na bateriqta [sec] (max 255)
.EQU	LED_BatteryLow_s	= 5; period na premigvane na svetodioda pri nisko nivo na bateriqta [sec] (max 255)

.EQU	T_button_prag1_s	=5	; prag1 za natisnat buton [sec] (max 255)
.EQU	T_button_prag2_s	=15	; prag2 za natisnat buton [sec] (max 255)

;.EQU	Battery_test_period_h	= 12; period za testvane na bateriqta v chasove (max 255)
.EQU	Battery_test_period_h	= 1; period za testvane na bateriqta v chasove (max 255)

.EQU	BatteryLevel_100	= 210	; nivo na bateriqta 8.4V =100% (max 255)
.EQU	BatteryLevel_0		= 160	; nivo na bateriqta 6.4V =0% (max 255)
.EQU	BatteryLevel_Low	= 165	; nivo na bateriqta 6.6V =10% (max 255)

;.EQU	TemperaturePragHigh	= 40	; temperaturen prag za visoka temperatura [oC]
.EQU	TemperaturePragHigh	= 40	; temperaturen prag za visoka temperatura [oC]
;.EQU	Tos_kor	= 19				; temperature sensor offset + kor
.EQU	Tos_kor	= 10				; temperature sensor offset + kor

;.EQU	T_AGGREG_1min_ini		=60		; period za agregaciq PIR and SMOKE events [sec]
.EQU	T_AGGREG_1min_ini		=30		; period za agregaciq PIR and SMOKE events [sec]
;.EQU	T_smoke_agr_min_ini		=5		; period za agregaciq smoke [min]
.EQU	T_smoke_agr_min_ini		=2		; period za agregaciq smoke [min]
;.EQU	T_PIR_agr_min_ini		=180	; period za agregaciq PIR [min]
.EQU	T_PIR_agr_min_ini		=2	; period za agregaciq PIR [min]
;.EQU	T_smoke_OFF_min_prag	=3		; prag [min] za prekratqvane na sledene SMOKE
.EQU	T_smoke_OFF_min_prag	=2		; prag [min] za prekratqvane na sledene SMOKE
;.EQU	T_PIR_OFF_min_prag		=15		; prag [min] za prekratqvane na sledene PIR
.EQU	T_PIR_OFF_min_prag		=2		; prag [min] za prekratqvane na sledene PIR

;.EQU	TimoutESPpowerUp_s	=10	; timout for WiFi module power up [sec] (max 255)
.EQU	TimoutESPpowerUp_s	=10	; timout for WiFi module power up [sec] (max 255)
;.EQU	CoRepeteRequestESP_ini	=3	; count of requestes to ini (powerUp) WiFi module (max 255)
.EQU	CoRepeteRequestESP_ini	=2	; count of requestes to ini (powerUp) WiFi module (max 255)
;.EQU	WaitConfirm_s		=7	; Wait time for confirm byte [sec] (max 255)
.EQU	WaitConfirm_s		=7	; Wait time for confirm byte [sec] (max 255)
;.EQU	CoRepeteRequestConfirm	=3	; count of requestes to confirm from WiFi module (max 255)
.EQU	CoRepeteRequestConfirm	=2	; count of requestes to confirm from WiFi module (max 255)
;.EQU	TimoutChangeModReq_s	=20	; timout for Change Mode Request [sec] (max 255)
.EQU	TimoutChangeModReq_s	=10	; timout for Change Mode Request [sec] (max 255)

#else

.message "AVR-APP: Using production configuration."

.EQU	Buzzer_block_s	= 10; period za blokirane na zumera [sec] (max 255)
.EQU	Buzzer_SMOKE_s	= 240; period za dejstvie na zumera pri dim [sec] (max 255)
.EQU	Buzzer_PIR_s	= 240; period za dejstvie na zumera pri dvijenie [sec] (max 255)
.EQU	Buzzer_pulse_s	= 15; period za dejstvie na zumera v rejim pulse [sec] (max 255)

.EQU	LED_BatteryLow_s	= 45; period na premigvane na svetodioda pri nisko nivo na bateriqta [sec] (max 255)

.EQU	T_button_prag1_s	=5	; prag1 za natisnat buton [sec] (max 255)
.EQU	T_button_prag2_s	=15	; prag2 za natisnat buton [sec] (max 255)

.EQU	Battery_test_period_h	= 12; period za testvane na bateriqta v chasove (max 255)

.EQU	BatteryLevel_100	= 210	; nivo na bateriqta 8.4V =100% (max 255)
.EQU	BatteryLevel_0		= 160	; nivo na bateriqta 6.4V =0% (max 255)
.EQU	BatteryLevel_Low	= 165	; nivo na bateriqta 6.6V =10% (max 255)

;.EQU	TemperaturePragHigh	= 40	; temperaturen prag za visoka temperatura [oC]
.EQU	TemperaturePragHigh	= 40	; temperaturen prag za visoka temperatura [oC]
;.EQU	Tos_kor	= 19				; temperature sensor offset + kor
.EQU	Tos_kor	= 10				; temperature sensor offset + kor

.EQU	T_AGGREG_1min_ini		=60		; period za agregaciq PIR and SMOKE events [sec]
.EQU	T_smoke_agr_min_ini		=5		; period za agregaciq smoke [min]
;.EQU	T_PIR_agr_min_ini		=180	; period za agregaciq PIR [min]
.EQU	T_PIR_agr_min_ini		=1	; period za agregaciq PIR [min]
.EQU	T_smoke_OFF_min_prag	=3		; prag [min] za prekratqvane na sledene SMOKE
.EQU	T_PIR_OFF_min_prag		=15		; prag [min] za prekratqvane na sledene PIR

.EQU	TimoutESPpowerUp_s	=10	; timout for WiFi module power up [sec] (max 255)
.EQU	CoRepeteRequestESP_ini	=3	; count of requestes to ini (powerUp) WiFi module (max 255)
.EQU	WaitConfirm_s		=7	; Wait time for confirm byte [sec] (max 255)
.EQU	CoRepeteRequestConfirm	=3	; count of requestes to confirm from WiFi module (max 255)
.EQU	TimoutChangeModReq_s	=180	; timout for Change Mode Request [sec] (max 255)

#endif

#ifdef ENABLE_OTA

.message "AVR-APP: OTA is enabled."

.EQU    OTAConfirm_s       = 30; Wait time for confirm byte [sec] (max 255)
.EQU    OTAUpdate_d        = 14; timer for OTA updates [day] (max 255)

#endif

;---------------



;*** CODES for messages ***

.EQU	ChangeModeMess		= 0x30	; '0' - CODE for Change Mode Message
.EQU	EventSmoke			= 0x31	; '1' - CODE for Event Smoke Message
.EQU	EventTemperature	= 0x32	; '2' - CODE for Event Temperature Message
.EQU	EventMotion			= 0x33	; '3' - CODE for Event Motion Message
.EQU	EventBatteryLevel	= 0x34	; '4' - CODE for Event Battery Level Message

#ifdef ENABLE_OTA

.EQU    EventOTA = 'o'  ; 'o' - CODE for OTA update

#endif


.EQU	Confirm_byte		= 0x5A	; 'Z' - Confirm byte

.EQU	BegSmokeMessParam1	= 1		; Parameter1 for begining smoke message

;*** CODES for Device modes ***

.EQU	ModeSmoke			= 0x41	; 'A' - CODE Mode SMOKE
.EQU	ModeAlarm			= 0x42	; 'B' - CODE Mode Alarm
.EQU	ModeSmartAlarm		= 0x44	; 'D' - CODE Mode SMOKE

#ifdef ENABLE_OTA

.EQU    ModeOTA             = 0x46  ; 'F' - CODE for Firmware Update.
                                    ;       That code is special as it is not saved as device mode
                                    ;       But used to perform OTA update
#endif

.EQU	ModeSmartProtection	= 0x48	; 'H' - CODE Mode SMOKE
.EQU    ModeCancel          = 'X'   ; 'X' - CODE for keeping the old mode unchanged

;.EQU	Dev_MODE_Default		= 0x41	;  CODE for Default Mode
.EQU	Dev_MODE_Default		= ModeSmoke	;  CODE for Default Mode


;***------


;;**** PORT PINS ATtiny1634 ****
; == PINOUT Schematics ==
; Page 2 from the data sheet contains the location of the pins
;
;                           +-\/-+
;  (PCINT8/TXD0/ADC5) PB0  1|    |20  PB1 (ADC6/DI/SDA/RXD1/PCINT9)
;  (PCINT7/RXD0/ADC4) PA7  2|    |19  PB2 (ADC7/DO/TXD1/PCINT10)
;  (PCINT6/OC1B/ADC3) PA6  3|    |18  PB3 (ADC8/OC1A/PCINT11)
;  (PCINT5/OC0B/ADC2) PA5  4|    |17  PC0 (ADC9/OC0A/XCK0/PCINT12)
;    (PCINT4/T0/ADC1) PA4  5|    |16  PC1 (ADC10/ICP1/SCL/USCK/XCK1/PCINT13)
;(PCINT3/T1/SNS/ADC0) PA3  6|    |15  PC2 (ADC11/CLKO/INT0/PCINT14)
;       (PCINT2/AIN1) PA2  7|    |14  PC3 (RESET/dW/PCINT15)
;       (PCINT1/AIN0) PA1  8|    |13  PC4 (XTAL2/PCINT16)
;       (PCINT0/AREF) PA0  9|    |12  PC5 (XTAL1/CLKI/PCINT17)
;                     GND 10|    |11  VCC
;                           +----+

.SET RxD_from_WF	=PA7	;Input	- from RS232 COM Port /RxD0 - za premane ot WF modul (USART0)/ (Internaly pulled high)
.SET POWER_WF_EN	=PA6	;Output	- power WF module enable  (Active = 1)
;.SET PA_5		 	=PA5	;Input	/ne se izpolzuva/ (Internaly pulled high)
.SET tLED1		 	=PA5	;Output	- testovi LED 1  (Active = 0)
;.SET PA_4 			=PA4	;Input	/ne se izpolzuva/ (Internaly pulled high)
.SET tLED2 			=PA4	;Output	- testovi LED 2  (Active = 0)
.SET BATTERYlevel	=PA3	;Input	- from BATTERY level /ADC0/
.SET PA_2	 		=PA2	;Input	/ne se izpolzuva/ (Internaly pulled high)
.SET SMOKEsensor 	=PA1	;Input	- from SMOKE sensor /PCINT1/ (Internaly pulled high) (Active = 0)
.SET PIRsensor		=PA0	;Input	- from PIR sensor /PCINT0/ (Internaly pulled high) (Active = 1)

.SET LED			=PB3	;Output	- LED  (Active = 0)
.SET TxD_to_PC	 	=PB2	;Input	/ne se izpolzuva/ (Internaly pulled high) [TxD1 - za predavane kym PC (reserve)]
.SET RxD_from_PC 	=PB1	;Input	/ne se izpolzuva/ (Internaly pulled high) [RxD1 - za premane ot PC (reserve)]
.SET TxD_to_WF 		=PB0	;Output	- to RS232 COM Port /TxD0 - za predavane kym WF modul (USART0)/

.SET PC_5 		=PC5	;Input	/ne se izpolzuva/ (Internaly pulled high)
.SET PC_4 		=PC4	;Input	/ne se izpolzuva/ (Internaly pulled high)
.SET PC_3		=PC3	;Input	/ne se izpolzuva/ (Internaly pulled high)
.SET BUTTON	 	=PC2	;Input	- from BUTTON /INT0/ (Internaly pulled high) (Active = 0)
.SET PC_1	 	=PC1	;Input	/ne se izpolzuva/ (Internaly pulled high)
.SET BUZZER	 	=PC0	;Output	- Zumer (Active = 1)

				; ***** init I/O ports

					;ustanowyawane (vklyuchvane) na pull-up resistorite
;.EQU	PUEAini	=0B10010111
;				;PA7-PullUp, PA6-no, PA5-no, PA4-PullUp, PA3-no, PA2-PullUp, PA1-PullUp, PA0-PullUp
.EQU	PUEAini	=0B10000110
				;PA7-PullUp, PA6-no, PA5-no, PA4-no, PA3-no, PA2-PullUp, PA1-PullUp, PA0-no
.EQU	PUEBini	=0B00000110
				;PB3-no, PB2-PullUp, PB1-PullUp, PB0-no
.EQU	PUECini	=0B00111110
				;PC5-PullUp, PC4-PullUp, PC3-PullUp, PC2-PullUp, PC1-PullUp, PC0-no

					;ustanowyawane na whodowete i izhodite
;.EQU	DDRAini	=0B01100000
				;PA7-in, PA6-out, PA5-out, PA4-in, PA3-in, PA2-in, PA1-in, PA0-in
.EQU	DDRAini	=0B01110000
				;PA7-in, PA6-out, PA5-out, PA4-out, PA3-in, PA2-in, PA1-in, PA0-in
.EQU	DDRBini	=0B00001000
				;PB3-out, PB2-in, PB1-in, PB0-in
.EQU	DDRCini	=0B00000001
				;PC5-in, PC4-in, PC3-in, PC2-in, PC1-in, PC0-out

				; **** init USART0

					; Baud Rate Register Value: BAUD0=12  -> 9600 ( U2Xn=1 and 1 MHz takt) (Error 0.2%)
;.EQU	BAUD0_L	= 12	; for UBRR0L register	/ �� ��������� /
.EQU	BAUD0_L	= 12	; for UBRR0L register		/ ������ /
.EQU	BAUD0_H	= 0		; for UBRR0H register

.EQU	UCSR0D_ini	=0B00000000
					; Bit 7	-> 0 - reserve for wake up mode
					; Bit 6	-> 0 - reserve for wake up mode
					; Bit 5	-> 0 - reserve for wake up mode (=0 -> Start frame detector disabled)
					; Bits 4:0	-> 00000 - reserve

.EQU	UCSR0C_ini	=0B00000110
					; Bits 7:6	-> 00 - Asynchronous USART mode
					; Bits 5:4	-> 00 - NO Parity
					; Bit 3		-> 0 - 1-Stop bit
					; Bits 2:1	-> 11 - 8-bit Character Size
					; Bit 0		-> 0 - reserve

.EQU	UCSR0B_ini	=0B00011000
					;; Bit 7		-> 1 - RX Complete Interrupt Enable = ENABLE
					; Bit 7		-> 0 - RX Complete Interrupt Enable = ENABLE
					; Bit 6		-> 0 - TX Complete Interrupt Enable = DISABLE
					; Bit 5		-> 0 - USART Data Register Empty Interrupt Enable = DISABLE
					; Bit 4		-> 1 - Receiver Enable = ENABLE
					; Bit 3		-> 1 - Transmitter Enable = ENABLE
					; Bit 2		-> 0 - reserve for 9-bit frame size
					; Bit 1		-> 0 - reserve for 9-bit frame size
					; Bit 0		-> 0 - reserve for 9-bit frame size

.EQU	UCSR0A_ini	=0B00000010
					; Bits 7:2	-> 000000 - USART Status bits
					; Bit 1		-> 1 - Double the USART Transmision Speed (U2X0 controll bit)
					; Bit 0		-> 0 - Multi-processor Communication Mode = DISABLE






;***** REGISTER VARIABLES *****

;;;;  LOW REGISTERS  ;;;;;;

.DEF	LPM_B	=R0	;Temp. reg. for read from program memory --- /ne se izpolzuva/

;;;; HIGH REGISTERS  ;;;;;;

.DEF	ACCA	=R16
.DEF	ACCB	=R17
.DEF	ACCC	=R18
.DEF	ACCD	=R19

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
.DEF	FLAG	=R20
;-------------------
.SET	BUTTONpressed	=7	;flag - natisnat buton
.SET	F_button_prag1	=6	;flag - zadyrjan buton prag1 (5 sec)
.SET	F_button_prag2	=5	;flag - zadyrjan buton prag2 (15 sec)
.SET	BatteryLow		=4	;flag - nivoto na bateriqta e nisko
.SET	Battery_test	=3	;flag - nastypilo vreme za proverka na bateriqta
.SET	F_AGGREG_req	=2	;flag - nastypilo vreme za obslujvane na agregaciq na sybitiqta SMOKE i PIR (1 min)
.SET	F_RTC_NEW_min 	=1	;flag ot RTC za iztekal period ot 1 min
.SET	F_RTC_NEW_hour	=0	;flag ot RTC za iztekal period ot 1 hour

;;;;;;;;;;;;;;;;;;;;;;;;;;;
.DEF	FLAG2	=R21
;-------------------
.SET	F_Buzzer			=7	;flag - aktiven zumer
.SET	F_Buzzer_pulse		=6	;flag - zumer v rejim impuls
.SET	F_Buzzer_block		=5	;flag - blokiran zumer za opredelen period
.SET	BUZZ_timeout_req	=4	;flag - zaqvka za iztekal period na tajmera na zumera
.SET	BUZZ_pulse_req		=3	;flag - zaqvka za impuls na zumera
.SET	LED_timeout_req		=2	;flag - zaqvka za iztekal period na tajmera na LED
.SET	LED_pulse_req		=1	;flag - zaqvka za impuls na LED
.SET	COMM_timeout_req	=0	;flag - zaqvka za iztekal period na tajmera za COMMUNICATION timeout

;;;;;;;;;;;;;;;;;;;;;;;;;;;
.DEF	StatusSMOKE	=R22	; flagov reg. SMOKE
;-------------------
.SET	SMOKE 				=7	;flag - zadejstvan Smoke detector
.SET	F_SMOKE				=6	;flag - aktiven dimen datchik (v period za nablyudenie)
.SET	F_SMOKE_1min		=5	;flag - zadejstvan dimen datchik prez teku]ata minuta
.SET	F_SMOKE_beg			=4	;flag - nachalno zadejstvane SMOKE d-k
.SET	F_SMOKE_end			=3	;flag - kraj na alarma SMOKE d-k
.SET	F_SMOKE_buzz		=2	;flag - aktiviran zumer ot SMOKE d-k

;;;;;;;;;;;;;;;;;;;;;;;;;;;

.DEF	StatusPIR	=R23	; flagov reg. PIR
;-------------------
.SET	PIR 				=7	;flag - zadejstvan PIR detector
.SET	F_PIR				=6	;flag - aktiven PIR datchik (v period za nablyudenie)
.SET	F_PIR_1min 			=5	;flag - zadejstvan PIR datchik prez teku]ata minuta
.SET	F_PIR_beg			=4	;flag - nachalno zadejstvane PIR d-k
.SET	F_PIR_end			=3	;flag - kraj na alarma PIR d-k
.SET	F_PIR_buzz			=2	;flag - aktiviran zumer ot PIR d-k

;;;;;;;;;;;;;;;;;;;;;;;;;;;

.DEF	StatusMODE	=R24	; flagov reg. MODE
;-------------------
.SET	F_AGGREGATE			=7	;flag - aktiviran rejim na agregaciq
.SET	F_ConfigMod			=4	;flag - aktiviran rejim Config
.SET	F_SmartProtectMod	=3	;flag - aktiviran rejim Smart Protect
.SET	F_SmartAlarmMod		=2	;flag - aktiviran rejim Smart Alarm
.SET	F_AlarmMod			=1	;flag - aktiviran rejim Alarm
.SET	F_SmokeMod			=0	;flag - aktiviran rejim Smoke

;;;;;;;;;;;;;;;;;;;;;;;;;;;

.DEF	FLAG3	=R25	;reserve

#ifdef ENABLE_OTA

.SET    F_OTA         =7  ;flag - Perform regular OTA
.SET    F_SOFT_RESET  =6  ;flag - Perform user requested OTA
; 5 - 0 ; unused

#endif


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.DSEG					; START DATA SEGMENT

.EQU	RAMBASE=0x0100

.ORG RAMBASE

;RX_BUF:	.BYTE	100	;priemen buffer
RX_BUF:	.BYTE	RX_BUF_len	;priemen buffer s dyljina RX_BUF_len bajta

RX_PTR:	.BYTE	2	;recive pointer to RX_BUF
			;0xXX	- RX_PTR (L)
			;0xXX+1	- RX_PTR (H)
TX_PTR:	.BYTE	2	;transmit pointer to RX_BUF
			;0xXX+2	- TX_PTR (L)
			;0xXX+3	- TX_PTR (H)

RX_Count:	.BYTE	1	;broj prieti blokove, predi da bydat izprateni


;-------------------------



			;   Status variables

DEV_MODE:		.BYTE	1	; Device Working Mode


			;   Timer variables

RTC_sec:		.BYTE	1	; sekundi ot nachalen Reset na ustrojstvoto
RTC_min:		.BYTE	1	; minuti ot nachalen Reset na ustrojstvoto
RTC_hour:		.BYTE	1	; chasove ot nachalen Reset na ustrojstvoto
RTC_day:		.BYTE	1	; dni ot nachalen Reset na ustrojstvoto

		; BATTERY status var.
T_Battery_test_h:		.BYTE	1	; timer for battery test [h]
BatteryLevel_V:			.BYTE	1	; temporary battery level ( *4/100 [V] )
BatteryLevel_p:			.BYTE	1	; temporary battery level  [%]

		; Temperature status var.
Temperature_U:			.BYTE	1	; temporary Temperature ( units/4 )
Temperature_oC:			.BYTE	1	; temporary Temperature  [oC]

		; BUZZER status var.
T_Buzzer_s:		.BYTE	1	; timer for buzzer (za blokirovka, za impulsen rejim i dr.) [sec]

		; LED status var.
T_LED_s:		.BYTE	1	; timer for LED (za BatteryLow period i dr.) [sec]

		; BUTTON status var.
T_button_s:		.BYTE	1	; period ot nachalno zadejstvane BUTTON [sec]

		; SMOKE status var.
;T_smoke_ON_sec:		.BYTE	1	; period ot nachalno zadejstvane smoke [sec]
;T_smoke_ON_min:		.BYTE	1	; period ot nachalno zadejstvane smoke [min]

;T_smoke_OFF_sec:	.BYTE	1	; period ot izklyuchvane smoke [sec]
T_smoke_OFF_min:	.BYTE	1	; period ot izklyuchvane smoke [min]

Co_smoke_active:	.BYTE	1	; broj minuti s aktiven datchik v perioda za agregaciq
T_smoke_agr_min:	.BYTE	1	; period za agregaciq smoke [min]

		; PIR status var.
;T_PIR_ON_sec:	.BYTE	1	; period ot nachalno zadejstvane PIR [sec]
;T_PIR_ON_min:	.BYTE	1	; period ot nachalno zadejstvane PIR [min]

;T_PIR_OFF_sec:	.BYTE	1	; period ot izklyuchvane PIR [sec]
T_PIR_OFF_min:	.BYTE	1	; period ot izklyuchvane PIR [min]

Co_PIR_active:	.BYTE	1	; broj minuti s aktiven datchik v perioda za agregaciq
T_PIR_agr_min:	.BYTE	1	; period za agregaciq PIR [min]

		; AGGREGATE status var.
T_AGGREG_1min:		.BYTE	1	; Timer 1 min AGGREGATE [sec] (60)

		; COMMUNICATION status var.
T_COMM_timout_s:		.BYTE	1	; Timout for communication [sec]





;-------------------------


CONTROLS:  	.BYTE 	2	; kontrolni bytowe

;STACK--v
; to 0xDF
