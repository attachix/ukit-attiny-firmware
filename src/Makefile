
AVRASM=avrasm

AVR_PROGRAMMER ?= usbasp
# AVR_PROGRAMMER ?= avrispmkII

TSB_PATH=../tsb
TOOLS_PATH=../tools

V ?= $(VERBOSE)
ifeq ("$(V)","1")
Q :=
vecho := @true
else
Q := @
vecho := @echo
endif

all: build/main.hex

-include Makefile-user.mk

build/main.hex: main.asm settings.h.asm
	$(Q) $(AVRASM) main $(ASM_FLAGS)
	
build/main.bin: build/main.hex
	$(Q) hex2bin.py $< $@

$(TSB_PATH)/build/tsb_tinymega.hex: $(TSB_PATH)/tsb_tinymega.asm
	$(Q) $(MAKE) -C $(TSB_PATH) 

tsb: $(TSB_PATH)/build/tsb_tinymega.hex

flash-tsb: tsb 
	$(Q) echo "Flashing TSB first. Press enter when the MCU1 device is ready for flashing..."
	$(Q) read line
	$(Q) $(MAKE) -C $(TSB_PATH) flash
	
ota-app: build/main.bin
	$(Q) echo  "Flashing AVR-APP. Make sure that MCU1 is connected to your PC via USB serial. Press Enter to continue."
	$(Q) read line
	$(Q) python $(TOOLS_PATH)/esp_sim.py build/main.bin

ota: flash-tsb ota-app

flash: build/main.hex
	$(Q) sudo avrdude -c $(AVR_PROGRAMMER) -p t1634 -B 12 $(WRITE_OPTS) -e -U flash:w:build/main.hex:i
	
dump-flash: 
	$(Q) sudo avrdude -c $(AVR_PROGRAMMER) -p t1634 -B 12 $(WRITE_OPTS) -e -U flash:r:"dump-flash.bin":r
	
