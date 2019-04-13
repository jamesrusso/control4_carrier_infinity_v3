# control4_carrier_infinity_v3
Carrier Infinity Touch Control4 Driver for use with SAM Module Serial Connection

This driver was adapted from the V2 driver provided by Control4. This enables
Control4 to work with Carrier Infinity or Bryant Evolution systems. This driver
requires the use of a SAM module. There are two options, the SYSTXCCRCT01 module
which has a wired Ethernet module or the SYSTXCCRWF01 module which is wifi enabled.

However, the Wifi or the Ethernet portion of these modules will not be used. They were
used for the older UID/UIZ based systems, so the SYSTXCCRCT01 module is likely cheaper
and the easiest solution. 

This module does not support Scheduling. It is not available via the API for infinity touch.

This module does provide an occupied/unoccupied mode which will set the zone to the AWAY comfort
profile in a permant hold and then when set to OCCUPIED it'll return to the schedule. This is available
on the Extra table as well as a command on the Thermostat themselves. This enables a programmable way to
setback the thermostats when you leave the house

You connect a controller to the serial port of the SYSTXCCRCT01/SYSTXCCRWF01 SAM module.

James Russo
Halo3 Consulting, LLC
jr@halo3.net
