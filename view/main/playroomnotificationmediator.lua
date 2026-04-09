local var0_0 = class("PlayRoomNotificationMediator", import("..base.ContextMediator"))

var0_0.SEND_CHAT = "PlayRoomNotificationMediator.SEND_CHAT"
var0_0.CHANGE_CHAT_ROOM = "PlayRoomNotificationMediator.CHANGE_CHAT_ROOM"
var0_0.OPEN_FRIEND_INFO = "PlayRoomNotificationMediator.OPEN_FRIEND_INFO"
var0_0.OPEN_EMOJI = "PlayRoomNotificationMediator.OPEN_EMOJI"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.OPEN_FRIEND_INFO, function(arg0_2, arg1_2, arg2_2, arg3_2)
		arg0_1.friendInfoPosition = arg2_2
		arg0_1.friendInfoMsg = arg3_2

		arg0_1:sendNotification(GAME.OPEN_FRIEND_INFO_DONE, arg2_2)
		arg0_1:sendNotification(GAME.FRIEND_SEARCH, {
			type = SearchFriendCommand.SEARCH_TYPE_RESUME,
			keyword = arg1_2
		})
	end)
	arg0_1:bind(var0_0.CHANGE_CHAT_ROOM, function(arg0_3, arg1_3)
		if not arg1_3 then
			return
		end

		if arg1_3 <= 0 or arg1_3 == "" then
			return
		end

		arg0_1:sendNotification(GAME.CHANGE_CHAT_ROOM, arg1_3)
	end)
	arg0_1:bind(var0_0.SEND_CHAT, function(arg0_4, arg1_4, arg2_4)
		arg0_1:sendNotification(GAME.PLAY_ROOM_SEND_CHAT, {
			channel = arg1_4,
			type = arg0_1.contextData.inRoom and 1 or 2,
			msg = arg2_4
		})
	end)
	arg0_1:bind(var0_0.OPEN_EMOJI, function(arg0_5, arg1_5)
		arg0_1:addSubLayers(Context.New({
			viewComponent = EmojiLayer,
			mediator = EmojiMediator,
			data = arg1_5
		}))
	end)
end

function var0_0.initNotificationHandleDic(arg0_6)
	arg0_6.handleDic = {
		[ChatProxy.NEW_MSG] = function(arg0_7, arg1_7)
			local var0_7 = arg1_7:getBody()

			arg0_7.viewComponent:Flush(true)
		end,
		[FriendProxy.FRIEND_NEW_MSG] = function(arg0_8, arg1_8)
			local var0_8 = arg1_8:getBody()

			arg0_8.viewComponent:Flush(true)
		end,
		[GuildProxy.NEW_MSG_ADDED] = function(arg0_9, arg1_9)
			local var0_9 = arg1_9:getBody()

			arg0_9.viewComponent:Flush(true)
		end,
		[PlayRoomProxy.CHAT_MSG_UPDATE] = function(arg0_10, arg1_10)
			local var0_10 = arg1_10:getBody()

			arg0_10.viewComponent:Flush(true)
		end,
		[GAME.CHANGE_CHAT_ROOM_DONE] = function(arg0_11, arg1_11)
			arg0_11.viewComponent:Flush()
		end
	}
end

return var0_0
