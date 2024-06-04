local var0 = class("GuideDoNothingStep", import(".GuideStep"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.eventFlag = arg1.doNothing
end

function var0.GetType(arg0)
	return GuideStep.TYPE_DONOTHING
end

function var0.ExistTrigger(arg0)
	return arg0.eventFlag
end

return var0
