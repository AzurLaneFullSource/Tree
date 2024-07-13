local var0_0 = require("string")
local var1_0 = _G
local var2_0 = require("table")
local var3_0 = require("socket")

var3_0.url = {}

local var4_0 = var3_0.url

var4_0._VERSION = "URL 1.0.3"

function var4_0.escape(arg0_1)
	return (var0_0.gsub(arg0_1, "([^A-Za-z0-9_])", function(arg0_2)
		return var0_0.format("%%%02x", var0_0.byte(arg0_2))
	end))
end

local var5_0 = (function(arg0_3)
	local var0_3 = {}

	for iter0_3, iter1_3 in var1_0.ipairs(arg0_3) do
		var0_3[arg0_3[iter0_3]] = 1
	end

	return var0_3
end)({
	"-",
	"_",
	".",
	"!",
	"~",
	"*",
	"'",
	"(",
	")",
	":",
	"@",
	"&",
	"=",
	"+",
	"$",
	","
})

local function var6_0(arg0_4)
	return var0_0.gsub(arg0_4, "([^A-Za-z0-9_])", function(arg0_5)
		if var5_0[arg0_5] then
			return arg0_5
		else
			return var0_0.format("%%%02x", var0_0.byte(arg0_5))
		end
	end)
end

function var4_0.unescape(arg0_6)
	return (var0_0.gsub(arg0_6, "%%(%x%x)", function(arg0_7)
		return var0_0.char(var1_0.tonumber(arg0_7, 16))
	end))
end

local function var7_0(arg0_8, arg1_8)
	if var0_0.sub(arg1_8, 1, 1) == "/" then
		return arg1_8
	end

	local var0_8 = var0_0.gsub(arg0_8, "[^/]*$", "") .. arg1_8
	local var1_8 = var0_0.gsub(var0_8, "([^/]*%./)", function(arg0_9)
		if arg0_9 ~= "./" then
			return arg0_9
		else
			return ""
		end
	end)
	local var2_8 = var0_0.gsub(var1_8, "/%.$", "/")
	local var3_8

	while var3_8 ~= var2_8 do
		var3_8 = var2_8
		var2_8 = var0_0.gsub(var3_8, "([^/]*/%.%./)", function(arg0_10)
			if arg0_10 ~= "../../" then
				return ""
			else
				return arg0_10
			end
		end)
	end

	return (var0_0.gsub(var3_8, "([^/]*/%.%.)$", function(arg0_11)
		if arg0_11 ~= "../.." then
			return ""
		else
			return arg0_11
		end
	end))
end

function var4_0.parse(arg0_12, arg1_12)
	local var0_12 = {}

	for iter0_12, iter1_12 in var1_0.pairs(arg1_12 or var0_12) do
		var0_12[iter0_12] = iter1_12
	end

	if not arg0_12 or arg0_12 == "" then
		return nil, "invalid url"
	end

	arg0_12 = var0_0.gsub(arg0_12, "#(.*)$", function(arg0_13)
		var0_12.fragment = arg0_13

		return ""
	end)
	arg0_12 = var0_0.gsub(arg0_12, "^([%w][%w%+%-%.]*)%:", function(arg0_14)
		var0_12.scheme = arg0_14

		return ""
	end)
	arg0_12 = var0_0.gsub(arg0_12, "^//([^/]*)", function(arg0_15)
		var0_12.authority = arg0_15

		return ""
	end)
	arg0_12 = var0_0.gsub(arg0_12, "%?(.*)", function(arg0_16)
		var0_12.query = arg0_16

		return ""
	end)
	arg0_12 = var0_0.gsub(arg0_12, "%;(.*)", function(arg0_17)
		var0_12.params = arg0_17

		return ""
	end)

	if arg0_12 ~= "" then
		var0_12.path = arg0_12
	end

	local var1_12 = var0_12.authority

	if not var1_12 then
		return var0_12
	end

	local var2_12 = var0_0.gsub(var1_12, "^([^@]*)@", function(arg0_18)
		var0_12.userinfo = arg0_18

		return ""
	end)
	local var3_12 = var0_0.gsub(var2_12, ":([^:%]]*)$", function(arg0_19)
		var0_12.port = arg0_19

		return ""
	end)

	if var3_12 ~= "" then
		var0_12.host = var0_0.match(var3_12, "^%[(.+)%]$") or var3_12
	end

	local var4_12 = var0_12.userinfo

	if not var4_12 then
		return var0_12
	end

	var0_12.user = var0_0.gsub(var4_12, ":([^:]*)$", function(arg0_20)
		var0_12.password = arg0_20

		return ""
	end)

	return var0_12
end

function var4_0.build(arg0_21)
	local var0_21 = var4_0.parse_path(arg0_21.path or "")
	local var1_21 = var4_0.build_path(var0_21)

	if arg0_21.params then
		var1_21 = var1_21 .. ";" .. arg0_21.params
	end

	if arg0_21.query then
		var1_21 = var1_21 .. "?" .. arg0_21.query
	end

	local var2_21 = arg0_21.authority

	if arg0_21.host then
		var2_21 = arg0_21.host

		if var0_0.find(var2_21, ":") then
			var2_21 = "[" .. var2_21 .. "]"
		end

		if arg0_21.port then
			var2_21 = var2_21 .. ":" .. arg0_21.port
		end

		local var3_21 = arg0_21.userinfo

		if arg0_21.user then
			var3_21 = arg0_21.user

			if arg0_21.password then
				var3_21 = var3_21 .. ":" .. arg0_21.password
			end
		end

		if var3_21 then
			var2_21 = var3_21 .. "@" .. var2_21
		end
	end

	if var2_21 then
		var1_21 = "//" .. var2_21 .. var1_21
	end

	if arg0_21.scheme then
		var1_21 = arg0_21.scheme .. ":" .. var1_21
	end

	if arg0_21.fragment then
		var1_21 = var1_21 .. "#" .. arg0_21.fragment
	end

	return var1_21
end

function var4_0.absolute(arg0_22, arg1_22)
	local var0_22

	if var1_0.type(arg0_22) == "table" then
		var0_22 = arg0_22
		arg0_22 = var4_0.build(var0_22)
	else
		var0_22 = var4_0.parse(arg0_22)
	end

	local var1_22 = var4_0.parse(arg1_22)

	if not var0_22 then
		return arg1_22
	elseif not var1_22 then
		return arg0_22
	elseif var1_22.scheme then
		return arg1_22
	else
		var1_22.scheme = var0_22.scheme

		if not var1_22.authority then
			var1_22.authority = var0_22.authority

			if not var1_22.path then
				var1_22.path = var0_22.path

				if not var1_22.params then
					var1_22.params = var0_22.params

					if not var1_22.query then
						var1_22.query = var0_22.query
					end
				end
			else
				var1_22.path = var7_0(var0_22.path or "", var1_22.path)
			end
		end

		return var4_0.build(var1_22)
	end
end

function var4_0.parse_path(arg0_23)
	local var0_23 = {}

	arg0_23 = arg0_23 or ""

	var0_0.gsub(arg0_23, "([^/]+)", function(arg0_24)
		var2_0.insert(var0_23, arg0_24)
	end)

	for iter0_23 = 1, #var0_23 do
		var0_23[iter0_23] = var4_0.unescape(var0_23[iter0_23])
	end

	if var0_0.sub(arg0_23, 1, 1) == "/" then
		var0_23.is_absolute = 1
	end

	if var0_0.sub(arg0_23, -1, -1) == "/" then
		var0_23.is_directory = 1
	end

	return var0_23
end

function var4_0.build_path(arg0_25, arg1_25)
	local var0_25 = ""
	local var1_25 = #arg0_25

	if arg1_25 then
		for iter0_25 = 1, var1_25 - 1 do
			var0_25 = var0_25 .. arg0_25[iter0_25]
			var0_25 = var0_25 .. "/"
		end

		if var1_25 > 0 then
			var0_25 = var0_25 .. arg0_25[var1_25]

			if arg0_25.is_directory then
				var0_25 = var0_25 .. "/"
			end
		end
	else
		for iter1_25 = 1, var1_25 - 1 do
			var0_25 = var0_25 .. var6_0(arg0_25[iter1_25])
			var0_25 = var0_25 .. "/"
		end

		if var1_25 > 0 then
			var0_25 = var0_25 .. var6_0(arg0_25[var1_25])

			if arg0_25.is_directory then
				var0_25 = var0_25 .. "/"
			end
		end
	end

	if arg0_25.is_absolute then
		var0_25 = "/" .. var0_25
	end

	return var0_25
end

return var4_0
