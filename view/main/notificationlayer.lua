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

function var0_0.setPlayer(arg0_2, arg1_2)
	arg0_2.player = arg1_2
end

function var0_0.setInGuild(arg0_3, arg1_3)
	arg0_3.inGuild = arg1_3
end

function var0_0.setMessages(arg0_4, arg1_4)
	arg0_4.messages = arg1_4
end

function var0_0.init(arg0_5)
	arg0_5.close = arg0_5:findTF("close")
	arg0_5.frame = arg0_5:findTF("frame")
	arg0_5.contain = arg0_5.frame:Find("contain")

	local var0_5 = arg0_5.contain:Find("ListContainer/list")

	arg0_5.content = var0_5:Find("content")
	arg0_5.emptySign = var0_5:Find("EmptySign")

	setActive(arg0_5.emptySign, false)

	arg0_5.prefabSelf = var0_5:Find("popo_self").gameObject
	arg0_5.prefabOthers = var0_5:Find("popo_other").gameObject
	arg0_5.prefabPublic = var0_5:Find("popo_public").gameObject
	arg0_5.prefabWorldBoss = var0_5:Find("popo_worldboss").gameObject
	arg0_5.prefabWorldBossArchives = var0_5:Find("popo_worldboss_archives").gameObject
	arg0_5.input = arg0_5.frame:Find("contain/ListContainer/inputbg/input"):GetComponent("InputField")

	setText(arg0_5.frame:Find("contain/ListContainer/inputbg/input/Placeholder"), i18n("notice_input_desc"))

	arg0_5.send = arg0_5.frame:Find("send")
	arg0_5.channelSend = arg0_5.frame:Find("channel_send")
	arg0_5.channelSendPop = arg0_5.frame:Find("channel_pop")
	arg0_5.scroll = var0_5:GetComponent("ScrollRect")
	arg0_5.topMsg = arg0_5.contain:Find("topmsg")

	SetActive(arg0_5.topMsg, false)

	arg0_5.topPublic = arg0_5:findTF("popo_public", arg0_5.topMsg)
	arg0_5.emoji = arg0_5.frame:Find("contain/ListContainer/inputbg/emoji")
	arg0_5.changeRoomPanel = arg0_5:findTF("change_room_Panel")
	arg0_5.roomSendBtns = arg0_5:findTF("frame/bg/type_send", arg0_5.changeRoomPanel)
	arg0_5.roomRecvBtns = arg0_5:findTF("frame/bg/type_recv", arg0_5.changeRoomPanel)
	arg0_5.enterRoomTip = arg0_5.frame:Find("enter_room_tip")
	arg0_5.enterRoomCG = arg0_5.enterRoomTip:GetComponent(typeof(CanvasGroup))
	arg0_5.roomBtn = arg0_5.contain:Find("top/room")
	arg0_5.typeBtns = arg0_5.contain:Find("top/type")
	arg0_5.inputTF = arg0_5:findTF("frame/bg/InputField", arg0_5.changeRoomPanel):GetComponent(typeof(InputField))
	arg0_5.switchTpl = arg0_5:findTF("switch_tpl", arg0_5.changeRoomPanel)
	arg0_5.switchNormalSprite = arg0_5:findTF("switch_normal", arg0_5.changeRoomPanel):GetComponent(typeof(Image)).sprite
	arg0_5.switchSelectedSprite = arg0_5:findTF("switch_selected", arg0_5.changeRoomPanel):GetComponent(typeof(Image)).sprite

	setText(findTF(arg0_5.changeRoomPanel, "frame/bg/label_send"), i18n("notice_label_send"))
	setText(findTF(arg0_5.changeRoomPanel, "frame/bg/label_recv"), i18n("notice_label_recv"))
	setText(findTF(arg0_5.changeRoomPanel, "frame/bg/label_room"), i18n("notice_label_room"))
	setText(findTF(arg0_5.changeRoomPanel, "frame/bg/label_tip"), i18n("notice_label_tip"))
	setText(findTF(arg0_5.changeRoomPanel, "frame/bg/InputField/Placeholder"), i18n("please_input_1_99"))
	setText(findTF(arg0_5.changeRoomPanel, "frame/cancel/Image"), i18n("word_cancel"))
	setText(findTF(arg0_5.changeRoomPanel, "frame/confirm/Image"), i18n("word_ok"))

	arg0_5.resource = arg0_5:findTF("resource")
	arg0_5.typeTpl = arg0_5:findTF("type_tpl", arg0_5.resource)
	arg0_5.normalSprite = arg0_5:findTF("normal", arg0_5.resource):GetComponent(typeof(Image)).sprite
	arg0_5.selectedSprite = arg0_5:findTF("selected", arg0_5.resource):GetComponent(typeof(Image)).sprite
	arg0_5.bottomChannelTpl = arg0_5:findTF("channel_tpl", arg0_5.resource)
	arg0_5.bottomChannelNormalSprite = arg0_5:findTF("channel_normal", arg0_5.resource):GetComponent(typeof(Image)).sprite
	arg0_5.bottomChannelSelectedSprite = arg0_5:findTF("channel_selected", arg0_5.resource):GetComponent(typeof(Image)).sprite

	local var1_5 = {
		ChatConst.ChannelAll,
		ChatConst.ChannelWorld,
		ChatConst.ChannelPublic,
		ChatConst.ChannelFriend,
		ChatConst.ChannelGuild,
		ChatConst.ChannelWorldBoss
	}

	arg0_5.textSprites = {}
	arg0_5.textSelectedSprites = {}
	arg0_5.bottomChannelTextSprites = {}
	arg0_5.switchTextSprites = {}

	for iter0_5, iter1_5 in pairs(var1_5) do
		local var2_5 = ChatConst.GetChannelSprite(iter0_5)

		arg0_5.textSprites[iter0_5] = arg0_5:findTF("text_" .. var2_5, arg0_5.resource):GetComponent(typeof(Image)).sprite
		arg0_5.textSelectedSprites[iter0_5] = arg0_5:findTF("text_" .. var2_5 .. "_selected", arg0_5.resource):GetComponent(typeof(Image)).sprite
		arg0_5.switchTextSprites[iter0_5] = arg0_5:findTF("text_" .. var2_5 .. "_switch", arg0_5.changeRoomPanel):GetComponent(typeof(Image)).sprite

		if table.contains(ChatConst.SendChannels, iter0_5) then
			arg0_5.bottomChannelTextSprites[iter0_5] = arg0_5:findTF("channel_" .. var2_5, arg0_5.resource):GetComponent(typeof(Image)).sprite
		end
	end

	arg0_5.prefabSelf:SetActive(false)
	arg0_5.prefabOthers:SetActive(false)
	arg0_5.prefabPublic:SetActive(false)

	arg0_5.bubbleCards = {}
	arg0_5.worldBossCards = {}
	arg0_5.poolBubble = {
		self = {},
		public = {},
		others = {}
	}
	var0_0.ChannelBits.recv = getProxy(SettingsProxy):GetChatFlag()
end

function var0_0.adjustMsgListPanel(arg0_6)
	arg0_6.listContainerTF = arg0_6.contain:Find("ListContainer")
	arg0_6.listTF = arg0_6.contain:Find("ListContainer/list")

	local var0_6 = arg0_6.listContainerTF.rect.size.y
	local var1_6 = 69.01791

	GetComponent(arg0_6.listTF, "LayoutElement").preferredHeight = var0_6 - var1_6
end

function var0_0.didEnter(arg0_7)
	arg0_7:adjustMsgListPanel()

	arg0_7.currentForm = arg0_7.contextData.form
	arg0_7.escFlag = false

	onButton(arg0_7, arg0_7.close, function()
		if arg0_7.isExitPlay then
			return
		end

		arg0_7.isExitPlay = true

		arg0_7:PlayUIAnimation(arg0_7._tf, "exit", function()
			if arg0_7.currentForm == var0_0.FORM_BATTLE then
				arg0_7:emit(NotificationMediator.BATTLE_CHAT_CLOSE)
			end

			arg0_7:closeView()
		end)
	end, SFX_CANCEL)
	onButton(arg0_7, arg0_7.emoji, function()
		arg0_7:displayEmojiPanel()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.send, function()
		local var0_11 = arg0_7.input.text

		if var0_11 == "" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("main_notificationLayer_sendButton"))

			return
		end

		arg0_7.input.text = ""

		arg0_7:emit(NotificationMediator.ON_SEND_PUBLIC, var0_0.ChannelBits.send, var0_11)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.roomBtn, function()
		arg0_7:showChangeRoomPanel()
	end, SFX_PANEL)
	onButton(arg0_7, findTF(arg0_7.changeRoomPanel, "frame/cancel"), function()
		arg0_7:closeChangeRoomPanel()
	end, SFX_CANCEL)
	onButton(arg0_7, findTF(arg0_7.changeRoomPanel, "frame/confirm"), function()
		arg0_7:emit(NotificationMediator.CHANGE_ROOM, tonumber(arg0_7.inputTF.text))
	end, SFX_CANCEL)
	onButton(arg0_7, arg0_7.channelSend, function()
		setActive(arg0_7.channelSendPop, not isActive(arg0_7.channelSendPop))

		if isActive(arg0_7.channelSendPop) then
			arg0_7:updateChannelSendPop()
		end
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7._tf, function()
		if isActive(arg0_7.channelSendPop) then
			setActive(arg0_7.channelSendPop, false)
		end
	end)
	pg.DelegateInfo.Add(arg0_7, arg0_7.scroll.onValueChanged)
	arg0_7.scroll.onValueChanged:AddListener(function(arg0_17)
		if arg0_7.index > 1 and arg0_17.y >= 1 then
			local var0_17 = arg0_7.content.sizeDelta.y * arg0_17.y
			local var1_17 = arg0_7.scroll.velocity
			local var2_17 = math.max(1, arg0_7.index - var0_0.InitCount)

			for iter0_17 = arg0_7.index - 1, var2_17, -1 do
				arg0_7:append(arg0_7.filteredMessages[iter0_17], 0)
			end

			Canvas.ForceUpdateCanvases()

			arg0_7.scroll.normalizedPosition = Vector2(0, var0_17 / arg0_7.content.sizeDelta.y)

			arg0_7.scroll.onValueChanged:Invoke(arg0_7.scroll.normalizedPosition)

			arg0_7.scroll.velocity = var1_17
			arg0_7.index = var2_17
		end
	end)
	arg0_7:updateRoom()
	arg0_7:updateChatChannel()
	arg0_7:initFilter()
	arg0_7:updateFilter()
	arg0_7:updateAll()

	if arg0_7.currentForm == var0_0.FORM_BATTLE then
		arg0_7._tf:SetParent(arg0_7.contextData.chatViewParent, true)

		rtf(arg0_7.frame.transform).offsetMax = Vector2(0, -120)
	else
		arg0_7:BlurPanel()
	end

	LeanTween.delayedCall(go(arg0_7._tf), 0.2, System.Action(function()
		scrollToBottom(arg0_7.content.parent)
	end))

	rtf(arg0_7._tf).offsetMax = Vector2(0, 0)
	rtf(arg0_7._tf).offsetMin = Vector2(0, 0)
end

function var0_0.BlurPanel(arg0_19)
	var0_0.super.BlurPanel(arg0_19, arg0_19._tf)
end

function var0_0.UnblurPanel(arg0_20)
	arg0_20:UnOverlayPanel(arg0_20._tf)
end

function var0_0.onBackPressed(arg0_21)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if isActive(arg0_21.changeRoomPanel) then
		arg0_21:closeChangeRoomPanel()
	else
		triggerButton(arg0_21.close)
	end
end

function var0_0.initFilter(arg0_22)
	local var0_22 = ChatConst.RecvChannels

	arg0_22.recvTypes = UIItemList.New(arg0_22.typeBtns, arg0_22.typeTpl)

	arg0_22.recvTypes:make(function(arg0_23, arg1_23, arg2_23)
		if arg0_23 == UIItemList.EventUpdate then
			local var0_23 = var0_22[arg1_23 + 1]

			setImageSprite(arg2_23:Find("text"), arg0_22.textSprites[var0_23], true)
			setImageSprite(arg2_23:Find("text_selected"), arg0_22.textSelectedSprites[var0_23], true)
			onButton(arg0_22, arg2_23, function()
				local var0_24 = _.filter(var0_22, function(arg0_25)
					return arg0_25 ~= ChatConst.ChannelGuild or arg0_22.inGuild
				end)
				local var1_24 = IndexConst.ToggleBits(var0_0.ChannelBits.recv, var0_24, ChatConst.ChannelAll, var0_23)

				if var0_0.ChannelBits.recv == var1_24 then
					return
				end

				var0_0.ChannelBits.recv = var1_24

				arg0_22:updateFilter()
				arg0_22:updateAll()
				getProxy(SettingsProxy):SetChatFlag(var0_0.ChannelBits.recv)
			end, SFX_UI_TAG)
		end
	end)
	arg0_22.recvTypes:align(#var0_22)
end

function var0_0.updateFilter(arg0_26)
	local var0_26 = ChatConst.RecvChannels

	arg0_26.recvTypes:each(function(arg0_27, arg1_27)
		local var0_27 = var0_26[arg0_27 + 1]

		if var0_27 == ChatConst.ChannelGuild and not arg0_26.inGuild then
			setButtonEnabled(arg1_27, false)
		end

		if bit.band(var0_0.ChannelBits.recv, bit.lshift(1, var0_27)) > 0 then
			setImageSprite(arg1_27, arg0_26.selectedSprite)
			setActive(arg1_27:Find("text_selected"), true)
		else
			setImageSprite(arg1_27, arg0_26.normalSprite)
			setActive(arg1_27:Find("text_selected"), false)
		end
	end)

	local var1_26 = var0_0.ChannelBits.recv
	local var2_26 = bit.lshift(1, ChatConst.ChannelAll)

	arg0_26.filteredMessages = _.filter(arg0_26.messages, function(arg0_28)
		return var1_26 == var2_26 or bit.band(var1_26, bit.lshift(1, arg0_28.type)) > 0
	end)
	arg0_26.filteredMessages = _.slice(arg0_26.filteredMessages, #arg0_26.filteredMessages - var0_0.MaxCount + 1, var0_0.MaxCount)
end

function var0_0.updateChatChannel(arg0_29)
	setImageSprite(arg0_29.channelSend:Find("Text"), arg0_29.bottomChannelTextSprites[var0_0.ChannelBits.send], true)
end

function var0_0.updateChannelSendPop(arg0_30)
	local var0_30 = ChatConst.SendChannels
	local var1_30 = UIItemList.New(arg0_30.channelSendPop:Find("type_send"), arg0_30.bottomChannelTpl)

	local function var2_30()
		var1_30:each(function(arg0_32, arg1_32)
			local var0_32 = var0_30[arg0_32 + 1]

			if var0_32 == ChatConst.ChannelGuild and not arg0_30.inGuild then
				setButtonEnabled(arg1_32, false)
			end

			local var1_32 = var0_0.ChannelBits.send == var0_32

			if var1_32 then
				setImageSprite(arg1_32:Find("bottom"), arg0_30.bottomChannelSelectedSprite, true)
			else
				setImageSprite(arg1_32:Find("bottom"), arg0_30.bottomChannelNormalSprite, true)
			end

			setActive(arg1_32:Find("selected"), var1_32)
			setActive(arg1_32:Find("text"), not var1_32)
		end)
	end

	var1_30:make(function(arg0_33, arg1_33, arg2_33)
		if arg0_33 == UIItemList.EventUpdate then
			local var0_33 = var0_30[arg1_33 + 1]

			setImageSprite(arg2_33:Find("text"), arg0_30.bottomChannelTextSprites[var0_33], true)
			setImageSprite(arg2_33:Find("selected"), arg0_30.bottomChannelTextSprites[var0_33], true)
			onButton(arg0_30, arg2_33, function()
				setActive(arg0_30.channelSendPop, false)

				var0_0.ChannelBits.send = var0_33

				var2_30()
				arg0_30:updateChatChannel()
			end, SFX_UI_TAG)
		end
	end)
	var1_30:align(#var0_30)
	var2_30()
end

function var0_0.updateRoom(arg0_35)
	setText(arg0_35.enterRoomTip:Find("text"), i18n("main_notificationLayer_enter_room", arg0_35.player.chatRoomId == 0 and "" or arg0_35.player.chatRoomId))
	setText(arg0_35:findTF("Text", arg0_35.roomBtn), arg0_35.player.chatRoomId == 0 and i18n("common_not_enter_room") or arg0_35.player.chatRoomId)
	arg0_35:showEnterRommTip()
end

function var0_0.showChangeRoomPanel(arg0_36)
	arg0_36:UnblurPanel()
	pg.UIMgr.GetInstance():BlurPanel(arg0_36.changeRoomPanel)

	arg0_36.inputTF.text = tostring(arg0_36.player.chatRoomId)
	arg0_36.tempRoomSendBits = var0_0.ChannelBits.send

	local var0_36 = ChatConst.SendChannels
	local var1_36 = UIItemList.New(arg0_36.roomSendBtns, arg0_36.switchTpl)

	local function var2_36()
		var1_36:each(function(arg0_38, arg1_38)
			local var0_38 = var0_36[arg0_38 + 1]

			if var0_38 == ChatConst.ChannelGuild and not arg0_36.inGuild then
				setButtonEnabled(arg1_38, false)
			end

			if arg0_36.tempRoomSendBits == var0_38 then
				setImageSprite(arg1_38, arg0_36.switchSelectedSprite)
			else
				setImageSprite(arg1_38, arg0_36.switchNormalSprite)
			end
		end)
	end

	var1_36:make(function(arg0_39, arg1_39, arg2_39)
		if arg0_39 == UIItemList.EventUpdate then
			local var0_39 = var0_36[arg1_39 + 1]

			setImageSprite(arg2_39:Find("text"), arg0_36.switchTextSprites[var0_39], true)
			onButton(arg0_36, arg2_39, function()
				arg0_36.tempRoomSendBits = var0_39

				var2_36()
			end, SFX_UI_TAG)
		end
	end)
	var1_36:align(#var0_36)
	var2_36()

	arg0_36.tempRoomRecvBits = var0_0.ChannelBits.recv

	local var3_36 = ChatConst.RecvChannels
	local var4_36 = UIItemList.New(arg0_36.roomRecvBtns, arg0_36.switchTpl)

	local function var5_36()
		var4_36:each(function(arg0_42, arg1_42)
			local var0_42 = var3_36[arg0_42 + 1]

			if var0_42 == ChatConst.ChannelGuild and not arg0_36.inGuild then
				setButtonEnabled(arg1_42, false)
			end

			if bit.band(arg0_36.tempRoomRecvBits, bit.lshift(1, var0_42)) > 0 then
				setImageSprite(arg1_42, arg0_36.switchSelectedSprite)
			else
				setImageSprite(arg1_42, arg0_36.switchNormalSprite)
			end
		end)
	end

	var4_36:make(function(arg0_43, arg1_43, arg2_43)
		if arg0_43 == UIItemList.EventUpdate then
			local var0_43 = var3_36[arg1_43 + 1]

			setImageSprite(arg2_43:Find("text"), arg0_36.switchTextSprites[var0_43], true)
			onButton(arg0_36, arg2_43, function()
				local var0_44 = _.filter(var3_36, function(arg0_45)
					return arg0_45 ~= ChatConst.ChannelGuild or arg0_36.inGuild
				end)

				arg0_36.tempRoomRecvBits = IndexConst.ToggleBits(arg0_36.tempRoomRecvBits, var0_44, ChatConst.ChannelAll, var0_43)

				var5_36()
			end, SFX_UI_TAG)
		end
	end)
	var4_36:align(#var3_36)
	var5_36()
	setActive(arg0_36.changeRoomPanel, true)
end

function var0_0.closeChangeRoomPanel(arg0_46)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_46.changeRoomPanel, arg0_46._tf)

	if arg0_46.currentForm == var0_0.FORM_BATTLE then
		arg0_46._tf:SetParent(arg0_46.contextData.chatViewParent, true)

		rtf(arg0_46.frame.transform).offsetMax = Vector2(0, -120)
	else
		arg0_46:BlurPanel()
	end

	setActive(arg0_46.changeRoomPanel, false)
end

function var0_0.removeAllBubble(arg0_47)
	for iter0_47, iter1_47 in ipairs(arg0_47.bubbleCards or {}) do
		setActive(iter1_47.tf, false)

		local var0_47 = arg0_47.poolBubble.others

		if iter1_47.__cname == "ChatBubblePublic" then
			var0_47 = arg0_47.poolBubble.public
		elseif iter1_47.__cname == "ChatBubble" and iter1_47.data.player and iter1_47.data.player.id == arg0_47.player.id then
			var0_47 = arg0_47.poolBubble.self
		end

		iter1_47:dispose()
		table.insert(var0_47, iter1_47)
	end

	arg0_47.bubbleCards = {}

	for iter2_47, iter3_47 in pairs(arg0_47.worldBossCards) do
		if not IsNil(iter3_47.tf) then
			Destroy(iter3_47.tf)
		end
	end

	arg0_47.worldBossCards = {}
end

function var0_0.updateAll(arg0_48)
	arg0_48:removeAllBubble()

	arg0_48.index = math.max(1, #arg0_48.filteredMessages - var0_0.InitCount)

	for iter0_48 = arg0_48.index, #arg0_48.filteredMessages do
		arg0_48:append(arg0_48.filteredMessages[iter0_48], -1)
	end

	scrollToBottom(arg0_48.content.parent)
	setActive(arg0_48.emptySign, PLATFORM_CODE == PLATFORM_JP and #arg0_48.filteredMessages <= 0)
end

function var0_0.append(arg0_49, arg1_49, arg2_49, arg3_49)
	if #arg0_49.filteredMessages >= var0_0.MaxCount * 2 then
		arg0_49:updateFilter()
		arg0_49:updateAll()
	else
		arg3_49 = arg3_49 and arg0_49.scroll.normalizedPosition.y < 0.1

		if arg1_49.type == ChatConst.ChannelPublic then
			if arg1_49.id == 0 then
				arg0_49:appendTopPublic(arg1_49)
			else
				arg0_49:appendPublic(arg1_49, arg2_49)
			end
		elseif arg1_49:IsWorldBossNotify() then
			arg0_49:appendPublic(arg1_49, arg2_49)
		else
			arg0_49:appendOthers(arg1_49, arg2_49)
		end

		if arg3_49 then
			scrollToBottom(arg0_49.content.parent)
		end
	end

	setActive(arg0_49.emptySign, PLATFORM_CODE == PLATFORM_JP and #arg0_49.filteredMessages <= 0)
end

function var0_0.appendOthers(arg0_50, arg1_50, arg2_50)
	local var0_50 = arg1_50.player
	local var1_50 = arg0_50.poolBubble.others
	local var2_50 = arg0_50.prefabOthers

	if var0_50.id == arg0_50.player.id then
		var1_50 = arg0_50.poolBubble.self
		var2_50 = arg0_50.prefabSelf
		arg1_50.isSelf = true
		arg1_50.player = setmetatable(Clone(arg0_50.player), {
			__index = arg1_50.player.__index
		})
	end

	local var3_50

	if #var1_50 > 0 then
		var3_50 = var1_50[1]

		setActive(var3_50.tf, true)
		table.remove(var1_50, 1)
	else
		local var4_50 = cloneTplTo(var2_50, arg0_50.content)

		var3_50 = ChatBubble.New(var4_50)
	end

	var3_50.tf:SetSiblingIndex(arg2_50)
	table.insert(arg0_50.bubbleCards, var3_50)
	var3_50:update(arg1_50)
	removeOnButton(var3_50.headTF)
	onButton(arg0_50, var3_50.headTF, function()
		local var0_51 = arg0_50:findTF("shipicon/icon", var3_50.tf).position

		arg0_50:emit(NotificationMediator.OPEN_INFO, var0_50, var0_51, arg1_50.content)
	end, SFX_PANEL)
end

function var0_0.appendPublic(arg0_52, arg1_52, arg2_52)
	local var0_52

	if arg1_52.id == 4 then
		local var1_52 = WorldBossConst.__IsCurrBoss(arg1_52.args.wordBossConfigId) and arg0_52.prefabWorldBoss or arg0_52.prefabWorldBossArchives
		local var2_52 = cloneTplTo(var1_52, arg0_52.content)

		var0_52 = ChatBubbleWorldBoss.New(var2_52, arg0_52.currentForm ~= var0_0.FORM_BATTLE)

		table.insert(arg0_52.worldBossCards, var0_52)
	else
		local var3_52 = arg0_52.poolBubble.public

		if #var3_52 > 0 then
			var0_52 = var3_52[1]

			setActive(var0_52.tf, true)
			table.remove(var3_52, 1)
		else
			local var4_52 = cloneTplTo(arg0_52.prefabPublic, arg0_52.content)

			var0_52 = ChatBubblePublic.New(var4_52)
		end

		table.insert(arg0_52.bubbleCards, var0_52)
	end

	var0_52.tf:SetSiblingIndex(arg2_52)
	var0_52:update(arg1_52)
end

function var0_0.appendTopPublic(arg0_53, arg1_53)
	local var0_53 = 120 - (pg.TimeMgr.GetInstance():GetServerTime() - arg1_53.timestamp)

	if var0_53 <= 0 then
		return
	end

	SetActive(arg0_53.topMsg, true)
	ChatProxy.InjectPublic(findTF(arg0_53.topPublic, "text"):GetComponent("RichText"), arg1_53)

	findTF(arg0_53.topPublic, "channel"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("channel", ChatConst.GetChannelSprite(arg1_53.type) .. "_1920")

	if arg0_53._topTimer then
		arg0_53._topTimer:Stop()

		arg0_53._topTimer = nil
	end

	arg0_53._topTimer = Timer.New(function()
		SetActive(arg0_53.topMsg, false)

		arg0_53._topTimer = nil
	end, var0_53, 1)

	arg0_53._topTimer:Start()
end

function var0_0.showEnterRommTip(arg0_55)
	if arg0_55.player.chatRoomId == 0 then
		return
	end

	if not LeanTween.isTweening(go(arg0_55.enterRoomTip)) then
		LeanTween.value(go(arg0_55.enterRoomTip), 1, 0, 2):setOnUpdate(System.Action_float(function(arg0_56)
			arg0_55.enterRoomCG.alpha = arg0_56
		end)):setEase(LeanTweenType.easeInSine):setOnComplete(System.Action(function()
			arg0_55.enterRoomCG.alpha = 0

			LeanTween.cancel(go(arg0_55.enterRoomTip))
		end)):setDelay(0.5)
	end
end

function var0_0.getPos(arg0_58, arg1_58)
	return
end

function var0_0.displayEmojiPanel(arg0_59)
	local var0_59 = arg0_59.emoji.position

	arg0_59:emit(NotificationMediator.OPEN_EMOJI, function(arg0_60)
		arg0_59:emit(NotificationMediator.ON_SEND_PUBLIC, var0_0.ChannelBits.send, string.gsub(ChatConst.EmojiCode, "code", arg0_60))
	end, Vector3(var0_59.x, var0_59.y, 0))
end

function var0_0.willExit(arg0_61)
	if arg0_61.currentForm == var0_0.FORM_BATTLE then
		if isActive(arg0_61.changeRoomPanel) then
			arg0_61:closeChangeRoomPanel()
		end
	else
		arg0_61:UnblurPanel()
	end

	LeanTween.cancel(arg0_61._go)
	LeanTween.cancel(go(arg0_61.enterRoomTip))

	if arg0_61._topTimer then
		arg0_61._topTimer:Stop()

		arg0_61._topTimer = nil
	end

	for iter0_61, iter1_61 in ipairs(arg0_61.bubbleCards or {}) do
		iter1_61:dispose()
	end

	for iter2_61, iter3_61 in ipairs(arg0_61.worldBossCards or {}) do
		iter3_61:dispose()
	end

	arg0_61.worldBossCards = nil

	for iter4_61, iter5_61 in pairs(arg0_61.poolBubble) do
		for iter6_61, iter7_61 in ipairs(iter5_61) do
			iter7_61:dispose()
		end
	end

	arg0_61:removeLateUpdateListener()
	getProxy(GuildProxy):ClearNewChatMsgCnt()
end

function var0_0.insertEmojiToInputText(arg0_62, arg1_62)
	arg0_62.input.text = arg0_62.input.text .. string.gsub(ChatConst.EmojiIconCode, "code", arg1_62)
end

function var0_0.addLateUpdateListener(arg0_63)
	return
end

function var0_0.removeLateUpdateListener(arg0_64)
	return
end

return var0_0
