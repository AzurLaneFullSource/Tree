local var0 = class("BgStep", import(".DialogueStep"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.bgSpeed = arg1.bgSpeed
	arg0.blankScreenTime = arg1.blankScreen
	arg0.unscaleDelay = arg1.unscaleDelay or 0
	arg0.subBg = arg1.subBgName
end

function var0.GetMode(arg0)
	return Story.MODE_BG
end

function var0.GetFadeSpeed(arg0)
	return arg0.bgSpeed or 0.5
end

function var0.GetSubBg(arg0)
	return arg0.subBg
end

function var0.GetPainting(arg0)
	return nil
end

function var0.ShouldBlackScreen(arg0)
	return arg0.blankScreenTime
end

function var0.GetUnscaleDelay(arg0)
	return arg0.unscaleDelay
end

return var0
