local var0_0 = class("NotificationLayer", import("..base.BaseUI"))

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
	if getProxy(SettingsProxy):IsMellowStyle() then
		return "NotificationUI4Mellow"
	else
		return "NotificationUI"
	end
end

function var0_0.getGroupName(arg0_2)
	return "group_NotificationUI"
end

function var0_0.setPlayer(arg0_3, arg1_3)
	arg0_3.player = arg1_3
end

function var0_0.setInGuild(arg0_4, arg1_4)
	arg0_4.inGuild = arg1_4
end

function var0_0.setMessages(arg0_5, arg1_5)
	arg0_5.messages = arg1_5
end

function var0_0.init(arg0_6)
	arg0_6.close = arg0_6:findTF("close")
	arg0_6.frame = arg0_6:findTF("frame")
	arg0_6.contain = arg0_6.frame:Find("contain")

	local var0_6 = arg0_6.contain:Find("ListContainer/list")

	arg0_6.content = var0_6:Find("content")
	arg0_6.emptySign = var0_6:Find("EmptySign")

	setActive(arg0_6.emptySign, false)

	arg0_6.prefabSelf = var0_6:Find("popo_self").gameObject
	arg0_6.prefabOthers = var0_6:Find("popo_other").gameObject
	arg0_6.prefabPublic = var0_6:Find("popo_public").gameObject
	arg0_6.prefabWorldBoss = var0_6:Find("popo_worldboss").gameObject
	arg0_6.prefabWorldBossArchives = var0_6:Find("popo_worldboss_archives").gameObject
	arg0_6.input = arg0_6.frame:Find("contain/ListContainer/inputbg/input"):GetComponent("InputField")

	setText(arg0_6.frame:Find("contain/ListContainer/inputbg/input/Placeholder"), i18n("notice_input_desc"))

	arg0_6.send = arg0_6.frame:Find("send")
	arg0_6.channelSend = arg0_6.frame:Find("channel_send")
	arg0_6.channelSendPop = arg0_6.frame:Find("channel_pop")
	arg0_6.scroll = var0_6:GetComponent("ScrollRect")
	arg0_6.topMsg = arg0_6.contain:Find("topmsg")

	SetActive(arg0_6.topMsg, false)

	arg0_6.topPublic = arg0_6:findTF("popo_public", arg0_6.topMsg)
	arg0_6.emoji = arg0_6.frame:Find("contain/ListContainer/inputbg/emoji")
	arg0_6.changeRoomPanel = arg0_6:findTF("change_room_Panel")
	arg0_6.roomSendBtns = arg0_6:findTF("frame/bg/type_send", arg0_6.changeRoomPanel)
	arg0_6.roomRecvBtns = arg0_6:findTF("frame/bg/type_recv", arg0_6.changeRoomPanel)
	arg0_6.enterRoomTip = arg0_6.frame:Find("enter_room_tip")
	arg0_6.enterRoomCG = arg0_6.enterRoomTip:GetComponent(typeof(CanvasGroup))
	arg0_6.roomBtn = arg0_6.contain:Find("top/room")
	arg0_6.typeBtns = arg0_6.contain:Find("top/type")
	arg0_6.inputTF = arg0_6:findTF("frame/bg/InputField", arg0_6.changeRoomPanel):GetComponent(typeof(InputField))
	arg0_6.switchTpl = arg0_6:findTF("switch_tpl", arg0_6.changeRoomPanel)
	arg0_6.switchNormalSprite = arg0_6:findTF("switch_normal", arg0_6.changeRoomPanel):GetComponent(typeof(Image)).sprite
	arg0_6.switchSelectedSprite = arg0_6:findTF("switch_selected", arg0_6.changeRoomPanel):GetComponent(typeof(Image)).sprite

	setText(findTF(arg0_6.changeRoomPanel, "frame/bg/label_send"), i18n("notice_label_send"))
	setText(findTF(arg0_6.changeRoomPanel, "frame/bg/label_recv"), i18n("notice_label_recv"))
	setText(findTF(arg0_6.changeRoomPanel, "frame/bg/label_room"), i18n("notice_label_room"))
	setText(findTF(arg0_6.changeRoomPanel, "frame/bg/label_tip"), i18n("notice_label_tip"))
	setText(findTF(arg0_6.changeRoomPanel, "frame/cancel/Image"), i18n("word_cancel"))
	setText(findTF(arg0_6.changeRoomPanel, "frame/confirm/Image"), i18n("word_ok"))

	arg0_6.resource = arg0_6:findTF("resource")
	arg0_6.typeTpl = arg0_6:findTF("type_tpl", arg0_6.resource)
	arg0_6.normalSprite = arg0_6:findTF("normal", arg0_6.resource):GetComponent(typeof(Image)).sprite
	arg0_6.selectedSprite = arg0_6:findTF("selected", arg0_6.resource):GetComponent(typeof(Image)).sprite
	arg0_6.bottomChannelTpl = arg0_6:findTF("channel_tpl", arg0_6.resource)
	arg0_6.bottomChannelNormalSprite = arg0_6:findTF("channel_normal", arg0_6.resource):GetComponent(typeof(Image)).sprite
	arg0_6.bottomChannelSelectedSprite = arg0_6:findTF("channel_selected", arg0_6.resource):GetComponent(typeof(Image)).sprite

	local var1_6 = {
		ChatConst.ChannelAll,
		ChatConst.ChannelWorld,
		ChatConst.ChannelPublic,
		ChatConst.ChannelFriend,
		ChatConst.ChannelGuild,
		ChatConst.ChannelWorldBoss
	}

	arg0_6.textSprites = {}
	arg0_6.textSelectedSprites = {}
	arg0_6.bottomChannelTextSprites = {}
	arg0_6.switchTextSprites = {}

	for iter0_6, iter1_6 in pairs(var1_6) do
		local var2_6 = ChatConst.GetChannelSprite(iter0_6)

		arg0_6.textSprites[iter0_6] = arg0_6:findTF("text_" .. var2_6, arg0_6.resource):GetComponent(typeof(Image)).sprite
		arg0_6.textSelectedSprites[iter0_6] = arg0_6:findTF("text_" .. var2_6 .. "_selected", arg0_6.resource):GetComponent(typeof(Image)).sprite
		arg0_6.switchTextSprites[iter0_6] = arg0_6:findTF("text_" .. var2_6 .. "_switch", arg0_6.changeRoomPanel):GetComponent(typeof(Image)).sprite

		if table.contains(ChatConst.SendChannels, iter0_6) then
			arg0_6.bottomChannelTextSprites[iter0_6] = arg0_6:findTF("channel_" .. var2_6, arg0_6.resource):GetComponent(typeof(Image)).sprite
		end
	end

	arg0_6.prefabSelf:SetActive(false)
	arg0_6.prefabOthers:SetActive(false)
	arg0_6.prefabPublic:SetActive(false)

	arg0_6.bubbleCards = {}
	arg0_6.worldBossCards = {}
	arg0_6.poolBubble = {
		self = {},
		public = {},
		others = {}
	}
	var0_0.ChannelBits.recv = getProxy(SettingsProxy):GetChatFlag()
end

function var0_0.adjustMsgListPanel(arg0_7)
	arg0_7.listContainerTF = arg0_7.contain:Find("ListContainer")
	arg0_7.listTF = arg0_7.contain:Find("ListContainer/list")

	local var0_7 = arg0_7.listContainerTF.rect.size.y
	local var1_7 = 69.01791

	GetComponent(arg0_7.listTF, "LayoutElement").preferredHeight = var0_7 - var1_7
end

function var0_0.didEnter(arg0_8)
	arg0_8:adjustMsgListPanel()

	arg0_8.currentForm = arg0_8.contextData.form
	arg0_8.escFlag = false

	onButton(arg0_8, arg0_8.close, function()
		arg0_8:PlayExitAnimation(function()
			if arg0_8.currentForm == var0_0.FORM_BATTLE then
				arg0_8:emit(NotificationMediator.BATTLE_CHAT_CLOSE)
			end

			arg0_8:emit(BaseUI.ON_CLOSE)
		end)
	end, SFX_CANCEL)
	onButton(arg0_8, arg0_8.emoji, function()
		arg0_8:displayEmojiPanel()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.send, function()
		local var0_12 = arg0_8.input.text

		if var0_12 == "" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("main_notificationLayer_sendButton"))

			return
		end

		arg0_8.input.text = ""

		arg0_8:emit(NotificationMediator.ON_SEND_PUBLIC, var0_0.ChannelBits.send, var0_12)
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.roomBtn, function()
		arg0_8:showChangeRoomPanel()
	end, SFX_PANEL)
	onButton(arg0_8, findTF(arg0_8.changeRoomPanel, "frame/cancel"), function()
		arg0_8:closeChangeRoomPanel()
	end, SFX_CANCEL)
	onButton(arg0_8, findTF(arg0_8.changeRoomPanel, "frame/confirm"), function()
		arg0_8:emit(NotificationMediator.CHANGE_ROOM, tonumber(arg0_8.inputTF.text))
	end, SFX_CANCEL)
	onButton(arg0_8, arg0_8.channelSend, function()
		setActive(arg0_8.channelSendPop, not isActive(arg0_8.channelSendPop))

		if isActive(arg0_8.channelSendPop) then
			arg0_8:updateChannelSendPop()
		end
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8._tf, function()
		if isActive(arg0_8.channelSendPop) then
			setActive(arg0_8.channelSendPop, false)
		end
	end)
	pg.DelegateInfo.Add(arg0_8, arg0_8.scroll.onValueChanged)
	arg0_8.scroll.onValueChanged:AddListener(function(arg0_18)
		if arg0_8.index > 1 and arg0_18.y >= 1 then
			local var0_18 = arg0_8.content.sizeDelta.y * arg0_18.y
			local var1_18 = arg0_8.scroll.velocity
			local var2_18 = math.max(1, arg0_8.index - var0_0.InitCount)

			for iter0_18 = arg0_8.index - 1, var2_18, -1 do
				arg0_8:append(arg0_8.filteredMessages[iter0_18], 0)
			end

			Canvas.ForceUpdateCanvases()

			arg0_8.scroll.normalizedPosition = Vector2(0, var0_18 / arg0_8.content.sizeDelta.y)

			arg0_8.scroll.onValueChanged:Invoke(arg0_8.scroll.normalizedPosition)

			arg0_8.scroll.velocity = var1_18
			arg0_8.index = var2_18
		end
	end)
	arg0_8:updateRoom()
	arg0_8:updateChatChannel()
	arg0_8:initFilter()
	arg0_8:updateFilter()
	arg0_8:updateAll()

	if arg0_8.currentForm == var0_0.FORM_BATTLE then
		arg0_8._tf:SetParent(arg0_8.contextData.chatViewParent, true)

		rtf(arg0_8.frame.transform).offsetMax = Vector2(0, -120)
	else
		arg0_8:BlurPanel()
	end

	LeanTween.delayedCall(go(arg0_8._tf), 0.2, System.Action(function()
		scrollToBottom(arg0_8.content.parent)
	end))

	rtf(arg0_8._tf).offsetMax = Vector2(0, 0)
	rtf(arg0_8._tf).offsetMin = Vector2(0, 0)
end

function var0_0.BlurPanel(arg0_20)
	pg.UIMgr.GetInstance():BlurPanel(arg0_20._tf, false, {
		groupName = arg0_20:getGroupNameFromData(),
		weight = arg0_20:getWeightFromData() + 1
	})
end

function var0_0.UnblurPanel(arg0_21)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_21._tf)
end

function var0_0.onBackPressed(arg0_22)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if isActive(arg0_22.changeRoomPanel) then
		arg0_22:closeChangeRoomPanel()
	else
		triggerButton(arg0_22.close)
	end
end

function var0_0.initFilter(arg0_23)
	local var0_23 = ChatConst.RecvChannels

	arg0_23.recvTypes = UIItemList.New(arg0_23.typeBtns, arg0_23.typeTpl)

	arg0_23.recvTypes:make(function(arg0_24, arg1_24, arg2_24)
		if arg0_24 == UIItemList.EventUpdate then
			local var0_24 = var0_23[arg1_24 + 1]

			setImageSprite(arg2_24:Find("text"), arg0_23.textSprites[var0_24], true)
			setImageSprite(arg2_24:Find("text_selected"), arg0_23.textSelectedSprites[var0_24], true)
			onButton(arg0_23, arg2_24, function()
				local var0_25 = _.filter(var0_23, function(arg0_26)
					return arg0_26 ~= ChatConst.ChannelGuild or arg0_23.inGuild
				end)
				local var1_25 = IndexConst.ToggleBits(var0_0.ChannelBits.recv, var0_25, ChatConst.ChannelAll, var0_24)

				if var0_0.ChannelBits.recv == var1_25 then
					return
				end

				var0_0.ChannelBits.recv = var1_25

				arg0_23:updateFilter()
				arg0_23:updateAll()
				getProxy(SettingsProxy):SetChatFlag(var0_0.ChannelBits.recv)
			end, SFX_UI_TAG)
		end
	end)
	arg0_23.recvTypes:align(#var0_23)
end

function var0_0.updateFilter(arg0_27)
	local var0_27 = ChatConst.RecvChannels

	arg0_27.recvTypes:each(function(arg0_28, arg1_28)
		local var0_28 = var0_27[arg0_28 + 1]

		if var0_28 == ChatConst.ChannelGuild and not arg0_27.inGuild then
			setButtonEnabled(arg1_28, false)
		end

		if bit.band(var0_0.ChannelBits.recv, bit.lshift(1, var0_28)) > 0 then
			setImageSprite(arg1_28, arg0_27.selectedSprite)
			setActive(arg1_28:Find("text_selected"), true)
		else
			setImageSprite(arg1_28, arg0_27.normalSprite)
			setActive(arg1_28:Find("text_selected"), false)
		end
	end)

	local var1_27 = var0_0.ChannelBits.recv
	local var2_27 = bit.lshift(1, ChatConst.ChannelAll)

	arg0_27.filteredMessages = _.filter(arg0_27.messages, function(arg0_29)
		return var1_27 == var2_27 or bit.band(var1_27, bit.lshift(1, arg0_29.type)) > 0
	end)
	arg0_27.filteredMessages = _.slice(arg0_27.filteredMessages, #arg0_27.filteredMessages - var0_0.MaxCount + 1, var0_0.MaxCount)
end

function var0_0.updateChatChannel(arg0_30)
	setImageSprite(arg0_30.channelSend:Find("Text"), arg0_30.bottomChannelTextSprites[var0_0.ChannelBits.send], true)
end

function var0_0.updateChannelSendPop(arg0_31)
	local var0_31 = ChatConst.SendChannels
	local var1_31 = UIItemList.New(arg0_31.channelSendPop:Find("type_send"), arg0_31.bottomChannelTpl)

	local function var2_31()
		var1_31:each(function(arg0_33, arg1_33)
			local var0_33 = var0_31[arg0_33 + 1]

			if var0_33 == ChatConst.ChannelGuild and not arg0_31.inGuild then
				setButtonEnabled(arg1_33, false)
			end

			local var1_33 = var0_0.ChannelBits.send == var0_33

			if var1_33 then
				setImageSprite(arg1_33:Find("bottom"), arg0_31.bottomChannelSelectedSprite, true)
			else
				setImageSprite(arg1_33:Find("bottom"), arg0_31.bottomChannelNormalSprite, true)
			end

			setActive(arg1_33:Find("selected"), var1_33)
			setActive(arg1_33:Find("text"), not var1_33)
		end)
	end

	var1_31:make(function(arg0_34, arg1_34, arg2_34)
		if arg0_34 == UIItemList.EventUpdate then
			local var0_34 = var0_31[arg1_34 + 1]

			setImageSprite(arg2_34:Find("text"), arg0_31.bottomChannelTextSprites[var0_34], true)
			setImageSprite(arg2_34:Find("selected"), arg0_31.bottomChannelTextSprites[var0_34], true)
			onButton(arg0_31, arg2_34, function()
				setActive(arg0_31.channelSendPop, false)

				var0_0.ChannelBits.send = var0_34

				var2_31()
				arg0_31:updateChatChannel()
			end, SFX_UI_TAG)
		end
	end)
	var1_31:align(#var0_31)
	var2_31()
end

function var0_0.updateRoom(arg0_36)
	setText(arg0_36.enterRoomTip:Find("text"), i18n("main_notificationLayer_enter_room", arg0_36.player.chatRoomId == 0 and "" or arg0_36.player.chatRoomId))
	setText(arg0_36:findTF("Text", arg0_36.roomBtn), arg0_36.player.chatRoomId == 0 and i18n("common_not_enter_room") or arg0_36.player.chatRoomId)
	arg0_36:showEnterRommTip()
end

function var0_0.showChangeRoomPanel(arg0_37)
	arg0_37:UnblurPanel()
	pg.UIMgr.GetInstance():BlurPanel(arg0_37.changeRoomPanel, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})

	arg0_37.inputTF.text = tostring(arg0_37.player.chatRoomId)
	arg0_37.tempRoomSendBits = var0_0.ChannelBits.send

	local var0_37 = ChatConst.SendChannels
	local var1_37 = UIItemList.New(arg0_37.roomSendBtns, arg0_37.switchTpl)

	local function var2_37()
		var1_37:each(function(arg0_39, arg1_39)
			local var0_39 = var0_37[arg0_39 + 1]

			if var0_39 == ChatConst.ChannelGuild and not arg0_37.inGuild then
				setButtonEnabled(arg1_39, false)
			end

			if arg0_37.tempRoomSendBits == var0_39 then
				setImageSprite(arg1_39, arg0_37.switchSelectedSprite)
			else
				setImageSprite(arg1_39, arg0_37.switchNormalSprite)
			end
		end)
	end

	var1_37:make(function(arg0_40, arg1_40, arg2_40)
		if arg0_40 == UIItemList.EventUpdate then
			local var0_40 = var0_37[arg1_40 + 1]

			setImageSprite(arg2_40:Find("text"), arg0_37.switchTextSprites[var0_40], true)
			onButton(arg0_37, arg2_40, function()
				arg0_37.tempRoomSendBits = var0_40

				var2_37()
			end, SFX_UI_TAG)
		end
	end)
	var1_37:align(#var0_37)
	var2_37()

	arg0_37.tempRoomRecvBits = var0_0.ChannelBits.recv

	local var3_37 = ChatConst.RecvChannels
	local var4_37 = UIItemList.New(arg0_37.roomRecvBtns, arg0_37.switchTpl)

	local function var5_37()
		var4_37:each(function(arg0_43, arg1_43)
			local var0_43 = var3_37[arg0_43 + 1]

			if var0_43 == ChatConst.ChannelGuild and not arg0_37.inGuild then
				setButtonEnabled(arg1_43, false)
			end

			if bit.band(arg0_37.tempRoomRecvBits, bit.lshift(1, var0_43)) > 0 then
				setImageSprite(arg1_43, arg0_37.switchSelectedSprite)
			else
				setImageSprite(arg1_43, arg0_37.switchNormalSprite)
			end
		end)
	end

	var4_37:make(function(arg0_44, arg1_44, arg2_44)
		if arg0_44 == UIItemList.EventUpdate then
			local var0_44 = var3_37[arg1_44 + 1]

			setImageSprite(arg2_44:Find("text"), arg0_37.switchTextSprites[var0_44], true)
			onButton(arg0_37, arg2_44, function()
				local var0_45 = _.filter(var3_37, function(arg0_46)
					return arg0_46 ~= ChatConst.ChannelGuild or arg0_37.inGuild
				end)

				arg0_37.tempRoomRecvBits = IndexConst.ToggleBits(arg0_37.tempRoomRecvBits, var0_45, ChatConst.ChannelAll, var0_44)

				var5_37()
			end, SFX_UI_TAG)
		end
	end)
	var4_37:align(#var3_37)
	var5_37()
	setActive(arg0_37.changeRoomPanel, true)
end

function var0_0.closeChangeRoomPanel(arg0_47)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_47.changeRoomPanel, arg0_47._tf)

	if arg0_47.currentForm == var0_0.FORM_BATTLE then
		arg0_47._tf:SetParent(arg0_47.contextData.chatViewParent, true)

		rtf(arg0_47.frame.transform).offsetMax = Vector2(0, -120)
	else
		arg0_47:BlurPanel()
	end

	setActive(arg0_47.changeRoomPanel, false)
end

function var0_0.removeAllBubble(arg0_48)
	for iter0_48, iter1_48 in ipairs(arg0_48.bubbleCards or {}) do
		setActive(iter1_48.tf, false)

		local var0_48 = arg0_48.poolBubble.others

		if iter1_48.__cname == "ChatBubblePublic" then
			var0_48 = arg0_48.poolBubble.public
		elseif iter1_48.__cname == "ChatBubble" and iter1_48.data.player and iter1_48.data.player.id == arg0_48.player.id then
			var0_48 = arg0_48.poolBubble.self
		end

		iter1_48:dispose()
		table.insert(var0_48, iter1_48)
	end

	arg0_48.bubbleCards = {}

	for iter2_48, iter3_48 in pairs(arg0_48.worldBossCards) do
		if not IsNil(iter3_48.tf) then
			Destroy(iter3_48.tf)
		end
	end

	arg0_48.worldBossCards = {}
end

function var0_0.updateAll(arg0_49)
	arg0_49:removeAllBubble()

	arg0_49.index = math.max(1, #arg0_49.filteredMessages - var0_0.InitCount)

	for iter0_49 = arg0_49.index, #arg0_49.filteredMessages do
		arg0_49:append(arg0_49.filteredMessages[iter0_49], -1)
	end

	scrollToBottom(arg0_49.content.parent)
	setActive(arg0_49.emptySign, PLATFORM_CODE == PLATFORM_JP and #arg0_49.filteredMessages <= 0)
end

function var0_0.append(arg0_50, arg1_50, arg2_50, arg3_50)
	if #arg0_50.filteredMessages >= var0_0.MaxCount * 2 then
		arg0_50:updateFilter()
		arg0_50:updateAll()
	else
		arg3_50 = arg3_50 and arg0_50.scroll.normalizedPosition.y < 0.1

		if arg1_50.type == ChatConst.ChannelPublic then
			if arg1_50.id == 0 then
				arg0_50:appendTopPublic(arg1_50)
			else
				arg0_50:appendPublic(arg1_50, arg2_50)
			end
		elseif arg1_50:IsWorldBossNotify() then
			arg0_50:appendPublic(arg1_50, arg2_50)
		else
			arg0_50:appendOthers(arg1_50, arg2_50)
		end

		if arg3_50 then
			scrollToBottom(arg0_50.content.parent)
		end
	end

	setActive(arg0_50.emptySign, PLATFORM_CODE == PLATFORM_JP and #arg0_50.filteredMessages <= 0)
end

function var0_0.appendOthers(arg0_51, arg1_51, arg2_51)
	local var0_51 = arg1_51.player
	local var1_51 = arg0_51.poolBubble.others
	local var2_51 = arg0_51.prefabOthers

	if var0_51.id == arg0_51.player.id then
		var1_51 = arg0_51.poolBubble.self
		var2_51 = arg0_51.prefabSelf
		arg1_51.isSelf = true
		arg1_51.player = setmetatable(Clone(arg0_51.player), {
			__index = arg1_51.player.__index
		})
	end

	local var3_51

	if #var1_51 > 0 then
		var3_51 = var1_51[1]

		setActive(var3_51.tf, true)
		table.remove(var1_51, 1)
	else
		local var4_51 = cloneTplTo(var2_51, arg0_51.content)

		var3_51 = ChatBubble.New(var4_51)
	end

	var3_51.tf:SetSiblingIndex(arg2_51)
	table.insert(arg0_51.bubbleCards, var3_51)
	var3_51:update(arg1_51)
	removeOnButton(var3_51.headTF)
	onButton(arg0_51, var3_51.headTF, function()
		local var0_52 = arg0_51:findTF("shipicon/icon", var3_51.tf).position

		arg0_51:emit(NotificationMediator.OPEN_INFO, var0_51, var0_52, arg1_51.content)
	end, SFX_PANEL)
end

function var0_0.appendPublic(arg0_53, arg1_53, arg2_53)
	local var0_53

	if arg1_53.id == 4 then
		local var1_53 = WorldBossConst.__IsCurrBoss(arg1_53.args.wordBossConfigId) and arg0_53.prefabWorldBoss or arg0_53.prefabWorldBossArchives
		local var2_53 = cloneTplTo(var1_53, arg0_53.content)

		var0_53 = ChatBubbleWorldBoss.New(var2_53, arg0_53.currentForm ~= var0_0.FORM_BATTLE)

		table.insert(arg0_53.worldBossCards, var0_53)
	else
		local var3_53 = arg0_53.poolBubble.public

		if #var3_53 > 0 then
			var0_53 = var3_53[1]

			setActive(var0_53.tf, true)
			table.remove(var3_53, 1)
		else
			local var4_53 = cloneTplTo(arg0_53.prefabPublic, arg0_53.content)

			var0_53 = ChatBubblePublic.New(var4_53)
		end

		table.insert(arg0_53.bubbleCards, var0_53)
	end

	var0_53.tf:SetSiblingIndex(arg2_53)
	var0_53:update(arg1_53)
end

function var0_0.appendTopPublic(arg0_54, arg1_54)
	local var0_54 = 120 - (pg.TimeMgr.GetInstance():GetServerTime() - arg1_54.timestamp)

	if var0_54 <= 0 then
		return
	end

	SetActive(arg0_54.topMsg, true)
	ChatProxy.InjectPublic(findTF(arg0_54.topPublic, "text"):GetComponent("RichText"), arg1_54)

	findTF(arg0_54.topPublic, "channel"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("channel", ChatConst.GetChannelSprite(arg1_54.type) .. "_1920")

	if arg0_54._topTimer then
		arg0_54._topTimer:Stop()

		arg0_54._topTimer = nil
	end

	arg0_54._topTimer = Timer.New(function()
		SetActive(arg0_54.topMsg, false)

		arg0_54._topTimer = nil
	end, var0_54, 1)

	arg0_54._topTimer:Start()
end

function var0_0.showEnterRommTip(arg0_56)
	if arg0_56.player.chatRoomId == 0 then
		return
	end

	if not LeanTween.isTweening(go(arg0_56.enterRoomTip)) then
		LeanTween.value(go(arg0_56.enterRoomTip), 1, 0, 2):setOnUpdate(System.Action_float(function(arg0_57)
			arg0_56.enterRoomCG.alpha = arg0_57
		end)):setEase(LeanTweenType.easeInSine):setOnComplete(System.Action(function()
			arg0_56.enterRoomCG.alpha = 0

			LeanTween.cancel(go(arg0_56.enterRoomTip))
		end)):setDelay(0.5)
	end
end

function var0_0.getPos(arg0_59, arg1_59)
	return
end

function var0_0.displayEmojiPanel(arg0_60)
	local var0_60 = arg0_60.emoji.position

	arg0_60:emit(NotificationMediator.OPEN_EMOJI, function(arg0_61)
		arg0_60:emit(NotificationMediator.ON_SEND_PUBLIC, var0_0.ChannelBits.send, string.gsub(ChatConst.EmojiCode, "code", arg0_61))
	end, Vector3(var0_60.x, var0_60.y, 0))
end

function var0_0.willExit(arg0_62)
	if arg0_62.currentForm == var0_0.FORM_BATTLE then
		if isActive(arg0_62.changeRoomPanel) then
			arg0_62:closeChangeRoomPanel()
		end
	else
		arg0_62:UnblurPanel()
	end

	LeanTween.cancel(arg0_62._go)
	LeanTween.cancel(go(arg0_62.enterRoomTip))

	if arg0_62._topTimer then
		arg0_62._topTimer:Stop()

		arg0_62._topTimer = nil
	end

	for iter0_62, iter1_62 in ipairs(arg0_62.bubbleCards or {}) do
		iter1_62:dispose()
	end

	for iter2_62, iter3_62 in ipairs(arg0_62.worldBossCards or {}) do
		iter3_62:dispose()
	end

	arg0_62.worldBossCards = nil

	for iter4_62, iter5_62 in pairs(arg0_62.poolBubble) do
		for iter6_62, iter7_62 in ipairs(iter5_62) do
			iter7_62:dispose()
		end
	end

	arg0_62:removeLateUpdateListener()
	getProxy(GuildProxy):ClearNewChatMsgCnt()
end

function var0_0.insertEmojiToInputText(arg0_63, arg1_63)
	arg0_63.input.text = arg0_63.input.text .. string.gsub(ChatConst.EmojiIconCode, "code", arg1_63)
end

function var0_0.addLateUpdateListener(arg0_64)
	return
end

function var0_0.removeLateUpdateListener(arg0_65)
	return
end

return var0_0
