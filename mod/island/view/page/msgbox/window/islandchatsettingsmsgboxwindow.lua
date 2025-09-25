local var0_0 = class("IslandChatSettingsMsgboxWindow", import(".IslandCommonMsgboxWindow"))

function var0_0.getUIName(arg0_1)
	return "IslandChatSettingsMsgBox"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.uiSendChanncelList = UIItemList.New(arg0_2:findTF("send_channel/list"), arg0_2:findTF("send_channel/list/tpl"))
	arg0_2.uiChanncelList = UIItemList.New(arg0_2:findTF("channels/list"), arg0_2:findTF("send_channel/list/tpl"))
	arg0_2.roomInput = arg0_2:findTF("room/room")

	setText(arg0_2:findTF("send_channel/Text"), i18n("notice_label_send"))
	setText(arg0_2:findTF("channels/Text"), i18n("notice_label_recv"))
	setText(arg0_2:findTF("room/Text"), i18n("notice_label_room"))
	setText(arg0_2:findTF("room/tip"), i18n("notice_label_tip"))
	arg0_2:InitSendChannel()
	arg0_2:InitChannels()
end

function var0_0.OnInit(arg0_3)
	var0_0.super.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		if arg0_3.onYes then
			local var0_4 = getInputText(arg0_3.roomInput)

			arg0_3.onYes(arg0_3.sendChannelValue, arg0_3.channelValue, tonumber(var0_4))
		end

		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.OnShow(arg0_5)
	var0_0.super.OnShow(arg0_5)

	local var0_5 = arg0_5.settings

	arg0_5.sendChannelValue = var0_5.sendChannelValue
	arg0_5.channelValue = var0_5.channelValue

	arg0_5:FlushSendChannel()
	arg0_5:FlushChannels()
	arg0_5:FlushRoom()
end

function var0_0.InitSendChannel(arg0_6)
	local var0_6 = IslandChatConst.SEND_CHANNELS

	arg0_6.uiSendChanncelList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			local var0_7 = var0_6[arg1_7 + 1]

			onButton(arg0_6, arg2_7, function()
				if var0_7 == IslandChatConst.CHANNEL_GUILD and getProxy(GuildProxy):getRawData() == nil then
					return
				end

				arg0_6.sendChannelValue = var0_7

				arg0_6:FlushSendChannel()
			end, SFX_PANEL)
			setActive(arg2_7:Find("line"), #var0_6 ~= arg1_7 + 1)
		end
	end)
	arg0_6.uiSendChanncelList:align(#var0_6)
end

function var0_0.InitChannels(arg0_9)
	local var0_9 = IslandChatConst.CHANNELS

	arg0_9.uiChanncelList:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			local var0_10 = var0_9[arg1_10 + 1]

			onButton(arg0_9, arg2_10, function()
				arg0_9:UpdatteChannelValue(var0_10)
				arg0_9:FlushChannels()
			end, SFX_PANEL)

			local var1_10 = arg1_10 + 1
			local var2_10 = var1_10 % 3 == 0
			local var3_10 = #var0_9 == var1_10

			setActive(arg2_10:Find("line"), not var3_10 and not var2_10)
		end
	end)
	arg0_9.uiChanncelList:align(#var0_9)
end

function var0_0.FlushSendChannel(arg0_12)
	local var0_12 = IslandChatConst.SEND_CHANNELS

	arg0_12.uiSendChanncelList:eachActive(function(arg0_13, arg1_13)
		local var0_13 = var0_12[arg0_13 + 1]
		local var1_13 = var0_13 == arg0_12.sendChannelValue

		setActive(arg1_13:Find("mark"), var1_13)

		local var2_13 = IslandChatConst.CHANNEL2CN(var0_13)

		setText(arg1_13:Find("Text"), setColorStr(var2_13, var1_13 and "#FFFFFF" or "#393a3c"))
	end)
end

function var0_0.FlushChannels(arg0_14)
	local var0_14 = IslandChatConst.CHANNELS

	arg0_14.uiChanncelList:eachActive(function(arg0_15, arg1_15)
		local var0_15 = var0_14[arg0_15 + 1]
		local var1_15 = arg0_14.channelValue == IslandChatConst.CHANNEL_ALL
		local var2_15 = var0_15 == IslandChatConst.CHANNEL_ALL
		local var3_15 = var2_15 and var1_15 or not var2_15 and not var1_15 and bit.band(arg0_14.channelValue, var0_15) > 0

		setActive(arg1_15:Find("mark"), var3_15)

		local var4_15 = IslandChatConst.CHANNEL2CN(var0_15)

		setText(arg1_15:Find("Text"), setColorStr(var4_15, var3_15 and "#FFFFFF" or "#393a3c"))
	end)
end

function var0_0.FlushRoom(arg0_16)
	local var0_16 = getProxy(PlayerProxy):getRawData().chatRoomId

	setInputText(arg0_16.roomInput, var0_16)
end

function var0_0.UpdatteChannelValue(arg0_17, arg1_17)
	if arg1_17 == IslandChatConst.CHANNEL_ALL then
		arg0_17.channelValue = IslandChatConst.CHANNEL_ALL
	else
		if bit.band(arg0_17.channelValue, arg1_17) > 0 then
			if arg0_17.channelValue == IslandChatConst.CHANNEL_ALL then
				arg0_17.channelValue = arg1_17
			else
				arg0_17.channelValue = bit.bxor(arg0_17.channelValue, arg1_17)
			end
		else
			arg0_17.channelValue = bit.bor(arg0_17.channelValue, arg1_17)
		end

		if arg0_17.channelValue <= 0 then
			arg0_17.channelValue = IslandChatConst.CHANNEL_ALL
		end
	end
end

return var0_0
