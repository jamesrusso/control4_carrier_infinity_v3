--[[=============================================================================
    c4_timer Class

    Copyright 2015 Control4 Corporation. All Rights Reserved.
===============================================================================]]
require "common.c4_driver_declarations"
require "lib.c4_object"

-- Set template version for this file
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.c4_timer = "2014.10.31"
end

c4_timer = inheritsFrom(nil)

function c4_timer:construct(name, interval, units, Callback, repeating, CallbackParam)
	self._name = name
	self._timerID = TimerLibGetNextTimerID()
	self._interval = interval
	self._units = units
	self._repeating = repeating or false
	self._Callback = Callback
	self._CallbackParam = CallbackParam or ""
	self._id = 0

	gTimerLibTimers[self._timerID] = self
	if (LOG ~= nil and type(LOG) == "table") then
		LogTrace("Created timer " .. self._name)
	end
end

function c4_timer:StartTimer(...)
	c4_timer:KillTimer()

	-- optional parameters (interval, units, repeating)
	if ... then
		local interval = select(1, ...)
		local units = select(2, ...)
		local repeating = select(3, ...)

		self._interval = interval or self._interval
		self._units = units or self._units
		self._repeating = repeating or self._repeating
	end

	if (tonumber(self._interval) > 0) then
		if (LOG ~= nil and type(LOG) == "table") then
			LogTrace("Starting Timer: " .. self._name)
		end

		self._id = C4:AddTimer(self._interval, self._units, self._repeating)
	end
end

function c4_timer:KillTimer()
	if (self._id) then
		self._id = C4:KillTimer(self._id)
	end
end

function c4_timer:TimerStarted()
	return (self._id ~= 0)
end

function c4_timer:TimerStopped()
	return (self._id == 0)
end

function c4_timer:GetTimerInterval()
	return (self._interval)
end

function TimerLibGetNextTimerID()
	gTimerLibTimerCurID = gTimerLibTimerCurID + 1
	return gTimerLibTimerCurID
end

function ON_DRIVER_EARLY_INIT.c4_timer()
	gTimerLibTimers = {}
	gTimerLibTimerCurID = 0
end

function ON_DRIVER_DESTROYED.c4_timer()
	-- Kill open timers
	for k,v in pairs(gTimerLibTimers) do
		v:KillTimer()
	end
end

--[[
OnTimerExpired
Function called by Director when the specified Control4 timer expires.
	Parameters
	idTimer
	Timer ID of expired timer.
--]]
function OnTimerExpired(idTimer)
	for k,v in pairs(gTimerLibTimers) do
		if (idTimer == v._id) then
			if (v._Callback) then
				v._Callback(v._CallbackParam)
			end
		end
	end
end

--[[=============================================================================
    c4_timer Unit Tests
===============================================================================]]
function __test_c4_timer()
	require "test.C4Virtual"
	require "lib.c4_log"
	require "common.c4_init"

	OnDriverInit()

	local LOG = c4_log:new("test_c4_timer")
	LOG:SetLogLevel(5)
	LOG:OutputPrint(true)

	function OnTestTimerExpired()
		c4Timer:KillTimer()
	end

	-- create an instance of the timer
	c4Timer = c4_timer:new("Test", 45, "MINUTES", OnTestTimerExpired)

	assert(c4Timer._id == 0, "_id is not equal to '0' it is: " .. c4Timer._id)
	c4Timer:StartTimer()
	assert(c4Timer._id == 10001, "_id is not equal to '10001' it is: " .. c4Timer._id)
	assert(c4Timer:TimerStarted() == true, "TimerStarted is not equal to true it is: " .. tostring(c4Timer:TimerStarted()))
	assert(c4Timer:TimerStopped() == false, "TimerStopped is not equal to false it is: " .. tostring(c4Timer:TimerStopped()))
	OnTimerExpired(c4Timer._id)
	assert(c4Timer:TimerStarted() == false, "TimerStarted is not equal to false it is: " .. tostring(c4Timer:TimerStarted()))
	assert(c4Timer:TimerStopped() == true, "TimerStopped is not equal to true it is: " .. tostring(c4Timer:TimerStopped()))
end