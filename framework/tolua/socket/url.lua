local var0 = require("string")
local var1 = _G
local var2 = require("table")
local var3 = require("socket")

var3.url = {}

local var4 = var3.url

var4._VERSION = "URL 1.0.3"

function var4.escape(arg0)
	return (var0.gsub(arg0, "([^A-Za-z0-9_])", function(arg0)
		return var0.format("%%%02x", var0.byte(arg0))
	end))
end

local var5 = (function(arg0)
	local var0 = {}

	for iter0, iter1 in var1.ipairs(arg0) do
		var0[arg0[iter0]] = 1
	end

	return var0
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

local function var6(arg0)
	return var0.gsub(arg0, "([^A-Za-z0-9_])", function(arg0)
		if var5[arg0] then
			return arg0
		else
			return var0.format("%%%02x", var0.byte(arg0))
		end
	end)
end

function var4.unescape(arg0)
	return (var0.gsub(arg0, "%%(%x%x)", function(arg0)
		return var0.char(var1.tonumber(arg0, 16))
	end))
end

local function var7(arg0, arg1)
	if var0.sub(arg1, 1, 1) == "/" then
		return arg1
	end

	local var0 = var0.gsub(arg0, "[^/]*$", "") .. arg1
	local var1 = var0.gsub(var0, "([^/]*%./)", function(arg0)
		if arg0 ~= "./" then
			return arg0
		else
			return ""
		end
	end)
	local var2 = var0.gsub(var1, "/%.$", "/")
	local var3

	while var3 ~= var2 do
		var3 = var2
		var2 = var0.gsub(var3, "([^/]*/%.%./)", function(arg0)
			if arg0 ~= "../../" then
				return ""
			else
				return arg0
			end
		end)
	end

	return (var0.gsub(var3, "([^/]*/%.%.)$", function(arg0)
		if arg0 ~= "../.." then
			return ""
		else
			return arg0
		end
	end))
end

function var4.parse(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in var1.pairs(arg1 or var0) do
		var0[iter0] = iter1
	end

	if not arg0 or arg0 == "" then
		return nil, "invalid url"
	end

	arg0 = var0.gsub(arg0, "#(.*)$", function(arg0)
		var0.fragment = arg0

		return ""
	end)
	arg0 = var0.gsub(arg0, "^([%w][%w%+%-%.]*)%:", function(arg0)
		var0.scheme = arg0

		return ""
	end)
	arg0 = var0.gsub(arg0, "^//([^/]*)", function(arg0)
		var0.authority = arg0

		return ""
	end)
	arg0 = var0.gsub(arg0, "%?(.*)", function(arg0)
		var0.query = arg0

		return ""
	end)
	arg0 = var0.gsub(arg0, "%;(.*)", function(arg0)
		var0.params = arg0

		return ""
	end)

	if arg0 ~= "" then
		var0.path = arg0
	end

	local var1 = var0.authority

	if not var1 then
		return var0
	end

	local var2 = var0.gsub(var1, "^([^@]*)@", function(arg0)
		var0.userinfo = arg0

		return ""
	end)
	local var3 = var0.gsub(var2, ":([^:%]]*)$", function(arg0)
		var0.port = arg0

		return ""
	end)

	if var3 ~= "" then
		var0.host = var0.match(var3, "^%[(.+)%]$") or var3
	end

	local var4 = var0.userinfo

	if not var4 then
		return var0
	end

	var0.user = var0.gsub(var4, ":([^:]*)$", function(arg0)
		var0.password = arg0

		return ""
	end)

	return var0
end

function var4.build(arg0)
	local var0 = var4.parse_path(arg0.path or "")
	local var1 = var4.build_path(var0)

	if arg0.params then
		var1 = var1 .. ";" .. arg0.params
	end

	if arg0.query then
		var1 = var1 .. "?" .. arg0.query
	end

	local var2 = arg0.authority

	if arg0.host then
		var2 = arg0.host

		if var0.find(var2, ":") then
			var2 = "[" .. var2 .. "]"
		end

		if arg0.port then
			var2 = var2 .. ":" .. arg0.port
		end

		local var3 = arg0.userinfo

		if arg0.user then
			var3 = arg0.user

			if arg0.password then
				var3 = var3 .. ":" .. arg0.password
			end
		end

		if var3 then
			var2 = var3 .. "@" .. var2
		end
	end

	if var2 then
		var1 = "//" .. var2 .. var1
	end

	if arg0.scheme then
		var1 = arg0.scheme .. ":" .. var1
	end

	if arg0.fragment then
		var1 = var1 .. "#" .. arg0.fragment
	end

	return var1
end

function var4.absolute(arg0, arg1)
	local var0

	if var1.type(arg0) == "table" then
		var0 = arg0
		arg0 = var4.build(var0)
	else
		var0 = var4.parse(arg0)
	end

	local var1 = var4.parse(arg1)

	if not var0 then
		return arg1
	elseif not var1 then
		return arg0
	elseif var1.scheme then
		return arg1
	else
		var1.scheme = var0.scheme

		if not var1.authority then
			var1.authority = var0.authority

			if not var1.path then
				var1.path = var0.path

				if not var1.params then
					var1.params = var0.params

					if not var1.query then
						var1.query = var0.query
					end
				end
			else
				var1.path = var7(var0.path or "", var1.path)
			end
		end

		return var4.build(var1)
	end
end

function var4.parse_path(arg0)
	local var0 = {}

	arg0 = arg0 or ""

	var0.gsub(arg0, "([^/]+)", function(arg0)
		var2.insert(var0, arg0)
	end)

	for iter0 = 1, #var0 do
		var0[iter0] = var4.unescape(var0[iter0])
	end

	if var0.sub(arg0, 1, 1) == "/" then
		var0.is_absolute = 1
	end

	if var0.sub(arg0, -1, -1) == "/" then
		var0.is_directory = 1
	end

	return var0
end

function var4.build_path(arg0, arg1)
	local var0 = ""
	local var1 = #arg0

	if arg1 then
		for iter0 = 1, var1 - 1 do
			var0 = var0 .. arg0[iter0]
			var0 = var0 .. "/"
		end

		if var1 > 0 then
			var0 = var0 .. arg0[var1]

			if arg0.is_directory then
				var0 = var0 .. "/"
			end
		end
	else
		for iter1 = 1, var1 - 1 do
			var0 = var0 .. var6(arg0[iter1])
			var0 = var0 .. "/"
		end

		if var1 > 0 then
			var0 = var0 .. var6(arg0[var1])

			if arg0.is_directory then
				var0 = var0 .. "/"
			end
		end
	end

	if arg0.is_absolute then
		var0 = "/" .. var0
	end

	return var0
end

return var4
