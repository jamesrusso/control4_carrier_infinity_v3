--[[=============================================================================
    Properties Code

    Copyright 2015 Control4 Corporation. All Rights Reserved.
===============================================================================]]

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.properties = "2014.10.31"
end


function ON_PROPERTY_CHANGED.SetpointHoldMode(propertyValue)
    if (propertyValue == "Permanent") then
            gSetpointHoldMode = ""
    else
            gSetpointHoldMode = propertyValue
    end

    LogDebug("gSetpointHoldMode=%s", gSetpointHoldMode)
end

function ON_PROPERTY_CHANGED.PollingTimer(propertyValue)
	gPollingTimerInterval = propertyValue:match(".-(%d+).-") or 1

	if (gCon ~= nil) then
		gCon._PollingInterval = gPollingTimerInterval
		gCon:StartPolling(gPollingTimerInterval, "MINUTES")
	else
		LogTrace ("ON_PROPERTY_CHANGED.PollingTimer - gCon = nil, polling timer not started.")
	end
end
