;
; Main firmware for the U:Kit Attiny 1634 microcontroller
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
;
; Contributor(s): See https://github.com/attachix/ukit-attiny-firmware/graphs/contributors


;**** A P P L I C A T I O N   N O T E   Smart Smoke Detector - Slavi ************************
;*
;* TITLE		: SSD_01.asm PROGRAM for Master microcontroller ATtiny1634 на платка CC-SSD-01
;* VERSION		: V1.0
;* FIRST    	: 03.03.2016
;* LAST UPDATED	: 10.05.2016
;*
;* TARGET		: ATtiny1634  AVR DEVICE
;*
;* FILE: main.asm
;*


;--------------


.NOLIST
;.INCLUDE "tn1634def.inc"
.LIST

.INCLUDE "settings.h.asm"

;.LISTMAC

.CSEG

; == Initial Memory Organization ==
; The process can suspend its normal execution and jump to special addresses in the memory which point to programs that
; we will call interrupt handlers.
; For every interrupt there is a handler.
; The RESET handler at address 0x0000 is the one that is called when the processor starts or is reset
; The INT0_ISR is for external interrupt 0. In our case this is used from the button
; In AVR assmebler these addresses and the respective handlers are defined below.
;  For example the reset handler is defined in
;  .org 0x0000
;        jmp RESET
;
; and if such an interrupt occurs the processor starts executing the instructions in subfunction/label with the name RESET


.org 0x0000 ;Set address of next statement

;**** INTERRUPT VECTORS ****

	jmp RESET ; Address 0x0000 -> External Pin, Power-on Reset, Brown-out Reset, Watchdog Reset
	jmp INT0_ISR ; Address 0x0002 -> External Interrupt Request 0 -- (polzva se za butona)
	jmp PCINT0_ISR ; Address 0x0004 -> Pin Change Interrupt Request 0 -- (used for PIR and SMOKE detectors)
	jmp PCINT1_ISR ; Address 0x0006 -> Pin Change Interrupt Request 1 -- (ne se polzva)
	jmp PCINT2_ISR ; Address 0x0008 -> Pin Change Interrupt Request 2 -- (ne se polzva)
	jmp WDT_ISR ; Address 0x000A -> Watchdog Time-out -- (used for RTC)
	jmp TIM1_CAPT_ISR ; Address 0x000C -> Timer/Counter1 Input Capture -- (ne se polzva)
	jmp TIM1_COMPA_ISR ; Address 0x000E -> Timer/Counter1 Compare Match A -- (ne se polzva)
	jmp TIM1_COMPB_ISR ; Address 0x0010 -> Timer/Counter1 Compare Match B -- (ne se polzva)
	jmp TIM1_OVF_ISR ; Address 0x0012 -> Timer/Counter1 Overflow -- (ne se polzva)
	jmp TIM0_COMPA_ISR ; Address 0x0014 -> Timer/Counter0 Compare Match A -- (ne se polzva)
	jmp TIM0_COMPB_ISR ; Address 0x0016 -> Timer/Counter0 Compare Match B -- (ne se polzva)
	jmp TIM0_OVF_ISR ; Address 0x0018 -> Timer/Counter0 Overflow -- (ne se polzva)
	jmp ANA_COMP_ISR ; Address 0x001A -> Analog Comparator -- (ne se polzva)
	jmp ADC_ISR ; Address 0x001C -> ADC Conversion Complete -- (used for battery control)
	jmp USART0_RXS_ISR ; Address 0x001E -> USART0 Rx Start -- (ne se polzva)
	jmp USART0_RXC_ISR ; Address 0x0020 -> USART0 Rx Complete -- (used for byte receive)
	jmp USART0_DRE_ISR ; Address 0x0022 -> USART0 Data Register Empty -- (ne se polzva)
	jmp USART0_TXC_ISR ; Address 0x0024 -> USART0 Tx Complete -- (ne se polzva)
	jmp USART1_RXS_ISR ; Address 0x0026 -> USART1 Rx Start -- (ne se polzva)
	jmp USART1_RXC_ISR ; Address 0x0028 -> USART1 Rx Complete -- (ne se polzva)
	jmp USART1_DRE_ISR ; Address 0x002A -> USART1 Data Register Empty -- (ne se polzva)
	jmp USART1_TXC_ISR ; Address 0x002C -> USART1 Tx Complete -- (ne se polzva)
	jmp USI_START_ISR ; Address 0x002E -> USI START -- (ne se polzva)
	jmp USI_OVF_ISR ; Address 0x0030 -> USI Overflow -- (ne se polzva)
	jmp TWI_ISR ; Address 0x0032 -> Two-Wire Interface -- (ne se polzva)
	jmp EE_RDY_ISR ; Address 0x0034 -> EEPROM Ready -- (ne se polzva)
	jmp QTRIP_ISR ; Address 0x0036 -> QTRIP QTouch -- (ne se polzva)


;************************

;INT0_ISR: ; Address 0x0002 -> External Interrupt Request 0 -- (polzva se za butona)
;PCINT0_ISR: ; Address 0x0004 -> Pin Change Interrupt Request 0 -- (used for PIR and SMOKE detectors)
PCINT1_ISR: ; Address 0x0006 -> Pin Change Interrupt Request 1 -- (ne se polzva)
PCINT2_ISR: ; Address 0x0008 -> Pin Change Interrupt Request 2 -- (ne se polzva)
;WDT_ISR: ; Address 0x000A -> Watchdog Time-out -- (used for RTC)
TIM1_CAPT_ISR: ; Address 0x000C -> Timer/Counter1 Input Capture -- (ne se polzva)
TIM1_COMPA_ISR: ; Address 0x000E -> Timer/Counter1 Compare Match A -- (ne se polzva)
TIM1_COMPB_ISR: ; Address 0x0010 -> Timer/Counter1 Compare Match B -- (ne se polzva)
TIM1_OVF_ISR: ; Address 0x0012 -> Timer/Counter1 Overflow -- (ne se polzva)
TIM0_COMPA_ISR: ; Address 0x0014 -> Timer/Counter0 Compare Match A -- (ne se polzva)
TIM0_COMPB_ISR: ; Address 0x0016 -> Timer/Counter0 Compare Match B -- (ne se polzva)
TIM0_OVF_ISR: ; Address 0x0018 -> Timer/Counter0 Overflow -- (ne se polzva)
ANA_COMP_ISR: ; Address 0x001A -> Analog Comparator -- (ne se polzva)
;ADC_ISR: ; Address 0x001C -> ADC Conversion Complete -- (used for battery control)
USART0_RXS_ISR: ; Address 0x001E -> USART0 Rx Start -- (ne se polzva)
;USART0_RXC_ISR: ; Address 0x0020 -> USART0 Rx Complete -- (used for byte receive)
USART0_DRE_ISR: ; Address 0x0022 -> USART0 Data Register Empty -- (ne se polzva)
USART0_TXC_ISR: ; Address 0x0024 -> USART0 Tx Complete -- (ne se polzva)
USART1_RXS_ISR: ; Address 0x0026 -> USART1 Rx Start -- (ne se polzva)
USART1_RXC_ISR: ; Address 0x0028 -> USART1 Rx Complete -- (ne se polzva)
USART1_DRE_ISR: ; Address 0x002A -> USART1 Data Register Empty -- (ne se polzva)
USART1_TXC_ISR: ; Address 0x002C -> USART1 Tx Complete -- (ne se polzva)
USI_START_ISR: ; Address 0x002E -> USI START -- (ne se polzva)
USI_OVF_ISR: ; Address 0x0030 -> USI Overflow -- (ne se polzva)
TWI_ISR: ; Address 0x0032 -> Two-Wire Interface -- (ne se polzva)
EE_RDY_ISR: ; Address 0x0034 -> EEPROM Ready -- (ne se polzva)
QTRIP_ISR: ; Address 0x0036 -> QTRIP QTouch -- (ne se polzva)

; == Empty Interrupt Handlers ==
; Every interrupt handler must return with RETI.
; Here we have interrupt handlers that do nothing.

	RETI


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
;			INTERRUPT HANDLE ROUTINES
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;****************************** External Int. (PUSHED BUTTON) ****

INT0_ISR: ; Address 0x0002 -> External Interrupt Request 0 -- (polzva se za butona)
	PUSH	ACCA
	IN	ACCA,SREG
	PUSH	ACCA

			; Check BUTTON (Active = 0)
	IN		ACCA,PINC
	SBRS	ACCA,BUTTON				;preskacha, ako nyama natisnat buton
	SBR		FLAG,1<<BUTTONpressed		;set flag che e natisnat butona
	SBRC	ACCA,BUTTON				;preskacha, ako e natisnat buton
	CBR		FLAG,1<<BUTTONpressed		; Clear flag BUTTONpressed (butona e otpusnat)

			; Clear BUTTON timer
	ldi	ACCA,0
	sts	T_button_s,ACCA

	POP	ACCA
	OUT	SREG,ACCA
	POP	ACCA

	RETI

;-----------------------------------------------------

;****************************** External Int. (PIR and SMOKE detectors) ****

PCINT0_ISR: ; Address 0x0004 -> Pin Change Interrupt Request 0 -- (used for PIR and SMOKE detectors)

; This interrupt handler is invoked when there is a change in the state in the row of pins A
; Futher it checks if the interrupt comes from PCINT0(PIR) or PCINT1 (Smoke)

	PUSH	ACCA
	IN	ACCA,SREG
	PUSH	ACCA

			; Check Smoke (Active = 0)
	IN		ACCA,PINA
	SBRS    ACCA,SMOKEsensor         ;preskacha, ako nyama dim
	SBR		StatusSMOKE,1<<SMOKE		;set flag che e zadejstvan Smoke detector
	SBRC    ACCA,SMOKEsensor          ;preskacha, ako ima dim
	CBR		StatusSMOKE,1<<SMOKE		;clear flag che e zadejstvan Smoke detector

	SBRC	StatusSMOKE,F_SMOKE	;preskacha, ako ne e aktiven dimen datchik (ne e v period za nablyudenie)
	rjmp	PCI0_ISR_100	; prehod, ako e aktiven dimen datchik (v period za nablyudenie)

	SBRS	ACCA,SMOKEsensor	;preskacha, ako nyama dim
	SBR		StatusSMOKE,1<<F_SMOKE_beg		;set flag nachalno zadejstvane SMOKE d-k

PCI0_ISR_100:

			; Check MODE
			; Disable pir on mode smoke
	lds	ACCA, DEV_MODE
	cpi	ACCA,ModeSmoke
	breq PCI0_ISR_200

			; Check PIR (Active = 1)

	IN		ACCA,PINA
	SBRC	ACCA,PIRsensor		;preskacha, ako nyama dvijenie
	SBR		StatusPIR,1<<PIR			;set flag che e zadejstvan PIR detector
	SBRS	ACCA,PIRsensor		;preskacha, ako ima dvijenie
	CBR		StatusPIR,1<<PIR			;clear flag che e zadejstvan PIR detector

	SBRC	StatusPIR,F_PIR	;preskacha, ako ne e aktiven PIR datchik (ne e v period za nablyudenie)
	rjmp	PCI0_ISR_200	; prehod, ako e aktiven PIR datchik (v period za nablyudenie)

	SBRC	ACCA,PIRsensor		;preskacha, ako nyama dvijenie
	SBR		StatusPIR,1<<F_PIR_beg			;set flag nachalno zadejstvane PIR d-k

PCI0_ISR_200:

;---------------------- for TEST ----------------------------v
;	rcall tLED2pulse
;---------------------- for TEST ----------------------------^


	POP	ACCA
	OUT	SREG,ACCA
	POP	ACCA

	RETI

;-----------------------------------------------------

;****************************** Watchdog RTC ****

WDT_ISR: ; Address 0x000A -> Watchdog Time-out -- (used for RTC)
	PUSH	ACCA
	IN	ACCA,SREG
	PUSH	ACCA
	PUSH	ACCB
	PUSH	XL
	PUSH	XH

					; --- manage RTC ---
	lds	ACCA,RTC_sec
	inc	ACCA
	sts	RTC_sec,ACCA
	cpi	ACCA,60
	brne	RTC_end
	ldi	ACCA,0
	sts	RTC_sec,ACCA
	SBR	FLAG,1<<F_RTC_NEW_min		;set flag che e iztekla 1 minuta

	lds	ACCA,RTC_min
	inc	ACCA
	sts	RTC_min,ACCA
	cpi	ACCA,60
	brne	RTC_end
	ldi	ACCA,0
	sts	RTC_min,ACCA
	SBR	FLAG,1<<F_RTC_NEW_hour		;set flag che e iztekal 1 chas

	lds	ACCA,RTC_hour
	inc	ACCA
	sts	RTC_hour,ACCA
	cpi	ACCA,24
	brne	RTC_end
	ldi	ACCA,0
	sts	RTC_hour,ACCA

	lds	ACCA,RTC_day
	inc	ACCA
	sts	RTC_day,ACCA
	cpi	ACCA,0
	brne	RTC_end
	ldi	ACCA,255
	sts	RTC_day,ACCA

RTC_end:
					; --- manage Battery Test timer ---

	SBRS	FLAG,F_RTC_NEW_hour		;preskacha, ako e vdignat flaga za nov chas
	rjmp	Battery_end
						; manage timer for battery test
	lds	ACCA,T_Battery_test_h
	inc	ACCA
	sts	T_Battery_test_h,ACCA
	cpi	ACCA,Battery_test_period_h
	brne	Battery_end
	ldi	ACCA,0
	sts	T_Battery_test_h,ACCA
	SBR	FLAG,1<<Battery_test		;set flag che e nastypilo vreme za test na bateriqta

Battery_end:

#ifdef ENABLE_OTA

#if TEST_AUTO_OTA
    lds ACCA,RTC_sec
    cpi ACCA, 30 ; Run OTA automatically after 30 seconds have elapsed
    breq OTA_check_set
#endif

    ;  Check for OTA period -> 1 hour, 1 min and 1 sec and (DAYS % OTAUpdate_d == 0)  .
    lds ACCA,RTC_hour
    cpi ACCA, 1
    brne OTA_check_end

    lds ACCA,RTC_min
    cpi ACCA, 1
    brne OTA_check_end

    lds ACCA,RTC_sec
    cpi ACCA, 1
    brne OTA_check_end

    ;  check if the days are devideable by OTAUpdate_d days
    lds ACCA,RTC_day
    cpi ACCA, OTAUpdate_d ; C - Set if the absolute value of K is larger than the absolute value of Rd; cleared otherwise
    breq OTA_check_set    ; if DAYS == X  -> set the FLAG
    brcs OTA_check_end    ; if DAYS < X  -> get out

OTA_DCheck:
                          ; if DAYS > X -> get the remainder
    subi ACCA, OTAUpdate_d ; Extract the remainder. See: http://math.stackexchange.com/questions/186421/how-to-divide-using-addition-or-subtraction
    cpi ACCA, OTAUpdate_d ; C - Set if the absolute value of K is larger than the absolute value of Rd; cleared otherwise
    breq OTA_check_set
    brcc OTA_DCheck
    rjmp OTA_check_end

OTA_check_set:
    ; if the remainder is 0 then it is time to trigger an update
    SBR FLAG3 ,1<<F_OTA       ;set flag che e nastypilo vreme za OTA

OTA_check_end:

#endif

					; --- manage BUZZER timer ---

	SBRS	FLAG2,F_Buzzer		;preskacha, ako e vdignat flaga za aktiven zumer
	rjmp	BUZZER_end
						; manage timer for BUZZER
	lds	ACCA,T_Buzzer_s
	tst	ACCA
	breq	BUZZER_100
	dec	ACCA
	sts	T_Buzzer_s,ACCA
	brne	BUZZER_100
							; manage timer BUZZER end
	SBR	FLAG2,1<<BUZZ_timeout_req		;set flag che e iztekal perioda za zumera

BUZZER_100:
						; check pulse for BUZZER
	SBRC	FLAG2,F_Buzzer_pulse		;preskacha, ako ne e vdignat flaga za impulsen rejim
	SBR	FLAG2,1<<BUZZ_pulse_req		;set flag zaqvka za impuls na zumera

BUZZER_end:


					; --- manage LED timer ---

						; proverka za rejim CONFIG
	SBRC	StatusMODE,F_ConfigMod		;preskacha, ako ne e v rejim CONFIG
	SBR	FLAG2,1<<LED_pulse_req		;set flag zaqvka za impuls na LED, pri aktiven rejim CONFIG

						; manage timer for LED
	lds	ACCA,T_LED_s
	tst	ACCA
	breq	LED_end
	dec	ACCA
	sts	T_LED_s,ACCA
	brne	LED_end
							; manage timer LED end
	SBR	FLAG2,1<<LED_timeout_req		;set flag che e iztekal perioda za LED pauza
	SBR	FLAG2,1<<LED_pulse_req		;set flag zaqvka za impuls na LED

LED_end:


					; --- manage BUTTON timer ---

	SBRS	FLAG,BUTTONpressed		;preskacha, ako e vdignat flaga za natisnat buton
	rjmp	BUTTON_end
						; manage timer for BUTTON
	lds	ACCA,T_button_s
	inc	ACCA
	sts	T_button_s,ACCA
	cpi	ACCA,T_button_prag1_s
	brne	BUTTON_100
	SBR	FLAG,1<<F_button_prag1		;set flag che e preminat prag1 za zadyrjan buton (5 sekundi)
	rjmp	BUTTON_end
BUTTON_100:
	cpi	ACCA,T_button_prag2_s
	brne	BUTTON_end
	SBR	FLAG,1<<F_button_prag2		;set flag che e preminat prag2 za zadyrjan buton (15 sekundi)

BUTTON_end:


					; --- manage AGGREGATE timer ---

	SBRS	StatusMODE,F_AGGREGATE		;preskacha, ako e vdignat flaga za agregaciq
	rjmp	AGGREGATE_end
						; manage timer for AGGREGATE
	lds	ACCA,T_AGGREG_1min
	tst	ACCA
	breq	AGGREGATE_100
	dec	ACCA
	sts	T_AGGREG_1min,ACCA
	brne	AGGREGATE_100
							; manage timer end
	SBR	FLAG,1<<F_AGGREG_req		;set flag che e iztekal perioda za AGGREGATE (1 min)

AGGREGATE_100:
						; check and manage SMOKE status
	SBRC	StatusSMOKE,SMOKE	;preskacha, ako nqma dim
	SBR		StatusSMOKE,1<<F_SMOKE_1min		;set flag zadejstvan dimen datchik prez teku]ata minuta
						; check and manage PIR status
	SBRC	StatusPIR,PIR	;preskacha, ako nqma dvijenie
	SBR		StatusPIR,1<<F_PIR_1min		;set flag zadejstvan PIR datchik prez teku]ata minuta

AGGREGATE_end:


					; --- manage SMOKE timers ---
					; - NONE --> upravlqvat se ot procedurata za obsluvvane na AGGREGATE

					; --- manage PIR timers ---
					; - NONE --> upravlqvat se ot procedurata za obsluvvane na AGGREGATE


					; --- manage COMMUNICATION timers ---

						; manage timer for COMMUNICATION timeout
	lds	ACCA,T_COMM_timout_s
	tst	ACCA
	breq	COMMtim_end
	dec	ACCA
	sts	T_COMM_timout_s,ACCA
	brne	COMMtim_end
							; manage timer end
	SBR	FLAG2,1<<COMM_timeout_req		;zaqvka za iztekal period na tajmera za COMMUNICATION timeout


COMMtim_end:
				; Manage BUZZER and LED
	RCALL	LED_BUZZ_control		;-v

	CBR		FLAG,1<<F_RTC_NEW_min			;izchistvane na flaga za nova minuta
	CBR		FLAG,1<<F_RTC_NEW_hour			;izchistvane na flaga za nov chas


	POP	XH
	POP	XL
	POP	ACCB
	POP	ACCA
	OUT	SREG,ACCA
	POP	ACCA

	RETI

;-----------------------------------------------------

;****************************** Battery level and Temperature ****

ADC_ISR: ; Address 0x001C -> ADC Conversion Complete -- (used for battery control)
	PUSH	ACCA
	IN	ACCA,SREG
	PUSH	ACCA
	PUSH	ACCB
	PUSH	XL
	PUSH	XH
/*
	SBRC	FLAG,RX_BLOCK		;preskacha, ako nyama priet blok gotov za izprastane
	SBR	FLAG,1<<TX_BLOCK	;set flag che e poluchena zayavka za izprastane na blok
*/
	POP	XH
	POP	XL
	POP	ACCB
	POP	ACCA
	OUT	SREG,ACCA
	POP	ACCA

	RETI

;-----------------------------------------------------

;****************************** Byte receive ****

USART0_RXC_ISR: ; Address 0x0020 -> USART0 Rx Complete -- (used for byte receive)
	PUSH	ACCA
	IN	ACCA,SREG
	PUSH	ACCA
	PUSH	ACCB
	PUSH	XL
	PUSH	XH
/*
	SBRC	FLAG,RX_BLOCK		;preskacha, ako nyama priet blok gotov za izprastane
	SBR	FLAG,1<<TX_BLOCK	;set flag che e poluchena zayavka za izprastane na blok
*/
	POP	XH
	POP	XL
	POP	ACCB
	POP	ACCA
	OUT	SREG,ACCA
	POP	ACCA

	RETI

;-----------------------------------------------------

/*

;****************************** RECIVED CHAR INT (za priemane na byte) ****

RX_INT:

	PUSH	ACCA
	IN	ACCA,SREG
	PUSH	ACCA
	PUSH	ACCB
	PUSH	XL
	PUSH	XH

					; Read recived byte
	IN	ACCB,UDR	; ACCB=UDR


			; Load buffer pointer
	LDS	XL,RX_PTR
	LDS	XH,RX_PTR+1

			; Check for end buffer
	CPI		XL,LOW(RX_PTR)		;
	BRNE	NO_END_BUF
		;--- End RX buffer ----------------------------v
			; Check for end message character
	CPI		ACCB,EndMessChar		; LF
	BREQ	END_MESS_CHAR
	RJMP	END_RX_INT

END_MESS_CHAR:
				; set ponter to begining of data
	LDI		ACCA,LOW(RX_BUF)	;
	STS		RX_PTR,ACCA
	RJMP	END_RX_INT

NO_END_BUF:

STORE_BYTE:

	ST	X+,ACCB		; STORE TO RX_BUF

	STS		RX_PTR,XL	;point to next byte

			; Check for end message character
	CPI		ACCB,EndMessChar		; LF
	BRNE	END_RX_INT
	SBR		FLAG,1<<RX_BLOCK	;set flag che ima priet blok gotov za izprastane
	RJMP	END_MESS_CHAR

END_RX_INT:

	POP	XH
	POP	XL
	POP	ACCB
	POP	ACCA
	OUT	SREG,ACCA
	POP	ACCA

	RETI

*/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;************************************  RESET HANDLE ******************

RESET: ; Main program start

#if 0
				; ***** pause ~200 ms x 15 = 3000 ms = ~ 3 s
	LDI	ACCC,15
	LDI	ACCA,0
	LDI	ACCB,0
PAUSE0:
	DEC	ACCA
	BRNE	PAUSE0
	DEC	ACCB
	BRNE	PAUSE0
	DEC	ACCC
	BRNE	PAUSE0

#endif

				; ***** init STACK POINTER
; == The Stack ==
; is effectively allocated in the general data SRAM, and consequently the Stack size is only limited by the total
; SRAM size and the usage of the SRAM. All user programs must initialize the SP in the Reset routine (before sub-
; routines or interrupts are executed). The Stack Pointer (SP) is read/write accessible in the I/O space.
	LDI	ACCA,LOW(RAMEND)
	OUT	SPL,ACCA
	LDI	ACCA,HIGH(RAMEND)
	OUT	SPH,ACCA

					;izchistwane na wsichki flagowe

#ifdef ENABLE_OTA

    sbrs FLAG3, F_SOFT_RESET   ; Do not clear the flags below during SOFT RESET
    rjmp Init_IO

#endif

	CLR	FLAG
	CLR	FLAG2
	CLR	StatusSMOKE
	CLR	StatusPIR
	CLR	StatusMODE

Init_IO:

				; ***** init I/O ports

; Below starts the General Programmable Input Output (GPIO) pins initialization.
; Excerpt from the data sheet (page 55):

; "Each port pin consists of four register bits: DDxn, PORTxn, PUExn, and PINxn. As shown in “Register Description”
; on page 71, the DDxn bits are accessed at the DDRx I/O address, the PORTxn bits at the PORTx I/O address, the
; PUExn bits at the PUEx I/O address, and the PINxn bits at the PINx I/O address.
; The DDxn bit in the DDRx Register selects the direction of this pin. If DDxn is written logic one, Pxn is configured
; as an output pin. If DDxn is written logic zero, Pxn is configured as an input pin.
; If PORTxn is written logic one when the pin is configured as an output pin, the port pin is driven high (one). If
; PORTxn is written logic zero when the pin is configured as an output pin, the port pin is driven low (zero)."
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



					; pedvaritelno ustanowyawane na izhodite v neaktivno systoqnie
	CBI	PORTA,POWER_WF_EN	; POWER_WF_EN = 0 (Inactive)
	SBI	PORTA,tLED1			; tLED1 = 1 (Inactive)
	SBI	PORTA,tLED2			; tLED2 = 1 (Inactive)

	SBI	PORTB,LED			; LED = 1 (Inactive)

	CBI	PORTC,BUZZER		; BUZZER = 0 (Inactive)

					;wklyuchwane na pull-up resistorite
	LDI	ACCA,PUEAini
	OUT	PUEA,ACCA
	LDI	ACCA,PUEBini
	OUT	PUEB,ACCA
	LDI	ACCA,PUECini
	OUT	PUEC,ACCA

					;ustanowyawane na whodowete i izhodite
	LDI	ACCA,DDRAini
	OUT	DDRA,ACCA
	LDI	ACCA,DDRBini
	OUT	DDRB,ACCA
	LDI	ACCA,DDRCini
	OUT	DDRC,ACCA


;----------- Test LED & BUZZER --------------------------------v


	ldi	ACCC, 2

;---------------


BegTest100:
					; Active LED-s & BUZZER

			; LED on
	CBI	PORTB,LED		; LED = 0 (Active)

	CBI	PORTA,tLED1			; tLED1 = 0 (Active)
	CBI	PORTA,tLED2			; tLED2 = 0 (Active)

	SBI	PORTC,BUZZER		; BUZZER = 1 (Active)

				; Pause ~ 10 ms
	push	ACCC
	ldi	ACCC,1
	rcall	PauseACCCx10ms
	pop		ACCC


					; Deactive LED-s & BUZZER

			; LED off
	SBI	PORTB,LED		; LED = 1 (Inactive)

	SBI	PORTA,tLED1			; tLED1 = 1 (Inactive)
	SBI	PORTA,tLED2			; tLED2 = 1 (Inactive)

	CBI	PORTC,BUZZER		; BUZZER = 0 (Inactive)

				; Pause ~ 1000 ms
	push	ACCC
	ldi	ACCC,100
	rcall	PauseACCCx10ms
	pop		ACCC

	dec	ACCC
	brne	BegTest100
;----------- Test LED & BUZZER --------------------------------^


				; **** init USART0  [ to WiFi module ]
					; Set baud rate
	LDI	ACCB,BAUD0_H
	LDI	ACCA,BAUD0_L
	OUT	UBRR0H,ACCB
	OUT	UBRR0L,ACCA
					; Enable receiver and transmiter
	LDI	ACCA,UCSR0B_ini
	OUT	UCSR0B,ACCA
					; Set frame format
	LDI	ACCA,UCSR0C_ini
	OUT	UCSR0C,ACCA
					; Set Double the USART Transmission Speed
					; /Не е нужно, по подразбиране си е така/
	LDI	ACCA,UCSR0A_ini
	OUT	UCSR0A,ACCA
					; izchistwane na priemniya buffer
	IN	ACCA,UDR0

			; PAUSE
	rcall	PAUSE_new


				; **** init USART1 [ to PC (for debuging) ]
					; Set baud rate
	LDI	ACCB,BAUD0_H
	LDI	ACCA,BAUD0_L
 	STS	UBRR1H,ACCB
	STS	UBRR1L,ACCA
					; Enable receiver and transmiter
	LDI	ACCA,UCSR0B_ini
	STS	UCSR1B,ACCA
					; Set frame format
	LDI	ACCA,UCSR0C_ini
	STS	UCSR1C,ACCA
					; Set Double the USART Transmission Speed
					; /Не е нужно, по подразбиране си е така/
	LDI	ACCA,UCSR0A_ini
	STS	UCSR1A,ACCA
					; izchistwane na priemniya buffer
	LDS	ACCA,UDR1

			; PAUSE
	rcall	PAUSE_new



				; **** init ADC

					; Disable digital function for analog inputs
						; PA3 (ADC0) - battery level analog input
	LDI	ACCA,(1<<ADC0D)
	STS	DIDR0,ACCA
					; Select Reference Voltage for ADC
						; 0b10xxxxxx -> internal 1.1V voltage reference
	LDI	ACCA,0b10000000
	OUT	ADMUX,ACCA
					; Select clock for ADC & Disable ADC
						; 0bxxxxx011 -> CK/8  (1MHz/8 = 125kHz) (takt period = 8 us)
							; init conversion -> 25 takt x 8 us = 200 us
							; normal conversion -> 13 takt x 8 us = 104 us
						; 0b0xxxxxxx -> Disable ADC (for poewer saving)
	LDI	ACCA,0b00000011
	OUT	ADCSRA,ACCA
					; Disable ADC Power (for power saving)
						; 0bxxxxxxx1 -> Disable ADC Power
	LDI	ACCA,0b00000001
	OUT	PRR,ACCA



			; PAUSE
	rcall	PAUSE_new


				; **** init MCUCR register - INT0 Sense and Sleep Mode ------v

.EQU	MCUCR_ini	= 0b00000001
								;bit7 --> reserve
								;bit6 & bit5 --> Sleep Mode
													;>	(=00 -> Idle)
													;	(=01 -> ADC Noise Reduction)
													;	(=10 -> Power-down)
													;	(=11 -> Standby)
								;bit4 --> Sleep Enable
													;	(=1 -> Enable)
													;>	(=0 -> Disable)
								;bit3 & bit2 --> reserve
								;bit1 & bit0 --> Interrupt 0 Sense Control
													;	(=00 -> low level)
													;>	(=01 -> logical change)
													;	(=10 -> falling edge)
													;	(=11 -> rising edge)

	LDI	ACCA,MCUCR_ini
	OUT	MCUCR,ACCA


				; **** init GIMSK register - enable External Interrupts ------v

; == GIMSK – General Interrupt Mask Register ==
; See page 51 from the data sheet for details.

.EQU	GIMSK_ini	= 0b01001000
							;	bit7 --> reserve
							;>	bit6 --> INT0 enable			(=1 -> Enable, =0 -> Disable) - from BUTTON
							;	bit5 --> PCINT2 group enable	(=1 -> Enable, =0 -> Disable)
							;	bit4 --> PCINT1 group enable	(=1 -> Enable, =0 -> Disable)
							;>	bit3 --> PCINT0 group enable	(=1 -> Enable, =0 -> Disable) - from SMOKE & PIR
							;	bit2 & bit1 & bit0 --> reserve

	LDI	ACCA,GIMSK_ini
	OUT	GIMSK,ACCA

				; **** init PCMSKx registers - enable External Interrupts from PCINT I/O pins ------v

.EQU	PCMSK2_ini	= 0b00000000
							;	bit7 & bit6 --> reserve
							;	bit5 --> PCINT17 enable	(=1 -> Enable, =0 -> Disable)
							;	bit4 --> PCINT16 enable	(=1 -> Enable, =0 -> Disable)
							;	bit3 --> PCINT15 enable	(=1 -> Enable, =0 -> Disable)
							;	bit2 --> PCINT14 enable	(=1 -> Enable, =0 -> Disable)
							;	bit1 --> PCINT13 enable	(=1 -> Enable, =0 -> Disable)
							;	bit0 --> PCINT12 enable	(=1 -> Enable, =0 -> Disable)
	LDI	ACCA,PCMSK2_ini
	OUT	PCMSK2,ACCA

.EQU	PCMSK1_ini	= 0b00000000
							;	bit7 & bit6 & bit5 & bit4 --> reserve
							;	bit3 --> PCINT11 enable	(=1 -> Enable, =0 -> Disable)
							;	bit2 --> PCINT10 enable	(=1 -> Enable, =0 -> Disable)
							;	bit1 --> PCINT9 enable	(=1 -> Enable, =0 -> Disable)
							;	bit0 --> PCINT8 enable	(=1 -> Enable, =0 -> Disable)
	LDI	ACCA,PCMSK1_ini
	OUT	PCMSK1,ACCA

.EQU	PCMSK0_ini	= 0b00000011
							;	bit7 --> PCINT7 enable	(=1 -> Enable, =0 -> Disable)
							;	bit6 --> PCINT6 enable	(=1 -> Enable, =0 -> Disable)
							;	bit5 --> PCINT5 enable	(=1 -> Enable, =0 -> Disable)
							;	bit4 --> PCINT4 enable	(=1 -> Enable, =0 -> Disable)
							;	bit3 --> PCINT3 enable	(=1 -> Enable, =0 -> Disable)
							;	bit2 --> PCINT2 enable	(=1 -> Enable, =0 -> Disable)
							;>	bit1 --> PCINT1 enable	(=1 -> Enable, =0 -> Disable) - SMOKE
							;>	bit0 --> PCINT0 enable	(=1 -> Enable, =0 -> Disable) - PIR
	LDI	ACCA,PCMSK0_ini
	OUT	PCMSK0,ACCA



				; ***** init WDT (Watch Dog Timer)

; == Watchdog Timer (WDT)==
; We are setting the WDT to trigger interrupt every second
; See page 43 from the data sheet for details

.EQU	WDTCSRini	= 0B01000110	;WDIE=1 (WDT interrupt enable), prescaler = 1 sec
							;	bit7 --> Watchdog Timeout Interrupt Flag
							;>  bit6 --> Watchdog Timeout Interrupt Enable
							;   bit5 --> reserve
							;   bit4 --> reserve
							;>	bit3..0 --> Watchdog Timer Prescaler
							;		0110 - 32K cycles - 1.0 sec
							;       See page: 46 from data sheet for details.
							;       Biggest value here is 8secs (1001)
	LDI	ACCA,WDTCSRini
	OUT	WDTCSR,ACCA


					; ***** init var.

#ifdef ENABLE_OTA

    sbrs FLAG3, F_SOFT_RESET   ; Do not reinitialize the time if that is a software reset
    rjmp Time_Init_end

#endif

	LDI	ACCA,0
	sts	RTC_sec,ACCA
	sts	RTC_min,ACCA
	sts	RTC_hour,ACCA
	sts	RTC_day,ACCA

	sts	T_Battery_test_h,ACCA
	sts	T_Buzzer_s,ACCA
	sts	T_LED_s,ACCA
	sts	T_button_s,ACCA
/*
*/
	;sts	T_smoke_ON_min,ACCA
	sts	T_smoke_OFF_min,ACCA
	sts	Co_smoke_active,ACCA
	sts	T_smoke_agr_min,ACCA

	;sts	T_PIR_ON_min,ACCA
	sts	T_PIR_OFF_min,ACCA
	sts	Co_PIR_active,ACCA
	sts	T_PIR_agr_min,ACCA

	sts	T_AGGREG_1min,ACCA
/*
*/

#ifdef ENABLE_OTA

Time_Init_end:
    CLR FLAG3                 ; Clear FLAG3

#endif

				; Set Device Working Mode
					;Read Device Mode from EEPROM
	rcall	GetDevModEEP	;Read Device Mode from EEPROM

					;Check Device Mode var. and set flags
	cpi	ACCA,ModeSmoke
	breq	SetDevMod_100
	cpi	ACCA,ModeAlarm
	breq	SetDevMod_100
	cpi	ACCA,ModeSmartAlarm
	breq	SetDevMod_100
	cpi	ACCA,ModeSmartProtection
	breq	SetDevMod_100
						;Wrong mode
	ldi	ACCA,ModeSmoke	; Set default mode = SMOKE
	rcall	SaveDevModEEP	;Save Device Mode to EEPROM

SetDevMod_100:
					;Set Device Mode var. and set flags
	sts	DEV_MODE,ACCA
	andi	ACCA,0x0F
	mov	StatusMODE,ACCA

#if TEST
;----------------------------- for TEST -------------------------v
	ldi	ACCA,ModeAlarm	; Set default mode = SMART ALARM
#if TEST_AUTO_OTA
    ldi ACCA,ModeSmoke ; MOTION can interupt us. Just SMOKE is fine.
#endif
	sts	DEV_MODE,ACCA
	andi	ACCA,0x0F
	mov	StatusMODE,ACCA
;----------------------------- for TEST -------------------------^
#endif
				; ***** enable INTERRUPTs
	SEI


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;---------------------MAIN------------------v

MAIN:
	nop


				; Check BUTTON
	SBRC	FLAG,F_button_prag2		;preskacha, ako nyama aktiven flag zadyrjan buton prag2 (15 sec)
	rjmp	EnterModeConfig				; obslujvane na rejim CONFIG

	SBRC	FLAG,F_button_prag1		;preskacha, ako nyama aktiven flag zadyrjan buton prag1 (5 sec)
	RCALL	Manage_button_prag1		;-v

#if TEST_BLINK
.message "AVR-APP: TEST: Blink enabled"
    rcall   LEDpulse
#endif

#if TEST_BUZZ
.message "AVR-APP: TEST: Buzzer enabled"
    rcall BuzzerPulse
#endif

Main_HighPrio:
    ; Here are the tests that are with High Priority and can interrupt ModeConfig

					; Check Smoke
	SBRC	StatusSMOKE,F_SMOKE_beg		;preskacha, ako ne e vdignt flaga
	RCALL	ManageSMOKE_beg		;-v

	SBRC	StatusSMOKE,F_SMOKE_end		;preskacha, ako ne e vdignt flaga
	RCALL	ManageSMOKE_end		;-v

    SBRC   StatusMODE, F_ConfigMod ; If we have ModeConfig running then do not trigger
                                   ; actions that can abort mode config unless it is SMOKE event
    RJMP  Main_end

Main_LowPrio:

                    ; Check Battery_test
    SBRC    FLAG,Battery_test       ;preskacha, ako nyama aktiven flag za test na bateriqta
    RCALL   Manage_Battery_test     ;-v

#ifdef ENABLE_OTA

    SBRS    FLAG3, F_OTA            ;preskacha, ako ima aktiven flag za OTA
    rjmp    Main_OTA_end

    RCALL   Manage_OTA              ;-v
    tst ACCD                        ; test ERR code from SendOTAmess
    brne Main_OTA_end               ; branch if there is no need to restart

;    SBRS    FLAG,BatteryLow         ; skip if the battery level is low

    rjmp Soft_Reset

Main_OTA_end:

#endif
				; Check PIR
	SBRC	StatusPIR,F_PIR_beg		;preskacha, ako ne e vdignt flaga
	RCALL	ManagePIR_beg		;-v

	SBRC	StatusPIR,F_PIR_end		;preskacha, ako ne e vdignt flaga
	RCALL	ManagePIR_end		;-v

				; Check AGGREGATE PIR and SMOKE events
	SBRC	FLAG,F_AGGREG_req		;preskacha, ako ne e vdignt flaga
	RCALL	ManageAGGREGATE		;-v

				; PAUSE
	rcall	PAUSE_new

Main_end:


				; Enable Sleep

; == Slepp Mode Settings ==
; Here is the sleep mode set.
; See page 37 from the data sheet named "The MCU Control Register contains control bits for power management."
	IN	ACCA,MCUCR
; == Sleep Enable ==
; Bit 4 – SE: Sleep Enable
; The SE bit must be written to logic one to make the MCU enter the sleep mode when the SLEEP instruction is exe-
; cuted. To avoid the MCU entering the sleep mode unless it is the programmer’s purpose, it is recommended to
; write the Sleep Enable (SE) bit to one just before the execution of the SLEEP instruction and to clear it immediately
; after waking up.
	SBR	ACCA,1<<SE
	OUT	MCUCR,ACCA

	sleep

; == Wake up from sleep ==
; The processor can be woken up from: External Pin, Power-on Reset, Brown-out Reset, Watchdog Reset

				; Disable Sleep
	IN	ACCA,MCUCR
	CBR	ACCA,1<<SE
	OUT	MCUCR,ACCA


	RJMP	MAIN

; == Subroutines ==
; The MAIN function will be the one that is executed as part of the RESET interrupt handler.
; Below are the other subroutines that might be called

;------------------------ Manage Mode CONFIG -----------v
EnterModeConfig:
			; Set flag F_ConfigMod - aktiviran rejim Config
	SBR		StatusMODE,1<<F_ConfigMod		; Set flag F_ConfigMod

					; Power Up WF module
	rcall	ESPpowerON	; power WF module enable  (Active = 1) /power ON/
	tst	ACCD	; test ERR code
	breq	EntModConf_100	;ESPpowerON = OK
				;ERR or timeout
				;ERR power ON WF module
	ldi	ACCD,1	;ERR code = timout
	rjmp	EntModConf_end

EntModConf_100:
					; Send Change Mode message by USART0 to WiFi module
	rcall	SendChangeModeMess	; Send Change Mode message by USART0 to WiFi module
	tst	ACCD	; test ERR code
	brne	EntModConf_300	;Send Change Mode message = ERR or timeout

					;Set new Device Mode and set flags
#ifdef ENABLE_OTA

    cpi ACCA, ModeOTA   ; Check if ACCA is Mode OTA, If yes -> rjmp $0000
    brne EntModConf_250

    rjmp Soft_Reset

#endif

EntModConf_250:

    cpi ACCA, ModeCancel
    breq EntModConf_300 ; if we have cancel -> then don't change the current mode

	lds ACCB, DEV_MODE
	cp ACCB, ACCA
	breq EntModConf_300

	sts	DEV_MODE,ACCA
	andi	ACCA,0x0F
	mov	StatusMODE,ACCA

	rcall	BuzzerPulse
	rcall	PAUSE_new
	rcall	BuzzerPulse
	rcall	PAUSE_new
	rcall	BuzzerPulse

EntModConf_300:
					; Power Down WF module
	rcall	ESPpowerOFF		;WF module power OFF


EntModConf_end:
			; Clear flag F_ConfigMod - aktiviran rejim Config
	CBR		StatusMODE,1<<F_ConfigMod		; Clear flag F_ConfigMod
			; Clear flag F_button_prag2 - otbelqzvane, che zaqvkata e obrabotena
	CBR		FLAG,1<<F_button_prag2		; Clear flag F_button_prag2

    RJMP    MAIN

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;==============================================================================
			; PAUSE ~ 400 ms
				; Input: none
				; Otput: none
				; Destroyed registers: none
;==============================================================================
PAUSE_new:
	PUSH	ACCA
	IN	ACCA,SREG
	PUSH	ACCA
	PUSH	ACCB
	PUSH	ACCC

	LDI	ACCC,2			; 2 x ~200 ms = ~400 ms
	LDI	ACCA,0
	LDI	ACCB,0
PAUSE3m:
	DEC	ACCA			; 1 us
	BRNE	PAUSE3m		; 2 us
	DEC	ACCB
	BRNE	PAUSE3m
	DEC	ACCC
	BRNE	PAUSE3m

	POP	ACCC
	POP	ACCB
	POP	ACCA
	OUT	SREG,ACCA
	POP	ACCA

	ret


;==============================================================================
			; PauseACCCx10ms	-> Pause ACCC x 10 ms
				; Input: ACCC
				; Otput: none
				; Destroyed registers:  ACCC
;==============================================================================
PauseACCCx10ms:
	PUSH	ACCA
	IN	ACCA,SREG
	PUSH	ACCA
	PUSH	ACCB

PaACx10ms_100:
	LDI	ACCB,10					; 1 ms x 10 = 10 ms
PaACx10ms_200:
	LDI	ACCA,250					; 4 us x 250 = 1000 us = 1 ms
PaACx10ms_300:
	nop						; 1 us
	DEC	ACCA				; 1 us
	BRNE	PaACx10ms_300	; 2 us
	DEC	ACCB
	BRNE	PaACx10ms_200
	DEC	ACCC
	BRNE	PaACx10ms_100

	POP	ACCB
	POP	ACCA
	OUT	SREG,ACCA
	POP	ACCA

	ret

;==============================================================================
			; LEDpulse	-> Active LED for ~ 8 ms
				; Input: none
				; Otput: none
				; Destroyed registers: none
;==============================================================================
LEDpulse:
	push	ACCA
	push	ACCC

			; LED on
	CBI	PORTB,LED		; LED = 0 (Active)

	LDI	ACCC,10			; 10 x 768 us = ~ 8 ms
	LDI	ACCA,0
L_PAUSE3m:
	DEC	ACCA			; 1 us
	BRNE	L_PAUSE3m	; 2 us
	DEC	ACCC
	BRNE	L_PAUSE3m

			; LED off
	SBI	PORTB,LED		; LED = 1 (Inactive)
			; Clear flag BUZZ_pulse_req
	CBR	FLAG2,1<<LED_pulse_req		;clear flag zaqvka za impuls na LED

	pop		ACCC
	pop		ACCA
	ret

;==============================================================================
			; tLED1pulse	-> Active tLED1 for ~ 8 ms
				; Input: none
				; Otput: none
				; Destroyed registers: none
;==============================================================================
tLED1pulse:
	push	ACCA
	push	ACCC

			; tLED1 on
	CBI	PORTA,tLED1		; tLED1 = 0 (Active)

	LDI	ACCC,10			; 10 x 768 us = ~ 8 ms
	LDI	ACCA,0
tLED1pulse_100:
	DEC	ACCA			; 1 us
	BRNE	tLED1pulse_100	; 2 us
	DEC	ACCC
	BRNE	tLED1pulse_100

			; tLED1 off
	SBI	PORTA,tLED1		; tLED1 = 1 (Inactive)

	pop		ACCC
	pop		ACCA
	ret

;==============================================================================
			; tLED2pulse	-> Active tLED2 for ~ 8 ms
				; Input: none
				; Otput: none
				; Destroyed registers: none
;==============================================================================
tLED2pulse:
	push	ACCA
	push	ACCC

			; tLED2 on
	CBI	PORTA,tLED2		; tLED2 = 0 (Active)

	LDI	ACCC,10			; 10 x 768 us = ~ 8 ms
	LDI	ACCA,0
tLED2pulse_100:
	DEC	ACCA			; 1 us
	BRNE	tLED2pulse_100	; 2 us
	DEC	ACCC
	BRNE	tLED2pulse_100

			; tLED2 off
	SBI	PORTA,tLED2		; tLED2 = 1 (Inactive)

	pop		ACCC
	pop		ACCA
	ret

;==============================================================================
			; BuzzerPulse	-> Active BUZZER for ~ 8 ms
				; Input: none
				; Otput: none
				; Destroyed registers: none
;==============================================================================
BuzzerPulse:
	push	ACCA
	push	ACCC

			; BUZZER on
	SBI	PORTC,BUZZER	; BUZZER = 1 (Active)

	LDI	ACCC,10			; 10 x 768 us = ~ 8 ms
	LDI	ACCA,0
L_PAUSE4m:
	DEC	ACCA			; 1 us
	BRNE	L_PAUSE4m	; 2 us
	DEC	ACCC
	BRNE	L_PAUSE4m

			; BUZZER off
	CBI	PORTC,BUZZER	; BUZZER = 0 (Inactive)
			; Clear flag BUZZ_pulse_req
	CBR	FLAG2,1<<BUZZ_pulse_req		;clear flag zaqvka za impuls na zumera

	pop		ACCC
	pop		ACCA
	ret


;==============================================================================
			; SendByteUSART0	-> Send byte by USART0
				; Input: ACCA	-> byte to send
				; Otput: none
				; Destroyed registers: none
;==============================================================================
SendByteUSART0:
	push	ACCC

SendByteUSART0_10:
	in		ACCC,UCSR0A
	sbrs	ACCC,UDRE0
	rjmp	SendByteUSART0_10
	out		UDR0,ACCA

	pop		ACCC
	ret

;==============================================================================
			; SendByteUSART1	-> Send byte by USART1
				; Input: ACCA	-> byte to send
				; Otput: none
				; Destroyed registers: none
;==============================================================================
SendByteUSART1:
	push	ACCC

SendByteUSART1_10:
	lds		ACCC,UCSR1A
	sbrs	ACCC,UDRE1
	rjmp	SendByteUSART1_10
	sts		UDR1,ACCA

	pop		ACCC
	ret

;==============================================================================
			; SendByteUSART1_ASSCI_HEX	-> Изпращане на байт чрез USART1 в HEX формат
				; Input: ACCA	-> байт за изпращане
				; Otput: none
				; Destroyed registers: none
;==============================================================================
SendByteUSART1_ASSCI_HEX:
	push	ACCC
	push	ACCB

	mov		ACCB,ACCA	;save ACCA
	lsr		ACCA
	lsr		ACCA
	lsr		ACCA
	lsr		ACCA
	ori		ACCA,0x30
	cpi		ACCA,0x3A
	brlo	SBUAH_100
	ldi		ACCC,0x07
	add		ACCA,ACCC
SBUAH_100:
	rcall	SendByteUSART1	; HH (ASCII)
	mov		ACCA,ACCB
	andi	ACCA,0b00001111
	ori		ACCA,0x30
	cpi		ACCA,0x3A
	brlo	SBUAH_110
	ldi		ACCC,0x07
	add		ACCA,ACCC
SBUAH_110:
	rcall	SendByteUSART1	; HL (ASCII)

	pop		ACCB
	pop		ACCC
	ret


;==============================================================================
			; ReceiveByteUSART0	-> Receive Byte from USART0
				; Input: set timout in T_COMM_timout_s !!!
				; Otput:	ACCA - received byte
				;			ACCD - ERR code (=0 -> OK ; =1 -> timout)
				; Destroyed registers: ACCA, ACCD
;==============================================================================
ReceiveByteUSART0:
	push	ACCC

USART0_Receive:
			; Check for data byte is received
	in		ACCC,UCSR0A
	sbrc	ACCC,RXC0
	rjmp ReByUS0_100	; byte is ready, go to get it
			; Check for timout
	SBRS	FLAG2,COMM_timeout_req		;preskacha, ako e vdignat flaga za iztekal period na tajmera T_COMM_timout_
	rjmp USART0_Receive		;go if no timeout
				; Timout
	ldi	ACCA,0			; Clear ACCA
	ldi	ACCD,1			; ERR code = 1 -> Timeout
	rjmp ReceiveByteUSART0_end	; go to end

ReByUS0_100:
			; Get received byte from buffer
	in ACCA, UDR0
	ldi	ACCD,0			; ERR code = 0 -> OK

ReceiveByteUSART0_end:
			;Clear timout
	ldi	ACCC,0
	sts	T_COMM_timout_s,ACCC
			; Clear flag COMM_timeout_req
	CBR	FLAG2,1<<COMM_timeout_req		;clear flag zaqvka za COMMUNICATION timeout

	pop		ACCC
	ret


;==============================================================================
			; ReceiveByteUSART1	-> Receive Byte from USART1
				; Input: set timout in T_COMM_timout_s !!!
				; Otput:	ACCA - received byte
				;			ACCD - ERR code (=0 -> OK ; =1 -> timout)
				; Destroyed registers: ACCA, ACCD
;==============================================================================
ReceiveByteUSART1:
	push	ACCC

USART1_Receive:
			; Check for data byte is received
	lds		ACCC,UCSR1A
	sbrc	ACCC,RXC1
	rjmp ReByUS1_100	; byte is ready, go to get it
			; Check for timout
	SBRS	FLAG2,COMM_timeout_req		;preskacha, ako e vdignat flaga za iztekal period na tajmera T_COMM_timout_
	rjmp USART1_Receive		;go if no timeout
				; Timout
	ldi	ACCA,0			; Clear ACCA
	ldi	ACCD,1			; ERR code = 1 -> Timeout
	rjmp ReceiveByteUSART1_end	; go to end

ReByUS1_100:
			; Get received byte from buffer
	lds ACCA, UDR1
	ldi	ACCD,0			; ERR code = 0 -> OK

ReceiveByteUSART1_end:
			;Clear timout
	ldi	ACCC,0
	sts	T_COMM_timout_s,ACCC
			; Clear flag COMM_timeout_req
	CBR	FLAG2,1<<COMM_timeout_req		;clear flag zaqvka za COMMUNICATION timeout

	pop		ACCC
	ret


;==============================================================================
			; ESPpowerON	-> power WF module enable  (Active = 1) /power ON/
				; Input: none
				; Otput: ACCD --> =0 - OK ; !=0 - ERROR (timout)
				; Destroyed registers: ACCA, ACCD
;==============================================================================
ESPpowerON:
	push	ACCC

	ldi	ACCC,CoRepeteRequestESP_ini	;count of requestes to powerUp WiFi module
ESPpoON_100:
		; WF module power ON
	SBI	PORTA,POWER_WF_EN	; POWER_WF_EN = 1 (Active) /WF module power ON/



#if TEST
;--------------------- for TEST --------------------v
	push	ACCA

		; Send Space
	ldi		ACCA,' '
	rcall	SendByteUSART1
		; Send '_'
	ldi		ACCA,'_'
	rcall	SendByteUSART1
		; Send 'O'
	ldi		ACCA,'O'
	rcall	SendByteUSART1
		; Send 'N'
	ldi		ACCA,'N'
	rcall	SendByteUSART1
		; Send '_'
	ldi		ACCA,'_'
	rcall	SendByteUSART1

	pop	ACCA
;--------------------- for TEST --------------------^
#endif

		; Wait for ready WF module
			; Set timeout and wait for confirm
	ldi	ACCA,TimoutESPpowerUp_s	;timeout for WiFi module power up [sec]
	rcall	WaitConfirmESP	;Wait for receive confirm byte from WF module

	tst	ACCD	; test ERR code
	breq	ESPpoON_end	;ESPpowerON = OK

				;ERR or timeout
	rcall	ESPpowerOFF		;WF module power OFF

				; Pause ~ 2500 ms
	push	ACCC
	ldi	ACCC,250
	rcall	PauseACCCx10ms
	pop		ACCC


	dec	ACCC
	brne	ESPpoON_100	; repete

				;ERR power ON WF module
	ldi	ACCD,1	;ERR code = timout

ESPpoON_end:



#if TEST
;--------------------- for TEST --------------------v
		; Send '*'
	ldi		ACCA,'*'
	rcall	SendByteUSART1
		; Send ERR code
	mov		ACCA,ACCD
	rcall	SendByteUSART1_ASSCI_HEX
		; Send Space
	ldi		ACCA,' '
	rcall	SendByteUSART1
;--------------------- for TEST --------------------^
#endif


	pop		ACCC
	ret

;==============================================================================
			; WaitConfirmESP	-> Wait for receive confirm byte from WF module
				; Input: ACCA - Timeout for waiting [sec]
				; Otput: ACCD --> =0 - OK ; =1 - ERROR (timout)
				; Destroyed registers: ACCA, ACCD
;==============================================================================
WaitConfirmESP:

		; Wait for ready WF module
			; Set timeout and Clear flag COMM_timeout_req
	sts	T_COMM_timout_s,ACCA
	CBR	FLAG2,1<<COMM_timeout_req		;clear flag zaqvka za COMMUNICATION timeout
			; Wait for receive confirm byte from WF module byte
WaCoESP_100:
	rcall	ReceiveByteUSART0	; Receive Byte from USART0
				; Check for timeout or ERR
	tst	ACCD
	brne	WaCoESP_200		; go to end if timeout or ERR

	cpi	ACCA,Confirm_byte	;proverka za poluchen bajt za potvyrjdenie
	brne	WaCoESP_100		; go to receive new byte
				; poluchen bajt za potvyrjdenie
	ldi	ACCD,0	;return code = OK

WaCoESP_200:

	ret

#ifdef ENABLE_OTA

;==============================================================================
            ; WaitConfirmOTA    -> Wait for receive confirm byte from WF module
                ; Input: ACCA - Timeout for waiting [sec]
                ; Otput: ACCD --> =0 - OK ; =1 - ERROR (timout)
                ; Destroyed registers: ACCA, ACCD
;==============================================================================
WaitConfirmOTA:
        ; Wait for ready WF module
            ; Set timeout and Clear flag COMM_timeout_req
    sts T_COMM_timout_s,ACCA
    CBR FLAG2,1<<COMM_timeout_req       ;clear flag zaqvka za COMMUNICATION timeout
            ; Wait for receive confirm byte from WF module byte
WaCoOTA_100:
    rcall   ReceiveByteUSART0   ; Receive Byte from USART0
                ; Check for timeout or ERR
    tst ACCD
    brne    WaCoOTA_200     ; go to end if timeout or ERR

    cpi ACCA, ModeOTA       ;proverka za poluchen bajt za potvyrjdenie
    breq  WaCoOTA_150       ; poluchen bajt za potvyrjdenie
    ldi ACCD,1              ; <-- Invalid confirmation or timeout
    rjmp WaCoOTA_200

WaCoOTA_150:
    ldi ACCD,0  ;return code = OK

WaCoOTA_200:

    ret

#endif


;==============================================================================
			; ESPpowerOFF	-> WF module power OFF
				; Input: none
				; Otput: none
				; Destroyed registers: none
;==============================================================================
ESPpowerOFF:
	;push	ACCC

		; WF module power OFF
	CBI	PORTA,POWER_WF_EN	; POWER_WF_EN = 0  /WF module power OFF/


;--------------------- for TEST --------------------v
#if defined(TEST)

	push	ACCA

		; Send Space
	ldi		ACCA,' '
	rcall	SendByteUSART1
		; Send '_'
	ldi		ACCA,'_'
	rcall	SendByteUSART1
		; Send 'O'
	ldi		ACCA,'O'
	rcall	SendByteUSART1
		; Send 'F'
	ldi		ACCA,'F'
	rcall	SendByteUSART1
		; Send 'F'
	ldi		ACCA,'F'
	rcall	SendByteUSART1
		; Send '_'
	ldi		ACCA,'_'
	rcall	SendByteUSART1
		; Send Space
	ldi		ACCA,' '
	rcall	SendByteUSART1

	pop	ACCA

#endif
;--------------------- for TEST --------------------^


	;pop		ACCC
	ret

;==============================================================================
			; SendChangeModeMess	--> Send Change Mode message by USART0
				; Input: none
				; Otput:	ACCA --> New Mode
				;			ACCD --> =0 - OK ; =1 - ERROR (timout)
				; Destroyed registers: none
;==============================================================================
SendChangeModeMess:

		; Clear Rx buffer USART0
	rcall	ClearRxBufUSART0	; Clear Rx buffer USART0

		; Send Change Mode Message
	ldi		ACCA,ChangeModeMess
	rcall	SendByteUSART0


;--------------------- for TEST --------------------v
#if defined(TEST)

		; Send Space
	ldi		ACCA,' '
	rcall	SendByteUSART1
		; Send '>'
	ldi		ACCA,'>'
	rcall	SendByteUSART1
		; Send Change Mode Message
	ldi		ACCA,ChangeModeMess
	rcall	SendByteUSART1
		; Send '_'
	ldi		ACCA,'_'
	rcall	SendByteUSART1

#endif
;--------------------- for TEST --------------------^


		; Wait for receive New Mode byte from WF module
			; Set timeout and Clear flag COMM_timeout_req
	ldi	ACCA,TimoutChangeModReq_s	; timout for Change Mode Request
	sts	T_COMM_timout_s,ACCA
	CBR	FLAG2,1<<COMM_timeout_req		;clear flag zaqvka za COMMUNICATION timeout
			; Wait for receive New Mode byte from WF module
SeChaMoMe_100:
	rcall	ReceiveByteUSART0	; Receive Byte from USART0
				; Check for timeout or ERR
	tst	ACCD
	brne	SeChaMoMe_200		; go to end if timeout or ERR

    cpi ACCA, ModeCancel        ; X - notifies cancel smartconfig
    breq SeChaMoMe_end

    mov ACCD,ACCA
	andi	ACCD,0xF0		;mask
	cpi	ACCD,0x40	;proverka za poluchen validen New Mode byte
	brne	SeChaMoMe_100		; go to receive new byte if New Mode byte is wrong
				; poluchen New Mode byte
	ldi	ACCD,0	;return code = OK
	rjmp	SeChaMoMe_end

SeChaMoMe_200:
				; timeout or ERR New Mode byte
	ldi	ACCD,1	;return code = timeout or ERR

SeChaMoMe_end:

;--------------------- for TEST --------------------v
#if defined(TEST)

	push	ACCA

		; Send '<'
	ldi		ACCA,'<'
	rcall	SendByteUSART1
		; Send New Mode byte from WF module
	pop	ACCA
	push	ACCA
	rcall	SendByteUSART1
		; Send '*'
	ldi		ACCA,'*'
	rcall	SendByteUSART1
		; Send ERR code
	mov		ACCA,ACCD
	rcall	SendByteUSART1_ASSCI_HEX
		; Send Space
	ldi		ACCA,' '
	rcall	SendByteUSART1

	pop	ACCA

#endif
;--------------------- for TEST --------------------^



;	pop		ACCC
	ret

;==============================================================================
			; SendSMOKEmess	-> Send SMOKE messages by USART0
				; Input: ACCB - Parameter 1 /broj aktivni minuti za 5 minuten period/
				; Otput: ACCD - result / =0 --> OK ; !=0 --> ERR (timeout)/
				; Destroyed registers: ACCA, ACCB, ACCD
;==============================================================================
SendSMOKEmess:
	push	ACCC

					; Send Event SMOKE Message
	ldi	ACCC,CoRepeteRequestConfirm	;count of requestes to confirm from WiFi module
SeSMOMe_100:
	ldi		ACCA,EventSmoke	;CODE for Event SMOKE Message
	rcall	SendByteUSART0
		; Send Parameter 1
	mov		ACCA,ACCB
	rcall	SendByteUSART0


;--------------------- for TEST --------------------v
#if defined(TEST)

		; Send Space
	ldi		ACCA,' '
	rcall	SendByteUSART1
		; Send '>'
	ldi		ACCA,'>'
	rcall	SendByteUSART1
		; Send Event Message
	ldi		ACCA,EventSmoke	;CODE for Event SMOKE Message
	rcall	SendByteUSART1
		; Send '_'
	ldi		ACCA,'_'
	rcall	SendByteUSART1
		; Send Parameter 1
	mov		ACCA,ACCB
	rcall	SendByteUSART1_ASSCI_HEX

#endif
;--------------------- for TEST --------------------^



		; Wait for receive confirm
			; Set timeout and wait for confirm
	ldi	ACCA,WaitConfirm_s	;Wait time for confirm byte [sec]
	rcall	WaitConfirmESP	;Wait for receive confirm byte from WF module
	tst	ACCD	; test ERR code
	breq	SeSMOMe_200	;confirm byte = OK
				;ERR or timeout
	dec	ACCC
	brne	SeSMOMe_100	; repete

				;ERR confirm from WF module
	ldi	ACCD,1	;ERR code = timout
	rjmp	SeSMOMe_end

SeSMOMe_200:
	ldi	ACCD,0	;ERR code = OK

SeSMOMe_end:


;--------------------- for TEST --------------------v
#if defined(TEST)

		; Send '*'
	ldi		ACCA,'*'
	rcall	SendByteUSART1
		; Send ERR code
	mov		ACCA,ACCD
	rcall	SendByteUSART1_ASSCI_HEX
		; Send Space
	ldi		ACCA,' '
	rcall	SendByteUSART1

#endif
;--------------------- for TEST --------------------^


	pop		ACCC
	ret

;==============================================================================
			; SendPIRmess	-> Send Motion messages by USART0
				; Input: ACCB - Parameter 1 /broj aktivni minuti za 180 minuten period/
				; Otput: ACCD - result / =0 --> OK ; !=0 --> ERR (timeout)/
				; Destroyed registers: ACCA, ACCB, ACCD
;==============================================================================
SendPIRmess:
	push	ACCC

					; Send Event Motion Message
	ldi	ACCC,CoRepeteRequestConfirm	;count of requestes to confirm from WiFi module
SePIRMe_100:
	ldi		ACCA,EventMotion	;CODE for Event Motion Message
	rcall	SendByteUSART0
		; Send Parameter 1
	mov		ACCA,ACCB
	rcall	SendByteUSART0


;--------------------- for TEST --------------------v
#if defined(TEST)

		; Send Space
	ldi		ACCA,' '
	rcall	SendByteUSART1
		; Send '>'
	ldi		ACCA,'>'
	rcall	SendByteUSART1
		; Send Event Message
	ldi		ACCA,EventMotion	;CODE for Event Motion Message
	rcall	SendByteUSART1
		; Send '_'
	ldi		ACCA,'_'
	rcall	SendByteUSART1
		; Send Parameter 1
	mov		ACCA,ACCB
	rcall	SendByteUSART1_ASSCI_HEX

#endif
;--------------------- for TEST --------------------^



		; Wait for receive confirm
			; Set timeout and wait for confirm
	ldi	ACCA,WaitConfirm_s	;Wait time for confirm byte [sec]
	rcall	WaitConfirmESP	;Wait for receive confirm byte from WF module
	tst	ACCD	; test ERR code
	breq	SePIRMe_200	;confirm byte = OK
				;ERR or timeout
	dec	ACCC
	brne	SePIRMe_100	; repete

				;ERR confirm from WF module
	ldi	ACCD,1	;ERR code = timout
	rjmp	SePIRMe_end

SePIRMe_200:
	ldi	ACCD,0	;ERR code = OK

SePIRMe_end:


;--------------------- for TEST --------------------v
#if defined(TEST)

		; Send '*'
	ldi		ACCA,'*'
	rcall	SendByteUSART1
		; Send ERR code
	mov		ACCA,ACCD
	rcall	SendByteUSART1_ASSCI_HEX
		; Send Space
	ldi		ACCA,' '
	rcall	SendByteUSART1

#endif
;--------------------- for TEST --------------------^


	pop		ACCC
	ret

;==============================================================================
			; SendTemperatureMess	-> Send temperature messages by USART0
				; Input: Temperature_oC - Parameter 1 /temperature [oC]/
				; Otput: ACCD - result / =0 --> OK ; !=0 --> ERR (timeout)/
				; Destroyed registers: ACCA, ACCD
;==============================================================================
SendTemperatureMess:
	push	ACCC

					; Send Event Temperature Message
	ldi	ACCC,CoRepeteRequestConfirm	;count of requestes to confirm from WiFi module
SeTempMe_100:
	ldi		ACCA,EventTemperature	;CODE for Event Temperature Message
	rcall	SendByteUSART0
		; Send Parameter 1
	lds		ACCA,Temperature_oC
	rcall	SendByteUSART0


;--------------------- for TEST --------------------v
#if defined(TEST)

		; Send Space
	ldi		ACCA,' '
	rcall	SendByteUSART1
		; Send '>'
	ldi		ACCA,'>'
	rcall	SendByteUSART1
		; Send Event Message
	ldi		ACCA,EventTemperature	;CODE for Event Temperature Message
	rcall	SendByteUSART1
		; Send '_'
	ldi		ACCA,'_'
	rcall	SendByteUSART1
		; Send Parameter 1
	lds		ACCA,Temperature_oC
	rcall	SendByteUSART1_ASSCI_HEX

#endif
;--------------------- for TEST --------------------^


		; Wait for receive confirm
			; Set timeout and wait for confirm
	ldi	ACCA,WaitConfirm_s	;Wait time for confirm byte [sec]
	rcall	WaitConfirmESP	;Wait for receive confirm byte from WF module
	tst	ACCD	; test ERR code
	breq	SeTempMe_200	;confirm byte = OK
				;ERR or timeout
	dec	ACCC
	brne	SeTempMe_100	; repete

				;ERR confirm from WF module
	ldi	ACCD,1	;ERR code = timout
	rjmp	SeTempMe_end

SeTempMe_200:
	ldi	ACCD,0	;ERR code = OK

SeTempMe_end:


;--------------------- for TEST --------------------v
#if defined(TEST)

		; Send '*'
	ldi		ACCA,'*'
	rcall	SendByteUSART1
		; Send ERR code
	mov		ACCA,ACCD
	rcall	SendByteUSART1_ASSCI_HEX
		; Send Space
	ldi		ACCA,' '
	rcall	SendByteUSART1

#endif
;--------------------- for TEST --------------------^


	pop		ACCC
	ret

;==============================================================================
			; SendBatteryLevelMess	-> Send message for battery level by USART0
				; Input: BatteryLevel_p (temporary battery level  [%])   /Parameter 1/
				; Otput: ACCD - result / =0 --> OK ; !=0 --> ERR (timeout)/
				; Destroyed registers: ACCA, ACCD
;==============================================================================
SendBatteryLevelMess:
	push	ACCC
					; Send Battery Level Message
	ldi	ACCC,CoRepeteRequestConfirm	;count of requestes to confirm from WiFi module
SeBaLeMe_300:
	ldi		ACCA,EventBatteryLevel	;CODE for Event Battery Level Message
	rcall	SendByteUSART0
		; Send Parameter 1
	lds		ACCA,BatteryLevel_p
	rcall	SendByteUSART0


;--------------------- for TEST --------------------v
#if defined(TEST)

		; Send Space
	ldi		ACCA,' '
	rcall	SendByteUSART1
		; Send '>'
	ldi		ACCA,'>'
	rcall	SendByteUSART1
		; Send Event Message
	ldi		ACCA,EventBatteryLevel	;CODE for Event Battery Level Message
	rcall	SendByteUSART1
		; Send '_'
	ldi		ACCA,'_'
	rcall	SendByteUSART1
		; Send Parameter 1
	lds		ACCA,BatteryLevel_p
	rcall	SendByteUSART1_ASSCI_HEX

#endif
;--------------------- for TEST --------------------^


		; Wait for receive confirm
			; Set timeout and wait for confirm
	ldi	ACCA,WaitConfirm_s	;Wait time for confirm byte [sec]
	rcall	WaitConfirmESP	;Wait for receive confirm byte from WF module
	tst	ACCD	; test ERR code
	breq	SeBaLeMe_400	;confirm byte = OK
				;ERR or timeout
	dec	ACCC
	brne	SeBaLeMe_300	; repete

				;ERR confirm from WF module
	ldi	ACCD,1	;ERR code = timout
	rjmp	SeBaLeMe_end

SeBaLeMe_400:
	ldi	ACCD,0	;ERR code = OK

SeBaLeMe_end:


;--------------------- for TEST --------------------v
#if defined(TEST)

		; Send '*'
	ldi		ACCA,'*'
	rcall	SendByteUSART1
		; Send ERR code
	mov		ACCA,ACCD
	rcall	SendByteUSART1_ASSCI_HEX
		; Send Space
	ldi		ACCA,' '
	rcall	SendByteUSART1

#endif
;--------------------- for TEST --------------------^


	pop		ACCC
	ret

#ifdef ENABLE_OTA

;==============================================================================
            ; SendOTAmess  -> Send message OTA by USART0
                ; Input: None
                ; Otput: ACCD - result / =0 --> OK ; !=0 --> ERR (timeout)/
                ; Destroyed registers: ACCA, ACCD
;==============================================================================
SendOTAmess:
    push    ACCC
                    ; Send OTA message
    ldi ACCC,CoRepeteRequestConfirm ;count of requestes to confirm from WiFi module
SeOTA_300:
    ldi     ACCA, EventOTA  ; code for Over-the-air update
    rcall   SendByteUSART0
                     ; Send Parameter 1 - s -for stable updates only
    lds     ACCA,'s'
    rcall   SendByteUSART0

        ; Wait for receive confirm
            ; Set timeout and wait for confirm
    ldi ACCA, OTAConfirm_s  ;Wait time for confirm byte [sec]
    rcall   WaitConfirmOTA  ;Wait for receive confirm byte from WF module
    tst ACCD    ; test ERR code
    breq    SeOTA_400    ;confirm byte = OK
                ;ERR or timeout

                ;ERR confirm from WF module
    ldi ACCD,1  ;ERR code = timout
    rjmp    SeOTA_end

SeOTA_400:
    ldi ACCD,0  ;ERR code = OK

SeOTA_end:
    pop     ACCC
    ret

#endif

;============================Testova funkciq==================================================
			; ManageSMOKE
				; Input: none
				; Otput: none
				; Destroyed registers: ACCA
;==============================================================================
ManageSMOKE:

			; LED on
	CBI	PORTB,LED		; LED = 0 (Active)

			; BUZZER on
	SBI	PORTC,BUZZER


				;Send SMOKE mess to USART0
ManageSMOKE_00:
	in		ACCA,UCSR0A
	sbrs	ACCA,UDRE0
	rjmp	ManageSMOKE_00
	;ldi		ACCA,0b00000011	;EventSmoke
	ldi		ACCA,0x33	;EventSmoke
	out		UDR0,ACCA

			; PAUSE
	rcall	PAUSE_new

ManageSMOKE_01:
	in		ACCA,UCSR0A
	sbrs	ACCA,UDRE0
	rjmp	ManageSMOKE_01
	;ldi		ACCA,0	;Parameter1
	ldi		ACCA,0x30	;Parameter1
	out		UDR0,ACCA

			; PAUSE
	rcall	PAUSE_new

ManageSMOKE_02:
	in		ACCA,UCSR0A
	sbrs	ACCA,UDRE0
	rjmp	ManageSMOKE_02
	;ldi		ACCA,0	;Parameter2
	ldi		ACCA,0x30	;Parameter2
	out		UDR0,ACCA

			; PAUSE
	rcall	PAUSE_new

				;Send SMOKE mess to USART1
ManageSMOKE_10:
	lds		ACCA,UCSR1A
	sbrs	ACCA,UDRE1
	rjmp	ManageSMOKE_10
	;ldi		ACCA,0b00000011	;EventSmoke
	ldi		ACCA,0x33	;EventSmoke
	sts		UDR1,ACCA

			; PAUSE
	rcall	PAUSE_new

ManageSMOKE_11:
	lds		ACCA,UCSR1A
	sbrs	ACCA,UDRE1
	rjmp	ManageSMOKE_11
	;ldi		ACCA,0	;Parameter1
	ldi		ACCA,0x30	;Parameter1
	sts		UDR1,ACCA

			; PAUSE
	rcall	PAUSE_new

ManageSMOKE_12:
	lds		ACCA,UCSR1A
	sbrs	ACCA,UDRE1
	rjmp	ManageSMOKE_12
	;ldi		ACCA,0	;Parameter2
	ldi		ACCA,0x30	;Parameter2
	sts		UDR1,ACCA

			; PAUSE
	rcall	PAUSE_new

			; Clear flag SMOKE - otbelqzvane, che zaqvkata e obrabotena
	CBR		StatusSMOKE,1<<SMOKE		; Clear flag SMOKE

	ret

;============================Testova funkciq==================================================
			; ManagePIR
				; Input: none
				; Otput: none
				; Destroyed registers: ACCA
;==============================================================================
ManagePIR:

			; LED on
	CBI	PORTB,LED		; LED = 0 (Active)
	;LDI	ACCA,0
	;OUT	PORTB,ACCA

			; BUZZER on
	SBI	PORTC,BUZZER	; BUZZER = 1 (Active)


				;Send PIR mess to UART0
ManagePIR_00:
	in		ACCA,UCSR0A
	sbrs	ACCA,UDRE0
	rjmp	ManagePIR_00
	;ldi		ACCA,0b00000101	;EventPIR
	ldi		ACCA,0x35	;EventPIR
	out		UDR0,ACCA

			; PAUSE
	rcall	PAUSE_new

ManagePIR_01:
	in		ACCA,UCSR0A
	sbrs	ACCA,UDRE0
	rjmp	ManagePIR_01
	;ldi		ACCA,0	;Parameter1
	ldi		ACCA,0x30	;Parameter1
	out		UDR0,ACCA

			; PAUSE
	rcall	PAUSE_new

				;Send PIR mess to UART1
ManagePIR_10:
	lds		ACCA,UCSR1A
	sbrs	ACCA,UDRE1
	rjmp	ManagePIR_10
	;ldi		ACCA,0b00000101	;EventPIR
	ldi		ACCA,0x35	;EventPIR
	sts		UDR1,ACCA

			; PAUSE
	rcall	PAUSE_new

ManagePIR_11:
	lds		ACCA,UCSR1A
	sbrs	ACCA,UDRE1
	rjmp	ManagePIR_11
	;ldi		ACCA,0	;Parameter1
	ldi		ACCA,0x30	;Parameter1
	sts		UDR1,ACCA

			; PAUSE
	rcall	PAUSE_new

			; Clear flag PIR - otbelqzvane, che zaqvkata e obrabotena
	CBR		StatusPIR,1<<PIR		; Clear flag PIR

	ret

;============================Testova funkciq==================================================
			; ManageBUTTON
				; Input: none
				; Otput: none
				; Destroyed registers: ACCA
;==============================================================================
ManageBUTTON:

			; LED off
	SBI	PORTB,LED		; LED = 1 (Inactive)
	;LDI	ACCA,(1<<LED)
	;OUT	PORTB,ACCA

			; BUZZER off
	CBI	PORTC,BUZZER	; BUZZER = 0 (Inactive)

				;Send BUTTON mess to UART1
ManageBUTTON_01:
	lds		ACCA,UCSR1A
	sbrs	ACCA,UDRE1
	rjmp	ManageBUTTON_01
	;ldi		ACCA,0b00000101	;EventPIR
	ldi		ACCA,0x23	; '#' - EventBUTTON
	sts		UDR1,ACCA

				;Get Temperature
	rcall	GetTemperature	; ACCB:ACCD - temperature
	;rcall	GetBattery	; ACCB:ACCD - battery level
	;ldi	ACCB,0x03
	;ldi	ACCD,0xA5
				;Send Temperature mess to UART1
	ldi		ACCA,0x20	;space
	rcall	SendByteUSART1
	ldi		ACCA,'T'	;Temperature
	rcall	SendByteUSART1
	ldi		ACCA,'='
	rcall	SendByteUSART1
	mov		ACCA,ACCB
	rcall	SendByteUSART1_ASSCI_HEX	; Temperature H (hex)
	mov		ACCA,ACCD
	rcall	SendByteUSART1_ASSCI_HEX	; Temperature L (hex)
	ldi		ACCA,0x20	;space
	rcall	SendByteUSART1

				;Get Battery level
	rcall	GetBattery	; ACCB:ACCD - battery level
				;Send Battery level mess to UART1
	ldi		ACCA,0x20	;space
	rcall	SendByteUSART1
	ldi		ACCA,'B'	;Battery level
	rcall	SendByteUSART1
	ldi		ACCA,'='
	rcall	SendByteUSART1
	mov		ACCA,ACCB
	rcall	SendByteUSART1_ASSCI_HEX	; Temperature H (hex)
	mov		ACCA,ACCD
	rcall	SendByteUSART1_ASSCI_HEX	; Temperature L (hex)
	ldi		ACCA,0x20	;space
	rcall	SendByteUSART1

			; PAUSE
	rcall	PAUSE_new

			; Clear flag BUTTONpressed - otbelqzvane, che zaqvkata e obrabotena
	CBR		FLAG,1<<BUTTONpressed		; Clear flag BUTTONpressed

	ret


;==============================================================================
			; Manage_button_prag1 (5 sec)
				; Input: none
				; Otput: none
				; Destroyed registers: ACCA
;==============================================================================
Manage_button_prag1:

			; BUZZER off
	CBI	PORTC,BUZZER	; BUZZER = 0 (Inactive)

			; Set flag F_Buzzer_block - blokirane na zumera za opredelen period
	SBR		FLAG2,1<<F_Buzzer_block		; Set flag F_Buzzer_block

			; Set timer T_Buzzer_block - vreme za blokirane na zumera za opredelen period (secundi)
	ldi		ACCA,Buzzer_block_s
	sts		T_Buzzer_s,ACCA


			; Clear flag F_button_prag1 - otbelqzvane, che zaqvkata e obrabotena
	CBR		FLAG,1<<F_button_prag1		; Clear flag F_button_prag1 (5 sec)

	ret


;==============================================================================
			; LED_BUZZ_control
				; Input: none
				; Otput: none
				; Destroyed registers: ACCA
;==============================================================================
LED_BUZZ_control:


;---------------------- for TEST ----------------------------v
;	rcall tLED2pulse
;---------------------- for TEST ----------------------------^



			;--- Manage zumer ---v

					; Check for Buzzer block
	SBRC	FLAG2,F_Buzzer_block		;preskacha, ako ne e vdignat flaga za blokirovka zumer
	rjmp	LE_BU_co_100	; prehod, ako e vdignat flaga za blokirovka zumer

					; Check and manage Buzzer pulse request
	SBRC	FLAG2,BUZZ_pulse_req		;preskacha, ako ne e vdignat flaga zaqvka za impuls na zumera
	rcall	BuzzerPulse				; prehod, ako e vdignat flaga zaqvka za impuls na zumera

LE_BU_co_100:
					; Check and manage Buzzer timout request
	SBRS	FLAG2,BUZZ_timeout_req		;preskacha, ako e vdignat flaga zaqvka za iztekal period na tajmera na zumera
	rjmp	LE_BU_co_200			; prehod, ako ne e vdignat flaga zaqvka za iztekal period na tajmera na zumera

						; manage Buzzer timout request

							; proverka za blokiran zumer za opredelen period
	SBRS	FLAG2,F_Buzzer_block		;preskacha, ako e vdignat flaga za blokirovka zumer
	rjmp	LE_BU_co_120	; prehod, ako ne e vdignat flaga za blokirovka zumer

								; manage rejim blokirovka zumer end
	CBR	FLAG2,1<<F_Buzzer_block		;clear flag rejim blokirovka zumer
								; check SMOKE and PIR
	SBRS	StatusSMOKE,SMOKE		;preskacha, ako e vdignat flaga za dim
	rjmp	LE_BU_co_110	; prehod, ako ne e vdignat flaga za dim
									; SMOKE
								; set timer for buzzer
	ldi	ACCA,Buzzer_SMOKE_s	;period za dejstvie na zumera pri dim [sec]
	sts	T_Buzzer_s,ACCA		;set timer for buzzer
			; BUZZER on
	SBI	PORTC,BUZZER	; BUZZER = 1 (Active)
	rjmp	LE_BU_co_120
LE_BU_co_110:
	SBRS	StatusPIR,PIR		;preskacha, ako e vdignat flaga za dvijenie
	rjmp	LE_BU_co_115	; prehod, ako ne e vdignat flaga za dvijenie
									; PIR
	lds ACCA, DEV_MODE
	cpi ACCA, ModeSmartProtection
	breq LE_BU_co_120
								; set timer for buzzer
	ldi	ACCA,Buzzer_PIR_s	;period za dejstvie na zumera pri dvijenie [sec]
	sts	T_Buzzer_s,ACCA		;set timer for buzzer
			; BUZZER on
	SBI	PORTC,BUZZER	; BUZZER = 1 (Active)
	rjmp	LE_BU_co_120
LE_BU_co_115:
									; NONE
			; BUZZER off
	CBI	PORTC,BUZZER	; BUZZER = 0 (Inactive)
	CBR	FLAG2,1<<F_Buzzer		;clear flag aktiven zumer

LE_BU_co_120:
							; proverka za zumer v rejim impuls
	SBRS	FLAG2,F_Buzzer_pulse		;preskacha, ako e vdignat flaga za zumer v rejim impuls
;	rjmp	LE_BU_co_150	; prehod, ako ne e vdignat flaga za zumer v rejim impuls
	rjmp	LE_BU_co_200	; prehod, ako ne e vdignat flaga za zumer v rejim impuls

								; manage rejim rejim impuls end
	CBR	FLAG2,1<<F_Buzzer_pulse		;clear flag rejim impuls
								; proverka za zadejstvan PIR
;	SBRS	StatusPIR,PIR		;preskacha, ako e vdignat flaga za dvijenie
;	rjmp	LE_BU_co_130	; prehod, ako ne e vdignat flaga za dvijenie
									; PIR
								; set timer for buzzer
	ldi	ACCA,Buzzer_PIR_s	;period za dejstvie na zumera pri dvijenie [sec]
	sts	T_Buzzer_s,ACCA		;set timer for buzzer
			; BUZZER on
	SBI	PORTC,BUZZER	; BUZZER = 1 (Active)
	rjmp	LE_BU_co_200
LE_BU_co_130:
									; NONE
			; BUZZER off
	CBI	PORTC,BUZZER	; BUZZER = 0 (Inactive)
	CBR	FLAG2,1<<F_Buzzer		;clear flag aktiven zumer
	rjmp	LE_BU_co_200

LE_BU_co_150:
							; Zumer v rejim alarma
								; manage rejim zumer alarma end
									; set timer for buzzer
	ldi	ACCA,Buzzer_block_s	;period za blokirane na zumera [sec]
	sts	T_Buzzer_s,ACCA		;set timer for buzzer
	SBR	FLAG2,1<<F_Buzzer_block		;set flag blokiran zumer za opredelen period
			; BUZZER off
	CBI	PORTC,BUZZER	; BUZZER = 0 (Inactive)

LE_BU_co_200:


			;--- Manage LED ---v

					; Check and manage LED pulse request
	SBRC	FLAG2,LED_pulse_req		;preskacha, ako ne e vdignat flaga zaqvka za impuls na LED
	rcall	LEDpulse				; prehod, ako e vdignat flaga zaqvka za impuls na LED

					; Check and manage LED timout request
	SBRS	FLAG2,LED_timeout_req		;preskacha, ako e vdignat flaga zaqvka za iztekal period na tajmera na LED
	rjmp	LE_BU_co_300			; prehod, ako ne e vdignat flaga zaqvka za iztekal period na tajmera na LED

						; manage LED timout request
								; check for Low Battery level
	SBRS	FLAG,BatteryLow		;preskacha, ako e vdignat flaga za nisko nivo na bateriqta
	rjmp	LE_BU_co_300	; prehod, ako nivoto na bateriqta e normalno
									; Low Battery level
								; set timer for LED
	ldi	ACCA,LED_BatteryLow_s	;period na premigvane na svetodioda pri nisko nivo na bateriqta [sec]
	sts	T_LED_s,ACCA		;set timer for LED


LE_BU_co_300:

	ret



;==============================================================================
			; Manage_Battery_test
				; Input: none
				; Otput: none
				; Destroyed registers: ACCA
;==============================================================================
Manage_Battery_test:

					; Get battery level (ACCB:ACCD)
	rcall	GetBattery	; Get battery level (ACCB:ACCD)
	lsr	ACCB
	ror	ACCD
	lsr	ACCB
	ror	ACCD
	sts	BatteryLevel_V,ACCD		; = ACCB:ACCD / 4

	cpi	ACCD,BatteryLevel_100
	brpl	MaBaTe_100
	cpi	ACCD,BatteryLevel_0
	brpl	MaBaTe_050
	ldi	ACCA,0	; = 0%
	rjmp	MaBaTe_200
MaBaTe_050:
	subi	ACCD,BatteryLevel_0
	lsl		ACCD
	mov	ACCA,ACCD
	rjmp	MaBaTe_200
MaBaTe_100:
	ldi	ACCA,100	; = 100%
MaBaTe_200:
	sts	BatteryLevel_p,ACCA
				; Check Battery level = Low
	lds	ACCD,BatteryLevel_V
	cpi	ACCD,BatteryLevel_Low
	brpl	MaBaTe_300
									; Low Battery level
	SBR	FLAG,1<<BatteryLow		;set flag Low Battery
								; set timer for LED
	ldi	ACCA,LED_BatteryLow_s	;period na premigvane na svetodioda pri nisko nivo na bateriqta [sec]
	sts	T_LED_s,ACCA		;set timer for LED
	rjmp	MaBaTe_400

MaBaTe_300:
	CBR	FLAG,1<<BatteryLow		;clear flag Low Battery

MaBaTe_400:
					; Power Up WF module
	rcall	ESPpowerON	; power WF module enable  (Active = 1) /power ON/
	tst	ACCD	; test ERR code
	breq	MaBaTe_500	;ESPpowerON = OK
				;ERR or timeout
				;ERR power ON WF module
	ldi	ACCD,1	;ERR code = timout
	rjmp	MaBaTe_end

MaBaTe_500:
					; Send Battery level message to WiFi module
	rcall	SendBatteryLevelMess	; Send Battery level message to WiFi module

					; Power Down WF module
	rcall	ESPpowerOFF		;WF module power OFF


MaBaTe_end:

			; Clear flag Battery_test - otbelqzvane, che zaqvkata e obrabotena
	CBR		FLAG,1<<Battery_test		; Clear flag Battery_test

	ret

#ifdef ENABLE_OTA

;==============================================================================
            ; ManageOTA - manage regular OverTheAir (OTA)  updates
                ; Input: none
                ; Otput: ACCD - 0 - success, 1- error or no need to update
                ; Destroyed registers: ACCA
;==============================================================================
Manage_OTA:
                ; skip OTA if the battery level is low
#ifndef TEST_AUTO_OTA
    SBRC FLAG, BatteryLow
    rjmp MOTA_end
#endif

    rcall   ESPpowerON  ; power WF module enable  (Active = 1) /power ON/
    tst ACCD    ; test ERR code
    breq    MOTA_500  ;ESPpowerON = OK
                ;ERR or timeout
                ;ERR power ON WF module
    ldi ACCD,1  ;ERR code = timout
    rjmp    MOTA_end

MOTA_500:
    ; Do the real work
    rcall   SendOTAmess; Send OTA command
    rcall   ESPpowerOFF     ;WF module power OFF

MOTA_end:
    CBR FLAG3, 1<<F_OTA ; Clear OTA flag
    ret

#endif

;==============================================================================
			; ManageSMOKE_beg
				; Input: none
				; Otput: none
				; Destroyed registers: ACCA
;==============================================================================
ManageSMOKE_beg:
	push	ACCC

				; --- Set Zumer SMOKE alarm
	SBR		StatusSMOKE,1<<F_SMOKE_buzz		;set flag aktiviran zumer ot SMOKE d-k
	SBR		FLAG2,1<<F_Buzzer		;set flag aktiven zumer
	CBR		FLAG2,1<<F_Buzzer_pulse		;clear flag zumer v rejim impuls
	CBR		FLAG2,1<<F_Buzzer_block		;clear flag blokiran zumer za opredelen period

	ldi		ACCA,Buzzer_SMOKE_s		;period za dejstvie na zumera pri dim [sec]
	sts		T_Buzzer_s,ACCA			;ustanovqvane na tajmera za zumera

			; BUZZER on
	SBI		PORTC,BUZZER	; BUZZER = 1 (Active)

				; --- Set  SMOKE control and agrregate
	SBR		StatusSMOKE,1<<F_SMOKE		;set flag aktiven dimen datchik (v period za nablyudenie)
	SBR		StatusMODE,1<<F_AGGREGATE		;set flag aktiviran rejim na agregaciq
						; init timer for AGGREGATE
	ldi	ACCA,T_AGGREG_1min_ini
	sts	T_AGGREG_1min,ACCA

					; -- Init SMOKE var.
	ldi		ACCA,0
;	sts		T_smoke_ON_min,ACCA			;clear period ot nachalno zadejstvane smoke [min]
	sts		T_smoke_OFF_min,ACCA		;clear period ot izklyuchvane smoke [min]
	sts		Co_smoke_active,ACCA		;clear broqch na minuti s aktiven dimen datchik v perioda za agregaciq
	ldi		ACCA,T_smoke_agr_min_ini	;period za agregaciq smoke [min]
	sts		T_smoke_agr_min,ACCA		;init period za agregaciq smoke [min]

				; --- Send  SMOKE begining message

			; Disable pir on mode smoke
	lds	ACCA, DEV_MODE
	cpi	ACCA,ModeSmoke
	breq MaSmoBeg_end

	cpi	ACCA,ModeAlarm
	breq MaSmoBeg_end

					; Power Up WF module
	rcall	ESPpowerON	; power WF module enable  (Active = 1) /power ON/
	tst	ACCD	; test ERR code
	breq	MaSmoBeg_200	;ESPpowerON = OK
				;ERR or timeout
				;ERR power ON WF module
	ldi	ACCD,1	;ERR code = timout
	rjmp	MaSmoBeg_end

MaSmoBeg_200:
					; Send SMOKE Begining Message
	ldi		ACCB,1		;Parameter 1 /broj aktivni minuti za 5 minuten period/
	rcall	SendSMOKEmess	; Send SMOKE message to WiFi module

					; Check Temperature

	rcall	GetTemperature	; Get Temperature (ACCB:ACCD)
	;lsr	ACCB
	;ror	ACCD
	;lsr	ACCB
	;ror	ACCD
	sts	Temperature_U,ACCD		; = ACCB:ACCD / 4

	;lds	ACCD,Temperature_U
	rcall	ConvertTemperature	; Convert Temperature
	sts		Temperature_oC,ACCA

	cpi	ACCA,TemperaturePragHigh
	brlt	MaSmoBeg_500	; go to if Temperature < TemperaturePragHigh

				; Send Temperature message to WiFi module
	rcall	SendTemperatureMess	; Send Temperature message to WiFi module

MaSmoBeg_500:

	rcall	ESPpowerOFF		;WF module power OFF

MaSmoBeg_end:

			; Clear flag F_SMOKE_beg - otbelqzvane, che zaqvkata e obrabotena
	CBR		StatusSMOKE,1<<F_SMOKE_beg		; Clear flag

	pop		ACCC
	ret



;==============================================================================
			; ManageSMOKE_end
				; Input: none
				; Otput: none
				; Destroyed registers: ACCA
;==============================================================================
ManageSMOKE_end:

				; --- Set  SMOKE control and agrregate
	CBR		StatusSMOKE,1<<F_SMOKE		;clear flag aktiven dimen datchik (v period za nablyudenie)
					; -- Check aktiven PIR datchik (v period za nablyudenie)
	SBRS	StatusPIR,F_PIR		;preskacha, ako e aktiven PIR datchik (v period za nablyudenie)
	CBR		StatusMODE,1<<F_AGGREGATE		;clear flag aktiviran rejim na agregaciq
					; -- Init SMOKE var.
	ldi		ACCA,0
;	sts		T_smoke_ON_min,ACCA			;clear period ot nachalno zadejstvane smoke [min]
	sts		T_smoke_OFF_min,ACCA		;clear period ot izklyuchvane smoke [min]
	sts		Co_smoke_active,ACCA		;clear broqch na minuti s aktiven dimen datchik v perioda za agregaciq
	sts		T_smoke_agr_min,ACCA		;clear period za agregaciq smoke [min]


				; --- Send  SMOKE end message

					; Power Up WF module
	rcall	ESPpowerON	; power WF module enable  (Active = 1) /power ON/
	tst	ACCD	; test ERR code
	breq	MaSmoEnd_200	;ESPpowerON = OK
				;ERR or timeout
				;ERR power ON WF module
	ldi	ACCD,1	;ERR code = timout
	rjmp	MaSmoEnd_end

MaSmoEnd_200:
					; Send SMOKE end Message
	ldi		ACCB,0		;Parameter 1 /broj aktivni minuti za 5 minuten period/
	rcall	SendSMOKEmess	; Send SMOKE message to WiFi module

	rcall	ESPpowerOFF		;WF module power OFF

MaSmoEnd_end:

			; Clear flag F_SMOKE_end - otbelqzvane, che zaqvkata e obrabotena
	CBR		StatusSMOKE,1<<F_SMOKE_end		; Clear flag

	ret



;==============================================================================
			; ManagePIR_beg
				; Input: none
				; Otput: none
				; Destroyed registers: ACCA
;==============================================================================
ManagePIR_beg:


/*
			; LED on
	CBI	PORTB,LED		; LED = 0 (Active)

*/
;	rjmp	MaPI_beg_buzzer_start2

				; --- Set Zumer PIR alarm
					; -- Check active SMOKE alarm
	SBRC	StatusSMOKE,F_SMOKE_buzz		;preskacha, ako ne e aktiviran zumer ot SMOKE d-k
	rjmp	MaPI_beg_100		; prehod, ako e aktiviran zumer ot SMOKE d-k

	; --- Send  PIR begining message

	lds	ACCA, DEV_MODE
	cpi	ACCA,ModeAlarm
	breq MaPI_beg_buzzer_start

					; Power Up WF module
	rcall	ESPpowerON	; power WF module enable  (Active = 1) /power ON/
	tst	ACCD	; test ERR code
	breq	MaPI_beg_200	;ESPpowerON = OK
				;ERR or timeout
				;ERR power ON WF module
	ldi	ACCD,1	;ERR code = timout
	rjmp	MaPI_beg_buzzer_start

MaPI_beg_200:
					; Send PIR begining Message
	ldi		ACCB,1		;Parameter 1 /broj aktivni minuti za 180 minuten period/
	rcall	SendPIRmess	; Send PIR message to WiFi module

MaPI_beg_buzzer_start:
	rcall	ESPpowerOFF		;WF module power OFF
MaPI_beg_buzzer_start2:
	SBR		StatusPIR,1<<F_PIR_buzz		;set flag aktiviran zumer ot PIR d-k
	SBR		FLAG2,1<<F_Buzzer		;set flag aktiven zumer
	SBR		FLAG2,1<<F_Buzzer_pulse		;set flag zumer v rejim impuls
	CBR		FLAG2,1<<F_Buzzer_block		;clear flag blokiran zumer za opredelen period

	ldi		ACCA,Buzzer_pulse_s		;period za dejstvie na zumera v rejim pulse [sec]
	sts		T_Buzzer_s,ACCA			;ustanovqvane na tajmera za zumera


			; LED on
	CBI	PORTB,LED		; LED = 0 (Active)

	;		; BUZZER on
	;SBI		PORTC,BUZZER	; BUZZER = 1 (Active)

MaPI_beg_100:

				; --- Set  PIR control and agrregate
	SBR		StatusPIR,1<<F_PIR		;set flag aktiven PIR datchik (v period za nablyudenie)
	SBR		StatusMODE,1<<F_AGGREGATE		;set flag aktiviran rejim na agregaciq
						; init timer for AGGREGATE
	ldi	ACCA,T_AGGREG_1min_ini
	sts	T_AGGREG_1min,ACCA

					; -- Init PIR var.
	ldi		ACCA,0
;	sts		T_PIR_ON_min,ACCA			;clear period ot nachalno zadejstvane PIR [min]
	sts		T_PIR_OFF_min,ACCA		;clear period ot izklyuchvane PIR [min]
	sts		Co_PIR_active,ACCA		;clear broqch na minuti s aktiven PIR datchik v perioda za agregaciq
	ldi		ACCA,T_PIR_agr_min_ini	;period za agregaciq PIR [min]
	sts		T_PIR_agr_min,ACCA		;init period za agregaciq PIR [min]

MaPI_beg_end:


;---------------------- for TEST ----------------------------v
;	rcall tLED2pulse
;---------------------- for TEST ----------------------------^


			; Clear flag F_PIR_beg - otbelqzvane, che zaqvkata e obrabotena
	CBR		StatusPIR,1<<F_PIR_beg		; Clear flag

	ret



;==============================================================================
			; ManagePIR_end
				; Input: none
				; Otput: none
				; Destroyed registers: ACCA
;==============================================================================
ManagePIR_end:

			; LED off
	SBI	PORTB,LED		; LED = 1 (off)


				; --- Manage  PIR control and agrregate
	CBR		StatusPIR,1<<F_PIR		;clear flag aktiven PIR datchik (v period za nablyudenie)
					; -- Check aktiven smoke datchik (v period za nablyudenie)
	SBRS	StatusSMOKE,F_SMOKE		;preskacha, ako e aktiven dimen datchik (v period za nablyudenie)
	CBR		StatusMODE,1<<F_AGGREGATE		;clear flag aktiviran rejim na agregaciq
					; -- Init PIR var.
	ldi		ACCA,0
;	sts		T_PIR_ON_min,ACCA			;clear period ot nachalno zadejstvane PIR [min]
	sts		T_PIR_OFF_min,ACCA		;clear period ot izklyuchvane PIR [min]
	sts		Co_PIR_active,ACCA		;clear broqch na minuti s aktiven PIR datchik v perioda za agregaciq
	sts		T_PIR_agr_min,ACCA		;clear period za agregaciq PIR [min]


				; --- Send  PIR end message

					; Power Up WF module
	rcall	ESPpowerON	; power WF module enable  (Active = 1) /power ON/
	tst	ACCD	; test ERR code
	breq	MaPI_end_100	;ESPpowerON = OK
				;ERR or timeout
				;ERR power ON WF module
	ldi	ACCD,1	;ERR code = timout
	rjmp	MaPI_end_end

MaPI_end_100:
					; Send PIR end Message
	ldi		ACCB,0		;Parameter 1 /broj aktivni minuti za 180 minuten period/
	rcall	SendPIRmess	; Send PIR message to WiFi module

	rcall	ESPpowerOFF		;WF module power OFF

MaPI_end_end:

			; Clear flag F_PIR_end - otbelqzvane, che zaqvkata e obrabotena
	CBR		StatusPIR,1<<F_PIR_end		; Clear flag

	ret



;==============================================================================
			;  ManageAGGREGATE - SMOKE and PIR event
				; Input: none
				; Otput: none
				; Destroyed registers: ACCA
;==============================================================================
 ManageAGGREGATE:
					; -- Check aktiven smoke datchik (v period za nablyudenie)
	SBRS	StatusSMOKE,F_SMOKE		;preskacha, ako e aktiven dimen datchik (v period za nablyudenie)
	rjmp		MaAGG_500		;go to check PIR
						; Manage SMOKE aggregate
							; Check flag for SMOKE
	SBRS	StatusSMOKE,F_SMOKE_1min		;preskacha, ako e zadejstvan dimen datchik prez teku]ata minuta
	rjmp		MaAGG_100		;go to manage NO activ SMOKE
							; manage activ SMOKE (prez teku]ata minuta)
								; inc counter broj minuti s aktiven datchik v perioda za agregaciq
	lds	ACCA,Co_smoke_active
	inc	ACCA
	sts	Co_smoke_active,ACCA
								;clear flag zadejstvan SMOKE datchik prez teku]ata minuta
	CBR		StatusSMOKE,1<<F_SMOKE_1min		;clear flag zadejstvan SMOKE datchik prez teku]ata minuta
								; clear period ot izklyuchvane smoke [min]
	ldi	ACCA,0
	sts	T_smoke_OFF_min,ACCA

	rjmp MaAGG_200


MaAGG_100:
							; manage NO activ SMOKE
								; inc period ot izklyuchvane smoke [min]
	lds	ACCA,T_smoke_OFF_min
	inc	ACCA
	sts	T_smoke_OFF_min,ACCA
	cpi	ACCA,T_smoke_OFF_min_prag	;prag za prekratqvane na sledene SMOKE
	brne	MaAGG_200
							; prekratqvane na sledene SMOKE (Set flag F_SMOKE_end)
	SBR		StatusSMOKE,1<<F_SMOKE_end		; Set flag F_SMOKE_end
							; check flag F_PIR (sledene PIR)
	SBRC	StatusPIR,F_PIR		;preskacha, ako ne e aktiven PIR datchik (v period za nablyudenie)
	rjmp	MaAGG_500		;go to check PIR
								; stop aggregate ( no set aggregate timer )
	rjmp	MaAGG_end		;go end	 ( no set aggregate timer )

MaAGG_200:
							; dec and check period za agregaciq smoke [min]
	lds		ACCA,T_smoke_agr_min	;period za agregaciq smoke [min]
	dec	ACCA
	sts		T_smoke_agr_min,ACCA		;save period za agregaciq smoke [min]
	brne	MaAGG_500		;go to check PIR							???

							; manage end aggregate period smoke

									; --- Send  SMOKE aggregate message

					; Power Up WF module
	rcall	ESPpowerON	; power WF module enable  (Active = 1) /power ON/
	tst	ACCD	; test ERR code
	breq	MaAGG_210	;ESPpowerON = OK
				;ERR or timeout
				;ERR power ON WF module
	ldi	ACCD,1	;ERR code = timout
	rjmp	MaAGG_300

MaAGG_210:
					; Send SMOKE aggregate Message
	lds		ACCB,Co_smoke_active		;Parameter 1 /broj aktivni minuti za 5 minuten period/
	rcall	SendSMOKEmess	; Send SMOKE message to WiFi module

					; Check Temperature

	rcall	GetTemperature	; Get Temperature (ACCB:ACCD)
	;lsr	ACCB
	;ror	ACCD
	;lsr	ACCB
	;ror	ACCD
	sts	Temperature_U,ACCD		; = ACCB:ACCD / 4

	;lds	ACCD,Temperature_U
	rcall	ConvertTemperature	; Convert Temperature
	sts		Temperature_oC,ACCA

	cpi	ACCA,TemperaturePragHigh
	brlt	MaAGG_250	; go to if Temperature < TemperaturePragHigh

				; Send Temperature message to WiFi module
	rcall	SendTemperatureMess	; Send Temperature message to WiFi module

MaAGG_250:

	rcall	ESPpowerOFF		;WF module power OFF

MaAGG_300:

									; -- Init SMOKE var.
	ldi		ACCA,0
	sts		Co_smoke_active,ACCA		;clear broj minuti s aktiven datchik v perioda za agregaciq
	ldi		ACCA,T_smoke_agr_min_ini	;period za agregaciq smoke [min]
	sts		T_smoke_agr_min,ACCA		;init tajmer period za agregaciq smoke [min]



MaAGG_500:
					; -- Check aktiven PIR datchik (v period za nablyudenie)
	SBRS	StatusPIR,F_PIR		;preskacha, ako e aktiven PIR datchik (v period za nablyudenie)
	rjmp		MaAGG_end_0		;go to end

						; Manage PIR aggregate

							; Check flag for PIR
	SBRS	StatusPIR,F_PIR_1min		;preskacha, ako e zadejstvan PIR datchik prez teku]ata minuta
	rjmp		MaAGG_600		;go to manage NO activ PIR
							; manage activ PIR (prez teku]ata minuta)
								; inc counter broj minuti s aktiven datchik v perioda za agregaciq
	lds	ACCA,Co_PIR_active
	inc	ACCA
	sts	Co_PIR_active,ACCA
								;clear flag zadejstvan PIR datchik prez teku]ata minuta
	CBR		StatusPIR,1<<F_PIR_1min		;clear flag zadejstvan PIR datchik prez teku]ata minuta

								; clear period ot izklyuchvane smoke [min]
	ldi	ACCA,0
	sts	T_PIR_OFF_min,ACCA

	rjmp MaAGG_700

MaAGG_600:
							; manage NO activ PIR
								; inc period ot izklyuchvane PIR [min]
	lds	ACCA,T_PIR_OFF_min
	inc	ACCA
	sts	T_PIR_OFF_min,ACCA
	cpi	ACCA,T_PIR_OFF_min_prag	;prag za prekratqvane na sledene PIR
	brne	MaAGG_700
							; prekratqvane na sledene PIR (Set flag F_PIR_end)
	SBR		StatusPIR,1<<F_PIR_end		; Set flag F_PIR_end
							; check flag F_SMOKE (sledene SMOKE)
	SBRC	StatusSMOKE,F_SMOKE		;preskacha, ako ne e aktiven SMOKE datchik (v period za nablyudenie)
	rjmp	MaAGG_end_0		;go to end_0  ( set aggregate timer )
								; stop aggregate ( no set aggregate timer )
	rjmp	MaAGG_end		;go end	 ( no set aggregate timer )

MaAGG_700:
							; dec and check period za agregaciq PIR [min]
	lds		ACCA,T_PIR_agr_min	;period za agregaciq PIR [min]
	dec	ACCA
	sts		T_PIR_agr_min,ACCA		;save period za agregaciq PIR [min]
	brne	MaAGG_end_0		;go to end_0

							; manage end aggregate period PIR

									; --- Send  PIR aggregate message

					; Power Up WF module
	rcall	ESPpowerON	; power WF module enable  (Active = 1) /power ON/
	tst	ACCD	; test ERR code
	breq	MaAGG_710	;ESPpowerON = OK
				;ERR or timeout
				;ERR power ON WF module
	ldi	ACCD,1	;ERR code = timout
	rjmp	MaAGG_800

MaAGG_710:
					; Send PIR aggregate Message
	lds		ACCB,Co_PIR_active		;Parameter 1 /broj aktivni minuti za 180 minuten period/
	rcall	SendPIRmess	; Send PIR message to WiFi module

	rcall	ESPpowerOFF		;WF module power OFF

MaAGG_800:

									; -- Init PIR var.
	ldi		ACCA,0
	sts		Co_PIR_active,ACCA		;clear broj minuti s aktiven datchik v perioda za agregaciq
	ldi		ACCA,T_PIR_agr_min_ini	;period za agregaciq PIR [min]
	sts		T_PIR_agr_min,ACCA		;init tajmer period za agregaciq PIR [min]


MaAGG_end_0:
						; init timer for AGGREGATE
	ldi	ACCA,T_AGGREG_1min_ini
	sts	T_AGGREG_1min,ACCA

MaAGG_end:
			; Clear flag F_SMOKE_agr_end - otbelqzvane, che zaqvkata e obrabotena
	CBR		FLAG,1<<F_AGGREG_req		; Clear flag

	ret





;==============================================================================
			; Get Battery level
				; Input: none
				; Otput: ACCB:ACCD -> 10 bit battery level
				; Destroyed registers: ACCA
;==============================================================================
GetBattery:
				; Set Battery ADC channel
						; 0bxxxx0000 -> ADC0 (PA3) /Battery voltage/
	ldi		ACCC,0b00000000		; set ADC chanel = 0
				; Get ADC data result
	rcall	GetADCdata

	ret

;==============================================================================
			; Get Temperature
				; Input: none
				; Otput: ACCB:ACCD -> 10 bit Temperature
				; Destroyed registers: ACCA
;==============================================================================
GetTemperature:
				; Set Temperature ADC channel
						; 0bxxxx1110 -> Temperature sensor (internal)
	ldi		ACCC,0b00001110
				; Get ADC data result
	rcall	GetADCdata

	ret

;==============================================================================
			; Convert Temperature
				; Input: ACCD -> 8-bit temperature in units
				; Otput: ACCA -> 8-bit temperature in oC
				; Destroyed registers: ACCA, ACCD
;==============================================================================
ConvertTemperature:

	mov	ACCA, ACCD
	subi	ACCA,Tos_kor

	ret


;==============================================================================
			; Get ADC data
				; Input: ACCC -> ADC channel MUX
				; Otput: ACCB:ACCD -> 10 bit ADC data result
				; Destroyed registers: ACCA
;==============================================================================
GetADCdata:
				; Clear ADC Power Reduction bit
						; 0bxxxxxxx0 -> Enable ADC Power
	IN		ACCA,PRR
	ANDI	ACCA,0b11111110
	OUT		PRR,ACCA

	nop
				; Set ADC channel
	IN		ACCA,ADMUX
	ANDI	ACCA,0b11110000
	OR		ACCA,ACCC
	OUT		ADMUX,ACCA

				; Enable ADC
						; 0b1xxxxxxx -> Enable ADC
	IN		ACCA,ADCSRA
	ORI		ACCA,0b10000000
	OUT		ADCSRA,ACCA

				; Pause for establish Internal Voltage Reference
				; (nyama golqm efekt, moje i bez neq ili trqbva mnogo po-golqma?)
	LDI	ACCA,0xFF
PAUSE_IVR:
	nop
	DEC	ACCA
	BRNE	PAUSE_IVR

				; Start ADC Conversion
						; 0bx1xxxxxx -> Start Conversion
	IN		ACCA,ADCSRA
	ORI		ACCA,0b01000000
	OUT		ADCSRA,ACCA
				; Wait for ADC Conversion complete
GAd_100:
	IN		ACCA,ADCSRA
	sbrc	ACCA,ADSC
	rjmp	GAd_100
				; Get ADC result
	IN		ACCD,ADCL
	IN		ACCB,ADCH
				; Disable ADC
						; 0b0xxxxxxx -> Disable ADC
	IN		ACCA,ADCSRA
	ANDI	ACCA,0b01111111
	OUT		ADCSRA,ACCA
				; Set ADC Power Reduction bit
						; 0bxxxxxxx1 -> Disable ADC Power
	IN		ACCA,PRR
	ORI		ACCA,0b00000001
	OUT		PRR,ACCA

	ret


;==============================================================================
			; GetDevModEEP -> Read Device Mode from EEPROM
				; Input: none
				; Otput: ACCA -> Device Mode
				; Destroyed registers: ACCA
;==============================================================================
GetDevModEEP:
					; set address of data in EEPROM
	LDI	ACCD,LOW(DEV_MODE_eep)
					; read data from EEPROM (in ACCA)
	RCALL	EEPROM_read	; Read data byte from EEPROM

	ret


;==============================================================================
			; SaveDevModEEP -> Save Device Mode to EEPROM
				; Input: ACCA -> Device Mode
				; Otput: none
				; Destroyed registers: none
;==============================================================================
SaveDevModEEP:
					; set address of data in EEPROM
	LDI	ACCD,LOW(DEV_MODE_eep)
					; write data (ACCA) to EEPROM
	RCALL	EEPROM_write	; Write data byte to EEPROM

	ret


;==============================================================================
			; ClearRxBufUSART0 -> Clear Rx buffer USART0
				; Input: none
				; Otput: none
				; Destroyed registers: none
;==============================================================================
ClearRxBufUSART0:
	push ACCA

ClearRxBufUSART0_100:
			; Check for data byte in received buffer
	in		ACCA,UCSR0A
	sbrs	ACCA,RXC0
	rjmp ClearRxBufUSART0_end	; buffer is empty, go to end
			; Get received byte from buffer
	in ACCA, UDR0
	rjmp ClearRxBufUSART0_100

ClearRxBufUSART0_end:

	pop ACCA
	ret



/*

;;;;; COMUNICATE ;;;;;-----------------------------------------------
			;Izprastane na priet block kym PC

COMUNICATE:
				;load address of RX buffer first byte

	LDI	XL,LOW(RX_BUF)
	LDI	XH,HIGH(RX_BUF)

NEXT_TX:

	LD	ACCA,X+

				; izchakwane na oswobojdawane na predawat. buffer
wait_udr_empty:


	sbis	USR,UDRE
	RJMP	wait_udr_empty


				; nulirane na flaga TX complete
	SBI	USR,TXC
				; izprastane na byte
	OUT	UDR,ACCA

	CPI		ACCA,EndMessChar	;proverka za LF (kraj na syobstenieto)
	BREQ	WAIT_TXC

	CPI		XL,LOW(RX_PTR)	;proverka za kraj na bufera
	BREQ	WAIT_TXC

	RJMP	NEXT_TX


WAIT_TXC:
				; izchakwane na TX complete


	SBIS	USR,TXC
	RJMP	WAIT_TXC

	NOP
	NOP
	NOP


STOP_TX:

;END_COMUNICATE:

				; Clear TX_BLOCK flag (nulirane na flaga za poluchena zayavka za izprastane na blok)
	CBR	FLAG,1<<TX_BLOCK
				; Clear RX_BLOCK flag (nulirane na flaga za priet blok gotov za izprastane)
	CBR	FLAG,1<<RX_BLOCK

	RET


*/


;***************************************************************************
;*		 EEPROM_write -> Write data byte to EEPROM
;*						Input:	ACCA - data byte to write to EEPROM
;*								ACCD - address of data
;*						Otput: none
;*						Destroyed registers: ACCA, ACCD
;***************************************************************************
EEPROM_write:
	push ACCB
	IN	ACCB,SREG
	PUSH	ACCB

EEPROM_write_100:
				; Wait for completion of previous write
	sbic EECR, EEPE
	rjmp EEPROM_write_100
				; Disable interrupts
	cli ; Disable interrupts during timed sequence
				; Set Programming mode
	ldi ACCB, (0<<EEPM1)|(0<<EEPM0)
	out EECR, ACCB
				; Set up address (ACCD) in address register
	out EEARL, ACCD
				; Write data (ACCA) to data register
	out EEDR, ACCA
				; Write logical one to EEMPE
	sbi EECR, EEMPE
				; Start eeprom write by setting EEPE
	sbi EECR, EEPE
				;This instruction takes 4 clock cycles since
				;it halts the CPU for two clock cycles

	POP	ACCB
	OUT	SREG,ACCB	; restore SREG (include status of Interrrupt enable flag)
	pop	ACCB
	ret


;***************************************************************************
;*		 EEPROM_read -> Read data byte from EEPROM
;*						Input:	ACCD - address of data
;*						Otput:	ACCA - readed data byte from EEPROM
;*						Destroyed registers: ACCA, ACCD
;***************************************************************************
EEPROM_read:
	push ACCB
	IN	ACCB,SREG
	PUSH	ACCB

EEPROM_read_100:
					; Wait for completion of previous write
	sbic EECR, EEPE
	rjmp EEPROM_read_100
				; Disable interrupts
	cli ; Disable interrupts during timed sequence
					; Set up address (ACCD) in address registers
	out EEARL, ACCD
					; Start eeprom read by writing EERE
	sbi EECR, EERE
				;This instruction takes 4 clock cycles since
				;it halts the CPU for two clock cycles
					; Start eeprom read by writing EERE (2nd time)
	sbi EECR, EERE
				;This instruction takes 4 clock cycles since
				;it halts the CPU for two clock cycles
					; Read data from data register
	in ACCA, EEDR

	POP	ACCB
	OUT	SREG,ACCB	; restore SREG (include status of Interrrupt enable flag)
	pop	ACCB
	ret

#ifdef ENABLE_OTA

Soft_Reset:

#ifdef DEBUG
    SBI PORTC,BUZZER
#endif

    CLI                             ; Disable all interrupts
    SBR FLAG3, 1<<F_SOFT_RESET      ; Specify software reset
    rjmp $0000                      ; do software reset

#endif



;======================================================================================


;;;;;;;;;;;;;;;;; EEPROM SEGMENTS ;;;;;;;;;;;;;;;;;;;;

.ESEG

.ORG	$010
DEV_MODE_eep:	.DB	Dev_MODE_Default	;Save Device mode in EEPROM

