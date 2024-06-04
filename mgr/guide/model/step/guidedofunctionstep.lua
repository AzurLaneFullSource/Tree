local var0 = class("GuideDoFunctionStep", import(".GuideStep"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.func = arg1.doFunc
end

function var0.GetType(arg0)
	return GuideStep.TYPE_DOFUNC
end

function var0.GetFunction(arg0)
	return arg0.func
end

function var0.ExistTrigger(arg0)
	return true
end

return var0
