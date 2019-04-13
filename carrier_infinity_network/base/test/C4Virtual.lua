--[[=============================================================================
    Control4 Mock Functions

    Copyright 2015 Control4 Corporation. All Rights Reserved.
===============================================================================]]

-- Control4 table of Functions/Variables
C4 = {}

-- Initialize Properties
Properties = {
	['Log Mode'] = 'Print',
	['Log Level'] = '5 - Debug',
	}

function C4:AddVariable(strName, strOther, strType)
	print ("C4:AddVariable()")
end

function C4:ErrorLog(strError)
	print ("C4:ErrorLog()->  " .. strError)
end

gTimerId = 10000
function C4:AddTimer(interval, units)
	gTimerId = gTimerId + 1
	return gTimerId
end

function C4:UpdateProperty(key, value)
	Properties[key] = value
end

function C4:KillTimer(idTimer)
	return 0
end

function C4:SendToSerial(bindingId, sCommand)
	print ("C4:SendToSerial on binding: " .. bindingId .. "\r\n")
	hexdump(sCommand)
end

function hexdump(buf, printFunc)
	local outtable, ins = {}, table.insert
	printFunc = printFunc or print

	for byte=1, #buf, 16 do
		local chunk = buf:sub(byte, byte+15)
		ins(outtable, string.format('%08X  ',byte-1))

		local chunkleft, chunkright = chunk:sub(1, 8), chunk:sub(9)
		chunkleft:gsub('.', function (c) ins(outtable, string.format('%02X ',string.byte(c))) end)
		ins(outtable, ' ')

		chunkright:gsub('.', function (c) ins(outtable, string.format('%02X ',string.byte(c))) end)
		ins(outtable, string.rep(' ',3*(16-#chunk)))

		chunk = chunk:gsub("[^%p%w%s]", '.')
		chunk = chunk:gsub("[\r\n]", '.')
		ins(outtable, ' ' .. chunk .. '\r\n')
	end

	printFunc(table.concat(outtable))
end

function tohex(str)
	local offset,dif = string.byte("0"), string.byte("A") - string.byte("9") - 1
	local hex = ""
	str = str:upper()
	for a,b in str:gfind "(%S)(%S)%s*" do
		a,b = a:upper():byte() - offset, b:upper():byte()-offset
		a,b = a>10 and a - dif or a, b>10 and b - dif or b
		local code = a*16+b
		hex = hex .. string.char(code)
	end
	return hex
end

function C4:SendToProxy(idBinding, Command, Params, Value, CallType)

	LogTrace("C4:SendToProxy>>  idBinding is: " .. idBinding .. "  Command is: " .. Command)
	if (Params ~= nil) then
		LogTrace(Params)
	end

	if (Value ~= nil) then
		LogTrace("Value: " .. Value)
	end

	if (CallType ~= nil) then
		LogTrace("CallType: " .. CallType)
	end
end

-- function C4:SendToSerial(idBinding, SerialString)
	-- print("C4:SendToSerial-- idBinding is: " .. idBinding .. "  Serial String is : " .. SerialString)
-- end

function C4:GetCapability(capability)
	local retValue = ""

	if (capability == "default_aux_names") then
		retValue = "<names_list><button_name index=\"0\">Pool Cleaner</button_name><button_name index=\"1\">Low Speed Pump</button_name><button_name index=\"2\">Spa Spillover</button_name></names_list>"
	elseif (capability == "button_list") then
		retValue = "<heat>\n        <button>\n          <id>51</id>\n          <button_text>Pool Heater</button_text>\n          <button_name>POOLHT</button_name>\n        </button>\n        <button>\n          <id>53</id>\n          <button_text>Spa Heater</button_text>\n          <button_name>SPAHT</button_name>\n        </button>\n        <button>\n          <id>54</id>\n          <button_text>Pool Solar Heater</button_text>\n          <button_name>SOLHT</button_name>\n        </button>\n      </heat>"
	end

	return retValue
end

function C4:ParseXml(xmlString)
	require ("test.xml")
	return (XmlParser:ParseXmlText(xmlString))
end

function C4:XmlEscapeString(xmlString)
	return xmlString
end

function C4:urlPost(url, data)
	return data
end

function C4:InvalidateState()
end