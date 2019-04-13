--[[=============================================================================
    Command Functions Received From Proxy to the Thermostat Driver

    Copyright 2015 Control4 Corporation. All Rights Reserved.
===============================================================================]]

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.thermostat_proxy_commands = "2014.12.11"
end

function PRX_CMD.SET_SETPOINT_HEAT(bindingID, tParams)
	gTStatProxy:prx_SET_SETPOINT_HEAT(tParams)
end

function PRX_CMD.SET_SETPOINT_COOL(bindingID, tParams)
	gTStatProxy:prx_SET_SETPOINT_COOL(tParams)
end

function PRX_CMD.SET_SETPOINT_SINGLE(bindingID, tParams)
	gTStatProxy:prx_SET_SETPOINT_SINGLE(tParams)
end

function PRX_CMD.INC_SETPOINT_HEAT(bindingID, tParams)
	gTStatProxy:prx_INC_SETPOINT_HEAT(tParams)
end

function PRX_CMD.DEC_SETPOINT_HEAT(bindingID, tParams)
	gTStatProxy:prx_DEC_SETPOINT_HEAT(tParams)
end

function PRX_CMD.INC_SETPOINT_COOL(bindingID, tParams)
	gTStatProxy:prx_INC_SETPOINT_COOL(tParams)
end

function PRX_CMD.DEC_SETPOINT_COOL(bindingID, tParams)
	gTStatProxy:prx_DEC_SETPOINT_COOL(tParams)
end

function PRX_CMD.SET_BUTTONS_LOCK(bindingID, tParams)
	gTStatProxy:prx_SET_BUTTONS_LOCK(tParams)
end

function PRX_CMD.SET_SCALE(bindingID, tParams)
	gTStatProxy:prx_SET_SCALE(tParams)
end

function PRX_CMD.SET_MODE_HVAC(bindingID, tParams)
	gTStatProxy:prx_SET_MODE_HVAC(tParams)
end

function PRX_CMD.SET_MODE_HUMIDITY(bindingID, tParams)
	gTStatProxy:prx_SET_MODE_HUMIDITY(tParams)
end

function PRX_CMD.SET_SETPOINT_HUMIDIFY(bindingID, tParams)
	gTStatProxy:prx_SET_SETPOINT_HUMIDIFY(tParams)
end

function PRX_CMD.SET_SETPOINT_DEHUMIDIFY(bindingID, tParams)
	gTStatProxy:prx_SET_SETPOINT_DEHUMIDIFY(tParams)
end

function PRX_CMD.SET_MODE_FAN(bindingID, tParams)
	gTStatProxy:prx_SET_MODE_FAN(tParams)
end

function PRX_CMD.SET_MODE_HOLD(bindingID, tParams)
	gTStatProxy:prx_SET_MODE_HOLD(tParams)
end

function PRX_CMD.SET_OUTDOOR_TEMPERATURE(bindingID, tParams)
	gTStatProxy:prx_SET_OUTDOOR_TEMPERATURE(tParams)
end

function PRX_CMD.SET_PRESETS(bindingID, tParams)
	gTStatProxy:prx_SET_PRESETS(tParams)
end

function PRX_CMD.SET_PRESET(bindingID, tParams)
	gTStatProxy:prx_SET_PRESET(tParams)
end

function PRX_CMD.SET_EVENTS(bindingID, tParams)
	gTStatProxy:prx_SET_EVENTS(tParams)
end

function PRX_CMD.SET_EVENT(bindingID, tParams)
	gTStatProxy:prx_SET_EVENT(tParams)
end

function PRX_CMD.SET_VACATION_MODE(bindingID, tParams)
	gTStatProxy:prx_SET_VACATION_MODE(tParams)
end

function PRX_CMD.SET_VAC_SETPOINT_HEAT(bindingID, tParams)
	gTStatProxy:prx_SET_VAC_SETPOINT_HEAT(tParams)
end

function PRX_CMD.SET_VAC_SETPOINT_COOL(bindingID, tParams)
	gTStatProxy:prx_SET_VAC_SETPOINT_COOL(tParams)
end

function PRX_CMD.SET_REMOTE_SENSOR(bindingID, tParams)
	gTStatProxy:prx_SET_REMOTE_SENSOR(tParams)
end

function PRX_CMD.SET_CALIBRATION(bindingID, tParams)
	gTStatProxy:prx_SET_CALIBRATION(tParams)
end

function PRX_CMD.UPDATE_SCHEDULE_ENTRIES(bindingID, tParams)
	gTStatProxy:prx_UPDATE_SCHEDULE_ENTRIES(tParams)
end
