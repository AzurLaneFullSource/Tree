local var0_0 = class("GuideDoFunctionStep", import(".GuideStep"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.func = arg1_1.doFunc
end

function var0_0.GetType(arg0_2)
	return GuideStep.TYPE_DOFUNC
end

function var0_0.GetFunction(arg0_3)
	return arg0_3.func
end

function var0_0.ExistTrigger(arg0_4)
	return true
end

return var0_0
