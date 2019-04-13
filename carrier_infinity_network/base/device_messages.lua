--[[=============================================================================
    Get, Handle and Dispatch message functions

    Copyright 2015 Control4 Corporation. All Rights Reserved.
===============================================================================]]

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.device_messages = "2014.10.31"
end

--[[=============================================================================
    GetMessage()
  
    Description:
    Used to retrieve a message from the communication buffer. Each driver is
    responsible for parsing that communication from the buffer.
  
    Parameters:
    None
  
    Returns:
    A single message from the communication buffer
===============================================================================]]
function GetMessage()
	local message, pos
	local pattern = "(S%d.+)\r\n()"
	
	if ((gReceiveBuffer ~= nil) and (gReceiveBuffer ~= "")) then
		if (gReceiveBuffer:len() > 0) then
			message, pos = string.match(gReceiveBuffer, pattern, messagePos)
			LogDebug("message = %s", tostring(message))
	
			if (message == nil) then
				LogDebug("Do not have a complete message.")
				return ""
			end
			gReceiveBuffer = gReceiveBuffer:sub(pos)
		end
	end

	return message
end

--[[=============================================================================
    HandleMessage(message)]

    Description
    This is where we parse the messages returned from the GetMessage()
    function into a command and data. The call to 'DispatchMessage' will use the
    'name' variable as a key to determine which handler routine, function, should
    be called in the DEV_MSG table. The 'value' variable will then be passed as
    a string parameter to that routine.

    Parameters
    message - Message string containing the function and value to be sent to DispatchMessage

    Returns
    Nothing
===============================================================================]]
function HandleMessage(message)
	LogTrace("HandleMessage. Message is ==>%s<==", message)

	local system, zone, pos
	
	-- get the system
	system, pos = string.match(message, "S(%d)().+")
	if (system == nil) then
		LogError("Invalid Command: %s", message)
		gCon:HandleACK()
		return
	end
	--LogDebug("system = %s", tostring(system))
	
	-- get the zone
	local zone, zonePos = string.match(message, "Z(%d)().+", pos)
	if (zone ~= nil) then
		pos = zonePos
		--LogDebug("zone = %s", tostring(zone))
	end
	
	-- get the command and value
	local command, value = string.match(message, "(%a+):(.*)", pos)
	if (command == nil) then
		LogError("Invalid Command: %s", message)
		gCon:HandleACK()
		return
	end
	
	-- check for ACK/NAK
	if ((value == "ACK") or (string.match(value, "^(NAK).-") == "NAK")) then
		LogInfo("ACK/NAK message received: value =  %s", tostring(value))
		gCon:HandleACK()
		return
	end

	DispatchMessage(command, value, system, zone)
	gCon:HandleACK()
end

--[[=============================================================================
    DispatchMessage(MsgKey, MsgData)

    Description
    Parse routine that will call the routines to handle the information returned
    by the connected system.

    Parameters
    MsgKey(string)  - The function to be called from within DispatchMessage
    MsgData(string) - The parameters to be passed to the function found in MsgKey

    Returns
    Nothing
===============================================================================]]
function DispatchMessage(MsgKey, MsgData, ...)
	-- if program command
	if (string.match(MsgKey, "^(PGM).-") == "PGM") then
		pgmCmd = string.match(MsgKey, "^PGM(.*)")
		
		local day, entry
		if (string.sub(pgmCmd, 1, 1) == "T") then
			day, entry = string.match(pgmCmd, "^(....)(.*)")
		else
			day, entry = string.match(pgmCmd, "^(...)(.*)")
		end
		
		if (DEV_MSG["PGM"] ~= nil and (type(DEV_MSG["PGM"]) == "function")) then
			LogInfo("DEV_MSG.%s: %s, %s", pgmCmd, MsgKey, MsgData)
			local status, err = pcall(DEV_MSG["PGM"], MsgData, day, entry, ...)
			if (not status) then
				LogError("LUA_ERROR: %s", err)
			end
		else
			LogTrace("HandleMessage: Unhandled command = PGM, %s", MsgKey)
		end
	elseif (DEV_MSG[MsgKey] ~= nil and (type(DEV_MSG[MsgKey]) == "function")) then
		LogInfo("DEV_MSG.%s:  %s", MsgKey, MsgData)
		local status, err = pcall(DEV_MSG[MsgKey], MsgData, ...)
		if (not status) then
			LogError("LUA_ERROR: %s", err)
		end
	else
		LogTrace("HandleMessage: Unhandled command = %s", MsgKey)
	end
end

-- system commands
function DEV_MSG.MODE(value, system, zone)
	local state, fanState
	mode, state = value:match("^(%a+)%s*(%d*)")

	-- Does not support FAN_STATE
	--if (tostring(state) ~= "") then fanState = "ON" else fanState = "OFF" end
	--SendToDevice(system, nil, "FAN_STATE", {STATE = fanState})

	if (mode == "EHEAT") then mode = "EMERGENCYHEAT" end

    if (state ~= "") then 
        if (mode == "COOL") then
	        SendToDevice(system, nil, "HVACSTATE_CHANGED", {HVACSTATE = mode})
        elseif (mode == "HEAT") then 
	        SendToDevice(system, nil, "HVACSTATE_CHANGED", {HVACSTATE = mode})
        elseif (mode == "AUTO") then 
            -- One way to do this might be to look at current temperature and then the heat setpoint, cool setpoint and the temperature. 
            -- For now, when in auto we will just leave it as off.
	        SendToDevice(system, nil, "HVACSTATE_CHANGED", {HVACSTATE = 'OFF'})
        end
    else 
	        SendToDevice(system, nil, "HVACSTATE_CHANGED", {HVACSTATE = 'OFF'})
    end 

	SendToDevice(system, nil, "HVACMODE_CHANGED", {HVACMODE = mode})
end

function DEV_MSG.CFGEM(value, system, zone)
	SendToDevice(system, nil, "SCALE_CHANGED", {SCALE = value})
end

function DEV_MSG.OAT(value, system, zone)
	local outdoorTemp = string.match(value, "(%d+).+")
	SendToDevice(system, nil, "OUTDOOR_TEMPERATURE_CHANGED", {TEMPERATURE = outdoorTemp})
end

function DEV_MSG.CFGTYPE(value, system, zone)
	local canHeat, canCool = false
	
	if (value == "HEATCOOL") then
		canHeat = true
		canCool = true
		value = "OFF,HEAT,COOL"
		gHVACModes = value
		
		if (gSysAutoMode) then
			value = value .. ",AUTO"
		end
	else
		if (value == "HEAT") then
			canHeat = true
			canCool = false
		else
			canHeat = false
			canCool = true
		end
		
		value = "OFF," .. value
		gHVACModes = value
	end

	local tParams = {}
	tParams["MODES"] = value
	tParams["CAN_HEAT"] = canHeat
	tParams["CAN_COOL"] = canCool
	tParams["CAN_AUTO"] = gSysAutoMode
	
	SendToDevice(system, nil, "SYSTEMMODES_CHANGED", tParams)
end

function DEV_MSG.CFGAUTO(value, system, zone)
	gSysAutoMode = (value == "ON")
	
	if (gHVACModes ~= nil and gHVACModes ~= "") then
		local modes = gHVACModes
		if (gSysAutoMode) then
			modes = modes .. ",AUTO"
		end

		local tParams = {}
		tParams["MODES"] = modes
		tParams["CAN_HEAT"] = true
		tParams["CAN_COOL"] = true
		tParams["CAN_AUTO"] = gSysAutoMode

		SendToDevice(system, nil, "SYSTEMMODES_CHANGED", tParams)
	end
end

-- zone commands
function DEV_MSG.FAN(value, system, zone)
	if (value == "MED") then value = "MEDIUM" end
	SendToDevice(system, zone, "FANMODE_CHANGED", {FANMODE = value})
end

-- This is for a perm hold.
function DEV_MSG.HOLD(value, system, zone)
	if (value == "OFF") then
        QueuePriority1Command(string.format('S%dZ%dOVR?', system, zone));
	elseif (value == "ON") then
		SendToDevice(system, zone, "HOLDMODE_CHANGED", { HOLDMODE = "Permanent" })
        SendToDevice(system, zone, "MESSAGE_CHANGED", { MESSAGE = "Permanent Hold" })
	end
end

-- This is for a hold until, you need to query OTMR to determine time left. 
function DEV_MSG.OVR(value, system, zone)
	if (value == "OFF") then
		SendToDevice(system, zone, "HOLDMODE_CHANGED", {HOLDMODE = "Off"})
        SendToDevice(system, zone, "MESSAGE_CHANGED", { MESSAGE = "Following Schedule" })
	elseif (value == "ON") then
        QueuePriority1Command(string.format('S%dZ%dOTMR?', system, zone));
		SendToDevice(system, zone, "HOLDMODE_CHANGED", {HOLDMODE = "Temporary"})
	end
end

function DEV_MSG.OTMR(value, system, zone)
    if (value ~= "00:00") then 
        hour, min = string.match(value,"(%d+):(%d+)");
        SendToDevice(system, zone, "MESSAGE_CHANGED", { MESSAGE = string.format("Holding for %d hours and %d minutes", hour, min) })
    end
end

function DEV_MSG.HTSP(value, system, zone)
	local setPoint = string.match(value, "(%d+).+")
	SendToDevice(system, zone, "HEAT_SETPOINT_CHANGED", {SETPOINT = setPoint})
end

function DEV_MSG.CLSP(value, system, zone)
	local setPoint = string.match(value, "(%d+).+")
	SendToDevice(system, zone, "COOL_SETPOINT_CHANGED", {SETPOINT = setPoint})
end

function DEV_MSG.RT(value, system, zone)
	local roomTemp = string.match(value, "(%d+).+")
	SendToDevice(system, zone, "TEMPERATURE_CHANGED", {TEMPERATURE = roomTemp})
end

function DEV_MSG.RH(value, system, zone)
	local roomHumidity = string.match(value, "(%d+).+")
	SendToDevice(system, zone, "HUMIDITY_CHANGED", {HUMIDITY = roomHumidity})
end
