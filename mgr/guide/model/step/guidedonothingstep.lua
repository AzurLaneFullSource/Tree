local var0_0 = class("GuideDoNothingStep", import(".GuideStep"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.eventFlag = arg1_1.doNothing
end

function var0_0.GetType(arg0_2)
	return GuideStep.TYPE_DONOTHING
end

function var0_0.ExistTrigger(arg0_3)
	return arg0_3.eventFlag
end

return var0_0
