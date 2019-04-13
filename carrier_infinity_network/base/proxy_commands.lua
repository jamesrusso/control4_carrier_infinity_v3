--[[=============================================================================
    Commands received from the Carrier Thermostat drivers (ReceivedFromProxy)

    Copyright 2015 Control4 Corporation. All Rights Reserved.
===============================================================================]]

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.proxy_commands = "2014.10.31"
end

PROXY_ID = 2

-- Commands received from carrier_infinity_thermostat drivers
function PRX_CMD.ADD_DRIVER(bindingID, tParams)
	local system = tParams["SYSTEM"]
	local zone = tParams["ZONE"]
	local deviceId = tParams["DEVICE_ID"]

	gDeviceList[deviceId] = {}
	gDeviceList[deviceId].system = system
	gDeviceList[deviceId].zone = zone

	if (gCon ~= nil and gCon._IsConnected) then
		GetDeviceSettings(system, zone)
	end
end

function PRX_CMD.REMOVE_DRIVER(bindingID, tParams)
	local deviceId = tParams["DEVICE_ID"]
	
	gDeviceList[deviceId] = nil
end

function PRX_CMD.CURRENT_SETTINGS(bindingID, tParams)
	GetSystemSettings(tParams)
	GetDeviceSettings(system, zone)
end

function PRX_CMD.SET_MODE(bindingID, tParams)
	local system = tParams["SYSTEM"]
	local hvacMode = tParams["HVACMODE"]
	
	QueuePriority1Command(string.format("S%dMODE!%s", system, hvacMode))	-- set mode
	QueuePriority1Command(string.format("S%dMODE?", system))				-- query current mode
end

function PRX_CMD.SET_FAN_MODE(bindingID, tParams)
	local system = tParams["SYSTEM"]
	local zone = tParams["ZONE"]
	local fanMode = tParams["FANMODE"]
	
	if ("medium" == string.lower(fanMode)) then
		fanMode = "MED"
	end

	QueuePriority1Command(string.format("S%dZ%dFAN!%s", system, zone, fanMode))	-- set fan mode
	QueuePriority1Command(string.format("S%dZ%dFAN?", system, zone))				-- query current fan mode
end

function PRX_CMD.SET_HEAT_SETPOINT(bindingID, tParams)
	local system = tParams["SYSTEM"]
	local zone = tParams["ZONE"]

    cmd = string.format("S%dZ%dHTSP!%s", system, zone, tParams["SETPOINT"])

    if (gSetpointHoldMode ~= "Permanent") then 
        cmd = cmd .. ",".. gSetpointHoldMode
    end 

	QueuePriority1Command(string.format("S%dZ%dHTSP?", system, zone))						-- query current heat setpoint
	QueuePriority1Command(string.format("S%dZ%dHOLD?", system, zone))
end

function PRX_CMD.SET_COOL_SETPOINT(bindingID, tParams)
	local system = tParams["SYSTEM"]
	local zone = tParams["ZONE"]

    cmd = string.format("S%dZ%dCLSP!%s", system, zone, tParams["SETPOINT"])

    LogInfo(gSetpointHoldMode)
    if (gSetpointHoldMode ~= "Permanent") then 
        cmd = cmd .. ",".. gSetpointHoldMode
    end 

	QueuePriority1Command(cmd)
	QueuePriority1Command(string.format("S%dZ%dCLSP?", system, zone))						-- query current cool setpoint
	QueuePriority1Command(string.format("S%dZ%dHOLD?", system, zone))
end

function PRX_CMD.SET_SCALE(bindingID, tParams)
	local system = tParams["SYSTEM"]
	local scale = tParams["SCALE"]
	
	if (string.sub(scale, 1, 1) == "F") then
		scale = "E"
	else
		scale = "M"
	end
	
	QueuePriority1Command(string.format("S%dCFGEM!%s", system, scale))	-- set scale
	C4:SendToProxy(PROXY_ID, "SCALE_CHANGED", tParams)			-- 
	QueuePriority1Command(string.format("S%dCFGEM?", system))			-- query current scale
end

function PRX_CMD.SET_HOLD_MODE(bindingID, tParams)
	local system = tParams["SYSTEM"]
	local zone = tParams["ZONE"]
	local holdMode = tParams["HOLDMODE"]
	local cmd

	if (holdMode == "Off") then
		cmd = string.format("S%dZ%dHOLD!OFF", system, zone)
	elseif (holdMode == "Permanent") then
		cmd = string.format("S%dZ%dHOLD!ON", system, zone)
	elseif (holdMode == "Temporary") then
		cmd = string.format("S%dZ%dOTMR!02:00", system, zone)
	else 
		LogError(string.format("HOLDMODE %s is not supported", holdMode))
		return
	end

	QueuePriority1Command(cmd)											-- set hold mode
	QueuePriority1Command(string.format("S%dZ%dHOLD?", system, zone))
   
    -- If we are setting hold mode to Off then it'll resume the schedule. So we need to look up the current set points.  
    if (holdMode == "Off") then  
	    QueuePriority1Command(string.format("S%dZ%dCLSP?", system, zone))
	    QueuePriority1Command(string.format("S%dZ%dHTSP?", system, zone))
    end
end

function PRX_CMD.SET_OCCUPIED_MODE(bindingId, tParams)
	local system = tParams["SYSTEM"]
	local zone = tParams["ZONE"]
    if (tParams['OCCUPIED_MODE'] == 'UNOCCUPIED') then 
		QueuePriority1Command(string.format("S%dZ%dHOLD!OFF", system, zone))
    	QueuePriority1Command(string.format("S%dZ%dUNOCC!ON", system, zone))
    else 
    	QueuePriority1Command(string.format("S%dZ%dHOLD!OFF", system, zone))
    end
end


function PRX_CMD.REFRESH_DATA(bindingId, tParams)
	local system = tParams["SYSTEM"]
	local zone = tParams["ZONE"]
    GetDeviceSettings(system,zone)
end
