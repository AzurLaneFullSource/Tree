local var0 = class("FeastShip", import("model.vo.Ship"))

var0.BUBBLE_TYPE_EMPTY = 0
var0.BUBBLE_TYPE_GREET = 1
var0.BUBBLE_TYPE_DRINK = 2
var0.BUBBLE_TYPE_EAT = 3
var0.BUBBLE_TYPE_DANCE = 4
var0.BUBBLE_TYPE_SLEEP = 5
var0.CHAT_BUBBLE_TYPE_EMPTY = 0
var0.CHAT_BUBBLE_TYPE_1 = 1
var0.CHAT_BUBBLE_TYPE_2 = 2

function var0.Ctor(arg0, arg1)
	arg0.tid = arg1.tid

	local var0 = ShipGroup.getDefaultShipConfig(arg0.tid)
	local var1 = arg0:FilterSkinId(ShipGroup.getSkinList(arg0.tid))

	var0.super.Ctor(arg0, {
		id = arg0.tid,
		configId = var0.id,
		skin_id = var1
	})

	arg0.bubble = arg1.bubble or 0
	arg0.speechBubble = arg1.speech_bubble or 0
	arg0.isSpecial = false
end

function var0.SetSkinId(arg0, arg1)
	arg0.skinId = arg1

	arg0:SetIsSpecial(true)
end

function var0.FilterSkinId(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(arg1) do
		if ShipSkin.GetShopTypeIdBySkinId(iter1.id, var0) == 7 then
			return iter1.id
		end
	end

	if #arg1 > 0 then
		return arg1[math.random(1, #arg1)].id
	else
		return 0
	end
end

function var0.UpdateBubble(arg0, arg1)
	arg0.bubble = arg1
end

function var0.ClearBubble(arg0)
	arg0.bubble = 0
end

function var0.GetBubble(arg0)
	return arg0.bubble
end

function var0.HasBubble(arg0)
	return arg0.bubble ~= 0
end

function var0.UpdateSpeechBubble(arg0, arg1)
	arg0.speechBubble = arg1
end

function var0.SetIsSpecial(arg0, arg1)
	arg0.isSpecial = arg1
end

function var0.IsSpecial(arg0)
	return arg0.isSpecial
end

return var0
