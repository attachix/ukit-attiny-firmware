INT0_ISR: 
    Checks if button was pressed (PINC & BUTTON) 
    Sets 
        FLAG,1<<BUTTONpressed
    on button pressed. Clears otherwise
    Side effects: None
     
PCINT0_ISR:
    Checks interrupts on PINA and detects if we have SMOKE or PIR (PINA & SMOKE) || (PINA & PIR)
    Sets 
        StatusSMOKE,1<<SMOKE
        StatusSMOKE,1<<F_SMOKE_beg
        StatusPIR,1<<PIR
        StatusPIR,1<<F_PIR_beg
    on smoke or motion. Clears otherwise
    Side effects: None

WDT_ISR:
     Seconds, minutes, hours and days are calculated here.
     Set flags
        SBR FLAG,1<<Battery_test    ; if the time has come to check the battery level
        SBR FLAG3 ,1<<F_OTA         ; if the time has come to do OTA
        SBR FLAG2,1<<BUZZ_pulse_req     ;set flag zaqvka za impuls na zumera // Manage BUZZER
        SBR FLAG2,1<<LED_pulse_req      ;set flag zaqvka za impuls na LED
        SBR FLAG,1<<F_button_prag1 ;set flag che e preminat prag1 za zadyrjan buton (5 sekundi)
        SBR FLAG,1<<F_button_prag2 ;set flag che e preminat prag2 za zadyrjan buton (15 sekundi)
        SBR FLAG,1<<F_AGGREG_req        ;set flag che e iztekal perioda za AGGREGATE (1 min)
        SBR StatusSMOKE,1<<F_SMOKE_1min     ;set flag zadejstvan dimen datchik prez teku]ata minuta
        SBR StatusPIR,1<<F_PIR_1min     ;set flag zadejstvan PIR datchik prez teku]ata minuta
        SBR FLAG2,1<<COMM_timeout_req       ;zaqvka za iztekal period na tajmera za COMMUNICATION timeout
        
        
        F_Buzzer_block ???
       
     Aggregate ... 
     RCALL LED_BUZZ_control

RESET: 
    Initialize all variables (Flags,Registers, Timers, Watchdogs, States, PINS, Interrupts, etc. )

MAIN:
    Trigger actions based on flags
    
Actions:
    ManageSMOKE_beg
    ManageSMOKE_end
    Manage_Battery_test
    Manage_OTA
    ManagePIR_beg
    ManagePIR_end
    ManageAGGREGATE
 
LED_BUZZ_control: 
    Manage Led and Buzzer
    
    Buzzer
    T_Buzzer_s = seconds 
    F_Buzzer_pulse
    

LED & Buzzer Pulse:
    tLED1pulse
    tLED2pulse
    BuzzerPulse
    LEDpulse
    
Pauses:
    PAUSE_new - 400 ms
    PauseACCCx10ms
    
Manage_button_prag1:
    SBR     FLAG2,1<<F_Buzzer_block     ; Set flag F_Buzzer_block
    
    
https://www.mikrocontroller.net/articles/AVR-Tutorial:_Interrupts
http://www.avr-asm-tutorial.net/avr_en/beginner/PORTS.html
