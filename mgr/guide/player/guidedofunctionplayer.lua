local var0 = class("GuideDoFunctionPlayer", import(".GuidePlayer"))

function var0.OnExecution(arg0, arg1, arg2)
	arg1:GetFunction()()
	arg2()
end

return var0
