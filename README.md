## Introduction

This is the source code of the firmware used in the Attiny microcontroller that is part of the [U:Kit sensor kit](https://github.com/attachix/ukit) project.

## Requirements
### Software

In order to compile and flash the source code and do some modifications to it you will need
* AVR Assembler. Our recommendation is to use the assembler compiler coming with AVR Studio 6 or later
* AVR binutils. In Ubuntu 16.04 you can install them with the following command `sudo apt install binutils-avr`.
* AVR Dude. In Ubuntu 16.04 you can install it with the following command `sudo apt install avrdude`.

### Hardware
* AVR programmer. A cheap [USBasp](http://www.fischl.de/usbasp/) or similar will be perfectly enough. Make sure that you have the latest firmware flashed on the programmer.

## Copyright
Copyright (c) 2016-2018, Slavey Karadzhov. All rights reserved.

## Authors
* Cviatko Delchev <cviatko@attachix.com> - The biggest part of the code is done by him.
* Slavey Karadzhov <slav@attachix.com> - Documentation and small changes for the factory default reset.
* .. Contributors - See https://github.com/attachix/ukit-attiny-firmware/graphs/contributors

## License
All files in this repository are licensed under GPLv2. See the [LICENSE](LICENSE) file details.