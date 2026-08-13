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
	arg0_1.rectMargin = arg1_1.rectMargin
	arg0_1.rectAlpha = arg1_1.rectAlpha or 1
	arg0_1.spacing = arg1_1.spacing
	arg0_1.typewriterSpeed = arg1_1.typewriterTime
	arg0_1.actor = arg1_1.actor or -1

	if arg0_1.asideType == var0_0.ASIDE_TYPE_LEFTBOTTOMVEC and not arg1_1.showMode then
		arg0_1.showMode = var0_0.SHOW_MODE_BUBBLE
	else
		arg0_1.showMode = arg1_1.showMode or var0_0.SHOW_MODE_DEFAUT
	end

	if arg0_1.asideType == var0_0.ASIDE_TYPE_CENTERWITHFRAME then
		arg0_1.hideBgAlpha = true
	end
end

function var0_0.GetPainting(arg0_2)
	if arg0_2.actor < 0 then
		return nil
	end

	local var0_2 = pg.ship_skin_template[arg0_2.actor]
	local var1_2 = var0_2.ship_group
	local var2_2 = ShipGroup.getDefaultShipConfig(var1_2)

	return var0_2.painting
end

function var0_0.GetMode(arg0_3)
	return Story.MODE_ASIDE
end

function var0_0.GetTypewriterSpeed(arg0_4)
	return arg0_4.typewriterSpeed or 0.1
end

function var0_0.GetSequence(arg0_5)
	local var0_5 = {}
	local var1_5 = arg0_5:ShouldReplacePlayer()

	for iter0_5, iter1_5 in ipairs(arg0_5.sequence or {}) do
		local var2_5 = var1_5 and arg0_5:ReplacePlayerName(iter1_5[1]) or iter1_5[1]

		if arg0_5:ShouldReplaceCar2026() then
			var2_5 = arg0_5:ReplaceCar2026Name(var2_5)
		end

		table.insert(var0_5, {
			HXSet.hxLan(var2_5),
			iter1_5[2]
		})
	end

	return var0_5
end

function var0_0.GetAsideType(arg0_6)
	return arg0_6.asideType
end

function var0_0.GetDateSign(arg0_7)
	return arg0_7.signDate
end

function var0_0.GetShowMode(arg0_8)
	return arg0_8.showMode
end

function var0_0.ShouldHideBGAlpha(arg0_9)
	return arg0_9.hideBgAlpha
end

function var0_0.ShouldUpdateSpacing(arg0_10)
	return arg0_10.spacing ~= nil
end

function var0_0.GetSpacing(arg0_11)
	return arg0_11.spacing
end

function var0_0.ShouldUpdatePadding(arg0_12)
	if arg0_12:ShouldUpdateMargin() then
		return false
	end

	return arg0_12.rectOffset ~= nil
end

function var0_0.ShouldUpdateMargin(arg0_13)
	return arg0_13.rectMargin ~= nil
end

function var0_0.GetMargin(arg0_14)
	local var0_14 = arg0_14.rectMargin

	return var0_14[1] or 0, var0_14[2] or 0, var0_14[3] or 0, var0_14[4] or 0
end

function var0_0.GetPadding(arg0_15)
	local var0_15 = arg0_15.rectOffset

	return var0_15[1] or 0, var0_15[2] or 0, var0_15[3] or 0, var0_15[4] or 0
end

function var0_0.GetRectAlpha(arg0_16)
	return arg0_16.rectAlpha
end

return var0_0
