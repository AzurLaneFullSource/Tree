local var0 = class("BaseEntity", import(".BaseDispatcher"))

var0.Fields = {}
var0.Listeners = {}

local var1 = {
	__index = function(arg0, arg1)
		local var0 = rawget(arg0, "class")
		local var1 = rawget(arg0, "fields")[arg1]

		if var1 ~= nil then
			return var1
		end

		local var2 = rawget(arg0, arg1)

		if var2 ~= nil then
			return var2
		end

		return var0[arg1]
	end,
	__newindex = function(arg0, arg1, arg2)
		local var0 = rawget(arg0, "fields")
		local var1 = rawget(arg0, "class")

		while var1 ~= nil and var1 ~= var0 do
			if var1.Fields[arg1] ~= nil then
				assert(type(arg2) == "nil" or type(arg2) == var1.Fields[arg1], "Field type mismatch: " .. var1.__cname .. "." .. arg1)

				var0[arg1] = arg2

				return
			end

			var1 = var1.super
		end

		assert(false, "Field miss: " .. rawget(arg0, "class").__cname .. "." .. arg1)
	end
}

function var0.Ctor(arg0, ...)
	var0.super.Ctor(arg0)

	local var0 = {}

	rawset(arg0, "fields", var0)

	local var1 = arg0.class

	while var1 ~= nil and var1 ~= var0 do
		for iter0, iter1 in pairs(var1.Listeners) do
			assert(var1.Fields[iter0] == nil, "Repeated field: " .. var1.__cname .. "." .. iter0)

			local var2 = var1[iter1]

			var0[iter0] = var0[iter0] or function(...)
				var2(arg0, ...)
			end
		end

		var1 = var1.super
	end

	setmetatable(arg0, var1)
	arg0:Build(...)
end

function var0.Build(arg0)
	return
end

function var0.Dispose(arg0)
	arg0:Clear()
end

function var0.Clear(arg0)
	var0.super.ClearListeners(arg0)

	local var0 = rawget(arg0, "class")
	local var1 = rawget(arg0, "fields")

	while var0 ~= nil and var0 ~= var0 do
		for iter0, iter1 in pairs(var0.Fields) do
			var1[iter0] = nil
		end

		var0 = var0.super
	end
end

function var0.Clone(arg0)
	return var0.Clone_Copy(arg0, {})
end

function var0.Clone_Copy(arg0, arg1)
	if type(arg0) ~= "table" then
		return arg0
	elseif arg1[arg0] then
		return arg1[arg0]
	end

	if type(arg0) == "table" and instanceof(arg0, var0) then
		local var0 = rawget(arg0, "class")
		local var1 = var0.New()

		arg1[arg0] = var1

		local var2 = rawget(arg0, "fields")

		while var0 ~= nil and var0 ~= var0 do
			for iter0, iter1 in pairs(var0.Fields) do
				var1[iter0] = var0.Clone_Copy(var2[iter0], arg1)
			end

			var0 = var0.super
		end

		return var1
	else
		local var3 = {}

		arg1[arg0] = var3

		local var4 = type(arg0) == "table" and arg0.__ctype == 2

		for iter2, iter3 in pairs(arg0) do
			if var4 and iter2 == "class" then
				var3[iter2] = iter3
			else
				var3[var0.Clone_Copy(iter2, arg1)] = var0.Clone_Copy(iter3, arg1)
			end
		end

		return setmetatable(var3, getmetatable(arg0))
	end
end

function var0.Trans(arg0, arg1)
	assert(superof(arg1, var0), "class error: without super of BaseEntity")

	local var0 = arg1.New()
	local var1 = rawget(arg0, "fields")

	while arg1 ~= nil and arg1 ~= var0 do
		for iter0, iter1 in pairs(arg1.Fields) do
			var0[iter0] = var1[iter0]
		end

		arg1 = arg1.super
	end

	return var0
end

return var0
