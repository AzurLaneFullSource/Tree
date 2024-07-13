local var0_0 = class("FeastShip", import("model.vo.Ship"))

var0_0.BUBBLE_TYPE_EMPTY = 0
var0_0.BUBBLE_TYPE_GREET = 1
var0_0.BUBBLE_TYPE_DRINK = 2
var0_0.BUBBLE_TYPE_EAT = 3
var0_0.BUBBLE_TYPE_DANCE = 4
var0_0.BUBBLE_TYPE_SLEEP = 5
var0_0.CHAT_BUBBLE_TYPE_EMPTY = 0
var0_0.CHAT_BUBBLE_TYPE_1 = 1
var0_0.CHAT_BUBBLE_TYPE_2 = 2

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.tid = arg1_1.tid

	local var0_1 = ShipGroup.getDefaultShipConfig(arg0_1.tid)
	local var1_1 = arg0_1:FilterSkinId(ShipGroup.getSkinList(arg0_1.tid))

	var0_0.super.Ctor(arg0_1, {
		id = arg0_1.tid,
		configId = var0_1.id,
		skin_id = var1_1
	})

	arg0_1.bubble = arg1_1.bubble or 0
	arg0_1.speechBubble = arg1_1.speech_bubble or 0
	arg0_1.isSpecial = false
end

function var0_0.SetSkinId(arg0_2, arg1_2)
	arg0_2.skinId = arg1_2

	arg0_2:SetIsSpecial(true)
end

function var0_0.FilterSkinId(arg0_3, arg1_3)
	local var0_3 = {}

	for iter0_3, iter1_3 in ipairs(arg1_3) do
		if ShipSkin.GetShopTypeIdBySkinId(iter1_3.id, var0_3) == 7 then
			return iter1_3.id
		end
	end

	if #arg1_3 > 0 then
		return arg1_3[math.random(1, #arg1_3)].id
	else
		return 0
	end
end

function var0_0.UpdateBubble(arg0_4, arg1_4)
	arg0_4.bubble = arg1_4
end

function var0_0.ClearBubble(arg0_5)
	arg0_5.bubble = 0
end

function var0_0.GetBubble(arg0_6)
	return arg0_6.bubble
end

function var0_0.HasBubble(arg0_7)
	return arg0_7.bubble ~= 0
end

function var0_0.UpdateSpeechBubble(arg0_8, arg1_8)
	arg0_8.speechBubble = arg1_8
end

function var0_0.SetIsSpecial(arg0_9, arg1_9)
	arg0_9.isSpecial = arg1_9
end

function var0_0.IsSpecial(arg0_10)
	return arg0_10.isSpecial
end

return var0_0
