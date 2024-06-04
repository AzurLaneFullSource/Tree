local var0 = class("AsyncParallelExcutionRequestPackage", import(".RequestPackage"))

function var0.__call(arg0)
	if arg0.stopped then
		return
	end

	if not arg0.funcs or #arg0.funcs == 0 then
		return
	end

	local var0 = arg0.funcs
	local var1 = #var0

	local function var2()
		if arg0.stopped then
			return
		end

		var1 = var1 - 1

		if var1 == 0 and arg0.final then
			arg0.final()
		end
	end

	if var1 > 0 then
		for iter0, iter1 in ipairs(var0) do
			iter1(var2)
		end
	elseif arg0.final then
		arg0.final()
	end
end

function var0.Ctor(arg0, arg1, arg2)
	arg0.funcs = arg1
	arg0.final = arg2
end

return var0
