local var0_0 = class("AsyncParallelExcutionRequestPackage", import(".RequestPackage"))

function var0_0.__call(arg0_1)
	if arg0_1.stopped then
		return
	end

	if not arg0_1.funcs or #arg0_1.funcs == 0 then
		return
	end

	local var0_1 = arg0_1.funcs
	local var1_1 = #var0_1

	local function var2_1()
		if arg0_1.stopped then
			return
		end

		var1_1 = var1_1 - 1

		if var1_1 == 0 and arg0_1.final then
			arg0_1.final()
		end
	end

	if var1_1 > 0 then
		for iter0_1, iter1_1 in ipairs(var0_1) do
			iter1_1(var2_1)
		end
	elseif arg0_1.final then
		arg0_1.final()
	end
end

function var0_0.Ctor(arg0_3, arg1_3, arg2_3)
	arg0_3.funcs = arg1_3
	arg0_3.final = arg2_3
end

return var0_0
