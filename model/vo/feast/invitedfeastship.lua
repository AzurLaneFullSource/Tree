local var0_0 = class("InvitedFeastShip", import("model.vo.BaseVO"))

var0_0.STATE_EMPTY = 0
var0_0.STATE_MAKE_TICKET = 1
var0_0.STATE_GOT_TICKET = 2
var0_0.GIFT_STATE_EMPTY = 0
var0_0.GIFT_STATE_GOT = 1

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.tid
	arg0_1.tid = arg0_1.id
	arg0_1.configId = arg0_1:FindFeastConfigIdByGroupId(arg0_1.id)

	assert(arg0_1.configId)

	arg0_1.invitationStatus = var0_0.STATE_EMPTY
	arg0_1.giftState = var0_0.GIFT_STATE_EMPTY
end

function var0_0.FindFeastConfigIdByGroupId(arg0_2, arg1_2)
	local var0_2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FEAST)

	assert(var0_2)

	local var1_2 = var0_2:getConfig("config_data")

	for iter0_2, iter1_2 in ipairs(var1_2[3] or {}) do
		if pg.activity_partyinvitation_template[iter1_2].groupid == arg1_2 then
			return iter1_2
		end
	end

	return nil
end

function var0_0.bindConfigTable(arg0_3)
	return pg.activity_partyinvitation_template
end

function var0_0.SetInvitationState(arg0_4, arg1_4)
	arg0_4.invitationStatus = arg1_4
end

function var0_0.GetInvitationState(arg0_5)
	return arg0_5.invitationStatus
end

function var0_0.SetGiftState(arg0_6, arg1_6)
	arg0_6.giftState = arg1_6
end

function var0_0.GetGiftState(arg0_7)
	return arg0_7.giftState
end

function var0_0.GetTicketConsume(arg0_8)
	local var0_8 = arg0_8:getConfig("invitationID")

	return {
		type = var0_8[1],
		id = var0_8[2],
		count = var0_8[3]
	}
end

function var0_0.GetGiftConsume(arg0_9)
	local var0_9 = arg0_9:getConfig("giftID")

	return {
		type = var0_9[1],
		id = var0_9[2],
		count = var0_9[3]
	}
end

function var0_0.GetSkinId(arg0_10)
	return arg0_10:getConfig("skinId")
end

function var0_0.GetPrefab(arg0_11)
	local var0_11 = arg0_11:GetSkinId()

	return pg.ship_skin_template[var0_11].prefab
end

function var0_0.GotTicket(arg0_12)
	return arg0_12:GetInvitationState() == var0_0.STATE_GOT_TICKET
end

function var0_0.GotGift(arg0_13)
	return arg0_13:GetGiftState() == var0_0.GIFT_STATE_GOT
end

function var0_0.HasTicket(arg0_14)
	return arg0_14:GetInvitationState() == var0_0.STATE_MAKE_TICKET
end

function var0_0.GetShipName(arg0_15)
	return ShipGroup.getDefaultShipConfig(arg0_15.tid).name
end

function var0_0.GetDialogueForTicket(arg0_16)
	if arg0_16:GotTicket() then
		return arg0_16:getConfig("getletter")
	else
		return arg0_16:getConfig("uninvitation")
	end
end

function var0_0.GetDialogueForGift(arg0_17)
	if arg0_17:GotGift() then
		return arg0_17:getConfig("getgift")
	else
		return arg0_17:getConfig("ungift")
	end
end

function var0_0.GetSpeechContent(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg1_18
	local var1_18 = {
		"feeling",
		"drinkfeeling",
		"foodfeeling",
		"dancefeeling"
	}

	if var0_18 <= 0 or var0_18 > #var1_18 or arg2_18 <= 0 then
		return ""
	end

	local var2_18 = var1_18[var0_18]

	return arg0_18:getConfig(var2_18)[arg2_18] or ""
end

function var0_0.GetInvitationStory(arg0_19)
	return arg0_19:getConfig("getletter_story")
end

function var0_0.GetGiftStory(arg0_20)
	return arg0_20:getConfig("getgift_story")
end

return var0_0
