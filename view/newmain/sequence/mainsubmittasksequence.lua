local var0 = class("MainSubmitTaskSequence")

function var0.Execute(arg0, arg1)
	getProxy(TaskProxy):pushAutoSubmitTask()
	arg1()
end

return var0
