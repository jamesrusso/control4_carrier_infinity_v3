--[[=============================================================================
    Thermostat Proxy Class

    Copyright 2015 Control4 Corporation. All Rights Reserved.
===============================================================================]]

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.thermostat_proxy_class = "2014.12.11"
end

ThermostatProxy = inheritsFrom(nil)

function ThermostatProxy:construct(bindingID)
	-- member variables
	self._BindingID = bindingID
	
	self:Initialize()
end

function ThermostatProxy:Initialize()
	self._HeatSetpoint = -1
	self._CoolSetpoint = -1
	self._SingleSetpoint = -1
	self._Temperature = -1
	self._OutdoorTemperature = -1
	self._Scale = ""
	self._HVACMode = ""
	self._HVACState = ""
	self._FanMode = ""
	self._FanState = ""
	self._HoldMode = ""
	self._ButtonLocked = nil
	self._Connected = nil
	self._Message = ""
	
	-- Lists
	self._HVACModes = ""
	self._CanHeat = nil
	self._CanCool = nil
	self._CanAuto = nil

	-- humidity variables
	self._Humidity = -1
	self._HumidifySetpoint = -1
	self._DehumidifySetpoint = -1
	self._HumidityMode = ""
	self._HumidityState = ""
	
	-- legacy schedule variables
	self._Schedule = {}
	
end

--[[=============================================================================
    Thermostat Proxy Commands(PRX_CMD)
===============================================================================]]
function ThermostatProxy:prx_SET_SETPOINT_HEAT(tParams)
	local celsius = tParams["CELSIUS"]
	local fahrenheit = tParams["FAHRENHEIT"]

	if (celsius ~= nil and fahrenheit ~= nil) then
		SET_SETPOINT_HEAT(celsius, fahrenheit)
	end
end

function ThermostatProxy:prx_SET_SETPOINT_COOL(tParams)
	local celsius = tParams["CELSIUS"]
	local fahrenheit = tParams["FAHRENHEIT"]

	if (celsius ~= nil and fahrenheit ~= nil) then
		SET_SETPOINT_COOL(celsius, fahrenheit)
	end
end

function ThermostatProxy:prx_SET_SETPOINT_SINGLE(tParams)
end

function ThermostatProxy:prx_INC_SETPOINT_HEAT(tParams)
end

function ThermostatProxy:prx_DEC_SETPOINT_HEAT(tParams)
end

function ThermostatProxy:prx_INC_SETPOINT_COOL(tParams)
end

function ThermostatProxy:prx_DEC_SETPOINT_COOL(tParams)
end

function ThermostatProxy:prx_SET_BUTTONS_LOCK(tParams)
	local mode = tParams["LOCK"]

	if (mode ~= nil) then
		SET_BUTTONS_LOCK(mode)
	end
end

function ThermostatProxy:prx_SET_SCALE(tParams)
	local scale = tParams["SCALE"]

	if (scale ~= nil and (scale ~= "CELSIUS" or scale ~= "FAHRENHEIT")) then
		SET_SCALE(scale)
	end
end

function ThermostatProxy:prx_SET_MODE_HVAC(tParams)
	local mode = tParams["MODE"]

	if (mode ~= nil) then
		SET_MODE_HVAC(mode)
	end
end

function ThermostatProxy:prx_SET_MODE_HUMIDITY(tParams)
	local mode = tParams["MODE"]

	if (mode ~= nil) then
		SET_MODE_HUMIDITY(mode)
	end
end

function ThermostatProxy:prx_SET_SETPOINT_HUMIDIFY(tParams)
	local setpoint = tParams["SETPOINT"]

	if (setpoint ~= nil) then
		SET_SETPOINT_HUMIDIFY(setpoint)
	end
end

function ThermostatProxy:prx_SET_SETPOINT_DEHUMIDIFY(tParams)
	local setpoint = tParams["SETPOINT"]

	if (setpoint ~= nil) then
		SET_SETPOINT_DEHUMIDIFY(setpoint)
	end
end

function ThermostatProxy:prx_SET_MODE_FAN(tParams)
	local mode = tParams["MODE"]

	if (mode ~= nil) then
		SET_MODE_FAN(mode)
	end
end

function ThermostatProxy:prx_SET_MODE_HOLD(tParams)
	local mode = tParams["MODE"]

	if (mode ~= nil) then
		if (mode == "Hold Until") then
			local year = tParams["YEAR"]
			local month = tParams["MONTH"]
			local day = tParams["DAY"]
			local hour = tParams["HOUR"]
			local minute = tParams["MINUTE"]
			local second = tParams["SECOND"]
			
			SET_MODE_HOLD_UNTIL(year, month, day, hour, minute, second)
		else
			SET_MODE_HOLD(mode)
		end
	end
end

function ThermostatProxy:prx_SET_OUTDOOR_TEMPERATURE(tParams)
end

function ThermostatProxy:prx_SET_PRESETS(tParams)
end

function ThermostatProxy:prx_SET_PRESET(tParams)
end

function ThermostatProxy:prx_SET_EVENTS(tParams)
end

function ThermostatProxy:prx_SET_EVENT(tParams)
end

function ThermostatProxy:prx_SET_VACATION_MODE(tParams)
	local mode = tParams["MODE"]

	if (mode ~= nil) then
		SET_VACATION_MODE(mode)
	end
end

function ThermostatProxy:prx_SET_VAC_SETPOINT_HEAT(tParams)
end

function ThermostatProxy:prx_SET_VAC_SETPOINT_COOL(tParams)
end

function ThermostatProxy:prx_UPDATE_SCHEDULE_ENTRIES(tParams)
--	local entriesXML = tParams["ENTRIES"]
--	LogTrace("entriesXML: ************************")
--	LogTrace(entriesXML)
	
	local tEntries = C4:ParseXml(tParams["ENTRIES"])
--	LogTrace("tEntries: ************************")
--	LogTrace(tEntries)
	
	-- Get all the entries
	for _, entry in pairs(tEntries.ChildNodes) do
		local sched = entry.Attributes

		local CelsiusHeatSetpoint = (sched.HeatSetpoint - 2731)/10
		local FahrenheitHeatSetpoint = round((CelsiusHeatSetpoint*9)/5+32)
		CelsiusHeatSetpoint = round(CelsiusHeatSetpoint)

		local CelsiusCoolSetpoint = (sched.CoolSetpoint - 2731)/10
		local FahrenheitCoolSetpoint = round((CelsiusCoolSetpoint*9)/5+32)
		CelsiusCoolSetpoint = round(CelsiusCoolSetpoint)

		self._Schedule[sched.DayOfWeek] = self._Schedule[sched.DayOfWeek] or {}
		self._Schedule[sched.DayOfWeek][sched.EntryIndex] = sched
		self._Schedule[sched.DayOfWeek][sched.EntryIndex].CelsiusHeatSetpoint = CelsiusHeatSetpoint
		self._Schedule[sched.DayOfWeek][sched.EntryIndex].FahrenheitHeatSetpoint = FahrenheitHeatSetpoint
		self._Schedule[sched.DayOfWeek][sched.EntryIndex].CelsiusCoolSetpoint = CelsiusCoolSetpoint
		self._Schedule[sched.DayOfWeek][sched.EntryIndex].FahrenheitCoolSetpoint = FahrenheitCoolSetpoint
		LogTrace("DayOfWeek: %s, EntryIndex: %s", sched.DayOfWeek, sched.EntryIndex)
		LogTrace(sched)
		
		if (string.sub(self._Scale, 1, 1) == "F") then
			SET_LEGACY_SCHEDULE_ENTRY(sched.DayOfWeek, sched.EntryIndex, sched.IsEnabled, sched.EntryTime, FahrenheitHeatSetpoint, FahrenheitCoolSetpoint, self._Scale)
		elseif (string.sub(self._Scale, 1, 1) == "C") then
			SET_LEGACY_SCHEDULE_ENTRY(sched.DayOfWeek, sched.EntryIndex, sched.IsEnabled, sched.EntryTime, CelsiusHeatSetpoint, CelsiusCoolSetpoint, self._Scale)
		else
			LogError("Empty or invalid scale.")
		end
	end
end

function round(num, idp)
  return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end

--[[=============================================================================
    Thermostat Proxy Notifies
===============================================================================]]
function ThermostatProxy:dev_Connected(connected)
	LogTrace("ThermostatProxy:dev_Connected(connected = %s)", tostring(connected))
	-- connected: boolean, connection status
	if (type(connected) == "boolean") then
		NOTIFY.CONNECTION(self._BindingID, connected)
	end
end

function ThermostatProxy:dev_AllowedFanModes(modes)
	-- modes: comma delimited list of available fan modes
	if (type(modes) == "string") then
		NOTIFY.ALLOWED_FAN_MODES_CHANGED(self._BindingID, modes)
	end
end

function ThermostatProxy:dev_AllowedHVACModes(modes, canHeat, canCool, canAuto)
	-- modes: comma delimited list of available HVAC modes
	-- canHeat, canCool, canAuto are optional boolean parameters that sets capabilities
	
	if (type(modes) == "string") then
		if ((canHeat == nil or (type(canHeat) == "boolean")) and
			(canCool == nil or (type(canCool) == "boolean")) and
			(canAuto == nil or (type(canAuto) == "boolean"))) then
				local hasChanged = false
				if (self._HVACModes ~= modes) then
					self._HVACModes = modes
					hasChanged = true
				end
				if (self._CanHeat ~= canHeat) then
					self._CanHeat = canHeat
					hasChanged = true
				end
				if (self._CanCool ~= canCool) then
					self._CanCool = canCool
					hasChanged = true
				end
				if (self._CanAuto ~= canAuto) then
					self._CanAuto = canAuto
					hasChanged = true
				end
				
				if (hasChanged) then
					NOTIFY.ALLOWED_HVAC_MODES_CHANGED(self._BindingID, modes, canHeat, canCool, canAuto)
				end
		end
	end
end

function ThermostatProxy:dev_ButtonLock(locked)
	-- locked: boolean value to lock/unlock buttons
	if (type(locked) == "boolean" and self._ButtonLocked ~= locked) then
		self._ButtonLocked = locked
		NOTIFY.BUTTONS_LOCK_CHANGED(self._BindingID, locked)
	end
end

function ThermostatProxy:dev_Connection(connected)
	-- connected: boolean value, changes the variable IS_CONNECTED
	if (type(connected) == "boolean" and self._Connected ~= connected) then
		self._Connected = connected
		NOTIFY.CONNECTION(self._BindingID, connected)
	end
end

function ThermostatProxy:dev_CoolSetpoint(setpoint, scale)
	-- setpoint: new cooling temperature setpoint
	-- scale: the scale being used for the setpoint (KELVIN, K, CELSIUS, C, FAHRENHEIT, or F)
	setpoint = tonumber(setpoint)
	if (type(setpoint) == "number" and self._CoolSetpoint ~= setpoint) then
		self._CoolSetpoint = setpoint
		NOTIFY.COOL_SETPOINT_CHANGED(self._BindingID, setpoint, scale)
	end
end

function ThermostatProxy:dev_FanMode(mode)
	-- mode: current fan mode, must be in the list of fan modes
	if (type(mode) == "string" and self._FanMode ~= mode) then
		self._FanMode = mode
		NOTIFY.FAN_MODE_CHANGED(self._BindingID, mode)
	end
end

function ThermostatProxy:dev_FanState(state)
	-- state: current fan state
	if (type(state) == "string" and self._FanState ~= state) then
		self._FanState = state
		NOTIFY.FAN_STATE_CHANGED(self._BindingID, state)
	end
end

function ThermostatProxy:dev_HeatSetpoint(setpoint, scale)
	-- setpoint: new heating temperature setpoint
	-- scale: the scale being used for the setpoint (KELVIN, K, CELSIUS, C, FAHRENHEIT, or F)
	setpoint = tonumber(setpoint)
	if (type(setpoint) == "number" and self._HeatSetpoint ~= setpoint) then
		self._HeatSetpoint = setpoint
		NOTIFY.HEAT_SETPOINT_CHANGED(self._BindingID, setpoint, scale)
	end
end

function ThermostatProxy:dev_SingleSetpoint(setpoint, scale)
	-- setpoint: new temperature setpoint
	-- scale: the scale being used for the setpoint (KELVIN, K, CELSIUS, C, FAHRENHEIT, or F)
	setpoint = tonumber(setpoint)
	if (type(setpoint) == "number" and self._SingleSetpoint ~= setpoint) then
		self._SingleSetpoint = setpoint
		NOTIFY.SINGLE_SETPOINT_CHANGED(self._BindingID, setpoint, scale)
	end
end

function ThermostatProxy:dev_AllowedHoldModes(modes)
	-- modes: comma delimited list of available hold modes
	if (type(modes) == "string") then
		NOTIFY.ALLOWED_HOLD_MODES_CHANGED(self._BindingID, modes)
	end
end

function ThermostatProxy:dev_HoldMode(mode, year, month, day, hour, minute)
	-- mode: current hold mode, must be in the list of hold modes
	-- year, month, day, hour, minute: optional parameters
	if (type(mode) == "string" and self._HoldMode ~= mode) then
		self._HoldMode = mode
		NOTIFY.HOLD_MODE_CHANGED(self._BindingID, mode, year, month, day, hour, minute)
	end
end

function ThermostatProxy:dev_HVACMode(mode)
	-- mode: current HVAC mode, must be in the list of fan modes
	if (type(mode) == "string" and self._HVACMode ~= mode) then
		self._HVACMode = mode
		NOTIFY.HVAC_MODE_CHANGED(self._BindingID, mode)
	end
end

function ThermostatProxy:dev_HVACState(state)
	-- state: current HVAC state
	if (type(state) == "string" and self._HVACState ~= state) then
		self._HVACState = state
		NOTIFY.HVAC_STATE_CHANGED(self._BindingID, state)
	end
end

function ThermostatProxy:dev_Scale(scale)
	-- scale: current scale
	if (type(scale) == "string" and self._Scale ~= scale) then
		self._Scale = scale
		NOTIFY.SCALE_CHANGED(self._BindingID, scale)
	end
end

function ThermostatProxy:dev_Temperature(temperature, scale)
	-- temperature: current temperature
	-- scale: the scale being used for the temperature (KELVIN, K, CELSIUS, C, FAHRENHEIT, or F)
	temperature = tonumber(temperature)
	if (type(temperature) == "number" and self._Temperature ~= temperature) then
		self._Temperature = temperature
		NOTIFY.TEMPERATURE_CHANGED(self._BindingID, temperature, scale)
	end
end

function ThermostatProxy:dev_OutdoorTemperature(temperature, scale)
	-- temperature: current outdoor temperature
	-- scale: the scale being used for the outdoor temperature (KELVIN, K, CELSIUS, C, FAHRENHEIT, or F)
	temperature = tonumber(temperature)
	if (type(temperature) == "number" and self._OutdoorTemperature ~= temperature) then
		self._OutdoorTemperature = temperature
		NOTIFY.OUTDOOR_TEMPERATURE_CHANGED(self._BindingID, temperature, scale)
	end
end

function ThermostatProxy:dev_Humidity(humidity)
	-- humidity: current humidity level
	humidity = tonumber(humidity)
	if (type(humidity) == "number" and self._Humidity ~= humidity) then
		self._Humidity = humidity
		NOTIFY.HUMIDITY_CHANGED(self._BindingID, humidity)
	end
end

function ThermostatProxy:dev_HumidityMode(mode)
	-- mode: current humidity mode, must be in the list of humidity modes
	if (type(mode) == "string" and self._HumidityMode ~= mode) then
		self._HumidityMode = mode
		NOTIFY.HUMIDITY_MODE_CHANGED(self._BindingID, mode)
	end
end

function ThermostatProxy:dev_AllowedHumidityModes(modes)
	-- modes: comma delimited list of available humidity modes
	if (type(modes) == "string") then
		NOTIFY.ALLOWED_HUMIDITY_MODES_CHANGED(self._BindingID, modes)
	end
end

function ThermostatProxy:dev_HumidityState(state)
	-- state: current humidity state
	if (type(state) == "string" and self._HumidityState ~= state) then
		self._HumidityState = state
		NOTIFY.HUMIDITY_STATE_CHANGED(self._BindingID, state)
	end
end

function ThermostatProxy:dev_HumidifySetpoint(setpoint)
	-- setpoint: current humidify setpoint
	setpoint = tonumber(setpoint)
	if (type(setpoint) == "number" and self._HumidifySetpoint ~= setpoint) then
		self._HumidifySetpoint = setpoint
		NOTIFY.HUMIDIFY_SETPOINT_CHANGED(self._BindingID, setpoint)
	end
end

function ThermostatProxy:dev_DehumidifySetpoint(setpoint)
	-- setpoint: current dehumidify setpoint
	setpoint = tonumber(setpoint)
	if (type(setpoint) == "number" and self._DehumidifySetpoint ~= setpoint) then
		self._DehumidifySetpoint = setpoint
		NOTIFY.DEHUMIDIFY_SETPOINT_CHANGED(self._BindingID, setpoint)
	end
end

function ThermostatProxy:dev_Message(message)
	-- message: message to send to the UI
	if (type(message) == "string" and self._Message ~= message) then
		self._Message = message
		NOTIFY.MESSAGE_CHANGED(self._BindingID, message)
	end
end

function ThermostatProxy:dev_Capabilities(tCapabilities)
	-- tCapabilities: table of capabilities to change
	if (type(tCapabilities) == "table") then
		NOTIFY.DYNAMIC_CAPABILITIES_CHANGED(self._BindingID, tCapabilities)
	end
end

function ThermostatProxy:dev_ExtrasSetup(xml)
	-- message: message to send to the UI
	if (type(xml) == "string") then
		NOTIFY.EXTRAS_SETUP_CHANGED(self._BindingID, xml)
	end
end

function ThermostatProxy:dev_ExtrasState(xml)
	-- message: message to send to the UI
	if (type(xml) == "string") then
		NOTIFY.EXTRAS_STATE_CHANGED(self._BindingID, xml)
	end
end

function ThermostatProxy:dev_ScheduleEntry(dayIndex, entryIndex, enabled, entryTime, heatSetpoint, coolSetpoint, scale)
	LogTrace("ThermostatProxy:dev_ScheduleEntry(dayIndex = %s, entryIndex = %s, enabled = %s, entryTime = %s, heatSetpoint = %s, coolSetpoint = %s", dayIndex, entryIndex, enabled, entryTime, heatSetpoint, coolSetpoint)
	
	dayIndex = tonumber(dayIndex)
	entryIndex = tonumber(entryIndex)
	
	-- message: message to send to the UI
	self._Schedule[dayIndex] = self._Schedule[dayIndex] or {}
	self._Schedule[dayIndex][entryIndex] = self._Schedule[dayIndex][entryIndex] or {}
	self._Schedule[dayIndex][entryIndex].DayOfWeek = dayIndex
	self._Schedule[dayIndex][entryIndex].EntryIndex = entryIndex
	self._Schedule[dayIndex][entryIndex].IsEnabled = tostring(enabled)
	self._Schedule[dayIndex][entryIndex].EntryTime = entryTime

	if (string.sub(self._Scale, 1, 1) == "F") then
		self._Schedule[dayIndex][entryIndex].FahrenheitHeatSetpoint = heatSetpoint
		self._Schedule[dayIndex][entryIndex].FahrenheitCoolSetpoint = coolSetpoint
		self._Schedule[dayIndex][entryIndex].HeatSetpoint = heatSetpoint*(50/9)+2553.72
		self._Schedule[dayIndex][entryIndex].CoolSetpoint = coolSetpoint*(50/9)+2553.72
		self._Schedule[dayIndex][entryIndex].CelsiusHeatSetpoint = round((self._Schedule[dayIndex][entryIndex].HeatSetpoint - 2731)/10)
		self._Schedule[dayIndex][entryIndex].CelsiusCoolSetpoint = round((self._Schedule[dayIndex][entryIndex].CoolSetpoint - 2731)/10)
	elseif (string.sub(self._Scale, 1, 1) == "C") then
		self._Schedule[dayIndex][entryIndex].CelsiusHeatSetpoint = heatSetpoint
		self._Schedule[dayIndex][entryIndex].CelsiusCoolSetpoint = coolSetpoint
		self._Schedule[dayIndex][entryIndex].HeatSetpoint = (heatSetpoint*10)+2731.5
		self._Schedule[dayIndex][entryIndex].CoolSetpoint = (coolSetpoint*10)+2731.5
		self._Schedule[dayIndex][entryIndex].FahrenheitHeatSetpoint = round((self._Schedule[dayIndex][entryIndex].CelsiusHeatSetpoint*9)/5+32)
		self._Schedule[dayIndex][entryIndex].FahrenheitCoolSetpoint = round((self._Schedule[dayIndex][entryIndex].CelsiusCoolSetpoint*9)/5+32)
	else
		LogError("Empty or invalid scale.")
	end

	if (scale == nil) then
		scale = self._Scale
	end
	
	local tParams =
	{
		Enabled = tostring(enabled),
		SchedTime = tostring(entryTime),
		HeatSetpoint = tostring(heatSetpoint),
		CoolSetpoint = tostring(coolSetpoint),
		Units = scale
	}

	if (type(xml) == "string") then
		NOTIFY.SCHEDULE_ENTRY_CHANGED(self._BindingID, dayIndex, entryIndex, tParams)
	end
end
