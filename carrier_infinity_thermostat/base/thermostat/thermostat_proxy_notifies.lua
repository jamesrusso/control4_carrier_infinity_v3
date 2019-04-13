--[[=============================================================================
    Notification Functions

    Copyright 2015 Control4 Corporation. All Rights Reserved.
===============================================================================]]

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.thermostat_proxy_notifies = "2014.12.11"
end

function NOTIFY.CONNECTION(bindingID, connected)
	LogTrace("NOTIFY.CONNECTION(bindingID = %s, connected = %s)", bindingID, tostring(connected))

	local tParams =
	{
		CONNECTED = tostring(connected)
	}

	SendNotify("CONNECTION", tParams, bindingID)
end

function NOTIFY.ALLOWED_FAN_MODES_CHANGED(bindingID, modes)
	LogTrace("NOTIFY.ALLOWED_FAN_MODES_CHANGED(bindingID = %s, modes = %s", bindingID, modes)

	local tParams = {}
	tParams["MODES"] = modes

	SendNotify("ALLOWED_FAN_MODES_CHANGED", tParams, bindingID)
end

function NOTIFY.ALLOWED_HVAC_MODES_CHANGED(bindingID, modes, canHeat, canCool, canAuto)
	LogTrace("NOTIFY.ALLOWED_HVAC_MODES_CHANGED(bindingID = %s, modes = %s, canHeat = %s, canCool = %s, canAuto = %s", bindingID, modes, tostring(canHeat), tostring(canCool), tostring(canAuto))

	local tParams = {}
	tParams["MODES"] = modes
	
	if (canHeat ~= nil) then
		tParams["CAN_HEAT"] = canHeat
	end

	if (canCool ~= nil) then
		tParams["CAN_COOL"] = canCool
	end

	if (canAuto ~= nil) then
		tParams["CAN_AUTO"] = canAuto
	end

	SendNotify("ALLOWED_HVAC_MODES_CHANGED", tParams, bindingID)
end

function NOTIFY.BUTTONS_LOCK_CHANGED(bindingID, lock)
	LogTrace("NOTIFY.BUTTONS_LOCK_CHANGED(bindingID = %s, lock = %s", bindingID, tostring(lock))

	local tParams = {}
	tParams["LOCK"] = lock

	SendNotify("BUTTONS_LOCK_CHANGED", tParams, bindingID)
end

function NOTIFY.COOL_SETPOINT_CHANGED(bindingID, setpoint, scale)
	LogTrace("NOTIFY.COOL_SETPOINT_CHANGED(bindingID = %s, setpoint = %s, scale = %s", bindingID, setpoint, scale)

	local tParams = {}
	tParams["SETPOINT"] = setpoint
	tParams["SCALE"] = scale

	SendNotify("COOL_SETPOINT_CHANGED", tParams, bindingID)
end

function NOTIFY.FAN_MODE_CHANGED(bindingID, mode)
	LogTrace("NOTIFY.FAN_MODE_CHANGED(bindingID = %s, mode = %s", bindingID, mode)

	local tParams = {}
	tParams["MODE"] = mode

	SendNotify("FAN_MODE_CHANGED", tParams, bindingID)
end

function NOTIFY.FAN_STATE_CHANGED(bindingID, state)
	LogTrace("NOTIFY.FAN_STATE_CHANGED(bindingID = %s, state = %s", bindingID, state)

	local tParams = {}
	tParams["STATE"] = state

	SendNotify("FAN_STATE_CHANGED", tParams, bindingID)
end

function NOTIFY.HEAT_SETPOINT_CHANGED(bindingID, setpoint, scale)
	LogTrace("NOTIFY.HEAT_SETPOINT_CHANGED(bindingID = %s, setpoint = %s, scale = %s", bindingID, setpoint, scale)

	local tParams = {}
	tParams["SETPOINT"] = setpoint
	tParams["SCALE"] = scale

	SendNotify("HEAT_SETPOINT_CHANGED", tParams, bindingID)
end

function NOTIFY.SINGLE_SETPOINT_CHANGED(bindingID, setpoint, scale)
	LogTrace("NOTIFY.SINGLE_SETPOINT_CHANGED(bindingID = %s, setpoint = %s, scale = %s", bindingID, setpoint, scale)

	local tParams = {}
	tParams["SETPOINT"] = setpoint
	tParams["SCALE"] = scale

	SendNotify("SINGLE_SETPOINT_CHANGED", tParams, bindingID)
end

function NOTIFY.ALLOWED_HOLD_MODES_CHANGED(bindingID, modes)
	LogTrace("NOTIFY.ALLOWED_HOLD_MODES_CHANGED(bindingID = %s, modes = %s", bindingID, modes)

	local tParams = {}
	tParams["MODES"] = modes

	SendNotify("ALLOWED_HOLD_MODES_CHANGED", tParams, bindingID)
end

function NOTIFY.HOLD_MODE_CHANGED(bindingID, mode, year, month, day, hour, minute)
	LogTrace("NOTIFY.HOLD_MODE_CHANGED(bindingID = %s, mode = %s, year = %s, month = %s, day = %s, hour = %s, minute = %s", bindingID, mode, tostring(year), tostring(month), tostring(day), tostring(hour), tostring(minute))

	local tParams = {}
	tParams["MODE"] = mode
	
	if (mode == "Hold Until") then
		tParams["YEAR"] = year
		tParams["MONTH"] = month
		tParams["DAY"] = day
		tParams["HOUR"] = hour
		tParams["MINUTE"] = minute
	end

	SendNotify("HOLD_MODE_CHANGED", tParams, bindingID)
end

function NOTIFY.HVAC_MODE_CHANGED(bindingID, mode)
	LogTrace("NOTIFY.HVAC_MODE_CHANGED(bindingID = %s, mode = %s", bindingID, tostring(mode))

	local tParams = {}
	tParams["MODE"] = mode

	SendNotify("HVAC_MODE_CHANGED", tParams, bindingID)
end

function NOTIFY.HVAC_STATE_CHANGED(bindingID, state)
	LogTrace("NOTIFY.HVAC_STATE_CHANGED(bindingID = %s, state = %s", bindingID, state)

	local tParams = {}
	tParams["STATE"] = state

	SendNotify("HVAC_STATE_CHANGED", tParams, bindingID)
end

function NOTIFY.SCALE_CHANGED(bindingID, scale)
	LogTrace("NOTIFY.SCALE_CHANGED(bindingID = %s, scale = %s", bindingID, scale)

	local tParams = {}
	tParams["SCALE"] = scale

	SendNotify("SCALE_CHANGED", tParams, bindingID)
end

function NOTIFY.TEMPERATURE_CHANGED(bindingID, temperature, scale)
	LogTrace("NOTIFY.TEMPERATURE_CHANGED(bindingID = %s, temperature = %s, scale = %s)", bindingID, temperature, scale)

	local tParams = {}
	tParams["TEMPERATURE"] = temperature
	tParams["SCALE"] = scale

	SendNotify("TEMPERATURE_CHANGED", tParams, bindingID)
end

function NOTIFY.OUTDOOR_TEMPERATURE_CHANGED(bindingID, temperature, scale)
	LogTrace("NOTIFY.OUTDOOR_TEMPERATURE_CHANGED(bindingID = %s, temperature = %s, scale = %s)", bindingID, temperature, scale)

	local tParams = {}
	tParams["TEMPERATURE"] = temperature
	tParams["SCALE"] = scale

	SendNotify("OUTDOOR_TEMPERATURE_CHANGED", tParams, bindingID)
end

function NOTIFY.HUMIDITY_CHANGED(bindingID, humidity)
	LogTrace("NOTIFY.HUMIDITY_CHANGED(bindingID = %s, humidity = %s", bindingID, humidity)

	local tParams = {}
	tParams["HUMIDITY"] = humidity

	SendNotify("HUMIDITY_CHANGED", tParams, bindingID)
end

function NOTIFY.HUMIDITY_MODE_CHANGED(bindingID, mode)
	LogTrace("NOTIFY.HUMIDITY_MODE_CHANGED(bindingID = %s, mode = %s", bindingID, tostring(mode))

	local tParams = {}
	tParams["MODE"] = mode

	SendNotify("HUMIDITY_MODE_CHANGED", tParams, bindingID)
end

function NOTIFY.ALLOWED_HUMIDITY_MODES_CHANGED(bindingID, modes)
	LogTrace("NOTIFY.ALLOWED_HUMIDITY_MODES_CHANGED(bindingID = %s, modes = %s", bindingID, modes)

	local tParams = {}
	tParams["MODES"] = modes
	
	SendNotify("ALLOWED_HUMIDITY_MODES_CHANGED", tParams, bindingID)
end

function NOTIFY.HUMIDITY_STATE_CHANGED(bindingID, state)
	LogTrace("NOTIFY.HUMIDITY_STATE_CHANGED(bindingID = %s, state = %s", bindingID, state)

	local tParams = {}
	tParams["STATE"] = state

	SendNotify("HUMIDITY_STATE_CHANGED", tParams, bindingID)
end

function NOTIFY.HUMIDIFY_SETPOINT_CHANGED(bindingID, setpoint)
	LogTrace("NOTIFY.HUMIDIFY_SETPOINT_CHANGED(bindingID = %s, setpoint = %s", bindingID, tostring(setpoint))

	local tParams = {}
	tParams["SETPOINT"] = setpoint

	SendNotify("HUMIDIFY_SETPOINT_CHANGED", tParams, bindingID)
end

function NOTIFY.DEHUMIDIFY_SETPOINT_CHANGED(bindingID, setpoint)
	LogTrace("NOTIFY.DEHUMIDIFY_SETPOINT_CHANGED(bindingID = %s, setpoint = %s", bindingID, tostring(setpoint))

	local tParams = {}
	tParams["SETPOINT"] = setpoint

	SendNotify("DEHUMIDIFY_SETPOINT_CHANGED", tParams, bindingID)
end

function NOTIFY.MESSAGE_CHANGED(bindingID, message)
	LogTrace("NOTIFY.MESSAGE_CHANGED(bindingID = %s, message = %s", bindingID, tostring(message))

	local tParams = {}
	tParams["MESSAGE"] = message

	SendNotify("MESSAGE_CHANGED", tParams, bindingID)
end

function NOTIFY.DYNAMIC_CAPABILITIES_CHANGED(bindingID, tCapabilities)
	LogTrace("NOTIFY.DYNAMIC_CAPABILITIES_CHANGED(bindingID = %s)", bindingID)
	LogTrace(tCapabilities)

	SendNotify("DYNAMIC_CAPABILITIES_CHANGED", tCapabilities, bindingID)
end

function NOTIFY.EXTRAS_SETUP_CHANGED(bindingID, xml)
	LogTrace("NOTIFY.EXTRAS_SETUP_CHANGED(bindingID = %s)", bindingID)
	LogTrace(xml)

	SendNotify("EXTRAS_SETUP_CHANGED", { XML = xml }, bindingID)
end

function NOTIFY.EXTRAS_STATE_CHANGED(bindingID, xml)
	LogTrace("NOTIFY.EXTRAS_STATE_CHANGED(bindingID = %s)", bindingID)
	LogTrace(xml)

	SendNotify("EXTRAS_STATE_CHANGED", { XML = xml }, bindingID)
end

function NOTIFY.SCHEDULE_ENTRY_CHANGED(bindingID, dayIndex, entryIndex, entryInfo)
	LogTrace("NOTIFY.SCHEDULE_ENTRY_CHANGED(bindingID = %s, dayIndex = %s, entryIndex = %s)", bindingID, dayIndex, entryIndex)
	LogTrace(entryInfo)

	local tParams =
	{
		DayIndex = tostring(dayIndex),
		EntryIndex = tostring(entryIndex),
		EnabledFlag = tostring(entryInfo.Enabled),
		TimeMinutes = tostring(entryInfo.SchedTime),
		HeatSetpoint = tostring(entryInfo.HeatSetpoint),
		CoolSetpoint = tostring(entryInfo.CoolSetpoint),
		Units = tostring(entryInfo.Units)
	}

	SendNotify("SCHEDULE_ENTRY_CHANGED", tParams, bindingID)
end
