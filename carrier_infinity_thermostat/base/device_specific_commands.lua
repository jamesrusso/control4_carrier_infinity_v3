--[[=============================================================================
    Copyright 2015 Control4 Corporation. All Rights Reserved.
===============================================================================]]

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.device_specific_commands = "2014.10.31"
end

--[[=============================================================================
    ExecuteCommand Code

    Define any functions for device specific commands (EX_CMD.<command>)
    received from ExecuteCommand that need to be handled by the driver.
===============================================================================]]
-- commands received from Carrier Infinity Network driver
function EX_CMD.COOL_SETPOINT_CHANGED(tParams)
	gTStatProxy:dev_CoolSetpoint(tParams["SETPOINT"], gScale)
end

function EX_CMD.SET_UNOCCUPIED_MODE(tParams)
    LogInfo("Setting SET_UNOCCUPIED_MODE")
    SendToCarrier('SET_OCCUPIED_MODE', { OCCUPIED_MODE = false});
end

function EX_CMD.SET_OCCUPIED_MODE(tParams)
    LogInfo("Setting SET_OCCUPIED_MODE")
    SendToCarrier('SET_OCCUPIED_MODE', { OCCUPIED_MODE = true });
end

function EX_CMD.FANMODE_CHANGED(tParams)
	gTStatProxy:dev_FanMode(tParams["FANMODE"])
end

function EX_CMD.HVACSTATE_CHANGED(tParams)
	gTStatProxy:dev_HVACState(tParams["HVACSTATE"])
end

function EX_CMD.FAN_STATE(tParams)
	gTStatProxy:dev_FanState(tParams["STATE"])
end

function EX_CMD.HEAT_SETPOINT_CHANGED(tParams)
	gTStatProxy:dev_HeatSetpoint(tParams["SETPOINT"], gScale)
end

function EX_CMD.HVACMODE_CHANGED(tParams)
	local HVACMode = tParams["HVACMODE"]
	if (HVACMode == "EMERGENCYHEAT") then
		if (gEmergencyMode == false) then
			LogInfo("Setting EMERGENCY_MODE = 1")
			C4:SetVariable("EMERGENCY_MODE", 1)
			gEmergencyMode = true
		end
		HVACMode = "HEAT"
	else
		if (gEmergencyMode == true) then
			LogInfo("Setting EMERGENCY_MODE = 0")
			C4:SetVariable("EMERGENCY_MODE", 0)
			gEmergencyMode = false
		end
	end

	gTStatProxy:dev_HVACMode(HVACMode)
end

function EX_CMD.SCALE_CHANGED(tParams)
	gScale = tParams["SCALE"]
	gTStatProxy:dev_Scale(tParams["SCALE"])
end

function EX_CMD.HOLDMODE_CHANGED(tParams)
	gTStatProxy:dev_HoldMode(tParams["HOLDMODE"])
end

function EX_CMD.TEMPERATURE_CHANGED(tParams)
	gTStatProxy:dev_Temperature(tParams["TEMPERATURE"], gScale)
end

function EX_CMD.OUTDOOR_TEMPERATURE_CHANGED(tParams)
	gTStatProxy:dev_OutdoorTemperature(tParams["TEMPERATURE"], gScale)
end

function EX_CMD.HUMIDITY_CHANGED(tParams)
	gTStatProxy:dev_Humidity(tParams["HUMIDITY"])
end

function EX_CMD.SYSTEMMODES_CHANGED(tParams)
	gTStatProxy:dev_AllowedHVACModes(tParams["MODES"], toboolean(tParams["CAN_HEAT"]), toboolean(tParams["CAN_COOL"]), toboolean(tParams["CAN_AUTO"]))
end

function EX_CMD.MESSAGE_CHANGED(tParams)
    LogTrace("MESSAGE_CHANGED: =>%s<=", tParams["MESSAGE"])
	gTStatProxy:dev_Message(tParams["MESSAGE"])
end

function EX_CMD.GET_EXTRAS_SETUP(tParams)
	LogTrace("GET_EXTRAS_SETUP() *****")
	gTStatProxy:dev_ExtrasSetup(GetExtrasSetup())
end

function GetExtrasSetup()
	xml = [[
	<extras_setup>
		<extra>
			<section label = "Misc">
				<object type = "button" id = "RefreshData" label = "Refresh Data" command = "REFRESH_DATA">
                    <buttontext>Refresh</buttontext>
                </object>
            </section>
			<section label = "Occupied">
			    <object type = "switch" id = "Occupied" label = "Occupied Mode" command = "SET_OCCUPIED" value = "false"></object>
            </section>
		</extra>
	</extras_setup>
	]]
	return removeNewlines(xml)
end

function GetExtrasSetupTest()
	xml = [[
	<extras_setup>
		<extra>
			<section label = "Vacation">
				<object type = "number" id = "NumVacDays" label = "Number of Days" command = "SET_VACATION_DAYS" min = "1" max = "255" resolution = "1" value = "7"></object>
				<object type = "switch" id = "Vacation" label = "Vacation Mode" command = "SET_VACATION" value = "true">
					<extraparameters>
						<param name = "NumDays" object_link_id = "NumVacDays"/>
					</extraparameters>
				</object>
				<object type = "text" id = "DaysRemaining" label = "Vacation Days Remaining" command = "DAYS_REMAINING" value = "0"></object>
			</section>
			<section label = "Test Extras">
				<object type = "button" id = "SetVacation" label = "Set Vacation" command = "SET_VACATION" buttontext = "Set Vacation">
					<extraparameters>
						<param name = "NumDays" object_link_id = "NumVacDays"/>
					</extraparameters>
				</object>
				<object type = "checkbox" id = "1" label = "Check Box" command = "CHECKBOX_ENABLED" value = "true"/>
				<object type = "list" id = "2" label = "List Type" command = "LIST_ITEM" value = "Off">
					<list maxselections = "1" minselections = "1">
						<item text = "Off" value = "0"/>
						<item text = "3 Hour Event" value = "1"/>
						<item text = "24 Hour Event" value = "2"/>
						<item text = "Hour Event" value = "3"/>
						<item text = "Automatic" value = "4"/>
					</list>
				</object>
				<object type = "switch" id = "3" label = "Switch Object" command = "SET_SWITCH" value = "true">
					<extraparameters>
						<param name = "NumDays" object_link_id = "NumVacDays"/>
						<param name = "Id1_CheckBox" object_link_id = "1"/>
						<param name = "Id2_List" object_link_id = "2"/>
					</extraparameters>
				</object>
				<object type = "text" id = "4" label = "Text Object" command = "SET_TEXT" value = "Default"></object>
				<object type = "slider" id = "5" label = "Slider Object" command = "SET_SLIDER" value = "30" min = "1" max = "100" resolution = "1"></object>
			</section>
		</extra>
	</extras_setup>
	]]

	return removeNewlines(xml)
end

function removeNewlines(string)
	return string.gsub(string, "\n", "") -- remove line breaks
end
