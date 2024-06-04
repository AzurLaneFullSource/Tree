pg = pg or {}

local var0 = pg

var0.IPAddress = class("IPAddress")

local var1 = var0.IPAddress
local var2 = "https://www.azurlane.tw/getip"
local var3 = {
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

function var1.Ctor(arg0)
	arg0:ConvertIPRange()

	arg0.requestUrl = var2

	if not IsUnityEditor then
		VersionMgr.Inst:WebRequest(arg0.requestUrl, function(arg0, arg1)
			arg0.exportIP = arg1
			arg0.isSpecialIP = arg0:CheckExportIP()
		end)
	end
end

function var1.IsIPString(arg0, arg1)
	if type(arg1) ~= "string" then
		return false
	end

	local var0 = string.len(arg1)

	if var0 < 7 or var0 > 15 then
		return false
	end

	local var1 = string.find(arg1, "%p", 1)
	local var2 = 0

	while var1 ~= nil do
		if string.sub(arg1, var1, var1) ~= "." then
			return false
		end

		var2 = var2 + 1
		var1 = string.find(arg1, "%p", var1 + 1)

		if var2 > 3 then
			return false
		end
	end

	if var2 ~= 3 then
		return false
	end

	local var3 = {}

	for iter0 in string.gmatch(arg1, "%d+") do
		var3[#var3 + 1] = iter0

		local var4 = tonumber(iter0)

		if var4 == nil or var4 > 255 then
			return false
		end
	end

	if #var3 ~= 4 then
		return false
	end

	return true
end

function var1.IP2Int(arg0, arg1)
	local var0 = 0
	local var1, var2, var3, var4 = arg1:match("(%d+)%.(%d+)%.(%d+)%.(%d+)")

	return 16777216 * var1 + 65536 * var2 + 256 * var3 + var4
end

function var1.ConvertIPRange(arg0)
	arg0.IPRangeIntList = {}

	for iter0, iter1 in ipairs(var3) do
		local var0 = {}
		local var1 = arg0:IP2Int(iter1[1])

		table.insert(var0, var1)

		local var2 = arg0:IP2Int(iter1[2])

		table.insert(var0, var2)
		assert(var1 < var2, "ip range is illegal" .. iter1[1] .. "-" .. iter1[2])
		table.insert(arg0.IPRangeIntList, var0)
	end
end

function var1.CheckExportIP(arg0)
	if not arg0.exportIP or not arg0:IsIPString(arg0.exportIP) then
		return false
	end

	local var0 = arg0:IP2Int(arg0.exportIP)

	for iter0, iter1 in ipairs(arg0.IPRangeIntList) do
		if var0 >= iter1[1] and var0 <= iter1[2] then
			return true
		end
	end

	return false
end

function var1.GetExportIPString(arg0)
	return arg0.exportIP
end

function var1.GetLocalIP(arg0)
	local var0 = ReflectionHelp.RefGetProperty(typeof("UnityEngine.Network"), "player")

	arg0.localIP = ReflectionHelp.RefGetProperty(typeof("UnityEngine.NetworkPlayer"), "ipAddress", var0)

	return arg0.localIP
end

function var1.IsSpecialIP(arg0)
	return arg0.isSpecialIP
end
