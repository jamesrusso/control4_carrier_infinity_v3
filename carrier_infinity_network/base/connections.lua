--[[=============================================================================
    Functions for managing the status of the drivers bindings and connection state
 
    Copyright 2015 Control4 Corporation. All Rights Reserved.
===============================================================================]]
require "common.c4_serial_connection"

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.connections = "2014.10.31"
end

-- constants
COM_USE_ACK = true
COM_COMMAND_DELAY_MILLISECONDS = 6000
COM_COMMAND_RESPONSE_TIMEOUT_SECONDS = 6

NETWORK_PORT = 1000
IR_BINDING_ID = -1
SERIAL_BINDING_ID = 1
NETWORK_BINDING_ID = 6000

PRIORITY_2_COUNT = 5
PRIORITY_3_COUNT = 10

PRIORITY_1 = 1
PRIORITY_2 = 2
PRIORITY_3 = 3

--[[=============================================================================
    OnSerialConnectionChanged(idBinding, class, bIsBound)
  
    Description:
    Function called when a serial binding changes state(bound or unbound).
  
    Parameters:
    idBinding(int) - ID of the binding whose state has changed (SERIAL_BINDING_ID).
    class(string)  - Class of binding that has changed.
                     A single binding can have multiple classes(i.e. COMPONENT,
                     STEREO, RS_232, etc).
                     This indicates which has been bound or unbound.
    bIsBound(bool) - Whether the binding has been bound or unbound.
  
    Returns:
    None
===============================================================================]]
function OnSerialConnectionChanged(idBinding, class, bIsBound)
	LogTrace("OnSerialConnectionChanged(%d, %s, %s)", idBinding, class, bIsBound)
	gSerialBound = bIsBound

	if (bIsBound) then
		-- GetAllSystemSettings()
		GetSystemSettings({SYSTEM = 1})
		GetSystemSettings({SYSTEM = 2})
		GetCurrentSettings()
		gCon:StartPolling()
	else
		gCon:StopPolling()
	end
end

--[[=============================================================================
    OnIRConnectionChanged(idBinding, class, bIsBound)
  
    Description:
    Function called when an IR binding changes state(bound or unbound).
  
    Parameters:
    idBinding(int) - ID of the binding whose state has changed (SERIAL_BINDING_ID).
    class(string)  - Class of binding that has changed.
                     A single binding can have multiple classes(i.e. COMPONENT,
                     STEREO, RS_232, etc).
                     This indicates which has been bound or unbound.
    bIsBound(bool) - Whether the binding has been bound or unbound.
  
    Returns:
    None
===============================================================================]]
function OnIRConnectionChanged(idBinding, class, bIsBound)
	
end

--[[=============================================================================
    OnNetworkConnectionChanged(idBinding, bIsBound)
  
    Description:
    Function called when a network binding changes state(bound or unbound).
  
    Parameters:
    idBinding(int) - ID of the binding whose state has changed.
    bIsBound(bool) - Whether the binding has been bound or unbound.
  
    Returns:
    None
===============================================================================]]
function OnNetworkConnectionChanged(idBinding, bIsBound)
	
end

--[[=============================================================================
    OnNetworkStatusChanged(idBinding, nPort, sStatus)
  
    Description:
    Called when the network connection status changes. Sets the updated status of the specified binding
  
    Parameters:
    idBinding(int)  - ID of the binding whose status has changed
    nPort(int)      - The communication port of the specified bindings connection
    sStatus(string) - "ONLINE" if the connection status is to be set to Online,
                      any other value will set the status to Offline
  
    Returns:
    None
===============================================================================]]
function OnNetworkStatusChanged(idBinding, nPort, sStatus)
	
end

--[[=============================================================================
    OnURLConnectionChanged(url)
  
    Description:
    Function called when the c4_url_connection is created.
  
    Parameters:
    url - url used by the url connection.
  
    Returns:
    None
===============================================================================]]
function OnURLConnectionChanged(url)
	
end

--[[=============================================================================
    DoEvents()
  
    Description:
    
  
    Parameters:
    None
  
    Returns:
    None
===============================================================================]]
function DoEvents()
end

--[[=============================================================================
    SendKeepAlivePollingCommand()
  
    Description:
    Sends a driver specific polling command to the connected system
  
    Parameters:
    None
  
    Returns:
    None
===============================================================================]]
function SendKeepAlivePollingCommand()
	--TODO: Implement the keep alive command for the network connected system if required.
end

function QueueCommand(sCommand)
	LogTrace("QueueCommand(%s)", sCommand)
	if (gCon ~= nil) then
		gCon:QueueCommand(sCommand .. "\r\n")
	else
		LogError("Error: Unable to send command: %s", sCommand)
	end
end

function QueuePriority1Command(sCommand)
--	LogTrace("QueuePriority1Command(%s)", sCommand)
	if (gCon ~= nil) then
		gCon:QueuePriority1Command(sCommand .. "\r\n")
	else
		LogError("Error: Unable to send command: %s", sCommand)
	end
end

function QueuePriority2Command(sCommand)
--	LogTrace("QueuePriority2Command(%s)", sCommand)
	if (gCon ~= nil) then
		gCon:QueuePriority2Command(sCommand .. "\r\n")
	else
		LogError("Error: Unable to send command: %s", sCommand)
	end
end

function ForEachDevice(func, ...)
	for i,v in pairs(gDeviceList) do
		local retval = func(i, v.system, v.zone, unpack(arg))
		if (retval == "found") then break end
		if (retval ~= nil) then return retval end
	end
end

function SendToAllOnSystem(ID, System, _, deviceSystem, strCommand, tParams)
	if ((deviceSystem == System)) then
		LogTrace("C4:SendToDevice(".. ID .. ", " .. strCommand .. ")")
		C4:SendToDevice(ID, strCommand, tParams)
	end
end

function SendToDeviceOnly(ID, System, Zone, deviceSystem, deviceZone, strCommand, tParams)
	if ((deviceSystem == System) and (deviceZone == Zone)) then
		LogTrace("C4:SendToDevice(".. ID .. ", " .. strCommand .. ")")
		C4:SendToDevice(ID, strCommand, tParams)
		return "found"
	end
end

function SendToDevice(deviceSystem, deviceZone, strCommand, tParams)
	if (deviceZone == nil) then
		LogTrace("SendToDevice(" .. deviceSystem .. ", " .. strCommand .. ")")
		ForEachDevice(SendToAllOnSystem, deviceSystem, strCommand, tParams)
	else
		LogTrace("SendToDevice(" .. deviceSystem .. ", " .. deviceZone .. ", " .. strCommand .. ")")
		ForEachDevice(SendToDeviceOnly, deviceSystem, deviceZone, strCommand, tParams)
	end
end

function GetAllSystemSettings(priority)
	priority = priority or 3	-- default to highest priority
	LogTrace("GetAllSystemSettings(%s)", tostring(priority))
	
	if (priority == 1) then
		ForEachDevice(function(_, S, _) if (tonumber(S) == 1) then GetP1SystemSettings({SYSTEM = S}); return "found"; end end)
		ForEachDevice(function(_, S, _) if (tonumber(S) == 2) then GetP1SystemSettings({SYSTEM = S}); return "found"; end end)
	elseif (priority == 2) then
		ForEachDevice(function(_, S, _) if (tonumber(S) == 1) then GetP2SystemSettings({SYSTEM = S}); return "found"; end end)
		ForEachDevice(function(_, S, _) if (tonumber(S) == 2) then GetP2SystemSettings({SYSTEM = S}); return "found"; end end)
	else	-- Get all system settings
		ForEachDevice(function(_, S, _) if (tonumber(S) == 1) then GetP3SystemSettings({SYSTEM = S}); return "found"; end end)
		ForEachDevice(function(_, S, _) if (tonumber(S) == 2) then GetSystemSettings({SYSTEM = S}); return "found"; end end)
	end

	GetCurrentSettings()
end

function GetP1SystemSettings(tParams)
	LogTrace("GetP1SystemSettings(): system = %s", tostring(tParams["SYSTEM"]))
	-- Get System Mode
	local cmd = string.format("S%dMODE?", tParams["SYSTEM"])
	QueuePriority2Command(cmd)
end

function GetP2SystemSettings(tParams)
	LogTrace("GetP2SystemSettings(): system = %s", tostring(tParams["SYSTEM"]))

	-- Get Priority 1 settings
	GetP1SystemSettings(tParams)

	-- Get Outside Temperature
	cmd = string.format("S%dOAT?", tParams["SYSTEM"])
	QueuePriority2Command(cmd)
end

function GetSystemSettings(tParams)
	LogTrace("GetP3SystemSettings(): system = %s", tostring(tParams["SYSTEM"]))

	-- Get Priority 2 settings, which also gets P1 settings.
	GetP2SystemSettings(tParams)
	-- Get Current Scale
	cmd = string.format("S%dCFGEM?", tParams["SYSTEM"])
	QueuePriority2Command(cmd)
	-- Get System type
	cmd = string.format("S%dCFGTYPE?", tParams["SYSTEM"])
	QueuePriority2Command(cmd)
	-- Get System Auto
	cmd = string.format("S%dCFGAUTO?", tParams["SYSTEM"])
	QueuePriority2Command(cmd)
end

function GetCurrentSettings()
	LogTrace("GetCurrentSettings()")
	ForEachDevice(function(_, S, Z) GetAllDeviceSettings({SYSTEM = S, ZONE = Z}) end)
end

function GetAllDeviceSettings(tParams)
	LogTrace("GetAllDeviceSettings(" .. tostring(tParams["SYSTEM"]) .. ", " .. tostring(tParams["ZONE"]) .. ")")
	if (tParams ~= nil and tParams["SYSTEM"] ~= nil and tParams["ZONE"] ~= nil) then
		GetDeviceSettings(tParams["SYSTEM"], tParams["ZONE"])
	end
end

function GetDeviceSettings(system, zone)
	LogTrace("GetDeviceSettings(" .. tostring(system) .. ", " .. tostring(zone) .. ")")
	if (system ~= nil and zone ~= nil) then
		-- Get Fan Mode
		local cmd = string.format("S%dZ%dFAN?", system, zone)
		QueuePriority2Command(cmd)

		-- Get Hold Mode
		cmd = string.format("S%dZ%dHOLD?", system, zone)
		QueuePriority2Command(cmd)

		-- Get Current Heat Set Point
		cmd = string.format("S%dZ%dHTSP?", system, zone)
		QueuePriority2Command(cmd)

		-- Get Current Cool Set Point
		cmd = string.format("S%dZ%dCLSP?", system, zone)
		QueuePriority2Command(cmd)

		-- Get Room Temperature
		cmd = string.format("S%dZ%dRT?", system, zone)
		QueuePriority2Command(cmd)

		-- Get Room Humidity
		cmd = string.format("S%dZ%dRH?", system, zone)
		QueuePriority2Command(cmd)
	end
end

function OnPollingTimerExpired()
	-- If the P2 queue is empty, then we will add some more commands
	if (gCon._Priority2CommandQueue:empty()) then
		-- If the count is 
		if (gPollCnt == PRIORITY_2_COUNT) then
			GetAllSystemSettings(PRIORITY_2)
			gPollCnt = gPollCnt + 1
		elseif (gPollCnt == PRIORITY_3_COUNT) then
			GetAllSystemSettings(PRIORITY_3)
			gPollCnt = 1
		else
			GetAllSystemSettings(PRIORITY_1)
			gPollCnt = gPollCnt + 1
		end

	else
		LogInfo("Priority 2 command queue is not empty. Waiting to queue more commands...")
	end
end
