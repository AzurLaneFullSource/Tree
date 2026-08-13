local var0_0 = class("CrossRoadGameQue")

function var0_0.Ctor(arg0_1)
	arg0_1.hh = 0
	arg0_1.tt = -1
	arg0_1._q = {}
	arg0_1._map = {}
end

function var0_0.push(arg0_2, arg1_2)
	if arg1_2 == nil then
		return
	end

	if arg0_2._map[arg1_2] == nil then
		arg0_2.tt = arg0_2.tt + 1
		arg0_2._q[arg0_2.tt] = arg1_2
		arg0_2._map[arg1_2] = true
	end
end

function var0_0.head(arg0_3)
	if arg0_3:empty() then
		return nil
	end

	return arg0_3._q[arg0_3.hh]
end

function var0_0.pop(arg0_4)
	if arg0_4:empty() then
		return nil
	end

	local var0_4 = arg0_4._q[arg0_4.hh]

	arg0_4._q[arg0_4.hh] = nil
	arg0_4.hh = arg0_4.hh + 1
	arg0_4._map[var0_4] = nil

	return var0_4
end

function var0_0.empty(arg0_5)
	return arg0_5.hh > arg0_5.tt
end

function var0_0.queryHasVal(arg0_6, arg1_6)
	return arg0_6._map[arg1_6]
end

function var0_0.clear(arg0_7)
	local var0_7 = arg0_7.hh
	local var1_7 = arg0_7.tt

	for iter0_7 = var0_7, var1_7 do
		arg0_7._q[iter0_7] = nil
	end

	arg0_7.hh = 0
	arg0_7.tt = -1
	arg0_7._map = {}
end

function var0_0.size(arg0_8)
	return arg0_8.tt - arg0_8.hh + 1
end

return var0_0
