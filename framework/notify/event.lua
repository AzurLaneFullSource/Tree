local var0 = require
local var1 = setmetatable
local var2 = string
local var3 = error
local var4 = unpack
local var5 = var0("Framework.notify.double-queue")
local var6 = ":"
local var7 = {}
local var8 = {}
local var9 = {
	__index = var8
}

local function var10()
	return {
		handlers = var5.New(),
		pre_emits = var5.New(),
		post_emits = var5.New(),
		blocked_handlers = {},
		subevents = {}
	}
end

local function var11(arg0)
	local var0 = {}

	for iter0 in var2.gmatch(arg0, "[^" .. var6 .. "]+") do
		var0[#var0 + 1] = iter0
	end

	return var0
end

local function var12(arg0, arg1)
	local var0 = var11(arg1)
	local var1 = arg0.events[var0[1]] or var10()

	arg0.events[var0[1]] = var1

	for iter0 = 2, #var0 do
		local var2 = var1.subevents[var0[iter0]] or var10()

		var1.subevents[var0[iter0]] = var2
		var1 = var2
	end

	return var1
end

local function var13(arg0, arg1)
	local var0 = var11(arg1)
	local var1 = arg0.events[var0[1]]

	if not var1 then
		return true
	end

	for iter0 = 2, #var0 do
		local var2 = var1.subevents[var0[iter0]]

		if not var2 then
			return true
		end

		var1 = var2
	end

	return false
end

local function var14(arg0, arg1)
	local var0 = var11(arg1)
	local var1 = 2
	local var2 = arg0.events[var0[1]]

	return function()
		if not var2 then
			return
		end

		local var0 = var2

		if var0[var1] then
			var2 = var2.subevents[var0[var1]]
			var1 = var1 + 1
		else
			var2 = nil
		end

		return var0
	end
end

local function var15(arg0, arg1)
	local var0 = var5.New()
	local var1 = var5.New()

	for iter0 in var14(arg0, arg1) do
		for iter1 in iter0.pre_emits:get_iterator() do
			iter1(arg1)
		end

		var0:push_back(iter0)
		var1:push_front(iter0)
	end

	return var0, var1
end

local function var16(arg0, arg1)
	for iter0 in arg1:get_iterator() do
		for iter1 in iter0.post_emits:get_iterator() do
			iter1(arg0)
		end
	end
end

local function var17(arg0, arg1)
	for iter0 in arg1.nodes:get_iterator() do
		for iter1 in iter0.handlers:get_iterator() do
			if arg0.stopped then
				return
			end

			if iter0.blocked_handlers[iter1] == 0 then
				if arg1.accumulator then
					arg1.accumulator(iter1(arg1.event_name, unpackEx(arg1.args)))
				else
					iter1(arg1.event_name, unpackEx(arg1.args))
				end
			end
		end
	end
end

function var7.New()
	return var1({
		stopped = false,
		events = {}
	}, var9)
end

function var8.connect(arg0, arg1, arg2)
	local var0 = var12(arg0, arg1)

	var0.handlers:push_back(arg2)

	if not var0.blocked_handlers[arg2] then
		var0.blocked_handlers[arg2] = 0
	end
end

function var8.disconnect(arg0, arg1, arg2)
	if var13(arg0, arg1) then
		return
	end

	local var0 = var12(arg0, arg1)

	var0.handlers:remove(arg2)

	var0.blocked_handlers[arg2] = nil
end

function var8.chectConnect(arg0, arg1)
	return not var13(arg0, arg1)
end

function var8.block(arg0, arg1, arg2)
	if var13(arg0, arg1) then
		return
	end

	local var0 = var12(arg0, arg1)
	local var1 = var0.blocked_handlers[arg2]

	if var1 then
		var0.blocked_handlers[arg2] = var1 + 1
	end
end

function var8.unblock(arg0, arg1, arg2)
	if var13(arg0, arg1) then
		return
	end

	local var0 = var12(arg0, arg1)

	if var0.blocked_handlers[arg2] and var0.blocked_handlers[arg2] > 0 then
		var0.blocked_handlers[arg2] = var0.blocked_handlers[arg2] - 1
	end
end

function var8.emit(arg0, arg1, ...)
	arg0.stopped = false

	local var0, var1 = var15(arg0, arg1)

	var17(arg0, {
		event_name = arg1,
		nodes = var0,
		args = packEx(...)
	})
	var16(arg1, var1)
end

function var8.emit_with_accumulator(arg0, arg1, arg2, ...)
	arg0.stopped = false

	local var0, var1 = var15(arg0, arg1)

	var17(arg0, {
		event_name = arg1,
		nodes = var0,
		accumulator = arg2,
		args = packEx(...)
	})
	var16(arg1, var1)
end

function var8.add_pre_emit(arg0, arg1, arg2)
	var12(arg0, arg1).pre_emits:push_back(arg2)
end

function var8.remove_pre_emit(arg0, arg1, arg2)
	if var13(arg0, arg1) then
		return
	end

	var12(arg0, arg1).pre_emits:remove(arg2)
end

function var8.add_post_emit(arg0, arg1, arg2)
	var12(arg0, arg1).post_emits:push_front(arg2)
end

function var8.remove_post_emit(arg0, arg1, arg2)
	if var13(arg0, arg1) then
		return
	end

	var12(arg0, arg1).post_emits:remove(arg2)
end

function var8.stop(arg0)
	arg0.stopped = true
end

function var8.clear(arg0, arg1)
	if not arg1 then
		arg0.events = {}

		return
	end
end

local var18 = var7.New()

function var7.get_global_event()
	return var18
end

return var7
