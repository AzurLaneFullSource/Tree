local var0_0 = class("TSTask")

function var0_0.SetJob(arg0_1, arg1_1)
	arg0_1.job = arg1_1
end

function var0_0.Execute(arg0_2)
	local var0_2 = os.clock()

	arg0_2.job()

	return os.clock() - var0_2
end

function var0_0.Clear(arg0_3)
	arg0_3.job = nil
end

return var0_0
