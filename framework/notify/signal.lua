local var0 = require
local var1 = setmetatable
local var2 = var0("Framework.notify.double-queue")
local var3 = {}
local var4 = {}
local var5 = {
	__index = var4
}

function var4.disconnect(arg0, arg1)
	arg0.handlers:remove(arg1)

	arg0.handlers_block[arg1] = nil
end

function var4.connect(arg0, arg1)
	if not arg0.handlers_block[arg1] then
		arg0.handlers_block[arg1] = 0

		arg0.handlers:push_back(arg1)
	end
end

function var4.block(arg0, arg1)
	if arg0.handlers_block[arg1] then
		arg0.handlers_block[arg1] = arg0.handlers_block[arg1] + 1
	end
end

function var4.unblock(arg0, arg1)
	if arg0.handlers_block[arg1] and arg0.handlers_block[arg1] > 0 then
		arg0.handlers_block[arg1] = arg0.handlers_block[arg1] - 1
	end
end

function var4.emit(arg0, ...)
	arg0.signal_stopped = false

	for iter0 in arg0.pre_emit_funcs:get_iterator() do
		iter0()
	end

	for iter1 in arg0.handlers:get_iterator() do
		if arg0.signal_stopped then
			break
		end

		if arg0.handlers_block[iter1] == 0 then
			iter1(...)
		end
	end

	for iter2 in arg0.post_emit_funcs:get_iterator() do
		iter2()
	end
end

function var4.emit_with_accumulator(arg0, arg1, ...)
	arg0.signal_stopped = false

	for iter0 in arg0.pre_emit_funcs:get_iterator() do
		iter0()
	end

	for iter1 in arg0.handlers:get_iterator() do
		if arg0.signal_stopped then
			break
		end

		if arg0.handlers_block[iter1] == 0 then
			arg1(iter1(...))
		end
	end

	for iter2 in arg0.post_emit_funcs:get_iterator() do
		iter2()
	end
end

function var4.add_pre_emit(arg0, arg1)
	arg0.pre_emit_funcs:push_back(arg1)
end

function var4.remove_pre_emit(arg0, arg1)
	arg0.pre_emit_funcs:remove(arg1)
end

function var4.add_post_emit(arg0, arg1)
	arg0.post_emit_funcs:push_front(arg1)
end

function var4.remove_post_emit(arg0, arg1)
	arg0.post_emit_funcs:remove(arg1)
end

function var4.stop(arg0)
	arg0.signal_stopped = true
end

function var3.New()
	local var0 = {}

	var1(var0, var5)

	var0.handlers_block = {}
	var0.handlers = var2.New()
	var0.pre_emit_funcs = var2.New()
	var0.post_emit_funcs = var2.New()
	var0.signal_stopped = false

	return var0
end

return var3
