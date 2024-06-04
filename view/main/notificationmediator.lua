local var0 = class("NotificationMediator", import("..base.ContextMediator"))

var0.ON_SEND_PUBLIC = "NotificationMediator:ON_SEND_PUBLIC"
var0.CHANGE_ROOM = "NotificationMediator:CHANGE_ROOM"
var0.OPEN_INFO = "NotificationMediator:OPEN_INFO"
var0.OPEN_EMOJI = "NotificationMediator:OPEN_EMOJI"
var0.BATTLE_CHAT_CLOSE = "NotificationMediator:BATTLE_CHAT_CLOSE"

function var0.register(arg0)
	local var0 = getProxy(PlayerProxy):getRawData()

	arg0.viewComponent:setPlayer(var0)

	local var1 = getProxy(GuildProxy)

	arg0.viewComponent:setInGuild(var1:getRawData() ~= nil)

	local var2 = arg0:getAllMessages()

	arg0.viewComponent:setMessages(var2)
	arg0:bind(var0.ON_SEND_PUBLIC, function(arg0, arg1, arg2)
		if arg2 == "$ rndsec refresh" and Application.isEditor then
			MainRandomFlagShipSequence.ForceRandom()
		elseif arg2:match("$ rndskin print %d+") and Application.isEditor then
			local var0 = string.gmatch(arg2, "%d+")

			MainRandomFlagShipSequence.CalcRatio(tonumber(var0()), function(arg0)
				local var0 = {
					richText = true,
					player = getProxy(PlayerProxy):getData(),
					content = arg0,
					timestamp = pg.TimeMgr.GetInstance():GetServerTime()
				}

				getProxy(ChatProxy):addNewMsg(ChatMsg.New(ChatConst.ChannelWorld, var0))
			end)
		elseif arg2:match("^$ (%S+)") then
			local var1 = {}

			for iter0, iter1 in arg2:gmatch("%s+(%S+)") do
				table.insert(var1, iter0)
			end

			arg0:sendNotification(GAME.SEND_CMD, {
				cmd = var1[1],
				arg1 = var1[2],
				arg2 = var1[3],
				arg3 = var1[4],
				arg4 = var1[5]
			})
		elseif arg2 == "world battle skip" then
			switch_world_skip_battle()
		elseif arg2 == pg.gameset.code_switch.description then
			if getProxy(PlayerProxy):getRawData().level >= 9 then
				HXSet.switchCodeMode()
			end
		else
			local var2 = getProxy(PlayerProxy):getData()
			local var3 = getProxy(ChatProxy):getData()
			local var4 = 0

			for iter2 = #var3, 1, -1 do
				if var3[iter2].type == ChatConst.ChannelWorld and var3[iter2].player.id == var2.id then
					var4 = var3[iter2].timestamp

					break
				end
			end

			local var5 = pg.TimeMgr.GetInstance():GetServerTime()

			if var5 < var2.chatMsgBanTime then
				local var6 = os.date("%Y/%m/%d %H:%M:%S", var2.chatMsgBanTime)

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					hideNo = true,
					content = i18n("chat_msg_ban", var6)
				})
			elseif PLATFORM_CODE == PLATFORM_CH and LuaHelper.GetCHPackageType() ~= PACKAGE_TYPE_BILI and var2.level < 70 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("chat_level_not_enough", 70))
			elseif var2.level < 10 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("chat_level_not_enough", 10))
			elseif var5 - var4 < 10 then
				local var7 = 10 - (var5 - var4)

				pg.TipsMgr.GetInstance():ShowTips(i18n("dont_send_message_frequently", var7))
			else
				local var8, var9 = wordVer(arg2, {
					isReplace = true
				})

				if arg1 == ChatConst.ChannelWorld then
					arg0:sendNotification(GAME.SEND_MSG, var9)
				elseif arg1 == ChatConst.ChannelGuild then
					arg0:sendNotification(GAME.GUILD_SEND_MSG, var9)
				end
			end
		end
	end)
	arg0:bind(var0.CHANGE_ROOM, function(arg0, arg1)
		if arg1 == getProxy(PlayerProxy):getRawData().chatRoomId then
			arg0:onChangeChatRoomDone()
		else
			arg0:sendNotification(GAME.CHANGE_CHAT_ROOM, arg1)
		end
	end)
	arg0:bind(var0.BATTLE_CHAT_CLOSE, function(arg0)
		arg0:sendNotification(BattleMediator.CLOSE_CHAT)
	end)
	arg0:bind(var0.OPEN_INFO, function(arg0, arg1, arg2, arg3)
		if arg1.id == var0.id then
			return
		end

		arg0.contextData.pos = arg2
		arg0.contextData.msg = arg3

		arg0:sendNotification(GAME.FRIEND_SEARCH, {
			type = SearchFriendCommand.SEARCH_TYPE_RESUME,
			keyword = arg1.id
		})
	end)
	arg0:bind(var0.OPEN_EMOJI, function(arg0, arg1, arg2)
		arg0:addSubLayers(Context.New({
			viewComponent = EmojiLayer,
			mediator = EmojiMediator,
			data = {
				callback = arg1,
				pos = arg2,
				LayerWeightMgr_groupName = LayerWeightConst.GROUP_NOTIFICATION,
				emojiIconCallback = function(arg0)
					arg0.viewComponent:insertEmojiToInputText(arg0)
				end
			}
		}), true)
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.SEND_CMD_DONE,
		ChatProxy.NEW_MSG,
		GAME.CHANGE_CHAT_ROOM_DONE,
		GAME.CHAT_ROOM_MAX_NUMBER,
		GAME.FRIEND_SEARCH_DONE,
		GAME.FINISH_STAGE,
		FriendProxy.FRIEND_NEW_MSG,
		GuildProxy.NEW_MSG_ADDED,
		GAME.GO_WORLD_BOSS_SCENE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == ChatProxy.NEW_MSG or var0 == FriendProxy.FRIEND_NEW_MSG or var0 == GuildProxy.NEW_MSG_ADDED then
		local var2 = arg0.viewComponent.messages

		table.insert(var2, var1)
		arg0.viewComponent:setMessages(var2)

		local var3 = getProxy(PlayerProxy):getRawData()
		local var4 = NotificationLayer.ChannelBits.recv

		if var4 == bit.lshift(1, ChatConst.ChannelAll) or bit.band(var4, bit.lshift(1, var1.type)) > 0 then
			table.insert(arg0.viewComponent.filteredMessages, var1)
			arg0.viewComponent:append(var1, -1, true)
		elseif var1.player and var1.player.id == var3.id then
			arg0.viewComponent.recvTypes:each(function(arg0, arg1)
				if ChatConst.RecvChannels[arg0 + 1] == var1.type then
					triggerButton(arg1)
				end
			end)
		end
	elseif var0 == GAME.SEND_CMD_DONE then
		if string.find(var1, "CMD:into") then
			arg0.viewComponent:closeView()
		end
	elseif var0 == GAME.CHANGE_CHAT_ROOM_DONE then
		arg0:onChangeChatRoomDone(var1)
	elseif var0 == GAME.CHAT_ROOM_MAX_NUMBER then
		pg.TipsMgr.GetInstance():ShowTips(i18n("main_notificationMediator_room_max_number"))
	elseif var0 == GAME.FRIEND_SEARCH_DONE then
		if var1.list[1] then
			arg0:addSubLayers(Context.New({
				viewComponent = FriendInfoLayer,
				mediator = FriendInfoMediator,
				data = {
					friend = var1.list[1],
					pos = arg0.contextData.pos,
					msg = arg0.contextData.msg,
					form = arg0.contextData.form,
					parent = arg0.contextData.chatViewParent,
					LayerWeightMgr_groupName = LayerWeightConst.GROUP_NOTIFICATION
				}
			}))

			arg0.contextData.pos = nil
			arg0.contextData.msg = nil
		end
	elseif var0 == GAME.FINISH_STAGE then
		arg0.viewComponent:closeView()
	elseif var0 == GAME.GO_WORLD_BOSS_SCENE then
		arg0.viewComponent:closeView()
	end
end

function var0.getAllMessages(arg0)
	local var0 = {}
	local var1 = getProxy(ChatProxy)

	_.each(var1:getRawData(), function(arg0)
		table.insert(var0, arg0)
	end)

	local var2 = getProxy(GuildProxy)

	if var2:getRawData() then
		_.each(var2:getChatMsgs(), function(arg0)
			table.insert(var0, arg0)
		end)
	end

	local var3 = getProxy(FriendProxy)

	_.each(var3:getCacheMsgList(), function(arg0)
		table.insert(var0, arg0)
	end)

	return _(var0):chain():filter(function(arg0)
		return not var3:isInBlackList(arg0.playerId)
	end):sort(function(arg0, arg1)
		return arg0.timestamp < arg1.timestamp
	end):value()
end

function var0.onChangeChatRoomDone(arg0, arg1)
	if arg0.viewComponent.tempRoomSendBits then
		NotificationLayer.ChannelBits.send = arg0.viewComponent.tempRoomSendBits
	end

	if arg0.viewComponent.tempRoomRecvBits then
		NotificationLayer.ChannelBits.recv = arg0.viewComponent.tempRoomRecvBits
	end

	arg0.viewComponent:closeChangeRoomPanel()

	local var0 = arg0:getAllMessages()

	arg0.viewComponent:setMessages(var0)
	arg0.viewComponent:updateChatChannel()
	arg0.viewComponent:updateFilter()
	arg0.viewComponent:updateAll()

	if arg1 then
		arg0.viewComponent:setPlayer(arg1)
		arg0.viewComponent:updateRoom()
	end
end

return var0
