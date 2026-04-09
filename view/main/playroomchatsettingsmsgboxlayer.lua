local var0_0 = class("PlayRoomChatSettingsMsgboxLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "IslandPlayRoomChatSettingsMsgBox"
end

function var0_0.init(arg0_2)
	arg0_2.titleTxt = arg0_2.rtPage:Find("title"):GetComponent(typeof(Text))
	arg0_2.contentTxt = arg0_2.rtPage:Find("content/Text"):GetComponent("RichText")
	arg0_2.closeBtn = arg0_2.rtPage:Find("close")
	arg0_2.cancelBtn = arg0_2.rtPage:Find("cancel")
	arg0_2.confirmBtn = arg0_2.rtPage:Find("confirm")
	arg0_2.cancelTxt = arg0_2.rtPage:Find("cancel/Text"):GetComponent(typeof(Text))
	arg0_2.confirmTxt = arg0_2.rtPage:Find("confirm/Text"):GetComponent(typeof(Text))
	arg0_2.uiSendChanncelList = UIItemList.New(arg0_2.rtPage:Find("send_channel/list"), arg0_2.rtPage:Find("send_channel/list/tpl"))
	arg0_2.uiChanncelList = UIItemList.New(arg0_2.rtPage:Find("channels/list"), arg0_2.rtPage:Find("send_channel/list/tpl"))
	arg0_2.roomInput = arg0_2.rtPage:Find("room/room")

	setText(arg0_2.rtPage:Find("send_channel/Text"), i18n("notice_label_send"))
	setText(arg0_2.rtPage:Find("channels/Text"), i18n("notice_label_recv"))
	setText(arg0_2.rtPage:Find("room/Text"), i18n("notice_label_room"))
	setText(arg0_2.rtPage:Find("room/tip"), i18n("notice_label_tip"))
	arg0_2:InitSendChannel()
	arg0_2:InitChannels()
	arg0_2:OverlayPanel(arg0_2._tf)
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3.rtBg, function()
		local var0_4 = arg0_3.onNo

		arg0_3:closeView()
		existCall(var0_4)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		local var0_5 = arg0_3.onNo

		arg0_3:closeView()
		existCall(var0_5)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:closeView()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		local var0_7 = arg0_3.onYes

		arg0_3:closeView()
		existCall(var0_7)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		local var0_8 = arg0_3.onYes

		existCall(var0_8, arg0_3.sendChannelValue, arg0_3.channelValue, tonumber(getInputText(arg0_3.roomInput)))
		arg0_3:closeView()
	end, SFX_PANEL)

	local var0_3 = arg0_3.contextData.settings

	if var0_3.rawIconDic then
		for iter0_3, iter1_3 in pairs(var0_3.rawIconDic) do
			arg0_3.contentTxt:AddSprite(iter0_3, iter1_3)
		end
	end

	arg0_3.titleTxt.text = var0_3.title or i18n("island_msg_info")
	arg0_3.contentTxt.text = var0_3.content or ""
	arg0_3.onYes = var0_3.onYes
	arg0_3.onNo = var0_3.onNo
	arg0_3.onHide = var0_3.onHide

	arg0_3:FlushBtn(var0_3)

	arg0_3.sendChannelValue = var0_3.sendChannelValue
	arg0_3.channelValue = var0_3.channelValue

	arg0_3:FlushSendChannel()
	arg0_3:FlushChannels()
	arg0_3:FlushRoom()
end

function var0_0.InitSendChannel(arg0_9)
	local var0_9 = PlayRoomChatConst.SEND_CHANNELS

	arg0_9.uiSendChanncelList:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			local var0_10 = var0_9[arg1_10 + 1]

			onButton(arg0_9, arg2_10, function()
				if var0_10 == PlayRoomChatConst.CHANNEL_GUILD and getProxy(GuildProxy):getRawData() == nil then
					return
				end

				arg0_9.sendChannelValue = var0_10

				arg0_9:FlushSendChannel()
			end, SFX_PANEL)
			setActive(arg2_10:Find("line"), #var0_9 ~= arg1_10 + 1)
		end
	end)
	arg0_9.uiSendChanncelList:align(#var0_9)
end

function var0_0.InitChannels(arg0_12)
	local var0_12 = PlayRoomChatConst.CHANNELS

	arg0_12.uiChanncelList:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventUpdate then
			local var0_13 = var0_12[arg1_13 + 1]

			onButton(arg0_12, arg2_13, function()
				arg0_12:UpdatteChannelValue(var0_13)
				arg0_12:FlushChannels()
			end, SFX_PANEL)

			local var1_13 = arg1_13 + 1
			local var2_13 = var1_13 % 3 == 0
			local var3_13 = #var0_12 == var1_13

			setActive(arg2_13:Find("line"), not var3_13 and not var2_13)
		end
	end)
	arg0_12.uiChanncelList:align(#var0_12)
end

function var0_0.FlushSendChannel(arg0_15)
	local var0_15 = PlayRoomChatConst.SEND_CHANNELS

	arg0_15.uiSendChanncelList:eachActive(function(arg0_16, arg1_16)
		local var0_16 = var0_15[arg0_16 + 1]
		local var1_16 = var0_16 == arg0_15.sendChannelValue

		setActive(arg1_16:Find("mark"), var1_16)

		local var2_16 = PlayRoomChatConst.CHANNEL2CN(var0_16)

		setText(arg1_16:Find("Text"), setColorStr(var2_16, var1_16 and "#FFFFFF" or "#393a3c"))
	end)
end

function var0_0.FlushChannels(arg0_17)
	local var0_17 = PlayRoomChatConst.CHANNELS

	arg0_17.uiChanncelList:eachActive(function(arg0_18, arg1_18)
		local var0_18 = var0_17[arg0_18 + 1]
		local var1_18 = arg0_17.channelValue == PlayRoomChatConst.CHANNEL_ALL
		local var2_18 = var0_18 == PlayRoomChatConst.CHANNEL_ALL
		local var3_18 = var2_18 and var1_18 or not var2_18 and not var1_18 and bit.band(arg0_17.channelValue, var0_18) > 0

		setActive(arg1_18:Find("mark"), var3_18)

		local var4_18 = PlayRoomChatConst.CHANNEL2CN(var0_18)

		setText(arg1_18:Find("Text"), setColorStr(var4_18, var3_18 and "#FFFFFF" or "#393a3c"))
	end)
end

function var0_0.FlushRoom(arg0_19)
	local var0_19 = getProxy(PlayerProxy):getRawData().chatRoomId

	setInputText(arg0_19.roomInput, var0_19)
end

function var0_0.FlushBtn(arg0_20, arg1_20)
	setActive(arg0_20.cancelBtn, not arg1_20.hideNo)

	local var0_20 = arg1_20.hideNo and 880 or 420

	arg0_20.confirmBtn.sizeDelta = Vector2(var0_20, arg0_20.confirmBtn.sizeDelta.y)
	arg0_20.cancelTxt.text = arg1_20.noText and arg1_20.noText or i18n("word_cancel")
	arg0_20.confirmTxt.text = arg1_20.yesText and arg1_20.yesText or i18n("word_ok")
end

function var0_0.UpdatteChannelValue(arg0_21, arg1_21)
	if arg1_21 == PlayRoomChatConst.CHANNEL_ALL then
		arg0_21.channelValue = PlayRoomChatConst.CHANNEL_ALL
	else
		if bit.band(arg0_21.channelValue, arg1_21) > 0 then
			if arg0_21.channelValue == PlayRoomChatConst.CHANNEL_ALL then
				arg0_21.channelValue = arg1_21
			else
				arg0_21.channelValue = bit.bxor(arg0_21.channelValue, arg1_21)
			end
		else
			arg0_21.channelValue = bit.bor(arg0_21.channelValue, arg1_21)
		end

		if arg0_21.channelValue <= 0 then
			arg0_21.channelValue = PlayRoomChatConst.CHANNEL_ALL
		end
	end
end

function var0_0.willExit(arg0_22)
	arg0_22:UnOverlayPanel(arg0_22._tf)

	if arg0_22.onHide then
		arg0_22.onHide()

		arg0_22.onHide = nil
	end
end

return var0_0
