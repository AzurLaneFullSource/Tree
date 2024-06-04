local var0 = class("AsideStep", import(".StoryStep"))

var0.ASIDE_TYPE_HRZ = 1
var0.ASIDE_TYPE_VEC = 2
var0.ASIDE_TYPE_LEFTBOTTOMVEC = 3
var0.ASIDE_TYPE_CENTERWITHFRAME = 4
var0.SHOW_MODE_DEFAUT = 1
var0.SHOW_MODE_BUBBLE = 2

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.sequence = arg1.sequence
	arg0.asideType = arg1.asideType or var0.ASIDE_TYPE_HRZ
	arg0.signDate = arg1.signDate
	arg0.hideBgAlpha = arg1.hideBgAlpha
	arg0.rectOffset = arg1.rectOffset
	arg0.spacing = arg1.spacing
	arg0.typewriterSpeed = arg1.typewriterTime

	if arg0.asideType == var0.ASIDE_TYPE_LEFTBOTTOMVEC and not arg1.showMode then
		arg0.showMode = var0.SHOW_MODE_BUBBLE
	else
		arg0.showMode = arg1.showMode or var0.SHOW_MODE_DEFAUT
	end

	if arg0.asideType == var0.ASIDE_TYPE_CENTERWITHFRAME then
		arg0.hideBgAlpha = true
	end
end

function var0.GetMode(arg0)
	return Story.MODE_ASIDE
end

function var0.GetTypewriterSpeed(arg0)
	return arg0.typewriterSpeed or 0.1
end

function var0.GetSequence(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.sequence or {}) do
		table.insert(var0, {
			iter1[1],
			iter1[2]
		})
	end

	return var0
end

function var0.GetAsideType(arg0)
	return arg0.asideType
end

function var0.GetDateSign(arg0)
	return arg0.signDate
end

function var0.GetShowMode(arg0)
	return arg0.showMode
end

function var0.ShouldHideBGAlpha(arg0)
	return arg0.hideBgAlpha
end

function var0.ShouldUpdateSpacing(arg0)
	return arg0.spacing ~= nil
end

function var0.GetSpacing(arg0)
	return arg0.spacing
end

function var0.ShouldUpdatePadding(arg0)
	return arg0.rectOffset ~= nil
end

function var0.GetPadding(arg0)
	local var0 = arg0.rectOffset

	return var0[1] or 0, var0[2] or 0, var0[3] or 0, var0[4] or 0
end

return var0
