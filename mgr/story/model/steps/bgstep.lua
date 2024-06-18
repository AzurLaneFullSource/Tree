local var0_0 = class("BgStep", import(".DialogueStep"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.bgSpeed = arg1_1.bgSpeed
	arg0_1.blankScreenTime = arg1_1.blankScreen
	arg0_1.unscaleDelay = arg1_1.unscaleDelay or 0
	arg0_1.subBg = arg1_1.subBgName
end

function var0_0.GetMode(arg0_2)
	return Story.MODE_BG
end

function var0_0.GetFadeSpeed(arg0_3)
	return arg0_3.bgSpeed or 0.5
end

function var0_0.GetSubBg(arg0_4)
	return arg0_4.subBg
end

function var0_0.GetPainting(arg0_5)
	return nil
end

function var0_0.ShouldBlackScreen(arg0_6)
	return arg0_6.blankScreenTime
end

function var0_0.GetUnscaleDelay(arg0_7)
	return arg0_7.unscaleDelay
end

return var0_0
