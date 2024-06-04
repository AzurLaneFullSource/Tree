local var0 = setmetatable
local var1 = xpcall
local var2 = pcall
local var3 = assert
local var4 = rawget
local var5 = error
local var6 = print
local var7 = tolua.traceback
local var8 = ilist
local var9 = {
	__call = function(arg0, ...)
		if jit then
			if arg0.obj == nil then
				return var1(arg0.func, var7, ...)
			else
				return var1(arg0.func, var7, arg0.obj, ...)
			end
		else
			local var0 = packEx(...)

			if arg0.obj == nil then
				local function var1()
					arg0.func(unpackEx(var0))
				end

				return var1(var1, var7)
			else
				local function var2()
					arg0.func(arg0.obj, unpackEx(var0))
				end

				return var1(var2, var7)
			end
		end
	end,
	__eq = function(arg0, arg1)
		return arg0.func == arg1.func and arg0.obj == arg1.obj
	end
}

local function var10(arg0, arg1)
	return var0({
		func = arg0,
		obj = arg1
	}, var9)
end

local var11 = {
	__call = function(arg0, ...)
		if arg0.obj == nil then
			return var2(arg0.func, ...)
		else
			return var2(arg0.func, arg0.obj, ...)
		end
	end,
	__eq = function(arg0, arg1)
		return arg0.func == arg1.func and arg0.obj == arg1.obj
	end
}

local function var12(arg0, arg1)
	return var0({
		func = arg0,
		obj = arg1
	}, var11)
end

local var13 = {}

var13.__index = var13

function var13.Add(arg0, arg1, arg2)
	var3(arg1)

	if arg0.keepSafe then
		arg1 = var10(arg1, arg2)
	else
		arg1 = var12(arg1, arg2)
	end

	if arg0.lock then
		local var0 = {
			_prev = 0,
			_next = 0,
			removed = true,
			value = arg1
		}

		table.insert(arg0.opList, function()
			arg0.list:pushnode(var0)
		end)

		return var0
	else
		return arg0.list:push(arg1)
	end
end

function var13.Remove(arg0, arg1, arg2)
	for iter0, iter1 in var8(arg0.list) do
		if iter1.func == arg1 and iter1.obj == arg2 then
			if arg0.lock then
				table.insert(arg0.opList, function()
					arg0.list:remove(iter0)
				end)
			else
				arg0.list:remove(iter0)
			end

			break
		end
	end
end

function var13.CreateListener(arg0, arg1, arg2)
	if arg0.keepSafe then
		arg1 = var10(arg1, arg2)
	else
		arg1 = var12(arg1, arg2)
	end

	return {
		_prev = 0,
		_next = 0,
		removed = true,
		value = arg1
	}
end

function var13.AddListener(arg0, arg1)
	var3(arg1)

	if arg0.lock then
		table.insert(arg0.opList, function()
			arg0.list:pushnode(arg1)
		end)
	else
		arg0.list:pushnode(arg1)
	end
end

function var13.RemoveListener(arg0, arg1)
	var3(arg1)

	if arg0.lock then
		table.insert(arg0.opList, function()
			arg0.list:remove(arg1)
		end)
	else
		arg0.list:remove(arg1)
	end
end

function var13.Count(arg0)
	return arg0.list.length
end

function var13.Clear(arg0)
	arg0.list:clear()

	arg0.opList = {}
	arg0.lock = false
	arg0.keepSafe = false
	arg0.current = nil
end

function var13.Dump(arg0)
	local var0 = 0

	for iter0, iter1 in var8(arg0.list) do
		if iter1.obj then
			var6("update function:", iter1.func, "object name:", iter1.obj.name)
		else
			var6("update function: ", iter1.func)
		end

		var0 = var0 + 1
	end

	var6("all function is:", var0)
end

function var13.__call(arg0, ...)
	local var0 = arg0.list

	arg0.lock = true

	for iter0, iter1 in var8(var0) do
		arg0.current = iter0

		local var1, var2 = iter1(...)

		if not var1 then
			var0:remove(iter0)

			arg0.lock = false

			var5(var2)
		end
	end

	local var3 = arg0.opList

	arg0.lock = false

	for iter2, iter3 in ipairs(var3) do
		iter3()

		var3[iter2] = nil
	end
end

function event(arg0, arg1)
	arg1 = arg1 or false

	return var0({
		lock = false,
		name = arg0,
		keepSafe = arg1,
		opList = {},
		list = list:new()
	}, var13)
end

UpdateBeat = event("Update", true)
LateUpdateBeat = event("LateUpdate", true)
FixedUpdateBeat = event("FixedUpdate", true)
CoUpdateBeat = event("CoUpdate")

local var14 = Time
local var15 = UpdateBeat
local var16 = LateUpdateBeat
local var17 = FixedUpdateBeat
local var18 = CoUpdateBeat

function Update(arg0, arg1)
	var14:SetDeltaTime(arg0, arg1)
	var15()
end

function LateUpdate()
	var16()
	var18()
	var14:SetFrameCount()
end

function FixedUpdate(arg0)
	var14:SetFixedDelta(arg0)
	var17()
end

function PrintEvents()
	var15:Dump()
	var17:Dump()
end
