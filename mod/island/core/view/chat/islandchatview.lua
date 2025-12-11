local var0_0 = class("IslandChatView", import("..IslandASynLoadSubView"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.parent = arg2_1
end

function var0_0.GetUIName(arg0_2)
	return "IslandChatUI"
end

function var0_0.GetUIParent(arg0_3, arg1_3)
	return arg0_3.parent
end

function var0_0.FirstFlush(arg0_4)
	arg0_4.settingsBtn = arg0_4._tf:Find("top/settings")
	arg0_4.uiChannelList = UIItemList.New(arg0_4._tf:Find("top/channels"), arg0_4._tf:Find("top/channels/tpl"))
	arg0_4.sendChanncelBtn = arg0_4._tf:Find("send_panel/channel_btn")
	arg0_4.sendChanncelTxt = arg0_4._tf:Find("send_panel/channel_btn/Text"):GetComponent(typeof(Text))
	arg0_4.roomNumTxt = arg0_4._tf:Find("top/settings/Text"):GetComponent(typeof(Text))
	arg0_4.scrollrect = arg0_4._tf:Find("list"):GetComponent("LScrollRect")
	arg0_4.emojiBtn = arg0_4._tf:Find("send_panel/input_panel/emoji")
	arg0_4.sendBtn = arg0_4._tf:Find("send_panel/send_btn")
	arg0_4.inputField = arg0_4._tf:Find("send_panel/input_panel/input"):GetComponent(typeof(InputField))
	arg0_4.uiSendChanncelList = UIItemList.New(arg0_4._tf:Find("send_panel/channel_sel_panel"), arg0_4._tf:Find("send_panel/channel_sel_panel/tpl"))
	arg0_4.channelValue = IslandChatConst.CHANNEL_ALL
	arg0_4.sendChannelValue = IslandChatConst.CHANNEL_ISLAND
	arg0_4.cards = {}
	arg0_4.emojiAdaptor = IslandEmojiAdaptor.New(arg0_4)

	arg0_4:InitChanncelToggles()
	arg0_4:InitSendChannelName()
	arg0_4:RegisterEvent()
end

function var0_0.RegisterEvent(arg0_5)
	onButton(arg0_5, arg0_5.settingsBtn, function()
		arg0_5:ShowMsgbox({
			type = IslandMsgBox.TYPE_CHAT_SETTINGS,
			sendChannelValue = arg0_5.sendChannelValue,
			channelValue = arg0_5.channelValue,
			title = i18n("island_chat_settings"),
			onYes = function(arg0_7, arg1_7, arg2_7)
				arg0_5:OnSettingEnd(arg0_7, arg1_7, arg2_7)
			end
		})
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.emojiBtn, function()
		local var0_8 = {
			emojiIconCallback = function(arg0_9)
				arg0_5.inputField.text = arg0_5.inputField.text .. string.gsub(ChatConst.EmojiIconCode, "code", arg0_9)
			end,
			callback = function(arg0_10)
				setInputText(arg0_5.inputField, "")
				arg0_5:NotifiyMeditor(IslandBaseMediator.SEND_CHAT, arg0_5.sendChannelValue, string.gsub(ChatConst.EmojiCode, "code", arg0_10))
			end,
			pos = arg0_5.emojiBtn.position
		}

		arg0_5.emojiAdaptor:Init(var0_8)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.sendBtn, function()
		local var0_11 = arg0_5.inputField.text

		setInputText(arg0_5.inputField, "")
		arg0_5:NotifiyMeditor(IslandBaseMediator.SEND_CHAT, arg0_5.sendChannelValue, var0_11)
	end, SFX_PANEL)
	onToggle(arg0_5, arg0_5.sendChanncelBtn, function(arg0_12)
		if arg0_12 then
			arg0_5:InitSendChannel()
		end
	end, SFX_PANEL)

	function arg0_5.scrollrect.onInitItem(arg0_13)
		arg0_5:OnInitItem(arg0_13)
	end

	function arg0_5.scrollrect.onUpdateItem(arg0_14, arg1_14)
		arg0_5:OnUpdateItem(arg0_14, arg1_14)
	end
end

function var0_0.OnSettingEnd(arg0_15, arg1_15, arg2_15, arg3_15)
	if arg0_15.sendChannelValue ~= arg1_15 then
		arg0_15.sendChannelValue = arg1_15

		arg0_15:InitSendChannelName()
	end

	if arg0_15.channelValue ~= arg2_15 then
		arg0_15.channelValue = arg2_15

		arg0_15:UpdateChannelToggles()
		arg0_15:Flush(false)
	end

	if arg0_15.chatRoomId ~= arg3_15 then
		arg0_15:NotifiyMeditor(IslandBaseMediator.CHANGE_CHAT_ROOM, arg3_15)
	end
end

function var0_0.InitRoomNum(arg0_16)
	local var0_16 = getProxy(PlayerProxy):getRawData().chatRoomId

	arg0_16.roomNumTxt.text = var0_16 == 0 and i18n("common_not_enter_room") or var0_16
	arg0_16.chatRoomId = var0_16
end

function var0_0.InitSendChannel(arg0_17)
	local var0_17 = IslandChatConst.SEND_CHANNELS

	arg0_17.uiSendChanncelList:make(function(arg0_18, arg1_18, arg2_18)
		if arg0_18 == UIItemList.EventUpdate then
			local var0_18 = var0_17[arg1_18 + 1]

			onButton(arg0_17, arg2_18, function()
				if var0_18 == IslandChatConst.CHANNEL_GUILD and getProxy(GuildProxy):getRawData() == nil then
					return
				end

				arg0_17.sendChannelValue = var0_18

				arg0_17:InitSendChannelName()
				triggerToggle(arg0_17.sendChanncelBtn, false)
			end, SFX_PANEL)

			local var1_18 = IslandChatConst.CHANNEL2CN(var0_18)

			setText(arg2_18:Find("Text"), setColorStr(var1_18, var0_18 == arg0_17.sendChannelValue and "#5ccaff" or "#ffffff"))
		end
	end)
	arg0_17.uiSendChanncelList:align(#var0_17)
end

function var0_0.InitSendChannelName(arg0_20)
	local var0_20 = IslandChatConst.CHANNEL2CN(arg0_20.sendChannelValue)

	arg0_20.sendChanncelTxt.text = var0_20
end

function var0_0.InitChanncelToggles(arg0_21)
	local var0_21 = IslandChatConst.CHANNELS

	arg0_21.uiChannelList:make(function(arg0_22, arg1_22, arg2_22)
		if arg0_22 == UIItemList.EventUpdate then
			local var0_22 = var0_21[arg1_22 + 1]

			onButton(arg0_21, arg2_22, function()
				arg0_21:UpdatteChannelValue(var0_22)
				arg0_21:Flush(false)
			end, SFX_PANEL)
		end
	end)
	arg0_21.uiChannelList:align(#var0_21)
	arg0_21:UpdatteChannelValue(arg0_21.channelValue)
end

function var0_0.UpdatteChannelValue(arg0_24, arg1_24)
	if arg1_24 == IslandChatConst.CHANNEL_ALL then
		arg0_24.channelValue = IslandChatConst.CHANNEL_ALL
	else
		if bit.band(arg0_24.channelValue, arg1_24) > 0 then
			if arg0_24.channelValue == IslandChatConst.CHANNEL_ALL then
				arg0_24.channelValue = arg1_24
			else
				arg0_24.channelValue = bit.bxor(arg0_24.channelValue, arg1_24)
			end
		else
			arg0_24.channelValue = bit.bor(arg0_24.channelValue, arg1_24)
		end

		if arg0_24.channelValue <= 0 then
			arg0_24.channelValue = IslandChatConst.CHANNEL_ALL
		end
	end

	arg0_24:UpdateChannelToggles()
end

function var0_0.UpdateChannelToggles(arg0_25)
	local var0_25 = IslandChatConst.CHANNELS

	arg0_25.uiChannelList:eachActive(function(arg0_26, arg1_26)
		local var0_26 = var0_25[arg0_26 + 1]
		local var1_26 = arg0_25.channelValue == IslandChatConst.CHANNEL_ALL
		local var2_26 = var0_26 == IslandChatConst.CHANNEL_ALL
		local var3_26 = var2_26 and var1_26 or not var2_26 and not var1_26 and bit.band(arg0_25.channelValue, var0_26) > 0

		setActive(arg1_26:Find("sel"), var3_26)

		local var4_26 = IslandChatConst.CHANNEL2CN(var0_26)

		setText(arg1_26:Find("Text"), setColorStr(var4_26, var3_26 and "#393a3c" or "#FFFFFF"))
	end)
end

function var0_0.Flush(arg0_27, arg1_27)
	arg0_27:InitChatMsg(arg1_27)
	arg0_27:InitRoomNum()
end

function var0_0.InsertMsg(arg0_28, arg1_28, arg2_28)
	if getProxy(FriendProxy):isInBlackList(arg2_28.playerId) then
		return
	end

	if arg2_28.player and arg2_28.content then
		table.insert(arg1_28, arg2_28)
	end
end

function var0_0.MatchChannel(arg0_29, arg1_29)
	return bit.band(arg0_29.channelValue, arg1_29) > 0
end

function var0_0.InitChatMsg(arg0_30, arg1_30)
	arg0_30.displays = {}

	if arg0_30:MatchChannel(IslandChatConst.CHANNEL_WORLD) then
		local var0_30 = getProxy(ChatProxy)

		_.each(var0_30:getRawData(), function(arg0_31)
			arg0_30:InsertMsg(arg0_30.displays, arg0_31)
		end)
	end

	if arg0_30:MatchChannel(IslandChatConst.CHANNEL_GUILD) then
		local var1_30 = getProxy(GuildProxy)

		if var1_30:getRawData() then
			_.each(var1_30:getChatMsgs(), function(arg0_32)
				arg0_30:InsertMsg(arg0_30.displays, arg0_32)
			end)
		end
	end

	if arg0_30:MatchChannel(IslandChatConst.CHANNEL_FRIEND) then
		local var2_30 = getProxy(FriendProxy)

		_.each(var2_30:getCacheMsgList(), function(arg0_33)
			arg0_30:InsertMsg(arg0_30.displays, arg0_33)
		end)
	end

	if arg0_30:MatchChannel(IslandChatConst.CHANNEL_ISLAND) then
		local var3_30 = arg0_30:GetView():GetIsland()

		_.each(getProxy(IslandProxy):GetChatMsgList(var3_30.id), function(arg0_34)
			arg0_30:InsertMsg(arg0_30.displays, arg0_34)
		end)
	end

	table.sort(arg0_30.displays, function(arg0_35, arg1_35)
		return arg0_35.timestamp < arg1_35.timestamp
	end)
	arg0_30.scrollrect:SetTotalCount(#arg0_30.displays, arg1_30 and 1 or -1)
end

function var0_0.OnInitItem(arg0_36, arg1_36)
	local var0_36 = IslandChatCard.New(arg1_36)

	onButton(arg0_36, var0_36.otherBubble.tf, function()
		local var0_37 = var0_36.sender.id
		local var1_37 = var0_36.otherBubble.circle.position
		local var2_37 = var0_36.data.content

		arg0_36:NotifiyMeditor(IslandBaseMediator.OPEN_FRIEND_INFO, var0_37, var1_37, var2_37)
	end)

	arg0_36.cards[arg1_36] = var0_36
end

function var0_0.OnUpdateItem(arg0_38, arg1_38, arg2_38)
	local var0_38 = arg0_38.cards[arg2_38]

	if not var0_38 then
		arg0_38:OnInitItem(arg2_38)

		var0_38 = arg0_38.cards[arg2_38]
	end

	local var1_38 = arg0_38.displays[arg1_38 + 1]

	var0_38:Update(var1_38)
end

function var0_0.OnDispose(arg0_39)
	var0_0.super.OnDispose(arg0_39)
	ClearLScrollrect(arg0_39.scrollrect)

	if arg0_39.emojiAdaptor then
		arg0_39.emojiAdaptor:Dispose()

		arg0_39.emojiAdaptor = nil
	end
end

return var0_0
