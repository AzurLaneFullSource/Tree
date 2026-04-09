local var0_0 = class("PlayRoomNotificationLayer", import("..base.BaseUI"))

var0_0.InitCount = 10
var0_0.MaxCount = 100
var0_0.FORM_COMMON = 0
var0_0.FORM_BATTLE = 1
var0_0.FORM_MAIN = 2
var0_0.ChannelBits = {
	send = ChatConst.ChannelWorld,
	recv = IndexConst.Flags2Bits({
		ChatConst.ChannelAll
	})
}

function var0_0.getUIName(arg0_1)
	return "IslandPlayRoomChatUI"
end

function var0_0.init(arg0_2)
	arg0_2.settingsBtn = arg0_2.rtWindow:Find("top/settings")
	arg0_2.uiChannelList = UIItemList.New(arg0_2.rtWindow:Find("top/channels"), arg0_2.rtWindow:Find("top/channels/tpl"))
	arg0_2.sendChanncelBtn = arg0_2.rtWindow:Find("send_panel/channel_btn")
	arg0_2.sendChanncelTxt = arg0_2.rtWindow:Find("send_panel/channel_btn/Text"):GetComponent(typeof(Text))
	arg0_2.roomNumTxt = arg0_2.rtWindow:Find("top/settings/Text"):GetComponent(typeof(Text))
	arg0_2.scrollrect = arg0_2.rtWindow:Find("list/content"):GetComponent("LScrollRect")
	arg0_2.emojiBtn = arg0_2.rtWindow:Find("send_panel/input_panel/emoji")
	arg0_2.sendBtn = arg0_2.rtWindow:Find("send_panel/send_btn")
	arg0_2.inputField = arg0_2.rtWindow:Find("send_panel/input_panel/input"):GetComponent(typeof(InputField))
	arg0_2.uiSendChanncelList = UIItemList.New(arg0_2.rtWindow:Find("send_panel/channel_sel_panel"), arg0_2.rtWindow:Find("send_panel/channel_sel_panel/tpl"))
	arg0_2.channelValue = PlayRoomChatConst.CHANNEL_ALL
	arg0_2.sendChannelValue = PlayRoomChatConst.CHANNEL_PLAYROOM
	arg0_2.cards = {}

	arg0_2:InitChanncelToggles()
	arg0_2:InitSendChannelName()
	arg0_2:RegisterEvent()
	arg0_2:BlurPanel(arg0_2._tf)
end

function var0_0.RegisterEvent(arg0_3)
	onButton(arg0_3, arg0_3.rtBg, function()
		arg0_3:closeView()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.settingsBtn, function()
		arg0_3:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			mediator = PlayRoomChatSettingsMsgboxMediator,
			viewComponent = PlayRoomChatSettingsMsgboxLayer,
			data = {
				groupName = arg0_3:getGroupName(),
				settings = {
					sendChannelValue = arg0_3.sendChannelValue,
					channelValue = arg0_3.channelValue,
					title = i18n("island_chat_settings"),
					onYes = function(arg0_6, arg1_6, arg2_6)
						arg0_3:OnSettingEnd(arg0_6, arg1_6, arg2_6)
					end
				}
			}
		}))
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.emojiBtn, function()
		local var0_7 = {
			emojiIconCallback = function(arg0_8)
				arg0_3.inputField.text = arg0_3.inputField.text .. string.gsub(ChatConst.EmojiIconCode, "code", arg0_8)
			end,
			callback = function(arg0_9)
				setInputText(arg0_3.inputField, "")
				arg0_3:emit(PlayRoomNotificationMediator.SEND_CHAT, arg0_3.sendChannelValue, string.gsub(ChatConst.EmojiCode, "code", arg0_9))
			end,
			pos = arg0_3.emojiBtn.position,
			groupName = arg0_3:getGroupName()
		}

		arg0_3:emit(PlayRoomNotificationMediator.OPEN_EMOJI, var0_7)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.sendBtn, function()
		local var0_10 = arg0_3.inputField.text

		setInputText(arg0_3.inputField, "")
		arg0_3:emit(PlayRoomNotificationMediator.SEND_CHAT, arg0_3.sendChannelValue, var0_10)
	end, SFX_PANEL)
	onToggle(arg0_3, arg0_3.sendChanncelBtn, function(arg0_11)
		if arg0_11 then
			arg0_3:InitSendChannel()
		end
	end, SFX_PANEL)

	function arg0_3.scrollrect.onInitItem(arg0_12)
		arg0_3:OnInitItem(arg0_12)
	end

	function arg0_3.scrollrect.onUpdateItem(arg0_13, arg1_13)
		arg0_3:OnUpdateItem(arg0_13, arg1_13)
	end
end

function var0_0.OnSettingEnd(arg0_14, arg1_14, arg2_14, arg3_14)
	if arg0_14.sendChannelValue ~= arg1_14 then
		arg0_14.sendChannelValue = arg1_14

		arg0_14:InitSendChannelName()
	end

	if arg0_14.channelValue ~= arg2_14 then
		arg0_14.channelValue = arg2_14

		arg0_14:UpdateChannelToggles()
		arg0_14:Flush(false)
	end

	if arg0_14.chatRoomId ~= arg3_14 then
		arg0_14:emit(PlayRoomNotificationMediator.CHANGE_CHAT_ROOM, arg3_14)
	end
end

function var0_0.InitRoomNum(arg0_15)
	local var0_15 = getProxy(PlayerProxy):getRawData().chatRoomId

	arg0_15.roomNumTxt.text = var0_15 == 0 and i18n("common_not_enter_room") or var0_15
	arg0_15.chatRoomId = var0_15
end

function var0_0.InitSendChannel(arg0_16)
	local var0_16 = PlayRoomChatConst.SEND_CHANNELS

	arg0_16.uiSendChanncelList:make(function(arg0_17, arg1_17, arg2_17)
		if arg0_17 == UIItemList.EventUpdate then
			local var0_17 = var0_16[arg1_17 + 1]

			onButton(arg0_16, arg2_17, function()
				if var0_17 == PlayRoomChatConst.CHANNEL_GUILD and getProxy(GuildProxy):getRawData() == nil then
					return
				end

				arg0_16.sendChannelValue = var0_17

				arg0_16:InitSendChannelName()
				triggerToggle(arg0_16.sendChanncelBtn, false)
			end, SFX_PANEL)

			local var1_17 = PlayRoomChatConst.CHANNEL2CN(var0_17)

			setText(arg2_17:Find("Text"), setColorStr(var1_17, var0_17 == arg0_16.sendChannelValue and "#5ccaff" or "#ffffff"))
		end
	end)
	arg0_16.uiSendChanncelList:align(#var0_16)
end

function var0_0.InitSendChannelName(arg0_19)
	local var0_19 = PlayRoomChatConst.CHANNEL2CN(arg0_19.sendChannelValue)

	arg0_19.sendChanncelTxt.text = var0_19
end

function var0_0.InitChanncelToggles(arg0_20)
	local var0_20 = PlayRoomChatConst.CHANNELS

	arg0_20.uiChannelList:make(function(arg0_21, arg1_21, arg2_21)
		if arg0_21 == UIItemList.EventUpdate then
			local var0_21 = var0_20[arg1_21 + 1]

			onButton(arg0_20, arg2_21, function()
				arg0_20:UpdatteChannelValue(var0_21)
				arg0_20:Flush(false)
			end, SFX_PANEL)
		end
	end)
	arg0_20.uiChannelList:align(#var0_20)
	arg0_20:UpdatteChannelValue(PlayRoomChatConst.CHANNEL_PLAYROOM)
end

function var0_0.UpdatteChannelValue(arg0_23, arg1_23)
	if arg1_23 == PlayRoomChatConst.CHANNEL_ALL then
		arg0_23.channelValue = PlayRoomChatConst.CHANNEL_ALL
	else
		if bit.band(arg0_23.channelValue, arg1_23) > 0 then
			if arg0_23.channelValue == PlayRoomChatConst.CHANNEL_ALL then
				arg0_23.channelValue = arg1_23
			else
				arg0_23.channelValue = bit.bxor(arg0_23.channelValue, arg1_23)
			end
		else
			arg0_23.channelValue = bit.bor(arg0_23.channelValue, arg1_23)
		end

		if arg0_23.channelValue <= 0 then
			arg0_23.channelValue = PlayRoomChatConst.CHANNEL_ALL
		end
	end

	arg0_23:UpdateChannelToggles()
end

function var0_0.UpdateChannelToggles(arg0_24)
	local var0_24 = PlayRoomChatConst.CHANNELS

	arg0_24.uiChannelList:eachActive(function(arg0_25, arg1_25)
		local var0_25 = var0_24[arg0_25 + 1]
		local var1_25 = arg0_24.channelValue == PlayRoomChatConst.CHANNEL_ALL
		local var2_25 = var0_25 == PlayRoomChatConst.CHANNEL_ALL
		local var3_25 = var2_25 and var1_25 or not var2_25 and not var1_25 and bit.band(arg0_24.channelValue, var0_25) > 0

		setActive(arg1_25:Find("sel"), var3_25)

		local var4_25 = PlayRoomChatConst.CHANNEL2CN(var0_25)

		setText(arg1_25:Find("Text"), setColorStr(var4_25, var3_25 and "#393a3c" or "#FFFFFF"))
	end)
end

function var0_0.Flush(arg0_26, arg1_26)
	arg0_26:InitChatMsg(arg1_26)
	arg0_26:InitRoomNum()
end

function var0_0.InsertMsg(arg0_27, arg1_27, arg2_27)
	if getProxy(FriendProxy):isInBlackList(arg2_27.playerId) then
		return
	end

	if arg2_27.player and arg2_27.content then
		table.insert(arg1_27, arg2_27)
	end
end

function var0_0.MatchChannel(arg0_28, arg1_28)
	return bit.band(arg0_28.channelValue, arg1_28) > 0
end

function var0_0.InitChatMsg(arg0_29, arg1_29)
	arg0_29.displays = {}

	if arg0_29:MatchChannel(PlayRoomChatConst.CHANNEL_WORLD) then
		local var0_29 = getProxy(ChatProxy)

		_.each(var0_29:getRawData(), function(arg0_30)
			arg0_29:InsertMsg(arg0_29.displays, arg0_30)
		end)
	end

	if arg0_29:MatchChannel(PlayRoomChatConst.CHANNEL_GUILD) then
		local var1_29 = getProxy(GuildProxy)

		if var1_29:getRawData() then
			_.each(var1_29:getChatMsgs(), function(arg0_31)
				arg0_29:InsertMsg(arg0_29.displays, arg0_31)
			end)
		end
	end

	if arg0_29:MatchChannel(PlayRoomChatConst.CHANNEL_FRIEND) then
		local var2_29 = getProxy(FriendProxy)

		_.each(var2_29:getCacheMsgList(), function(arg0_32)
			arg0_29:InsertMsg(arg0_29.displays, arg0_32)
		end)
	end

	if arg0_29:MatchChannel(PlayRoomChatConst.CHANNEL_PLAYROOM) then
		_.each(getProxy(PlayRoomProxy):GetChatMsgs(), function(arg0_33)
			arg0_29:InsertMsg(arg0_29.displays, arg0_33)
		end)
	end

	table.sort(arg0_29.displays, function(arg0_34, arg1_34)
		return arg0_34.timestamp < arg1_34.timestamp
	end)
	onNextTick(function()
		arg0_29.scrollrect:SetTotalCount(#arg0_29.displays, arg1_29 and 1 or -1)
	end)
end

function var0_0.OnInitItem(arg0_36, arg1_36)
	local var0_36 = IslandChatCard.New(arg1_36)

	onButton(arg0_36, var0_36.otherBubble.tf, function()
		local var0_37 = var0_36.sender.id
		local var1_37 = var0_36.otherBubble.circle.position
		local var2_37 = var0_36.data.content

		arg0_36:emit(PlayRoomNotificationMediator.OPEN_FRIEND_INFO, var0_37, var1_37, var2_37)
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

function var0_0.didEnter(arg0_39)
	arg0_39:Flush()
end

function var0_0.willExit(arg0_40)
	arg0_40:UnOverlayPanel(arg0_40._tf)
	ClearLScrollrect(arg0_40.scrollrect)
end

return var0_0
