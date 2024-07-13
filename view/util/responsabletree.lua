local var0_0 = {}

var0_0.__cname = "ResponsableTree"
var0_0.__ctype = 2

local var1_0 = {
	__mode = "kv"
}

var0_0.InstanceMap = setmetatable({}, var1_0)
var0_0.DATA_ADD = 1
var0_0.DATA_UPDATE = 0
var0_0.DATA_DELETE = -1

function var0_0.__index(arg0_1, arg1_1)
	return var0_0[arg1_1] or arg0_1._properties[arg1_1]
end

local var2_0 = 1000
local var3_0 = 0

function var0_0.__newindex(arg0_2, arg1_2, arg2_2)
	local var0_2 = rawget(arg0_2._properties, arg1_2)

	if var0_2 ~= arg2_2 and not arg0_2._quiet then
		local var1_2 = var0_2
		local var2_2 = var0_0.CreateShell(arg2_2, arg0_2)

		arg0_2._properties[arg1_2] = var2_2

		local var3_2 = var0_0.DATA_UDPATE

		var3_2 = var1_2 == nil and var0_0.DATA_ADD or var3_2
		var3_2 = var2_2 == nil and var0_0.DATA_DELETE or var3_2

		if type(var1_2) == "table" and var1_2.class == var0_0 then
			var1_2._parents[arg0_2] = nil
		end

		if type(var2_2) == "table" and var2_2.class == var0_0 then
			var2_2._parents[arg0_2] = true
		end

		var3_0 = 0

		arg0_2:Response(arg0_2, {
			arg1_2
		}, {
			var0_2,
			var3_2
		})
	end
end

function var0_0.Response(arg0_3, arg1_3, arg2_3, arg3_3)
	if var3_0 >= var2_0 then
		errorMsg("Exceed the Iterate Limitation, Might have inherit loop")

		return
	end

	var3_0 = var3_0 + 1

	local var0_3 = not next(arg0_3._listeners)

	if not var0_3 then
		local var1_3 = table.concat(arg2_3, ".")

		for iter0_3, iter1_3 in ipairs(arg0_3._listeners) do
			local var2_3 = iter1_3.settings

			for iter2_3, iter3_3 in ipairs(iter1_3.keys) do
				local var3_3 = "^" .. iter3_3 .. "$"
				local var4_3 = string.match(var1_3, var3_3)

				if not var4_3 and (not var2_3 or not var2_3.strict) then
					local var5_3 = "^" .. iter3_3 .. "%."

					var4_3 = string.match(var1_3, var5_3)
				end

				if var4_3 then
					var0_3 = var0_3 or var2_3 and not var2_3.NoAffectOnTransparent

					arg0_3:DoAction(iter1_3, arg2_3, arg3_3)

					break
				end
			end
		end
	end

	if not var0_3 or not next(arg0_3._parents) then
		return
	end

	local var6_3 = table.getCount(arg0_3._parents)

	for iter4_3, iter5_3 in pairs(arg0_3._parents) do
		var6_3 = var6_3 - 1

		local var7_3 = var6_3 > 0 and Clone(arg2_3) or arg2_3

		table.insert(var7_3, 1, table.keyof(iter4_3:GetRawData(), arg0_3))
		iter4_3:Response(arg1_3, var7_3, arg3_3)
	end
end

function var0_0.DoAction(arg0_4, arg1_4, arg2_4, arg3_4)
	local var0_4 = {}
	local var1_4 = #arg1_4.keys

	for iter0_4, iter1_4 in ipairs(arg1_4.keys) do
		local var2_4 = string.split(iter1_4, ".") or {}
		local var3_4 = arg0_4
		local var4_4 = 0

		while var3_4 and var4_4 < #var2_4 do
			var4_4 = var4_4 + 1
			var3_4 = var3_4[var2_4[var4_4]]
		end

		var0_4[iter0_4] = var3_4
	end

	if arg1_4.settings and arg1_4.settings.useOldRef then
		local var5_4 = table.shallowCopy(var0_4)

		for iter2_4, iter3_4 in ipairs(arg1_4.keys) do
			local var6_4 = string.split(iter3_4, ".") or {}

			if table.equal(var6_4, arg2_4) then
				var5_4[iter2_4] = arg3_4[1]

				break
			end
		end

		arg1_4.listener(var1_4, var0_4, var5_4, arg3_4[2])
	else
		arg1_4.listener(unpack(var0_4, 1, var1_4))
	end
end

function var0_0.PropertyChange(arg0_5, arg1_5)
	var3_0 = 0

	arg0_5:Response(arg0_5, {
		arg1_5
	}, {
		arg0_5[arg1_5],
		var0_0.DATA_UPDATE
	})
end

function var0_0.CreateShell(arg0_6, arg1_6)
	if type(arg0_6) ~= "table" or arg0_6.class == var0_0 then
		return arg0_6
	end

	if var0_0.InstanceMap[arg0_6] then
		if arg1_6 then
			var0_0.InstanceMap[arg0_6]._parents[arg1_6] = true
		end

		return var0_0.InstanceMap[arg0_6]
	end

	local var0_6 = {
		_quiet = false,
		class = var0_0,
		_properties = {},
		_listeners = {},
		_parents = {}
	}

	if arg1_6 then
		var0_6._parents[arg1_6] = true
	end

	setmetatable(var0_6, var0_0)
	setmetatable(var0_6._parents, var1_0)

	var0_0.InstanceMap[arg0_6] = var0_6

	local var1_6 = getmetatable(arg0_6)

	if var1_6 then
		setmetatable(var0_6._properties, var1_6)
	end

	for iter0_6, iter1_6 in pairs(arg0_6) do
		if type(iter1_6) == "table" and iter1_6.class ~= var0_0 then
			rawset(var0_6._properties, iter0_6, var0_0.CreateShell(iter1_6, var0_6))
		else
			rawset(var0_6._properties, iter0_6, iter1_6)
		end
	end

	return var0_6
end

function var0_0.AddRawListener(arg0_7, arg1_7, arg2_7, arg3_7)
	local var0_7 = {
		keys = arg1_7,
		listener = arg2_7,
		settings = arg3_7
	}

	table.insert(arg0_7._listeners, var0_7)

	return function()
		return table.removebyvalue(arg0_7._listeners, var0_7)
	end
end

function var0_0.GetRawData(arg0_9, arg1_9)
	return arg1_9 and arg0_9._properties[arg1_9] or arg0_9._properties
end

function var0_0.SetRawData(arg0_10, arg1_10, arg2_10)
	arg0_10._properties[arg1_10] = arg2_10
end

function var0_0.EnterQuietMode(arg0_11)
	arg0_11._quiet = true
end

function var0_0.ExitQuietMode(arg0_12)
	arg0_12._quiet = false
end

function var0_0.insert(arg0_13, ...)
	if select("#", ...) > 1 then
		local var0_13 = select(1, ...)
		local var1_13 = select(2, ...)

		assert(var0_13 ~= nil, "invalid param 1 for insert, expect number but got " .. type(var0_13))

		if var1_13 == nil then
			return
		end

		local var2_13 = #arg0_13._properties
		local var3_13 = arg0_13._properties[var0_13]
		local var4_13

		arg0_13[var0_13] = var1_13

		for iter0_13 = var0_13 + 1, var2_13 + 1 do
			var3_13, arg0_13[iter0_13] = arg0_13._properties[iter0_13], var3_13
		end
	else
		local var5_13 = select(1, ...)

		if var5_13 == nil then
			return
		end

		arg0_13[#arg0_13._properties + 1] = var5_13
	end
end

function var0_0.remove(arg0_14, arg1_14)
	if arg1_14 == 0 then
		return
	end

	local var0_14 = #arg0_14._properties

	if var0_14 == 0 or var0_14 < arg1_14 or arg1_14 + var0_14 <= 0 then
		return
	end

	arg1_14 = arg1_14 or var0_14
	arg1_14 = arg1_14 > 0 and arg1_14 or var0_14 + arg1_14

	local var1_14 = arg0_14[arg1_14]

	arg0_14[arg1_14] = nil

	for iter0_14 = arg1_14, var0_14 - 1 do
		arg0_14[iter0_14] = arg0_14._properties[iter0_14 + 1]
	end

	arg0_14[var0_14] = nil

	return var1_14
end

return var0_0
