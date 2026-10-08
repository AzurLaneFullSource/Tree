local var0_0 = class("YidaliV4FrameRePage", import("view.activity.subPages.YidaliV4FramePage"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	ActivityRemasterUtil.AdapterCoreScene(arg0_1, arg1_1, arg2_1, arg3_1)
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)

	arg0_2.inPhase2 = true

	arg0_2:UpdateTime()
end

function var0_0.UpdateTime(arg0_3)
	ActivityRemasterUtil.UpdateTime(arg0_3)
end

function var0_0.CheckSwitch2Phase2(arg0_4)
	local var0_4 = arg0_4.phases[1]
	local var1_4 = arg0_4.phases[2]

	GetOrAddComponent(var0_4, typeof(CanvasGroup)).alpha = 0
	GetOrAddComponent(var1_4, typeof(CanvasGroup)).alpha = 1
end

function var0_0.Switch(arg0_5, arg1_5)
	return
end

return var0_0
