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
	arg0_5.close = arg0_5._tf:Find("close")
	arg0_5.frame = arg0_5._tf:Find("adapt/frame")
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

	arg0_5.topPublic = arg0_5.topMsg:Find("popo_public")
	arg0_5.emoji = arg0_5.frame:Find("contain/ListContainer/inputbg/emoji")
	arg0_5.changeRoomPanel = arg0_5._tf:Find("change_room_Panel")
	arg0_5.roomSendBtns = arg0_5.changeRoomPanel:Find("frame/bg/type_send")
	arg0_5.roomRecvBtns = arg0_5.changeRoomPanel:Find("frame/bg/type_recv")
	arg0_5.enterRoomTip = arg0_5.frame:Find("enter_room_tip")
	arg0_5.enterRoomCG = arg0_5.enterRoomTip:GetComponent(typeof(CanvasGroup))
	arg0_5.roomBtn = arg0_5.contain:Find("top/room")
	arg0_5.typeBtns = arg0_5.contain:Find("top/type")
	arg0_5.inputTF = arg0_5.changeRoomPanel:Find("frame/bg/InputField"):GetComponent(typeof(InputField))
	arg0_5.switchTpl = arg0_5.changeRoomPanel:Find("switch_tpl")
	arg0_5.switchNormalSprite = arg0_5.changeRoomPanel:Find("switch_normal"):GetComponent(typeof(Image)).sprite
	arg0_5.switchSelectedSprite = arg0_5.changeRoomPanel:Find("switch_selected"):GetComponent(typeof(Image)).sprite

	setText(findTF(arg0_5.changeRoomPanel, "frame/bg/label_send"), i18n("notice_label_send"))
	setText(findTF(arg0_5.changeRoomPanel, "frame/bg/label_recv"), i18n("notice_label_recv"))
	setText(findTF(arg0_5.changeRoomPanel, "frame/bg/label_room"), i18n("notice_label_room"))
	setText(findTF(arg0_5.changeRoomPanel, "frame/bg/label_tip"), i18n("notice_label_tip"))
	setText(findTF(arg0_5.changeRoomPanel, "frame/bg/InputField/Placeholder"), i18n("please_input_1_99"))
	setText(findTF(arg0_5.changeRoomPanel, "frame/cancel/Image"), i18n("word_cancel"))
	setText(findTF(arg0_5.changeRoomPanel, "frame/confirm/Image"), i18n("word_ok"))

	arg0_5.resource = arg0_5._tf:Find("resource")
	arg0_5.typeTpl = arg0_5.resource:Find("type_tpl")
	arg0_5.normalSprite = arg0_5.resource:Find("normal"):GetComponent(typeof(Image)).sprite
	arg0_5.selectedSprite = arg0_5.resource:Find("selected"):GetComponent(typeof(Image)).sprite
	arg0_5.bottomChannelTpl = arg0_5.resource:Find("channel_tpl")
	arg0_5.bottomChannelNormalSprite = arg0_5.resource:Find("channel_normal"):GetComponent(typeof(Image)).sprite
	arg0_5.bottomChannelSelectedSprite = arg0_5.resource:Find("channel_selected"):GetComponent(typeof(Image)).sprite

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

		arg0_5.textSprites[iter0_5] = arg0_5.resource:Find("text_" .. var2_5):GetComponent(typeof(Image)).sprite
		arg0_5.textSelectedSprites[iter0_5] = arg0_5.resource:Find("text_" .. var2_5 .. "_selected"):GetComponent(typeof(Image)).sprite
		arg0_5.switchTextSprites[iter0_5] = arg0_5.changeRoomPanel:Find("text_" .. var2_5 .. "_switch"):GetComponent(typeof(Image)).sprite

		if table.contains(ChatConst.SendChannels, iter0_5) then
			arg0_5.bottomChannelTextSprites[iter0_5] = arg0_5.resource:Find("channel_" .. var2_5):GetComponent(typeof(Image)).sprite
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

	arg0_5:BlurPanel(arg0_5._tf)
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
	LeanTween.delayedCall(go(arg0_7._tf), 0.2, System.Action(function()
		scrollToBottom(arg0_7.content.parent)
	end))

	rtf(arg0_7._tf).offsetMax = Vector2(0, 0)
	rtf(arg0_7._tf).offsetMin = Vector2(0, 0)
end

function var0_0.onBackPressed(arg0_19)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if isActive(arg0_19.changeRoomPanel) then
		arg0_19:closeChangeRoomPanel()
	else
		triggerButton(arg0_19.close)
	end
end

function var0_0.initFilter(arg0_20)
	local var0_20 = ChatConst.RecvChannels

	arg0_20.recvTypes = UIItemList.New(arg0_20.typeBtns, arg0_20.typeTpl)

	arg0_20.recvTypes:make(function(arg0_21, arg1_21, arg2_21)
		if arg0_21 == UIItemList.EventUpdate then
			local var0_21 = var0_20[arg1_21 + 1]

			setImageSprite(arg2_21:Find("text"), arg0_20.textSprites[var0_21], true)
			setImageSprite(arg2_21:Find("text_selected"), arg0_20.textSelectedSprites[var0_21], true)
			onButton(arg0_20, arg2_21, function()
				local var0_22 = _.filter(var0_20, function(arg0_23)
					return arg0_23 ~= ChatConst.ChannelGuild or arg0_20.inGuild
				end)
				local var1_22 = IndexConst.ToggleBits(var0_0.ChannelBits.recv, var0_22, ChatConst.ChannelAll, var0_21)

				if var0_0.ChannelBits.recv == var1_22 then
					return
				end

				var0_0.ChannelBits.recv = var1_22

				arg0_20:updateFilter()
				arg0_20:updateAll()
				getProxy(SettingsProxy):SetChatFlag(var0_0.ChannelBits.recv)
			end, SFX_UI_TAG)
		end
	end)
	arg0_20.recvTypes:align(#var0_20)
end

function var0_0.updateFilter(arg0_24)
	local var0_24 = ChatConst.RecvChannels

	arg0_24.recvTypes:each(function(arg0_25, arg1_25)
		local var0_25 = var0_24[arg0_25 + 1]

		if var0_25 == ChatConst.ChannelGuild and not arg0_24.inGuild then
			setButtonEnabled(arg1_25, false)
		end

		if bit.band(var0_0.ChannelBits.recv, bit.lshift(1, var0_25)) > 0 then
			setImageSprite(arg1_25, arg0_24.selectedSprite)
			setActive(arg1_25:Find("text_selected"), true)
		else
			setImageSprite(arg1_25, arg0_24.normalSprite)
			setActive(arg1_25:Find("text_selected"), false)
		end
	end)

	local var1_24 = var0_0.ChannelBits.recv
	local var2_24 = bit.lshift(1, ChatConst.ChannelAll)

	arg0_24.filteredMessages = _.filter(arg0_24.messages, function(arg0_26)
		return var1_24 == var2_24 or bit.band(var1_24, bit.lshift(1, arg0_26.type)) > 0
	end)
	arg0_24.filteredMessages = _.slice(arg0_24.filteredMessages, #arg0_24.filteredMessages - var0_0.MaxCount + 1, var0_0.MaxCount)
end

function var0_0.updateChatChannel(arg0_27)
	setImageSprite(arg0_27.channelSend:Find("Text"), arg0_27.bottomChannelTextSprites[var0_0.ChannelBits.send], true)
end

function var0_0.updateChannelSendPop(arg0_28)
	local var0_28 = ChatConst.SendChannels
	local var1_28 = UIItemList.New(arg0_28.channelSendPop:Find("type_send"), arg0_28.bottomChannelTpl)

	local function var2_28()
		var1_28:each(function(arg0_30, arg1_30)
			local var0_30 = var0_28[arg0_30 + 1]

			if var0_30 == ChatConst.ChannelGuild and not arg0_28.inGuild then
				setButtonEnabled(arg1_30, false)
			end

			local var1_30 = var0_0.ChannelBits.send == var0_30

			if var1_30 then
				setImageSprite(arg1_30:Find("bottom"), arg0_28.bottomChannelSelectedSprite, true)
			else
				setImageSprite(arg1_30:Find("bottom"), arg0_28.bottomChannelNormalSprite, true)
			end

			setActive(arg1_30:Find("selected"), var1_30)
			setActive(arg1_30:Find("text"), not var1_30)
		end)
	end

	var1_28:make(function(arg0_31, arg1_31, arg2_31)
		if arg0_31 == UIItemList.EventUpdate then
			local var0_31 = var0_28[arg1_31 + 1]

			setImageSprite(arg2_31:Find("text"), arg0_28.bottomChannelTextSprites[var0_31], true)
			setImageSprite(arg2_31:Find("selected"), arg0_28.bottomChannelTextSprites[var0_31], true)
			onButton(arg0_28, arg2_31, function()
				setActive(arg0_28.channelSendPop, false)

				var0_0.ChannelBits.send = var0_31

				var2_28()
				arg0_28:updateChatChannel()
			end, SFX_UI_TAG)
		end
	end)
	var1_28:align(#var0_28)
	var2_28()
end

function var0_0.updateRoom(arg0_33)
	setText(arg0_33.enterRoomTip:Find("text"), i18n("main_notificationLayer_enter_room", arg0_33.player.chatRoomId == 0 and "" or arg0_33.player.chatRoomId))
	setText(arg0_33.roomBtn:Find("Text"), arg0_33.player.chatRoomId == 0 and i18n("common_not_enter_room") or arg0_33.player.chatRoomId)
	arg0_33:showEnterRommTip()
end

function var0_0.showChangeRoomPanel(arg0_34)
	pg.UIMgr.GetInstance():BlurPanel(arg0_34.changeRoomPanel)

	arg0_34.inputTF.text = tostring(arg0_34.player.chatRoomId)
	arg0_34.tempRoomSendBits = var0_0.ChannelBits.send

	local var0_34 = ChatConst.SendChannels
	local var1_34 = UIItemList.New(arg0_34.roomSendBtns, arg0_34.switchTpl)

	local function var2_34()
		var1_34:each(function(arg0_36, arg1_36)
			local var0_36 = var0_34[arg0_36 + 1]

			if var0_36 == ChatConst.ChannelGuild and not arg0_34.inGuild then
				setButtonEnabled(arg1_36, false)
			end

			if arg0_34.tempRoomSendBits == var0_36 then
				setImageSprite(arg1_36, arg0_34.switchSelectedSprite)
			else
				setImageSprite(arg1_36, arg0_34.switchNormalSprite)
			end
		end)
	end

	var1_34:make(function(arg0_37, arg1_37, arg2_37)
		if arg0_37 == UIItemList.EventUpdate then
			local var0_37 = var0_34[arg1_37 + 1]

			setImageSprite(arg2_37:Find("text"), arg0_34.switchTextSprites[var0_37], true)
			onButton(arg0_34, arg2_37, function()
				arg0_34.tempRoomSendBits = var0_37

				var2_34()
			end, SFX_UI_TAG)
		end
	end)
	var1_34:align(#var0_34)
	var2_34()

	arg0_34.tempRoomRecvBits = var0_0.ChannelBits.recv

	local var3_34 = ChatConst.RecvChannels
	local var4_34 = UIItemList.New(arg0_34.roomRecvBtns, arg0_34.switchTpl)

	local function var5_34()
		var4_34:each(function(arg0_40, arg1_40)
			local var0_40 = var3_34[arg0_40 + 1]

			if var0_40 == ChatConst.ChannelGuild and not arg0_34.inGuild then
				setButtonEnabled(arg1_40, false)
			end

			if bit.band(arg0_34.tempRoomRecvBits, bit.lshift(1, var0_40)) > 0 then
				setImageSprite(arg1_40, arg0_34.switchSelectedSprite)
			else
				setImageSprite(arg1_40, arg0_34.switchNormalSprite)
			end
		end)
	end

	var4_34:make(function(arg0_41, arg1_41, arg2_41)
		if arg0_41 == UIItemList.EventUpdate then
			local var0_41 = var3_34[arg1_41 + 1]

			setImageSprite(arg2_41:Find("text"), arg0_34.switchTextSprites[var0_41], true)
			onButton(arg0_34, arg2_41, function()
				local var0_42 = _.filter(var3_34, function(arg0_43)
					return arg0_43 ~= ChatConst.ChannelGuild or arg0_34.inGuild
				end)

				arg0_34.tempRoomRecvBits = IndexConst.ToggleBits(arg0_34.tempRoomRecvBits, var0_42, ChatConst.ChannelAll, var0_41)

				var5_34()
			end, SFX_UI_TAG)
		end
	end)
	var4_34:align(#var3_34)
	var5_34()
	setActive(arg0_34.changeRoomPanel, true)
end

function var0_0.closeChangeRoomPanel(arg0_44)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_44.changeRoomPanel, arg0_44._tf)
	setActive(arg0_44.changeRoomPanel, false)
end

function var0_0.removeAllBubble(arg0_45)
	for iter0_45, iter1_45 in ipairs(arg0_45.bubbleCards or {}) do
		setActive(iter1_45.tf, false)

		local var0_45 = arg0_45.poolBubble.others

		if iter1_45.__cname == "ChatBubblePublic" then
			var0_45 = arg0_45.poolBubble.public
		elseif iter1_45.__cname == "ChatBubble" and iter1_45.data.player and iter1_45.data.player.id == arg0_45.player.id then
			var0_45 = arg0_45.poolBubble.self
		end

		iter1_45:dispose()
		table.insert(var0_45, iter1_45)
	end

	arg0_45.bubbleCards = {}

	for iter2_45, iter3_45 in pairs(arg0_45.worldBossCards) do
		if not IsNil(iter3_45.tf) then
			Destroy(iter3_45.tf)
		end
	end

	arg0_45.worldBossCards = {}
end

function var0_0.updateAll(arg0_46)
	arg0_46:removeAllBubble()

	arg0_46.index = math.max(1, #arg0_46.filteredMessages - var0_0.InitCount)

	for iter0_46 = arg0_46.index, #arg0_46.filteredMessages do
		arg0_46:append(arg0_46.filteredMessages[iter0_46], -1)
	end

	scrollToBottom(arg0_46.content.parent)
	setActive(arg0_46.emptySign, PLATFORM_CODE == PLATFORM_JP and #arg0_46.filteredMessages <= 0)
end

function var0_0.append(arg0_47, arg1_47, arg2_47, arg3_47)
	if #arg0_47.filteredMessages >= var0_0.MaxCount * 2 then
		arg0_47:updateFilter()
		arg0_47:updateAll()
	else
		arg3_47 = arg3_47 and arg0_47.scroll.normalizedPosition.y < 0.1

		if arg1_47.type == ChatConst.ChannelPublic then
			if arg1_47.id == 0 then
				arg0_47:appendTopPublic(arg1_47)
			else
				arg0_47:appendPublic(arg1_47, arg2_47)
			end
		elseif arg1_47:IsWorldBossNotify() then
			arg0_47:appendPublic(arg1_47, arg2_47)
		else
			arg0_47:appendOthers(arg1_47, arg2_47)
		end

		if arg3_47 then
			scrollToBottom(arg0_47.content.parent)
		end
	end

	setActive(arg0_47.emptySign, PLATFORM_CODE == PLATFORM_JP and #arg0_47.filteredMessages <= 0)
end

function var0_0.appendOthers(arg0_48, arg1_48, arg2_48)
	local var0_48 = arg1_48.player
	local var1_48 = arg0_48.poolBubble.others
	local var2_48 = arg0_48.prefabOthers

	if var0_48.id == arg0_48.player.id then
		var1_48 = arg0_48.poolBubble.self
		var2_48 = arg0_48.prefabSelf
		arg1_48.isSelf = true
		arg1_48.player = setmetatable(Clone(arg0_48.player), {
			__index = arg1_48.player.__index
		})
	end

	local var3_48

	if #var1_48 > 0 then
		var3_48 = var1_48[1]

		setActive(var3_48.tf, true)
		table.remove(var1_48, 1)
	else
		local var4_48 = cloneTplTo(var2_48, arg0_48.content)

		var3_48 = ChatBubble.New(var4_48)
	end

	var3_48.tf:SetSiblingIndex(arg2_48)
	table.insert(arg0_48.bubbleCards, var3_48)
	var3_48:update(arg1_48)
	removeOnButton(var3_48.headTF)
	onButton(arg0_48, var3_48.headTF, function()
		local var0_49 = var3_48.tf:Find("shipicon/icon").position

		arg0_48:emit(NotificationMediator.OPEN_INFO, var0_48, var0_49, arg1_48.content)
	end, SFX_PANEL)
end

function var0_0.appendPublic(arg0_50, arg1_50, arg2_50)
	local var0_50

	if arg1_50.id == 4 then
		local var1_50 = WorldBossConst.__IsCurrBoss(arg1_50.args.wordBossConfigId) and arg0_50.prefabWorldBoss or arg0_50.prefabWorldBossArchives
		local var2_50 = cloneTplTo(var1_50, arg0_50.content)

		var0_50 = ChatBubbleWorldBoss.New(var2_50, arg0_50.currentForm ~= var0_0.FORM_BATTLE)

		table.insert(arg0_50.worldBossCards, var0_50)
	else
		local var3_50 = arg0_50.poolBubble.public

		if #var3_50 > 0 then
			var0_50 = var3_50[1]

			setActive(var0_50.tf, true)
			table.remove(var3_50, 1)
		else
			local var4_50 = cloneTplTo(arg0_50.prefabPublic, arg0_50.content)

			var0_50 = ChatBubblePublic.New(var4_50)
		end

		table.insert(arg0_50.bubbleCards, var0_50)
	end

	var0_50.tf:SetSiblingIndex(arg2_50)
	var0_50:update(arg1_50)
end

function var0_0.appendTopPublic(arg0_51, arg1_51)
	local var0_51 = 120 - (pg.TimeMgr.GetInstance():GetServerTime() - arg1_51.timestamp)

	if var0_51 <= 0 then
		return
	end

	SetActive(arg0_51.topMsg, true)
	ChatProxy.InjectPublic(findTF(arg0_51.topPublic, "text"):GetComponent("RichText"), arg1_51)

	findTF(arg0_51.topPublic, "channel"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("channel", ChatConst.GetChannelSprite(arg1_51.type) .. "_1920")

	if arg0_51._topTimer then
		arg0_51._topTimer:Stop()

		arg0_51._topTimer = nil
	end

	arg0_51._topTimer = Timer.New(function()
		SetActive(arg0_51.topMsg, false)

		arg0_51._topTimer = nil
	end, var0_51, 1)

	arg0_51._topTimer:Start()
end

function var0_0.showEnterRommTip(arg0_53)
	if arg0_53.player.chatRoomId == 0 then
		return
	end

	if not LeanTween.isTweening(go(arg0_53.enterRoomTip)) then
		LeanTween.value(go(arg0_53.enterRoomTip), 1, 0, 2):setOnUpdate(System.Action_float(function(arg0_54)
			arg0_53.enterRoomCG.alpha = arg0_54
		end)):setEase(LeanTweenType.easeInSine):setOnComplete(System.Action(function()
			arg0_53.enterRoomCG.alpha = 0

			LeanTween.cancel(go(arg0_53.enterRoomTip))
		end)):setDelay(0.5)
	end
end

function var0_0.getPos(arg0_56, arg1_56)
	return
end

function var0_0.displayEmojiPanel(arg0_57)
	local var0_57 = arg0_57.emoji.position

	arg0_57:emit(NotificationMediator.OPEN_EMOJI, function(arg0_58)
		arg0_57:emit(NotificationMediator.ON_SEND_PUBLIC, var0_0.ChannelBits.send, string.gsub(ChatConst.EmojiCode, "code", arg0_58))
	end, Vector3(var0_57.x, var0_57.y, 0))
end

function var0_0.willExit(arg0_59)
	if isActive(arg0_59.changeRoomPanel) then
		arg0_59:closeChangeRoomPanel()
	end

	arg0_59:UnOverlayPanel(arg0_59._tf)
	LeanTween.cancel(arg0_59._go)
	LeanTween.cancel(go(arg0_59.enterRoomTip))

	if arg0_59._topTimer then
		arg0_59._topTimer:Stop()

		arg0_59._topTimer = nil
	end

	for iter0_59, iter1_59 in ipairs(arg0_59.bubbleCards or {}) do
		iter1_59:dispose()
	end

	for iter2_59, iter3_59 in ipairs(arg0_59.worldBossCards or {}) do
		iter3_59:dispose()
	end

	arg0_59.worldBossCards = nil

	for iter4_59, iter5_59 in pairs(arg0_59.poolBubble) do
		for iter6_59, iter7_59 in ipairs(iter5_59) do
			iter7_59:dispose()
		end
	end

	arg0_59:removeLateUpdateListener()
	getProxy(GuildProxy):ClearNewChatMsgCnt()
end

function var0_0.insertEmojiToInputText(arg0_60, arg1_60)
	arg0_60.input.text = arg0_60.input.text .. string.gsub(ChatConst.EmojiIconCode, "code", arg1_60)
end

function var0_0.addLateUpdateListener(arg0_61)
	return
end

function var0_0.removeLateUpdateListener(arg0_62)
	return
end

return var0_0
