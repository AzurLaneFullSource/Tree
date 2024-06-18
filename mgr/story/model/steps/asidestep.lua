local var0_0 = class("AsideStep", import(".StoryStep"))

var0_0.ASIDE_TYPE_HRZ = 1
var0_0.ASIDE_TYPE_VEC = 2
var0_0.ASIDE_TYPE_LEFTBOTTOMVEC = 3
var0_0.ASIDE_TYPE_CENTERWITHFRAME = 4
var0_0.SHOW_MODE_DEFAUT = 1
var0_0.SHOW_MODE_BUBBLE = 2

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.sequence = arg1_1.sequence
	arg0_1.asideType = arg1_1.asideType or var0_0.ASIDE_TYPE_HRZ
	arg0_1.signDate = arg1_1.signDate
	arg0_1.hideBgAlpha = arg1_1.hideBgAlpha
	arg0_1.rectOffset = arg1_1.rectOffset
	arg0_1.spacing = arg1_1.spacing
	arg0_1.typewriterSpeed = arg1_1.typewriterTime

	if arg0_1.asideType == var0_0.ASIDE_TYPE_LEFTBOTTOMVEC and not arg1_1.showMode then
		arg0_1.showMode = var0_0.SHOW_MODE_BUBBLE
	else
		arg0_1.showMode = arg1_1.showMode or var0_0.SHOW_MODE_DEFAUT
	end

	if arg0_1.asideType == var0_0.ASIDE_TYPE_CENTERWITHFRAME then
		arg0_1.hideBgAlpha = true
	end
end

function var0_0.GetMode(arg0_2)
	return Story.MODE_ASIDE
end

function var0_0.GetTypewriterSpeed(arg0_3)
	return arg0_3.typewriterSpeed or 0.1
end

function var0_0.GetSequence(arg0_4)
	local var0_4 = {}

	for iter0_4, iter1_4 in ipairs(arg0_4.sequence or {}) do
		table.insert(var0_4, {
			iter1_4[1],
			iter1_4[2]
		})
	end

	return var0_4
end

function var0_0.GetAsideType(arg0_5)
	return arg0_5.asideType
end

function var0_0.GetDateSign(arg0_6)
	return arg0_6.signDate
end

function var0_0.GetShowMode(arg0_7)
	return arg0_7.showMode
end

function var0_0.ShouldHideBGAlpha(arg0_8)
	return arg0_8.hideBgAlpha
end

function var0_0.ShouldUpdateSpacing(arg0_9)
	return arg0_9.spacing ~= nil
end

function var0_0.GetSpacing(arg0_10)
	return arg0_10.spacing
end

function var0_0.ShouldUpdatePadding(arg0_11)
	return arg0_11.rectOffset ~= nil
end

function var0_0.GetPadding(arg0_12)
	local var0_12 = arg0_12.rectOffset

	return var0_12[1] or 0, var0_12[2] or 0, var0_12[3] or 0, var0_12[4] or 0
end

return var0_0
