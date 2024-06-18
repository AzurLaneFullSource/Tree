function Clone_Copy(arg0_1, arg1_1)
	if type(arg0_1) ~= "table" then
		return arg0_1
	elseif arg1_1[arg0_1] then
		return arg1_1[arg0_1]
	end

	local var0_1 = {}

	arg1_1[arg0_1] = var0_1

	local var1_1 = type(arg0_1) == "table" and arg0_1.__ctype == 2

	for iter0_1, iter1_1 in pairs(arg0_1) do
		if var1_1 and iter0_1 == "class" then
			var0_1[iter0_1] = iter1_1
		else
			var0_1[Clone_Copy(iter0_1, arg1_1)] = Clone_Copy(iter1_1, arg1_1)
		end
	end

	return setmetatable(var0_1, getmetatable(arg0_1))
end

function Clone(arg0_2)
	return Clone_Copy(arg0_2, {})
end

function class(arg0_3, arg1_3)
	local var0_3 = type(arg1_3)
	local var1_3

	if var0_3 ~= "function" and var0_3 ~= "table" then
		var0_3 = nil
		arg1_3 = nil
	end

	if var0_3 == "function" or arg1_3 and arg1_3.__ctype == 1 then
		var1_3 = {}

		if var0_3 == "table" then
			for iter0_3, iter1_3 in pairs(arg1_3) do
				var1_3[iter0_3] = iter1_3
			end

			var1_3.__create = arg1_3.__create
			var1_3.super = arg1_3
		else
			var1_3.__create = arg1_3
		end

		function var1_3.Ctor()
			return
		end

		var1_3.__cname = arg0_3
		var1_3.__ctype = 1

		function var1_3.New(...)
			local var0_5 = var1_3.__create(...)

			for iter0_5, iter1_5 in pairs(var1_3) do
				var0_5[iter0_5] = iter1_5
			end

			var0_5.class = var1_3

			var0_5:Ctor(...)

			return var0_5
		end
	else
		if arg1_3 then
			var1_3 = setmetatable({}, arg1_3)
			var1_3.super = arg1_3
		else
			var1_3 = {
				Ctor = function()
					return
				end
			}
		end

		var1_3.__cname = arg0_3
		var1_3.__ctype = 2
		var1_3.__index = var1_3

		function var1_3.New(...)
			local var0_7 = setmetatable({}, var1_3)

			var0_7.class = var1_3

			var0_7:Ctor(...)

			return var0_7
		end
	end

	return var1_3
end

function isa(arg0_8, arg1_8)
	local var0_8 = getmetatable(arg0_8)

	while var0_8 ~= nil do
		if var0_8 == arg1_8 then
			return true
		else
			assert(var0_8 ~= getmetatable(var0_8), "Loop metatable")

			var0_8 = getmetatable(var0_8)
		end
	end

	return false
end

function instanceof(arg0_9, arg1_9)
	return superof(arg0_9.class, arg1_9)
end

function superof(arg0_10, arg1_10)
	while arg0_10 ~= nil do
		if arg0_10 == arg1_10 then
			return true
		else
			arg0_10 = arg0_10.super
		end
	end

	return false
end

function singletonClass(arg0_11, arg1_11)
	local var0_11 = class(arg0_11, arg1_11)

	var0_11._new = var0_11.New

	rawset(var0_11, "_singletonInstance", nil)

	function var0_11.New()
		if not var0_11._singletonInstance then
			return var0_11.GetInstance()
		end

		error("singleton class can not new. Please use " .. arg0_11 .. ".GetInstance() to get it", 2)
	end

	function var0_11.GetInstance()
		if rawget(var0_11, "_singletonInstance") == nil then
			rawset(var0_11, "_singletonInstance", var0_11._new())
		end

		return var0_11._singletonInstance
	end

	return var0_11
end

function removeSingletonInstance(arg0_14)
	if arg0_14 and rawget(arg0_14, "_singletonInstance") then
		rawset(arg0_14, "_singletonInstance", nil)

		return true
	end

	return false
end

function tracebackex()
	local var0_15 = ""
	local var1_15 = 2
	local var2_15 = var0_15 .. "stack traceback:\n"

	while true do
		local var3_15 = debug.getinfo(var1_15, "Sln")

		if not var3_15 then
			break
		end

		if var3_15.what == "C" then
			var2_15 = var2_15 .. tostring(var1_15) .. "\tC function\n"
		else
			var2_15 = var2_15 .. string.format("\t[%s]:%d in function `%s`\n", var3_15.short_src, var3_15.currentline, var3_15.name or "")
		end

		local var4_15 = 1

		while true do
			local var5_15, var6_15 = debug.getlocal(var1_15, var4_15)

			if not var5_15 then
				break
			end

			var2_15 = var2_15 .. "\t\t" .. var5_15 .. " =\t" .. tostringex(var6_15, 3) .. "\n"
			var4_15 = var4_15 + 1
		end

		var1_15 = var1_15 + 1
	end

	return var2_15
end

function tostringex(arg0_16, arg1_16)
	if arg1_16 == nil then
		arg1_16 = 0
	end

	local var0_16 = string.rep("\t", arg1_16)
	local var1_16 = ""

	if type(arg0_16) == "table" then
		if arg1_16 > 5 then
			return "\t{ ... }"
		end

		local var2_16 = ""

		for iter0_16, iter1_16 in pairs(arg0_16) do
			var2_16 = var2_16 .. "\n\t" .. var0_16 .. tostring(iter0_16) .. ":"
			var2_16 = var2_16 .. tostringex(iter1_16, arg1_16 + 1)
		end

		if var2_16 == "" then
			var1_16 = var1_16 .. var0_16 .. "{ }\t(" .. tostring(arg0_16) .. ")"
		else
			if arg1_16 > 0 then
				var1_16 = var1_16 .. "\t(" .. tostring(arg0_16) .. ")\n"
			end

			var1_16 = var1_16 .. var0_16 .. "{" .. var2_16 .. "\n" .. var0_16 .. "}"
		end
	else
		var1_16 = var1_16 .. var0_16 .. tostring(arg0_16) .. "\t(" .. type(arg0_16) .. ")"
	end

	return var1_16
end

function DecorateClass(arg0_17, arg1_17)
	assert(arg0_17, "Need a Base Class")

	local var0_17 = setmetatable({}, {
		__index = function(arg0_18, arg1_18)
			return arg0_17[arg1_18] or arg1_17[arg1_18]
		end
	})

	var0_17.super = arg0_17
	var0_17.__cname = arg0_17.__cname .. " feat." .. arg1_17.__cname
	var0_17.__ctype = 2
	var0_17.__index = var0_17

	function var0_17.New(...)
		local var0_19 = setmetatable({}, var0_17)

		var0_19.class = var0_17

		var0_19:Ctor(...)

		return var0_19
	end

	return var0_17
end
