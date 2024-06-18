local var0_0 = class("BaseEntity", import(".BaseDispatcher"))

var0_0.Fields = {}
var0_0.Listeners = {}

local var1_0 = {
	__index = function(arg0_1, arg1_1)
		local var0_1 = rawget(arg0_1, "class")
		local var1_1 = rawget(arg0_1, "fields")[arg1_1]

		if var1_1 ~= nil then
			return var1_1
		end

		local var2_1 = rawget(arg0_1, arg1_1)

		if var2_1 ~= nil then
			return var2_1
		end

		return var0_1[arg1_1]
	end,
	__newindex = function(arg0_2, arg1_2, arg2_2)
		local var0_2 = rawget(arg0_2, "fields")
		local var1_2 = rawget(arg0_2, "class")

		while var1_2 ~= nil and var1_2 ~= var0_0 do
			if var1_2.Fields[arg1_2] ~= nil then
				assert(type(arg2_2) == "nil" or type(arg2_2) == var1_2.Fields[arg1_2], "Field type mismatch: " .. var1_2.__cname .. "." .. arg1_2)

				var0_2[arg1_2] = arg2_2

				return
			end

			var1_2 = var1_2.super
		end

		assert(false, "Field miss: " .. rawget(arg0_2, "class").__cname .. "." .. arg1_2)
	end
}

function var0_0.Ctor(arg0_3, ...)
	var0_0.super.Ctor(arg0_3)

	local var0_3 = {}

	rawset(arg0_3, "fields", var0_3)

	local var1_3 = arg0_3.class

	while var1_3 ~= nil and var1_3 ~= var0_0 do
		for iter0_3, iter1_3 in pairs(var1_3.Listeners) do
			assert(var1_3.Fields[iter0_3] == nil, "Repeated field: " .. var1_3.__cname .. "." .. iter0_3)

			local var2_3 = var1_3[iter1_3]

			var0_3[iter0_3] = var0_3[iter0_3] or function(...)
				var2_3(arg0_3, ...)
			end
		end

		var1_3 = var1_3.super
	end

	setmetatable(arg0_3, var1_0)
	arg0_3:Build(...)
end

function var0_0.Build(arg0_5)
	return
end

function var0_0.Dispose(arg0_6)
	arg0_6:Clear()
end

function var0_0.Clear(arg0_7)
	var0_0.super.ClearListeners(arg0_7)

	local var0_7 = rawget(arg0_7, "class")
	local var1_7 = rawget(arg0_7, "fields")

	while var0_7 ~= nil and var0_7 ~= var0_0 do
		for iter0_7, iter1_7 in pairs(var0_7.Fields) do
			var1_7[iter0_7] = nil
		end

		var0_7 = var0_7.super
	end
end

function var0_0.Clone(arg0_8)
	return var0_0.Clone_Copy(arg0_8, {})
end

function var0_0.Clone_Copy(arg0_9, arg1_9)
	if type(arg0_9) ~= "table" then
		return arg0_9
	elseif arg1_9[arg0_9] then
		return arg1_9[arg0_9]
	end

	if type(arg0_9) == "table" and instanceof(arg0_9, var0_0) then
		local var0_9 = rawget(arg0_9, "class")
		local var1_9 = var0_9.New()

		arg1_9[arg0_9] = var1_9

		local var2_9 = rawget(arg0_9, "fields")

		while var0_9 ~= nil and var0_9 ~= var0_0 do
			for iter0_9, iter1_9 in pairs(var0_9.Fields) do
				var1_9[iter0_9] = var0_0.Clone_Copy(var2_9[iter0_9], arg1_9)
			end

			var0_9 = var0_9.super
		end

		return var1_9
	else
		local var3_9 = {}

		arg1_9[arg0_9] = var3_9

		local var4_9 = type(arg0_9) == "table" and arg0_9.__ctype == 2

		for iter2_9, iter3_9 in pairs(arg0_9) do
			if var4_9 and iter2_9 == "class" then
				var3_9[iter2_9] = iter3_9
			else
				var3_9[var0_0.Clone_Copy(iter2_9, arg1_9)] = var0_0.Clone_Copy(iter3_9, arg1_9)
			end
		end

		return setmetatable(var3_9, getmetatable(arg0_9))
	end
end

function var0_0.Trans(arg0_10, arg1_10)
	assert(superof(arg1_10, var0_0), "class error: without super of BaseEntity")

	local var0_10 = arg1_10.New()
	local var1_10 = rawget(arg0_10, "fields")

	while arg1_10 ~= nil and arg1_10 ~= var0_0 do
		for iter0_10, iter1_10 in pairs(arg1_10.Fields) do
			var0_10[iter0_10] = var1_10[iter0_10]
		end

		arg1_10 = arg1_10.super
	end

	return var0_10
end

return var0_0
