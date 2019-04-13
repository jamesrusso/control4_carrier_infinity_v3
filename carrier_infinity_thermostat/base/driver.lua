--[[=============================================================================
    Basic Template for Driver

    Copyright 2015 Control4 Corporation. All Rights Reserved.
===============================================================================]]
require "common.c4_driver_declarations"
require "common.c4_common"
require "common.c4_init"
require "common.c4_property"
require "common.c4_command"
require "common.c4_notify"
require "common.c4_utils"
require "lib.c4_timer"
require "actions"
require "device_specific_commands"
require "device_messages"
require "proxy_init"
require "properties"
require "proxy_commands"
require "connections"
require "extras"

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.driver = "2014.10.31"
end

--[[=============================================================================
    Initialization Code
===============================================================================]]
function ON_DRIVER_EARLY_INIT.main()
	CARRIER_BINDING_ID = 1
	
	gScale = "F"
	gEmergencyMode = false
end

function ON_DRIVER_INIT.main()
	SetLogName("carrier_infinity_thermostat_c4z")

	C4:AddVariable("EMERGENCY_MODE", "", "BOOL", false, false)
end

function ON_DRIVER_LATEINIT.main()
	gTStatProxy:dev_ExtrasSetup(GetExtrasSetup())
end

function SendToProxy(idBinding, command, tParams)
	LogTrace("SendToProxy (%s, %s)", idBinding, command)
	LogTrace(tParams)
	C4:SendToProxy(idBinding, command, tParams)
end

function SendToCarrier(command, tParams)
	LogTrace("SendToCarrier(%s)", command)
	tParams["SYSTEM"] = Properties["System"]
	tParams["ZONE"] = Properties["Zone"]

	SendToProxy(CARRIER_BINDING_ID, command, tParams)
end

function AddDriverToCarrier()
	local tParams = {DEVICE_ID = C4:GetDeviceID()}
	SendToCarrier("ADD_DRIVER", tParams)
end

function RemoveDriverFromCarrier()
	local tParams = {DEVICE_ID = C4:GetDeviceID()}
	SendToCarrier("REMOVE_DRIVER", tParams)
end

function PRX_CMD.AV_BINDINGS_CHANGED(bindingID, tParams)
	AddDriverToCarrier()
end
