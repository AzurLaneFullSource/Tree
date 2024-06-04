local var0 = class("ChatRoomMediator", import("..base.ContextMediator"))

var0.SEND_FRIEND_MSG = "ChatRoomMediator:SEND_FRIEND_MSG"
var0.FETCH_FRIEND_MSG = "ChatRoomMediator:FETCH_FRIEND_MSG"
var0.CLEAR_UNREADCOUNT = "ChatRoomMediator:CLEAR_UNREADCOUNT"
var0.OPEN_EMOJI = "ChatRoomMediator:OPEN_EMOJI"

function var0.register(arg0)
	local var0 = getProxy(PlayerProxy):getData()

	arg0.viewComponent:setPlayer(var0)

	local var1 = arg0.contextData.friendVO

	arg0.viewComponent:setFriendVO(var1)

	arg0.friendProxy = getProxy(FriendProxy)

	local var2 = arg0.friendProxy:getAllFriends()
	local var3 = arg0.friendProxy:getAllCacheMsg()

	arg0:bind(var0.SEND_FRIEND_MSG, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.FRIEND_SEND_MSG, {
			playerId = arg1,
			msg = arg2
		})
	end)
	arg0:bind(var0.FETCH_FRIEND_MSG, function(arg0, arg1)
		arg0:sendNotification(GAME.FRIEND_FETCH_MSG, arg1)
	end)
	arg0:bind(var0.CLEAR_UNREADCOUNT, function(arg0, arg1)
		local var0 = arg0.friendProxy:getFriend(arg1)

		if var0:hasUnreadMsg() then
			var0:resetUnreadCount()
			arg0.friendProxy:updateFriend(var0)
		end
	end)
	arg0:bind(var0.OPEN_EMOJI, function(arg0, arg1, arg2)
		arg0:addSubLayers(Context.New({
			viewComponent = EmojiLayer,
			mediator = EmojiMediator,
			data = {
				callback = arg2,
				pos = arg1,
				LayerWeightMgr_groupName = LayerWeightConst.GROUP_CHATROOM,
				emojiIconCallback = function(arg0)
					arg0.viewComponent:insertEmojiToInputText(arg0)
				end
			}
		}))
	end)
	arg0.viewComponent:setFriends(var2)
	arg0.viewComponent:setCacheMsgs(var3)
end

function var0.listNotificationInterests(arg0)
	return {
		FriendProxy.FRIEND_NEW_MSG,
		FriendProxy.FRIEND_UPDATED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == FriendProxy.FRIEND_NEW_MSG then
		arg0.viewComponent:setCacheMsgs(arg0.friendProxy:getAllCacheMsg())
		arg0.viewComponent:appendMsg(var1)
	elseif var0 == FriendProxy.FRIEND_UPDATED then
		arg0.viewComponent:updateFriendVO(var1)
	end
end

return var0
