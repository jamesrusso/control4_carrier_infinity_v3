--[[=============================================================================
    Initialization Functions

    Copyright 2015 Control4 Corporation. All Rights Reserved.
===============================================================================]]
require "thermostat.thermostat_proxy_class"
require "thermostat.thermostat_proxy_commands"
require "thermostat.thermostat_proxy_notifies"

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.proxy_init = "2014.12.11"
end

function ON_DRIVER_EARLY_INIT.proxy_init()
	-- declare and initialize global variables
end

function ON_DRIVER_INIT.proxy_init()
	-- instantiate the thermostat proxy class
	gTStatProxy = ThermostatProxy:new(DEFAULT_PROXY_BINDINGID)
	gTStatProxy:dev_Scale("F") -- default to Fahrenheit
end

function ON_DRIVER_LATEINIT.proxy_init()
	
end
