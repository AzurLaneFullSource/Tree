local var0_0 = setmetatable
local var1_0 = xpcall
local var2_0 = pcall
local var3_0 = assert
local var4_0 = rawget
local var5_0 = error
local var6_0 = print
local var7_0 = tolua.traceback
local var8_0 = ilist
local var9_0 = {
	__call = function(arg0_1, ...)
		if jit then
			if arg0_1.obj == nil then
				return var1_0(arg0_1.func, var7_0, ...)
			else
				return var1_0(arg0_1.func, var7_0, arg0_1.obj, ...)
			end
		else
			local var0_1 = packEx(...)

			if arg0_1.obj == nil then
				local function var1_1()
					arg0_1.func(unpackEx(var0_1))
				end

				return var1_0(var1_1, var7_0)
			else
				local function var2_1()
					arg0_1.func(arg0_1.obj, unpackEx(var0_1))
				end

				return var1_0(var2_1, var7_0)
			end
		end
	end,
	__eq = function(arg0_4, arg1_4)
		return arg0_4.func == arg1_4.func and arg0_4.obj == arg1_4.obj
	end
}

local function var10_0(arg0_5, arg1_5)
	return var0_0({
		func = arg0_5,
		obj = arg1_5
	}, var9_0)
end

local var11_0 = {
	__call = function(arg0_6, ...)
		if arg0_6.obj == nil then
			return var2_0(arg0_6.func, ...)
		else
			return var2_0(arg0_6.func, arg0_6.obj, ...)
		end
	end,
	__eq = function(arg0_7, arg1_7)
		return arg0_7.func == arg1_7.func and arg0_7.obj == arg1_7.obj
	end
}

local function var12_0(arg0_8, arg1_8)
	return var0_0({
		func = arg0_8,
		obj = arg1_8
	}, var11_0)
end

local var13_0 = {}

var13_0.__index = var13_0

function var13_0.Add(arg0_9, arg1_9, arg2_9)
	var3_0(arg1_9)

	if arg0_9.keepSafe then
		arg1_9 = var10_0(arg1_9, arg2_9)
	else
		arg1_9 = var12_0(arg1_9, arg2_9)
	end

	if arg0_9.lock then
		local var0_9 = {
			_prev = 0,
			_next = 0,
			removed = true,
			value = arg1_9
		}

		table.insert(arg0_9.opList, function()
			arg0_9.list:pushnode(var0_9)
		end)

		return var0_9
	else
		return arg0_9.list:push(arg1_9)
	end
end

function var13_0.Remove(arg0_11, arg1_11, arg2_11)
	for iter0_11, iter1_11 in var8_0(arg0_11.list) do
		if iter1_11.func == arg1_11 and iter1_11.obj == arg2_11 then
			if arg0_11.lock then
				table.insert(arg0_11.opList, function()
					arg0_11.list:remove(iter0_11)
				end)
			else
				arg0_11.list:remove(iter0_11)
			end

			break
		end
	end
end

function var13_0.CreateListener(arg0_13, arg1_13, arg2_13)
	if arg0_13.keepSafe then
		arg1_13 = var10_0(arg1_13, arg2_13)
	else
		arg1_13 = var12_0(arg1_13, arg2_13)
	end

	return {
		_prev = 0,
		_next = 0,
		removed = true,
		value = arg1_13
	}
end

function var13_0.AddListener(arg0_14, arg1_14)
	var3_0(arg1_14)

	if arg0_14.lock then
		table.insert(arg0_14.opList, function()
			arg0_14.list:pushnode(arg1_14)
		end)
	else
		arg0_14.list:pushnode(arg1_14)
	end
end

function var13_0.RemoveListener(arg0_16, arg1_16)
	var3_0(arg1_16)

	if arg0_16.lock then
		table.insert(arg0_16.opList, function()
			arg0_16.list:remove(arg1_16)
		end)
	else
		arg0_16.list:remove(arg1_16)
	end
end

function var13_0.Count(arg0_18)
	return arg0_18.list.length
end

function var13_0.Clear(arg0_19)
	arg0_19.list:clear()

	arg0_19.opList = {}
	arg0_19.lock = false
	arg0_19.keepSafe = false
	arg0_19.current = nil
end

function var13_0.Dump(arg0_20)
	local var0_20 = 0

	for iter0_20, iter1_20 in var8_0(arg0_20.list) do
		if iter1_20.obj then
			var6_0("update function:", iter1_20.func, "object name:", iter1_20.obj.name)
		else
			var6_0("update function: ", iter1_20.func)
		end

		var0_20 = var0_20 + 1
	end

	var6_0("all function is:", var0_20)
end

function var13_0.__call(arg0_21, ...)
	local var0_21 = arg0_21.list

	arg0_21.lock = true

	for iter0_21, iter1_21 in var8_0(var0_21) do
		arg0_21.current = iter0_21

		local var1_21, var2_21 = iter1_21(...)

		if not var1_21 then
			var0_21:remove(iter0_21)

			arg0_21.lock = false

			var5_0(var2_21)
		end
	end

	local var3_21 = arg0_21.opList

	arg0_21.lock = false

	for iter2_21, iter3_21 in ipairs(var3_21) do
		iter3_21()

		var3_21[iter2_21] = nil
	end
end

function event(arg0_22, arg1_22)
	arg1_22 = arg1_22 or false

	return var0_0({
		lock = false,
		name = arg0_22,
		keepSafe = arg1_22,
		opList = {},
		list = list:new()
	}, var13_0)
end

UpdateBeat = event("Update", true)
LateUpdateBeat = event("LateUpdate", true)
FixedUpdateBeat = event("FixedUpdate", true)
CoUpdateBeat = event("CoUpdate")

local var14_0 = Time
local var15_0 = UpdateBeat
local var16_0 = LateUpdateBeat
local var17_0 = FixedUpdateBeat
local var18_0 = CoUpdateBeat

function Update(arg0_23, arg1_23)
	var14_0:SetDeltaTime(arg0_23, arg1_23)
	var15_0()
end

function LateUpdate()
	var16_0()
	var18_0()
	var14_0:SetFrameCount()
end

function FixedUpdate(arg0_25)
	var14_0:SetFixedDelta(arg0_25)
	var17_0()
end

function PrintEvents()
	var15_0:Dump()
	var17_0:Dump()
end
