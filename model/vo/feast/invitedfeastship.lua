local var0 = class("InvitedFeastShip", import("model.vo.BaseVO"))

var0.STATE_EMPTY = 0
var0.STATE_MAKE_TICKET = 1
var0.STATE_GOT_TICKET = 2
var0.GIFT_STATE_EMPTY = 0
var0.GIFT_STATE_GOT = 1

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.tid
	arg0.tid = arg0.id
	arg0.configId = arg0:FindFeastConfigIdByGroupId(arg0.id)

	assert(arg0.configId)

	arg0.invitationStatus = var0.STATE_EMPTY
	arg0.giftState = var0.GIFT_STATE_EMPTY
end

function var0.FindFeastConfigIdByGroupId(arg0, arg1)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FEAST)

	assert(var0)

	local var1 = var0:getConfig("config_data")

	for iter0, iter1 in ipairs(var1[3] or {}) do
		if pg.activity_partyinvitation_template[iter1].groupid == arg1 then
			return iter1
		end
	end

	return nil
end

function var0.bindConfigTable(arg0)
	return pg.activity_partyinvitation_template
end

function var0.SetInvitationState(arg0, arg1)
	arg0.invitationStatus = arg1
end

function var0.GetInvitationState(arg0)
	return arg0.invitationStatus
end

function var0.SetGiftState(arg0, arg1)
	arg0.giftState = arg1
end

function var0.GetGiftState(arg0)
	return arg0.giftState
end

function var0.GetTicketConsume(arg0)
	local var0 = arg0:getConfig("invitationID")

	return {
		type = var0[1],
		id = var0[2],
		count = var0[3]
	}
end

function var0.GetGiftConsume(arg0)
	local var0 = arg0:getConfig("giftID")

	return {
		type = var0[1],
		id = var0[2],
		count = var0[3]
	}
end

function var0.GetSkinId(arg0)
	return arg0:getConfig("skinId")
end

function var0.GetPrefab(arg0)
	local var0 = arg0:GetSkinId()

	return pg.ship_skin_template[var0].prefab
end

function var0.GotTicket(arg0)
	return arg0:GetInvitationState() == var0.STATE_GOT_TICKET
end

function var0.GotGift(arg0)
	return arg0:GetGiftState() == var0.GIFT_STATE_GOT
end

function var0.HasTicket(arg0)
	return arg0:GetInvitationState() == var0.STATE_MAKE_TICKET
end

function var0.GetShipName(arg0)
	return ShipGroup.getDefaultShipConfig(arg0.tid).name
end

function var0.GetDialogueForTicket(arg0)
	if arg0:GotTicket() then
		return arg0:getConfig("getletter")
	else
		return arg0:getConfig("uninvitation")
	end
end

function var0.GetDialogueForGift(arg0)
	if arg0:GotGift() then
		return arg0:getConfig("getgift")
	else
		return arg0:getConfig("ungift")
	end
end

function var0.GetSpeechContent(arg0, arg1, arg2)
	local var0 = arg1
	local var1 = {
		"feeling",
		"drinkfeeling",
		"foodfeeling",
		"dancefeeling"
	}

	if var0 <= 0 or var0 > #var1 or arg2 <= 0 then
		return ""
	end

	local var2 = var1[var0]

	return arg0:getConfig(var2)[arg2] or ""
end

function var0.GetInvitationStory(arg0)
	return arg0:getConfig("getletter_story")
end

function var0.GetGiftStory(arg0)
	return arg0:getConfig("getgift_story")
end

return var0
