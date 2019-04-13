--[[=============================================================================
    Commands received from the thermostatV2 proxy (ReceivedFromProxy)

    Copyright 2015 Control4 Corporation. All Rights Reserved.
===============================================================================]]

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.proxy_commands = "2014.12.11"
end

--[[=============================================================================
    SET_SETPOINT_HEAT(celsius, fahrenheit)

    Description
    Sets the heat setpoint

    Parameters
    celsius   - celsius setpoint value
    fahrenheit - fahrenheit setpoint value
===============================================================================]]
function SET_SETPOINT_HEAT(celsius, fahrenheit)
	LogTrace("SET_SETPOINT_HEAT(celsius = %s, fahrenheit = %s)", celsius, fahrenheit)
	
	local tParams = {}
	if (string.sub(gScale, 1, 1) == "F") then
		tParams["SETPOINT"] = fahrenheit
	else
		tParams["SETPOINT"] = celsius
	end
	
	SendToCarrier("SET_HEAT_SETPOINT", tParams)
	--gTStatProxy:dev_HeatSetpoint(tParams["SETPOINT"], gScale)
end

--[[=============================================================================
    SET_SETPOINT_COOL(celsius, fahrenheit)

    Description
    Sets the cool setpoint

    Parameters
    celsius   - celsius setpoint value
    fahrenheit - fahrenheit setpoint value
===============================================================================]]
function SET_SETPOINT_COOL(celsius, fahrenheit)
	LogTrace("SET_SETPOINT_COOL(celsius = %s, fahrenheit = %s)", celsius, fahrenheit)
	
	local tParams = {}
	if (string.sub(gScale, 1, 1) == "F") then
		tParams["SETPOINT"] = fahrenheit
	else
		tParams["SETPOINT"] = celsius
	end
	
	SendToCarrier("SET_COOL_SETPOINT", tParams)
	--gTStatProxy:dev_CoolSetpoint(tParams["SETPOINT"], gScale)
end

function SET_SETPOINT_SINGLE()
end

function INC_SETPOINT_HEAT()
end

function DEC_SETPOINT_HEAT()
end

function INC_SETPOINT_COOL()
end

function DEC_SETPOINT_COOL()
end

--[[=============================================================================
    SET_BUTTONS_LOCK(mode)

    Description
    Sets the button lock mode

    Parameters
    mode   - string containing the name of the mode to set the HVAC mode to
===============================================================================]]
function SET_BUTTONS_LOCK(mode)
	LogTrace("SET_BUTTONS_LOCK(mode = %s)", mode)
	
	-- TODO: Create the packet/command to send to the device
end

--[[=============================================================================
    SET_SCALE(mode)

    Description
    Used to set the temperature scale the thermostat should use

    Parameters
    scale   - string containing the scale the thermostat should use
===============================================================================]]
function SET_SCALE(scale)
	LogTrace("SET_SCALE(scale = %s)", string.sub(scale, 1, 1))
	
	local tParams = {SCALE = scale}
	SendToCarrier("SET_SCALE", tParams)
	--gTStatProxy:dev_Scale(scale)
end

--[[=============================================================================
    SET_MODE_HVAC(mode)

    Description
    Sets the HVAC mode

    Parameters
    mode   - string containing the name of the mode to set the HVAC mode to
===============================================================================]]
function SET_MODE_HVAC(mode)
	LogTrace("SET_MODE_HVAC(mode = %s)", mode)
	
	local tParams = {HVACMODE = mode}
	SendToCarrier("SET_MODE", tParams)
	--gTStatProxy:dev_HVACMode(mode)
end

function SET_MODE_HUMIDITY(mode)
	LogTrace("SET_MODE_HUMIDITY(mode = %s)", mode)
	
	-- TODO: Create the packet/command to send to the device
end

function SET_SETPOINT_HUMIDIFY(setpoint)
	LogTrace("SET_MODE_HUMIDITY(setpoint = %s)", setpoint)
	
	-- TODO: Create the packet/command to send to the device
end

function SET_SETPOINT_DEHUMIDIFY(setpoint)
	LogTrace("SET_SETPOINT_DEHUMIDIFY(setpoint = %s)", setpoint)
	
	-- TODO: Create the packet/command to send to the device
end

--[[=============================================================================
    SET_MODE_FAN(mode)

    Description
    Sets the fan mode

    Parameters
    mode   - string containing the name of the mode to set the fan mode to
===============================================================================]]
function SET_MODE_FAN(mode)
	LogTrace("SET_MODE_FAN(mode = %s)", mode)
	
	local tParams = {FANMODE = mode}
	SendToCarrier("SET_FAN_MODE", tParams)
	--gTStatProxy:dev_FanMode(mode)
end

--[[=============================================================================
    SET_MODE_HOLD(mode)

    Description
    used to set the current hold mode of the thermostat

    Parameters
    mode   - string containing the hold mode to set the thermostat hold mode to
===============================================================================]]
function SET_MODE_HOLD(mode)
	LogTrace("SET_MODE_HOLD(mode = %s)", mode)
	
	local tParams = {HOLDMODE = mode}
	SendToCarrier("SET_HOLD_MODE", tParams)
	gTStatProxy:dev_Message(" ")
	--gTStatProxy:dev_HoldMode(mode)
end

--[[=============================================================================
    SET_MODE_HOLD_UNTIL(mode)

    Description
    used to set the current hold mode of the thermostat

    Parameters
    mode   - string containing the hold mode to set the thermostat hold mode to
===============================================================================]]
function SET_MODE_HOLD_UNTIL(year, month, day, hour, minute, second)
	LogTrace("SET_MODE_HOLD_UNTIL(year = %s, month = %s, day = %s, hour = %s, minute = %s, second = %s)", year, month, day, hour, minute, second)
	
	-- TODO: Create the packet/command to send to the device, the hold timer is specified in hours and minutes. 
end

function SET_OUTDOOR_TEMPERATURE()
end

function SET_PRESETS()
end

function SET_PRESET()
end

function SET_EVENTS()
end

function SET_EVENT()
end

function PRX_CMD.REFRESH_DATA()
    LogInfo("Requesting updated information.")
	SendToCarrier("REFRESH_DATA", {})
end

-- These get called from the extras page via the proxy
function PRX_CMD.SET_OCCUPIED(idBinding, tParams)
    if (tParams["value"] == 'true') then 
        EX_CMD.SET_OCCUPIED_MODE({});
    else 
        EX_CMD.SET_UNOCCUPIED_MODE({});
    end
end
