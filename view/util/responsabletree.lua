local var0 = {}

var0.__cname = "ResponsableTree"
var0.__ctype = 2

local var1 = {
	__mode = "kv"
}

var0.InstanceMap = setmetatable({}, var1)
var0.DATA_ADD = 1
var0.DATA_UPDATE = 0
var0.DATA_DELETE = -1

function var0.__index(arg0, arg1)
	return var0[arg1] or arg0._properties[arg1]
end

local var2 = 1000
local var3 = 0

function var0.__newindex(arg0, arg1, arg2)
	local var0 = rawget(arg0._properties, arg1)

	if var0 ~= arg2 and not arg0._quiet then
		local var1 = var0
		local var2 = var0.CreateShell(arg2, arg0)

		arg0._properties[arg1] = var2

		local var3 = var0.DATA_UDPATE

		var3 = var1 == nil and var0.DATA_ADD or var3
		var3 = var2 == nil and var0.DATA_DELETE or var3

		if type(var1) == "table" and var1.class == var0 then
			var1._parents[arg0] = nil
		end

		if type(var2) == "table" and var2.class == var0 then
			var2._parents[arg0] = true
		end

		var3 = 0

		arg0:Response(arg0, {
			arg1
		}, {
			var0,
			var3
		})
	end
end

function var0.Response(arg0, arg1, arg2, arg3)
	if var3 >= var2 then
		errorMsg("Exceed the Iterate Limitation, Might have inherit loop")

		return
	end

	var3 = var3 + 1

	local var0 = not next(arg0._listeners)

	if not var0 then
		local var1 = table.concat(arg2, ".")

		for iter0, iter1 in ipairs(arg0._listeners) do
			local var2 = iter1.settings

			for iter2, iter3 in ipairs(iter1.keys) do
				local var3 = "^" .. iter3 .. "$"
				local var4 = string.match(var1, var3)

				if not var4 and (not var2 or not var2.strict) then
					local var5 = "^" .. iter3 .. "%."

					var4 = string.match(var1, var5)
				end

				if var4 then
					var0 = var0 or var2 and not var2.NoAffectOnTransparent

					arg0:DoAction(iter1, arg2, arg3)

					break
				end
			end
		end
	end

	if not var0 or not next(arg0._parents) then
		return
	end

	local var6 = table.getCount(arg0._parents)

	for iter4, iter5 in pairs(arg0._parents) do
		var6 = var6 - 1

		local var7 = var6 > 0 and Clone(arg2) or arg2

		table.insert(var7, 1, table.keyof(iter4:GetRawData(), arg0))
		iter4:Response(arg1, var7, arg3)
	end
end

function var0.DoAction(arg0, arg1, arg2, arg3)
	local var0 = {}
	local var1 = #arg1.keys

	for iter0, iter1 in ipairs(arg1.keys) do
		local var2 = string.split(iter1, ".") or {}
		local var3 = arg0
		local var4 = 0

		while var3 and var4 < #var2 do
			var4 = var4 + 1
			var3 = var3[var2[var4]]
		end

		var0[iter0] = var3
	end

	if arg1.settings and arg1.settings.useOldRef then
		local var5 = table.shallowCopy(var0)

		for iter2, iter3 in ipairs(arg1.keys) do
			local var6 = string.split(iter3, ".") or {}

			if table.equal(var6, arg2) then
				var5[iter2] = arg3[1]

				break
			end
		end

		arg1.listener(var1, var0, var5, arg3[2])
	else
		arg1.listener(unpack(var0, 1, var1))
	end
end

function var0.PropertyChange(arg0, arg1)
	var3 = 0

	arg0:Response(arg0, {
		arg1
	}, {
		arg0[arg1],
		var0.DATA_UPDATE
	})
end

function var0.CreateShell(arg0, arg1)
	if type(arg0) ~= "table" or arg0.class == var0 then
		return arg0
	end

	if var0.InstanceMap[arg0] then
		if arg1 then
			var0.InstanceMap[arg0]._parents[arg1] = true
		end

		return var0.InstanceMap[arg0]
	end

	local var0 = {
		_quiet = false,
		class = var0,
		_properties = {},
		_listeners = {},
		_parents = {}
	}

	if arg1 then
		var0._parents[arg1] = true
	end

	setmetatable(var0, var0)
	setmetatable(var0._parents, var1)

	var0.InstanceMap[arg0] = var0

	local var1 = getmetatable(arg0)

	if var1 then
		setmetatable(var0._properties, var1)
	end

	for iter0, iter1 in pairs(arg0) do
		if type(iter1) == "table" and iter1.class ~= var0 then
			rawset(var0._properties, iter0, var0.CreateShell(iter1, var0))
		else
			rawset(var0._properties, iter0, iter1)
		end
	end

	return var0
end

function var0.AddRawListener(arg0, arg1, arg2, arg3)
	local var0 = {
		keys = arg1,
		listener = arg2,
		settings = arg3
	}

	table.insert(arg0._listeners, var0)

	return function()
		return table.removebyvalue(arg0._listeners, var0)
	end
end

function var0.GetRawData(arg0, arg1)
	return arg1 and arg0._properties[arg1] or arg0._properties
end

function var0.SetRawData(arg0, arg1, arg2)
	arg0._properties[arg1] = arg2
end

function var0.EnterQuietMode(arg0)
	arg0._quiet = true
end

function var0.ExitQuietMode(arg0)
	arg0._quiet = false
end

function var0.insert(arg0, ...)
	if select("#", ...) > 1 then
		local var0 = select(1, ...)
		local var1 = select(2, ...)

		assert(var0 ~= nil, "invalid param 1 for insert, expect number but got " .. type(var0))

		if var1 == nil then
			return
		end

		local var2 = #arg0._properties
		local var3 = arg0._properties[var0]
		local var4

		arg0[var0] = var1

		for iter0 = var0 + 1, var2 + 1 do
			var3, arg0[iter0] = arg0._properties[iter0], var3
		end
	else
		local var5 = select(1, ...)

		if var5 == nil then
			return
		end

		arg0[#arg0._properties + 1] = var5
	end
end

function var0.remove(arg0, arg1)
	if arg1 == 0 then
		return
	end

	local var0 = #arg0._properties

	if var0 == 0 or var0 < arg1 or arg1 + var0 <= 0 then
		return
	end

	arg1 = arg1 or var0
	arg1 = arg1 > 0 and arg1 or var0 + arg1

	local var1 = arg0[arg1]

	arg0[arg1] = nil

	for iter0 = arg1, var0 - 1 do
		arg0[iter0] = arg0._properties[iter0 + 1]
	end

	arg0[var0] = nil

	return var1
end

return var0
