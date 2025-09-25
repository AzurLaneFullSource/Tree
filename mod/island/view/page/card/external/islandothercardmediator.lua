local var0_0 = class("IslandOtherCardMediator", import("view.base.ContextMediator"))

var0_0.GIVE_CARD_LIKE = "IslandOtherCardMediator.GIVE_CARD_LIKE"
var0_0.GIVE_CARD_LABEL = "IslandOtherCardMediator.GIVE_CARD_LABEL"
var0_0.ADD_FRIEND = "IslandOtherCardMediator.ADD_FRIEND"
var0_0.REMOVE_FRIEND = "IslandOtherCardMediator.REMOVE_FRIEND"
var0_0.ADD_WHITE_LIST = "IslandOtherCardMediator.ADD_WHITE_LIST"
var0_0.ADD_BLACK_LIST = "IslandOtherCardMediator.ADD_BLACK_LIST"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.GIVE_CARD_LIKE, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.ISLAND_GIVE_CARD_LIKE, {
			userId = arg1_2,
			callback = arg2_2
		})
	end)
	arg0_1:bind(var0_0.GIVE_CARD_LABEL, function(arg0_3, arg1_3, arg2_3)
		arg0_1:sendNotification(GAME.ISLAND_GIVE_CARD_LABEL, {
			userId = arg1_3,
			labelId = arg2_3
		})
	end)
	arg0_1:bind(var0_0.ADD_FRIEND, function(arg0_4, arg1_4, arg2_4)
		arg0_1:sendNotification(GAME.FRIEND_SEND_REQUEST, {
			id = arg1_4,
			msg = arg2_4
		})
	end)
	arg0_1:bind(var0_0.REMOVE_FRIEND, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.FRIEND_DELETE, arg1_5)
	end)
	arg0_1:bind(var0_0.ADD_WHITE_LIST, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.ISLAND_ACCESS_OP, {
			op = IslandConst.ACCESS_OP_ADD_WHITELIST,
			list = {
				arg1_6
			}
		})
	end)
	arg0_1:bind(var0_0.ADD_BLACK_LIST, function(arg0_7, arg1_7)
		arg0_1:sendNotification(GAME.ISLAND_ACCESS_OP, {
			op = IslandConst.ACCESS_OP_ADD_BLACKLIST,
			list = {
				arg1_7
			}
		})
	end)
end

function var0_0.listNotificationInterests(arg0_8)
	return {
		GAME.ISLAND_GIVE_CARD_LIKE_DONE,
		GAME.ISLAND_GIVE_CARD_LABEL_DONE,
		GAME.FRIEND_SEND_REQUEST_DONE,
		FriendProxy.FRIEND_ADDED,
		GAME.FRIEND_DELETE_DONE,
		GAME.ISLAND_ACCESS_OP_DONE
	}
end

function var0_0.handleNotification(arg0_9, arg1_9)
	local var0_9 = arg1_9:getName()
	local var1_9 = arg1_9:getBody()

	if var0_9 == GAME.ISLAND_GIVE_CARD_LIKE_DONE then
		arg0_9.viewComponent:OnGiveLikeDone()
	elseif var0_9 == GAME.ISLAND_GIVE_CARD_LABEL_DONE then
		arg0_9.viewComponent:OnGiveLabelDone(var1_9.labelId)
	elseif var0_9 == GAME.FRIEND_SEND_REQUEST_DONE then
		arg0_9.viewComponent:OnAddFriendDone(var1_9)
	elseif var0_9 == FriendProxy.FRIEND_ADDED then
		arg0_9.viewComponent:OnAddFriendPass(var1_9.id)
	elseif var0_9 == GAME.FRIEND_DELETE_DONE then
		arg0_9.viewComponent:OnRemoveFriendDone()
	elseif var0_9 == GAME.ISLAND_ACCESS_OP_DONE then
		arg0_9.viewComponent:OnAccessOpDone(var1_9.clientOp)
	end
end

return var0_0
