local var0_0 = class("SpAnimStep", import(".StoryStep"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.name = arg1_1.name
	arg0_1.actionName = defaultValue(arg1_1.actionName, "normal")
	arg0_1.speed = defaultValue(arg1_1.speed, 1)
	arg0_1.hideSkip = defaultValue(arg1_1.hideSkip, false)
	arg0_1.stopTime = defaultValue(arg1_1.stopTime, 0)
end

function var0_0.GetMode(arg0_2)
	return Story.MODE_SPANIM
end

function var0_0.GetSpineName(arg0_3)
	return arg0_3.name
end

function var0_0.GetActionName(arg0_4)
	return arg0_4.actionName
end

function var0_0.ShouldAdjustSpeed(arg0_5)
	return arg0_5:GetSpeed() ~= 1
end

function var0_0.GetSpeed(arg0_6)
	return arg0_6.speed
end

function var0_0.ShouldHideSkipBtn(arg0_7)
	return arg0_7.hideSkip
end

function var0_0.HasStopTime(arg0_8)
	return arg0_8:GetStopTime() ~= 0
end

function var0_0.GetStopTime(arg0_9)
	return arg0_9.stopTime
end

return var0_0
