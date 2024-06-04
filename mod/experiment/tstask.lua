local var0 = class("TSTask")

function var0.SetJob(arg0, arg1)
	arg0.job = arg1
end

function var0.Execute(arg0)
	local var0 = os.clock()

	arg0.job()

	return os.clock() - var0
end

function var0.Clear(arg0)
	arg0.job = nil
end

return var0
