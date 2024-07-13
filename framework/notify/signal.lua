local var0_0 = require
local var1_0 = setmetatable
local var2_0 = var0_0("Framework.notify.double-queue")
local var3_0 = {}
local var4_0 = {}
local var5_0 = {
	__index = var4_0
}

function var4_0.disconnect(arg0_1, arg1_1)
	arg0_1.handlers:remove(arg1_1)

	arg0_1.handlers_block[arg1_1] = nil
end

function var4_0.connect(arg0_2, arg1_2)
	if not arg0_2.handlers_block[arg1_2] then
		arg0_2.handlers_block[arg1_2] = 0

		arg0_2.handlers:push_back(arg1_2)
	end
end

function var4_0.block(arg0_3, arg1_3)
	if arg0_3.handlers_block[arg1_3] then
		arg0_3.handlers_block[arg1_3] = arg0_3.handlers_block[arg1_3] + 1
	end
end

function var4_0.unblock(arg0_4, arg1_4)
	if arg0_4.handlers_block[arg1_4] and arg0_4.handlers_block[arg1_4] > 0 then
		arg0_4.handlers_block[arg1_4] = arg0_4.handlers_block[arg1_4] - 1
	end
end

function var4_0.emit(arg0_5, ...)
	arg0_5.signal_stopped = false

	for iter0_5 in arg0_5.pre_emit_funcs:get_iterator() do
		iter0_5()
	end

	for iter1_5 in arg0_5.handlers:get_iterator() do
		if arg0_5.signal_stopped then
			break
		end

		if arg0_5.handlers_block[iter1_5] == 0 then
			iter1_5(...)
		end
	end

	for iter2_5 in arg0_5.post_emit_funcs:get_iterator() do
		iter2_5()
	end
end

function var4_0.emit_with_accumulator(arg0_6, arg1_6, ...)
	arg0_6.signal_stopped = false

	for iter0_6 in arg0_6.pre_emit_funcs:get_iterator() do
		iter0_6()
	end

	for iter1_6 in arg0_6.handlers:get_iterator() do
		if arg0_6.signal_stopped then
			break
		end

		if arg0_6.handlers_block[iter1_6] == 0 then
			arg1_6(iter1_6(...))
		end
	end

	for iter2_6 in arg0_6.post_emit_funcs:get_iterator() do
		iter2_6()
	end
end

function var4_0.add_pre_emit(arg0_7, arg1_7)
	arg0_7.pre_emit_funcs:push_back(arg1_7)
end

function var4_0.remove_pre_emit(arg0_8, arg1_8)
	arg0_8.pre_emit_funcs:remove(arg1_8)
end

function var4_0.add_post_emit(arg0_9, arg1_9)
	arg0_9.post_emit_funcs:push_front(arg1_9)
end

function var4_0.remove_post_emit(arg0_10, arg1_10)
	arg0_10.post_emit_funcs:remove(arg1_10)
end

function var4_0.stop(arg0_11)
	arg0_11.signal_stopped = true
end

function var3_0.New()
	local var0_12 = {}

	var1_0(var0_12, var5_0)

	var0_12.handlers_block = {}
	var0_12.handlers = var2_0.New()
	var0_12.pre_emit_funcs = var2_0.New()
	var0_12.post_emit_funcs = var2_0.New()
	var0_12.signal_stopped = false

	return var0_12
end

return var3_0
