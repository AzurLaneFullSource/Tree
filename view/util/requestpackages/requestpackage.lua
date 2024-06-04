local var0 = class("RequestPackage")

function var0.Start(arg0, ...)
	if arg0.__call then
		arg0.__call(arg0, ...)
	end

	return arg0
end

function var0.Stop(arg0)
	setmetatable(arg0, nil)
	table.clear(arg0)

	arg0.stopped = true
end

return var0
