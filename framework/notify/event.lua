local var0_0 = require
local var1_0 = setmetatable
local var2_0 = string
local var3_0 = error
local var4_0 = unpack
local var5_0 = var0_0("Framework.notify.double-queue")
local var6_0 = ":"
local var7_0 = {}
local var8_0 = {}
local var9_0 = {
	__index = var8_0
}

local function var10_0()
	return {
		handlers = var5_0.New(),
		pre_emits = var5_0.New(),
		post_emits = var5_0.New(),
		blocked_handlers = {},
		subevents = {}
	}
end

local function var11_0(arg0_2)
	local var0_2 = {}

	for iter0_2 in var2_0.gmatch(arg0_2, "[^" .. var6_0 .. "]+") do
		var0_2[#var0_2 + 1] = iter0_2
	end

	return var0_2
end

local function var12_0(arg0_3, arg1_3)
	local var0_3 = var11_0(arg1_3)
	local var1_3 = arg0_3.events[var0_3[1]] or var10_0()

	arg0_3.events[var0_3[1]] = var1_3

	for iter0_3 = 2, #var0_3 do
		local var2_3 = var1_3.subevents[var0_3[iter0_3]] or var10_0()

		var1_3.subevents[var0_3[iter0_3]] = var2_3
		var1_3 = var2_3
	end

	return var1_3
end

local function var13_0(arg0_4, arg1_4)
	local var0_4 = var11_0(arg1_4)
	local var1_4 = arg0_4.events[var0_4[1]]

	if not var1_4 then
		return true
	end

	for iter0_4 = 2, #var0_4 do
		local var2_4 = var1_4.subevents[var0_4[iter0_4]]

		if not var2_4 then
			return true
		end

		var1_4 = var2_4
	end

	return false
end

local function var14_0(arg0_5, arg1_5)
	local var0_5 = var11_0(arg1_5)
	local var1_5 = 2
	local var2_5 = arg0_5.events[var0_5[1]]

	return function()
		if not var2_5 then
			return
		end

		local var0_6 = var2_5

		if var0_5[var1_5] then
			var2_5 = var2_5.subevents[var0_5[var1_5]]
			var1_5 = var1_5 + 1
		else
			var2_5 = nil
		end

		return var0_6
	end
end

local function var15_0(arg0_7, arg1_7)
	local var0_7 = var5_0.New()
	local var1_7 = var5_0.New()

	for iter0_7 in var14_0(arg0_7, arg1_7) do
		for iter1_7 in iter0_7.pre_emits:get_iterator() do
			iter1_7(arg1_7)
		end

		var0_7:push_back(iter0_7)
		var1_7:push_front(iter0_7)
	end

	return var0_7, var1_7
end

local function var16_0(arg0_8, arg1_8)
	for iter0_8 in arg1_8:get_iterator() do
		for iter1_8 in iter0_8.post_emits:get_iterator() do
			iter1_8(arg0_8)
		end
	end
end

local function var17_0(arg0_9, arg1_9)
	for iter0_9 in arg1_9.nodes:get_iterator() do
		for iter1_9 in iter0_9.handlers:get_iterator() do
			if arg0_9.stopped then
				return
			end

			if iter0_9.blocked_handlers[iter1_9] == 0 then
				if arg1_9.accumulator then
					arg1_9.accumulator(iter1_9(arg1_9.event_name, unpackEx(arg1_9.args)))
				else
					iter1_9(arg1_9.event_name, unpackEx(arg1_9.args))
				end
			end
		end
	end
end

function var7_0.New()
	return var1_0({
		stopped = false,
		events = {}
	}, var9_0)
end

function var8_0.connect(arg0_11, arg1_11, arg2_11)
	local var0_11 = var12_0(arg0_11, arg1_11)

	var0_11.handlers:push_back(arg2_11)

	if not var0_11.blocked_handlers[arg2_11] then
		var0_11.blocked_handlers[arg2_11] = 0
	end
end

function var8_0.disconnect(arg0_12, arg1_12, arg2_12)
	if var13_0(arg0_12, arg1_12) then
		return
	end

	local var0_12 = var12_0(arg0_12, arg1_12)

	var0_12.handlers:remove(arg2_12)

	var0_12.blocked_handlers[arg2_12] = nil
end

function var8_0.chectConnect(arg0_13, arg1_13)
	return not var13_0(arg0_13, arg1_13)
end

function var8_0.block(arg0_14, arg1_14, arg2_14)
	if var13_0(arg0_14, arg1_14) then
		return
	end

	local var0_14 = var12_0(arg0_14, arg1_14)
	local var1_14 = var0_14.blocked_handlers[arg2_14]

	if var1_14 then
		var0_14.blocked_handlers[arg2_14] = var1_14 + 1
	end
end

function var8_0.unblock(arg0_15, arg1_15, arg2_15)
	if var13_0(arg0_15, arg1_15) then
		return
	end

	local var0_15 = var12_0(arg0_15, arg1_15)

	if var0_15.blocked_handlers[arg2_15] and var0_15.blocked_handlers[arg2_15] > 0 then
		var0_15.blocked_handlers[arg2_15] = var0_15.blocked_handlers[arg2_15] - 1
	end
end

function var8_0.emit(arg0_16, arg1_16, ...)
	arg0_16.stopped = false

	local var0_16, var1_16 = var15_0(arg0_16, arg1_16)

	var17_0(arg0_16, {
		event_name = arg1_16,
		nodes = var0_16,
		args = packEx(...)
	})
	var16_0(arg1_16, var1_16)
end

function var8_0.emit_with_accumulator(arg0_17, arg1_17, arg2_17, ...)
	arg0_17.stopped = false

	local var0_17, var1_17 = var15_0(arg0_17, arg1_17)

	var17_0(arg0_17, {
		event_name = arg1_17,
		nodes = var0_17,
		accumulator = arg2_17,
		args = packEx(...)
	})
	var16_0(arg1_17, var1_17)
end

function var8_0.add_pre_emit(arg0_18, arg1_18, arg2_18)
	var12_0(arg0_18, arg1_18).pre_emits:push_back(arg2_18)
end

function var8_0.remove_pre_emit(arg0_19, arg1_19, arg2_19)
	if var13_0(arg0_19, arg1_19) then
		return
	end

	var12_0(arg0_19, arg1_19).pre_emits:remove(arg2_19)
end

function var8_0.add_post_emit(arg0_20, arg1_20, arg2_20)
	var12_0(arg0_20, arg1_20).post_emits:push_front(arg2_20)
end

function var8_0.remove_post_emit(arg0_21, arg1_21, arg2_21)
	if var13_0(arg0_21, arg1_21) then
		return
	end

	var12_0(arg0_21, arg1_21).post_emits:remove(arg2_21)
end

function var8_0.stop(arg0_22)
	arg0_22.stopped = true
end

function var8_0.clear(arg0_23, arg1_23)
	if not arg1_23 then
		arg0_23.events = {}

		return
	end
end

local var18_0 = var7_0.New()

function var7_0.get_global_event()
	return var18_0
end

return var7_0
