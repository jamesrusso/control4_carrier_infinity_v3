--[[=============================================================================
    Lua Action Code

    Copyright 2015 Control4 Corporation. All Rights Reserved.
===============================================================================]]

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.actions = "2014.10.31"
end

-- Driver Actions

function LUA_ACTION.TemplateVersion()
	TemplateVersion()
end

function DisplayDevice(deviceID, System, Zone)
	print (deviceID, System, Zone)
end

function LUA_ACTION.DisplayCarrierDevices()
	ForEachDevice(DisplayDevice)
end

function LUA_ACTION.GetCurrentSettings()
	GetAllSystemSettings()
end
