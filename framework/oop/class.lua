function Clone_Copy(arg0, arg1)
	if type(arg0) ~= "table" then
		return arg0
	elseif arg1[arg0] then
		return arg1[arg0]
	end

	local var0 = {}

	arg1[arg0] = var0

	local var1 = type(arg0) == "table" and arg0.__ctype == 2

	for iter0, iter1 in pairs(arg0) do
		if var1 and iter0 == "class" then
			var0[iter0] = iter1
		else
			var0[Clone_Copy(iter0, arg1)] = Clone_Copy(iter1, arg1)
		end
	end

	return setmetatable(var0, getmetatable(arg0))
end

function Clone(arg0)
	return Clone_Copy(arg0, {})
end

function class(arg0, arg1)
	local var0 = type(arg1)
	local var1

	if var0 ~= "function" and var0 ~= "table" then
		var0 = nil
		arg1 = nil
	end

	if var0 == "function" or arg1 and arg1.__ctype == 1 then
		var1 = {}

		if var0 == "table" then
			for iter0, iter1 in pairs(arg1) do
				var1[iter0] = iter1
			end

			var1.__create = arg1.__create
			var1.super = arg1
		else
			var1.__create = arg1
		end

		function var1.Ctor()
			return
		end

		var1.__cname = arg0
		var1.__ctype = 1

		function var1.New(...)
			local var0 = var1.__create(...)

			for iter0, iter1 in pairs(var1) do
				var0[iter0] = iter1
			end

			var0.class = var1

			var0:Ctor(...)

			return var0
		end
	else
		if arg1 then
			var1 = setmetatable({}, arg1)
			var1.super = arg1
		else
			var1 = {
				Ctor = function()
					return
				end
			}
		end

		var1.__cname = arg0
		var1.__ctype = 2
		var1.__index = var1

		function var1.New(...)
			local var0 = setmetatable({}, var1)

			var0.class = var1

			var0:Ctor(...)

			return var0
		end
	end

	return var1
end

function isa(arg0, arg1)
	local var0 = getmetatable(arg0)

	while var0 ~= nil do
		if var0 == arg1 then
			return true
		else
			assert(var0 ~= getmetatable(var0), "Loop metatable")

			var0 = getmetatable(var0)
		end
	end

	return false
end

function instanceof(arg0, arg1)
	return superof(arg0.class, arg1)
end

function superof(arg0, arg1)
	while arg0 ~= nil do
		if arg0 == arg1 then
			return true
		else
			arg0 = arg0.super
		end
	end

	return false
end

function singletonClass(arg0, arg1)
	local var0 = class(arg0, arg1)

	var0._new = var0.New

	rawset(var0, "_singletonInstance", nil)

	function var0.New()
		if not var0._singletonInstance then
			return var0.GetInstance()
		end

		error("singleton class can not new. Please use " .. arg0 .. ".GetInstance() to get it", 2)
	end

	function var0.GetInstance()
		if rawget(var0, "_singletonInstance") == nil then
			rawset(var0, "_singletonInstance", var0._new())
		end

		return var0._singletonInstance
	end

	return var0
end

function removeSingletonInstance(arg0)
	if arg0 and rawget(arg0, "_singletonInstance") then
		rawset(arg0, "_singletonInstance", nil)

		return true
	end

	return false
end

function tracebackex()
	local var0 = ""
	local var1 = 2
	local var2 = var0 .. "stack traceback:\n"

	while true do
		local var3 = debug.getinfo(var1, "Sln")

		if not var3 then
			break
		end

		if var3.what == "C" then
			var2 = var2 .. tostring(var1) .. "\tC function\n"
		else
			var2 = var2 .. string.format("\t[%s]:%d in function `%s`\n", var3.short_src, var3.currentline, var3.name or "")
		end

		local var4 = 1

		while true do
			local var5, var6 = debug.getlocal(var1, var4)

			if not var5 then
				break
			end

			var2 = var2 .. "\t\t" .. var5 .. " =\t" .. tostringex(var6, 3) .. "\n"
			var4 = var4 + 1
		end

		var1 = var1 + 1
	end

	return var2
end

function tostringex(arg0, arg1)
	if arg1 == nil then
		arg1 = 0
	end

	local var0 = string.rep("\t", arg1)
	local var1 = ""

	if type(arg0) == "table" then
		if arg1 > 5 then
			return "\t{ ... }"
		end

		local var2 = ""

		for iter0, iter1 in pairs(arg0) do
			var2 = var2 .. "\n\t" .. var0 .. tostring(iter0) .. ":"
			var2 = var2 .. tostringex(iter1, arg1 + 1)
		end

		if var2 == "" then
			var1 = var1 .. var0 .. "{ }\t(" .. tostring(arg0) .. ")"
		else
			if arg1 > 0 then
				var1 = var1 .. "\t(" .. tostring(arg0) .. ")\n"
			end

			var1 = var1 .. var0 .. "{" .. var2 .. "\n" .. var0 .. "}"
		end
	else
		var1 = var1 .. var0 .. tostring(arg0) .. "\t(" .. type(arg0) .. ")"
	end

	return var1
end

function DecorateClass(arg0, arg1)
	assert(arg0, "Need a Base Class")

	local var0 = setmetatable({}, {
		__index = function(arg0, arg1)
			return arg0[arg1] or arg1[arg1]
		end
	})

	var0.super = arg0
	var0.__cname = arg0.__cname .. " feat." .. arg1.__cname
	var0.__ctype = 2
	var0.__index = var0

	function var0.New(...)
		local var0 = setmetatable({}, var0)

		var0.class = var0

		var0:Ctor(...)

		return var0
	end

	return var0
end
