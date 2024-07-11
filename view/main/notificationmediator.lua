local var0_0 = class("NotificationMediator", import("..base.ContextMediator"))

var0_0.ON_SEND_PUBLIC = "NotificationMediator:ON_SEND_PUBLIC"
var0_0.CHANGE_ROOM = "NotificationMediator:CHANGE_ROOM"
var0_0.OPEN_INFO = "NotificationMediator:OPEN_INFO"
var0_0.OPEN_EMOJI = "NotificationMediator:OPEN_EMOJI"
var0_0.BATTLE_CHAT_CLOSE = "NotificationMediator:BATTLE_CHAT_CLOSE"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(PlayerProxy):getRawData()

	arg0_1.viewComponent:setPlayer(var0_1)

	local var1_1 = getProxy(GuildProxy)

	arg0_1.viewComponent:setInGuild(var1_1:getRawData() ~= nil)

	local var2_1 = arg0_1:getAllMessages()

	arg0_1.viewComponent:setMessages(var2_1)
	arg0_1:bind(var0_0.ON_SEND_PUBLIC, function(arg0_2, arg1_2, arg2_2)
		if arg2_2 == "$ rndsec refresh" and Application.isEditor then
			MainRandomFlagShipSequence.ForceRandom()
		elseif arg2_2:match("$ rndskin print %d+") and Application.isEditor then
			local var0_2 = string.gmatch(arg2_2, "%d+")

			MainRandomFlagShipSequence.CalcRatio(tonumber(var0_2()), function(arg0_3)
				local var0_3 = {
					richText = true,
					player = getProxy(PlayerProxy):getData(),
					content = arg0_3,
					timestamp = pg.TimeMgr.GetInstance():GetServerTime()
				}

				getProxy(ChatProxy):addNewMsg(ChatMsg.New(ChatConst.ChannelWorld, var0_3))
			end)
		elseif arg2_2:match("^$ (%S+)") then
			local var1_2 = {}

			for iter0_2, iter1_2 in arg2_2:gmatch("%s+(%S+)") do
				table.insert(var1_2, iter0_2)
			end

			arg0_1:sendNotification(GAME.SEND_CMD, {
				cmd = var1_2[1],
				arg1 = var1_2[2],
				arg2 = var1_2[3],
				arg3 = var1_2[4],
				arg4 = var1_2[5]
			})
		elseif arg2_2 == "world battle skip" then
			switch_world_skip_battle()
		elseif arg2_2 == pg.gameset.code_switch.description then
			if getProxy(PlayerProxy):getRawData().level >= 9 then
				HXSet.switchCodeMode()
			end
		else
			local var2_2 = getProxy(PlayerProxy):getData()
			local var3_2 = getProxy(ChatProxy):getData()
			local var4_2 = 0

			for iter2_2 = #var3_2, 1, -1 do
				if var3_2[iter2_2].type == ChatConst.ChannelWorld and var3_2[iter2_2].player.id == var2_2.id then
					var4_2 = var3_2[iter2_2].timestamp

					break
				end
			end

			local var5_2 = pg.TimeMgr.GetInstance():GetServerTime()

			if var5_2 < var2_2.chatMsgBanTime then
				local var6_2 = os.date("%Y/%m/%d %H:%M:%S", var2_2.chatMsgBanTime)

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					hideNo = true,
					content = i18n("chat_msg_ban", var6_2)
				})
			elseif PLATFORM_CODE == PLATFORM_CH and LuaHelper.GetCHPackageType() ~= PACKAGE_TYPE_BILI and var2_2.level < 70 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("chat_level_not_enough", 70))
			elseif var2_2.level < 10 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("chat_level_not_enough", 10))
			elseif var5_2 - var4_2 < 10 then
				local var7_2 = 10 - (var5_2 - var4_2)

				pg.TipsMgr.GetInstance():ShowTips(i18n("dont_send_message_frequently", var7_2))
			else
				local var8_2, var9_2 = wordVer(arg2_2, {
					isReplace = true
				})

				if arg1_2 == ChatConst.ChannelWorld then
					arg0_1:sendNotification(GAME.SEND_MSG, var9_2)
				elseif arg1_2 == ChatConst.ChannelGuild then
					arg0_1:sendNotification(GAME.GUILD_SEND_MSG, var9_2)
				end

				TrackConst.EmojiSend(var9_2)
			end
		end
	end)
	arg0_1:bind(var0_0.CHANGE_ROOM, function(arg0_4, arg1_4)
		if arg1_4 == getProxy(PlayerProxy):getRawData().chatRoomId then
			arg0_1:onChangeChatRoomDone()
		else
			arg0_1:sendNotification(GAME.CHANGE_CHAT_ROOM, arg1_4)
		end
	end)
	arg0_1:bind(var0_0.BATTLE_CHAT_CLOSE, function(arg0_5)
		arg0_1:sendNotification(BattleMediator.CLOSE_CHAT)
	end)
	arg0_1:bind(var0_0.OPEN_INFO, function(arg0_6, arg1_6, arg2_6, arg3_6)
		if arg1_6.id == var0_1.id then
			return
		end

		arg0_1.contextData.pos = arg2_6
		arg0_1.contextData.msg = arg3_6

		arg0_1:sendNotification(GAME.FRIEND_SEARCH, {
			type = SearchFriendCommand.SEARCH_TYPE_RESUME,
			keyword = arg1_6.id
		})
	end)
	arg0_1:bind(var0_0.OPEN_EMOJI, function(arg0_7, arg1_7, arg2_7)
		arg0_1:addSubLayers(Context.New({
			viewComponent = EmojiLayer,
			mediator = EmojiMediator,
			data = {
				callback = arg1_7,
				pos = arg2_7,
				LayerWeightMgr_groupName = LayerWeightConst.GROUP_NOTIFICATION,
				emojiIconCallback = function(arg0_8)
					arg0_1.viewComponent:insertEmojiToInputText(arg0_8)
				end
			}
		}), true)
	end)
end

function var0_0.listNotificationInterests(arg0_9)
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

function var0_0.handleNotification(arg0_10, arg1_10)
	local var0_10 = arg1_10:getName()
	local var1_10 = arg1_10:getBody()

	if var0_10 == ChatProxy.NEW_MSG or var0_10 == FriendProxy.FRIEND_NEW_MSG or var0_10 == GuildProxy.NEW_MSG_ADDED then
		local var2_10 = arg0_10.viewComponent.messages

		table.insert(var2_10, var1_10)
		arg0_10.viewComponent:setMessages(var2_10)

		local var3_10 = getProxy(PlayerProxy):getRawData()
		local var4_10 = NotificationLayer.ChannelBits.recv

		if var4_10 == bit.lshift(1, ChatConst.ChannelAll) or bit.band(var4_10, bit.lshift(1, var1_10.type)) > 0 then
			table.insert(arg0_10.viewComponent.filteredMessages, var1_10)
			arg0_10.viewComponent:append(var1_10, -1, true)
		elseif var1_10.player and var1_10.player.id == var3_10.id then
			arg0_10.viewComponent.recvTypes:each(function(arg0_11, arg1_11)
				if ChatConst.RecvChannels[arg0_11 + 1] == var1_10.type then
					triggerButton(arg1_11)
				end
			end)
		end
	elseif var0_10 == GAME.SEND_CMD_DONE then
		if string.find(var1_10, "CMD:into") then
			arg0_10.viewComponent:closeView()
		end
	elseif var0_10 == GAME.CHANGE_CHAT_ROOM_DONE then
		arg0_10:onChangeChatRoomDone(var1_10)
	elseif var0_10 == GAME.CHAT_ROOM_MAX_NUMBER then
		pg.TipsMgr.GetInstance():ShowTips(i18n("main_notificationMediator_room_max_number"))
	elseif var0_10 == GAME.FRIEND_SEARCH_DONE then
		if var1_10.list[1] then
			arg0_10:addSubLayers(Context.New({
				viewComponent = FriendInfoLayer,
				mediator = FriendInfoMediator,
				data = {
					friend = var1_10.list[1],
					pos = arg0_10.contextData.pos,
					msg = arg0_10.contextData.msg,
					form = arg0_10.contextData.form,
					parent = arg0_10.contextData.chatViewParent,
					LayerWeightMgr_groupName = LayerWeightConst.GROUP_NOTIFICATION
				}
			}))

			arg0_10.contextData.pos = nil
			arg0_10.contextData.msg = nil
		end
	elseif var0_10 == GAME.FINISH_STAGE then
		arg0_10.viewComponent:closeView()
	elseif var0_10 == GAME.GO_WORLD_BOSS_SCENE then
		arg0_10.viewComponent:closeView()
	end
end

function var0_0.getAllMessages(arg0_12)
	local var0_12 = {}
	local var1_12 = getProxy(ChatProxy)

	_.each(var1_12:getRawData(), function(arg0_13)
		table.insert(var0_12, arg0_13)
	end)

	local var2_12 = getProxy(GuildProxy)

	if var2_12:getRawData() then
		_.each(var2_12:getChatMsgs(), function(arg0_14)
			table.insert(var0_12, arg0_14)
		end)
	end

	local var3_12 = getProxy(FriendProxy)

	_.each(var3_12:getCacheMsgList(), function(arg0_15)
		table.insert(var0_12, arg0_15)
	end)

	return _(var0_12):chain():filter(function(arg0_16)
		return not var3_12:isInBlackList(arg0_16.playerId)
	end):sort(function(arg0_17, arg1_17)
		return arg0_17.timestamp < arg1_17.timestamp
	end):value()
end

function var0_0.onChangeChatRoomDone(arg0_18, arg1_18)
	if arg0_18.viewComponent.tempRoomSendBits then
		NotificationLayer.ChannelBits.send = arg0_18.viewComponent.tempRoomSendBits
	end

	if arg0_18.viewComponent.tempRoomRecvBits then
		NotificationLayer.ChannelBits.recv = arg0_18.viewComponent.tempRoomRecvBits
	end

	arg0_18.viewComponent:closeChangeRoomPanel()

	local var0_18 = arg0_18:getAllMessages()

	arg0_18.viewComponent:setMessages(var0_18)
	arg0_18.viewComponent:updateChatChannel()
	arg0_18.viewComponent:updateFilter()
	arg0_18.viewComponent:updateAll()

	if arg1_18 then
		arg0_18.viewComponent:setPlayer(arg1_18)
		arg0_18.viewComponent:updateRoom()
	end
end

return var0_0
