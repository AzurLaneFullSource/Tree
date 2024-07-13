local var0_0 = class("MainSubmitTaskSequence")

function var0_0.Execute(arg0_1, arg1_1)
	getProxy(TaskProxy):pushAutoSubmitTask()
	arg1_1()
end

return var0_0
