local var0_0 = class("RequestPackage")

function var0_0.Start(arg0_1, ...)
	if arg0_1.__call then
		arg0_1.__call(arg0_1, ...)
	end

	return arg0_1
end

function var0_0.Stop(arg0_2)
	setmetatable(arg0_2, nil)
	table.clear(arg0_2)

	arg0_2.stopped = true
end

return var0_0
