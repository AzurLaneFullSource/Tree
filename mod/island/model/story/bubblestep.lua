local var0_0 = class("BubbleStep", import(".IslandBaseStep"))

var0_0.HIDE_TYPE_IMMEDIATELY = 0
var0_0.HIDE_TYPE_NEVER = 1
var0_0.HIDE_TYPE_TIME = 2

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.emoji = arg1_1.emoji
	arg0_1.time = arg1_1.time or 3
	arg0_1.hideType = arg1_1.hideType or var0_0.HIDE_TYPE_IMMEDIATELY
	arg0_1.hideTime = arg1_1.hideTime or 0
end

function var0_0.ExistEmoji(arg0_2)
	return arg0_2.emoji ~= nil
end

function var0_0.GetEmoji(arg0_3)
	return arg0_3.emoji
end

function var0_0.GetHideType(arg0_4)
	return arg0_4.hideType, arg0_4.hideTime
end

function var0_0.GetTime(arg0_5)
	return arg0_5.time
end

return var0_0
