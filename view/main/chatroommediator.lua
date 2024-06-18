local var0_0 = class("ChatRoomMediator", import("..base.ContextMediator"))

var0_0.SEND_FRIEND_MSG = "ChatRoomMediator:SEND_FRIEND_MSG"
var0_0.FETCH_FRIEND_MSG = "ChatRoomMediator:FETCH_FRIEND_MSG"
var0_0.CLEAR_UNREADCOUNT = "ChatRoomMediator:CLEAR_UNREADCOUNT"
var0_0.OPEN_EMOJI = "ChatRoomMediator:OPEN_EMOJI"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(PlayerProxy):getData()

	arg0_1.viewComponent:setPlayer(var0_1)

	local var1_1 = arg0_1.contextData.friendVO

	arg0_1.viewComponent:setFriendVO(var1_1)

	arg0_1.friendProxy = getProxy(FriendProxy)

	local var2_1 = arg0_1.friendProxy:getAllFriends()
	local var3_1 = arg0_1.friendProxy:getAllCacheMsg()

	arg0_1:bind(var0_0.SEND_FRIEND_MSG, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.FRIEND_SEND_MSG, {
			playerId = arg1_2,
			msg = arg2_2
		})
	end)
	arg0_1:bind(var0_0.FETCH_FRIEND_MSG, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.FRIEND_FETCH_MSG, arg1_3)
	end)
	arg0_1:bind(var0_0.CLEAR_UNREADCOUNT, function(arg0_4, arg1_4)
		local var0_4 = arg0_1.friendProxy:getFriend(arg1_4)

		if var0_4:hasUnreadMsg() then
			var0_4:resetUnreadCount()
			arg0_1.friendProxy:updateFriend(var0_4)
		end
	end)
	arg0_1:bind(var0_0.OPEN_EMOJI, function(arg0_5, arg1_5, arg2_5)
		arg0_1:addSubLayers(Context.New({
			viewComponent = EmojiLayer,
			mediator = EmojiMediator,
			data = {
				callback = arg2_5,
				pos = arg1_5,
				LayerWeightMgr_groupName = LayerWeightConst.GROUP_CHATROOM,
				emojiIconCallback = function(arg0_6)
					arg0_1.viewComponent:insertEmojiToInputText(arg0_6)
				end
			}
		}))
	end)
	arg0_1.viewComponent:setFriends(var2_1)
	arg0_1.viewComponent:setCacheMsgs(var3_1)
end

function var0_0.listNotificationInterests(arg0_7)
	return {
		FriendProxy.FRIEND_NEW_MSG,
		FriendProxy.FRIEND_UPDATED
	}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()

	if var0_8 == FriendProxy.FRIEND_NEW_MSG then
		arg0_8.viewComponent:setCacheMsgs(arg0_8.friendProxy:getAllCacheMsg())
		arg0_8.viewComponent:appendMsg(var1_8)
	elseif var0_8 == FriendProxy.FRIEND_UPDATED then
		arg0_8.viewComponent:updateFriendVO(var1_8)
	end
end

return var0_0
