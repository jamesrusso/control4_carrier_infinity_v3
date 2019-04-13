--[[=============================================================================
    Main script file for driver

    Copyright 2015 Control4 Corporation. All Rights Reserved.
===============================================================================]]
require "common.c4_driver_declarations"
require "common.c4_common"
require "common.c4_init"
require "common.c4_property"
require "common.c4_command"
require "common.c4_utils"
require "lib.c4_timer"
require "actions"
require "device_specific_commands"
require "device_messages"
require "properties"
require "proxy_commands"
require "connections"

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.driver = "2014.10.31"
end

--[[=============================================================================
    Initialization Code
===============================================================================]]
function ON_DRIVER_EARLY_INIT.main()
	---- global vars ----
	gDeviceList = {}
	gSysAutoMode = false
	gSetpointHoldMode = "Permanent"
	gCanHeatCool = true
	gPollCnt = 1
end

function ON_DRIVER_INIT.main()
	SetLogName("carrier_infinity_c4z")
end

function ON_DRIVER_LATEINIT.main()
end

