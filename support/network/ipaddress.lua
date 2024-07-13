pg = pg or {}

local var0_0 = pg

var0_0.IPAddress = class("IPAddress")

local var1_0 = var0_0.IPAddress
local var2_0 = "https://www.azurlane.tw/getip"
local var3_0 = {
	{
		"202.39.128.0",
		"202.39.255.255"
	},
	{
		"203.66.0.0",
		"203.66.255.255"
	},
	{
		"203.69.0.0",
		"203.69.255.255"
	},
	{
		"203.75.0.0",
		"203.75.255.255"
	},
	{
		"203.74.0.0",
		"203.74.255.255"
	},
	{
		"210.65.0.0",
		"210.65.255.255"
	},
	{
		"210.71.128.0",
		"210.71.255.255"
	},
	{
		"210.61.0.0",
		"210.61.255.255"
	},
	{
		"210.62.248.0",
		"210.62.255.255"
	},
	{
		"210.59.128.0",
		"210.59.255.255"
	},
	{
		"210.242.0.0",
		"210.242.127.255"
	},
	{
		"210.242.128.0",
		"210.242.255.255"
	},
	{
		"210.241.224.0",
		"210.241.255.255"
	},
	{
		"211.72.0.0",
		"211.72.127.255"
	},
	{
		"211.72.128.0",
		"211.72.255.255"
	},
	{
		"211.75.0.0",
		" 211.75.127.255"
	},
	{
		"211.75.128.0",
		"211.75.255.255"
	},
	{
		"211.20.0.0",
		"211.20.255.255"
	},
	{
		"211.21.0.0",
		"211.21.255.255"
	},
	{
		"211.22.0.0",
		"211.22.255.255"
	},
	{
		"211.23.0.0",
		"211.23.255.255"
	},
	{
		"61.216.0.0",
		"61.219.255.255"
	},
	{
		"61.220.0.0",
		"61.227.255.255"
	},
	{
		"61.228.0.0",
		"61.231.255.255"
	},
	{
		"218.160.0.0",
		"218.165.255.255"
	}
}

function var1_0.Ctor(arg0_1)
	arg0_1:ConvertIPRange()

	arg0_1.requestUrl = var2_0

	if not IsUnityEditor then
		VersionMgr.Inst:WebRequest(arg0_1.requestUrl, function(arg0_2, arg1_2)
			arg0_1.exportIP = arg1_2
			arg0_1.isSpecialIP = arg0_1:CheckExportIP()
		end)
	end
end

function var1_0.IsIPString(arg0_3, arg1_3)
	if type(arg1_3) ~= "string" then
		return false
	end

	local var0_3 = string.len(arg1_3)

	if var0_3 < 7 or var0_3 > 15 then
		return false
	end

	local var1_3 = string.find(arg1_3, "%p", 1)
	local var2_3 = 0

	while var1_3 ~= nil do
		if string.sub(arg1_3, var1_3, var1_3) ~= "." then
			return false
		end

		var2_3 = var2_3 + 1
		var1_3 = string.find(arg1_3, "%p", var1_3 + 1)

		if var2_3 > 3 then
			return false
		end
	end

	if var2_3 ~= 3 then
		return false
	end

	local var3_3 = {}

	for iter0_3 in string.gmatch(arg1_3, "%d+") do
		var3_3[#var3_3 + 1] = iter0_3

		local var4_3 = tonumber(iter0_3)

		if var4_3 == nil or var4_3 > 255 then
			return false
		end
	end

	if #var3_3 ~= 4 then
		return false
	end

	return true
end

function var1_0.IP2Int(arg0_4, arg1_4)
	local var0_4 = 0
	local var1_4, var2_4, var3_4, var4_4 = arg1_4:match("(%d+)%.(%d+)%.(%d+)%.(%d+)")

	return 16777216 * var1_4 + 65536 * var2_4 + 256 * var3_4 + var4_4
end

function var1_0.ConvertIPRange(arg0_5)
	arg0_5.IPRangeIntList = {}

	for iter0_5, iter1_5 in ipairs(var3_0) do
		local var0_5 = {}
		local var1_5 = arg0_5:IP2Int(iter1_5[1])

		table.insert(var0_5, var1_5)

		local var2_5 = arg0_5:IP2Int(iter1_5[2])

		table.insert(var0_5, var2_5)
		assert(var1_5 < var2_5, "ip range is illegal" .. iter1_5[1] .. "-" .. iter1_5[2])
		table.insert(arg0_5.IPRangeIntList, var0_5)
	end
end

function var1_0.CheckExportIP(arg0_6)
	if not arg0_6.exportIP or not arg0_6:IsIPString(arg0_6.exportIP) then
		return false
	end

	local var0_6 = arg0_6:IP2Int(arg0_6.exportIP)

	for iter0_6, iter1_6 in ipairs(arg0_6.IPRangeIntList) do
		if var0_6 >= iter1_6[1] and var0_6 <= iter1_6[2] then
			return true
		end
	end

	return false
end

function var1_0.GetExportIPString(arg0_7)
	return arg0_7.exportIP
end

function var1_0.GetLocalIP(arg0_8)
	local var0_8 = ReflectionHelp.RefGetProperty(typeof("UnityEngine.Network"), "player")

	arg0_8.localIP = ReflectionHelp.RefGetProperty(typeof("UnityEngine.NetworkPlayer"), "ipAddress", var0_8)

	return arg0_8.localIP
end

function var1_0.IsSpecialIP(arg0_9)
	return arg0_9.isSpecialIP
end
