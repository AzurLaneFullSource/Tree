local var0 = class("NotificationLayer", import("..base.BaseUI"))

var0.InitCount = 10
var0.MaxCount = 100
var0.FORM_COMMON = 0
var0.FORM_BATTLE = 1
var0.FORM_MAIN = 2
var0.ChannelBits = {
	send = ChatConst.ChannelWorld,
	recv = IndexConst.Flags2Bits({
		ChatConst.ChannelAll
	})
}

function var0.getUIName(arg0)
	if getProxy(SettingsProxy):IsMellowStyle() then
		return "NotificationUI4Mellow"
	else
		return "NotificationUI"
	end
end

function var0.getGroupName(arg0)
	return "group_NotificationUI"
end

function var0.setPlayer(arg0, arg1)
	arg0.player = arg1
end

function var0.setInGuild(arg0, arg1)
	arg0.inGuild = arg1
end

function var0.setMessages(arg0, arg1)
	arg0.messages = arg1
end

function var0.init(arg0)
	arg0.close = arg0:findTF("close")
	arg0.frame = arg0:findTF("frame")
	arg0.contain = arg0.frame:Find("contain")

	local var0 = arg0.contain:Find("ListContainer/list")

	arg0.content = var0:Find("content")
	arg0.emptySign = var0:Find("EmptySign")

	setActive(arg0.emptySign, false)

	arg0.prefabSelf = var0:Find("popo_self").gameObject
	arg0.prefabOthers = var0:Find("popo_other").gameObject
	arg0.prefabPublic = var0:Find("popo_public").gameObject
	arg0.prefabWorldBoss = var0:Find("popo_worldboss").gameObject
	arg0.prefabWorldBossArchives = var0:Find("popo_worldboss_archives").gameObject
	arg0.input = arg0.frame:Find("contain/ListContainer/inputbg/input"):GetComponent("InputField")

	setText(arg0.frame:Find("contain/ListContainer/inputbg/input/Placeholder"), i18n("notice_input_desc"))

	arg0.send = arg0.frame:Find("send")
	arg0.channelSend = arg0.frame:Find("channel_send")
	arg0.channelSendPop = arg0.frame:Find("channel_pop")
	arg0.scroll = var0:GetComponent("ScrollRect")
	arg0.topMsg = arg0.contain:Find("topmsg")

	SetActive(arg0.topMsg, false)

	arg0.topPublic = arg0:findTF("popo_public", arg0.topMsg)
	arg0.emoji = arg0.frame:Find("contain/ListContainer/inputbg/emoji")
	arg0.changeRoomPanel = arg0:findTF("change_room_Panel")
	arg0.roomSendBtns = arg0:findTF("frame/bg/type_send", arg0.changeRoomPanel)
	arg0.roomRecvBtns = arg0:findTF("frame/bg/type_recv", arg0.changeRoomPanel)
	arg0.enterRoomTip = arg0.frame:Find("enter_room_tip")
	arg0.enterRoomCG = arg0.enterRoomTip:GetComponent(typeof(CanvasGroup))
	arg0.roomBtn = arg0.contain:Find("top/room")
	arg0.typeBtns = arg0.contain:Find("top/type")
	arg0.inputTF = arg0:findTF("frame/bg/InputField", arg0.changeRoomPanel):GetComponent(typeof(InputField))
	arg0.switchTpl = arg0:findTF("switch_tpl", arg0.changeRoomPanel)
	arg0.switchNormalSprite = arg0:findTF("switch_normal", arg0.changeRoomPanel):GetComponent(typeof(Image)).sprite
	arg0.switchSelectedSprite = arg0:findTF("switch_selected", arg0.changeRoomPanel):GetComponent(typeof(Image)).sprite

	setText(findTF(arg0.changeRoomPanel, "frame/bg/label_send"), i18n("notice_label_send"))
	setText(findTF(arg0.changeRoomPanel, "frame/bg/label_recv"), i18n("notice_label_recv"))
	setText(findTF(arg0.changeRoomPanel, "frame/bg/label_room"), i18n("notice_label_room"))
	setText(findTF(arg0.changeRoomPanel, "frame/bg/label_tip"), i18n("notice_label_tip"))
	setText(findTF(arg0.changeRoomPanel, "frame/cancel/Image"), i18n("word_cancel"))
	setText(findTF(arg0.changeRoomPanel, "frame/confirm/Image"), i18n("word_ok"))

	arg0.resource = arg0:findTF("resource")
	arg0.typeTpl = arg0:findTF("type_tpl", arg0.resource)
	arg0.normalSprite = arg0:findTF("normal", arg0.resource):GetComponent(typeof(Image)).sprite
	arg0.selectedSprite = arg0:findTF("selected", arg0.resource):GetComponent(typeof(Image)).sprite
	arg0.bottomChannelTpl = arg0:findTF("channel_tpl", arg0.resource)
	arg0.bottomChannelNormalSprite = arg0:findTF("channel_normal", arg0.resource):GetComponent(typeof(Image)).sprite
	arg0.bottomChannelSelectedSprite = arg0:findTF("channel_selected", arg0.resource):GetComponent(typeof(Image)).sprite

	local var1 = {
		ChatConst.ChannelAll,
		ChatConst.ChannelWorld,
		ChatConst.ChannelPublic,
		ChatConst.ChannelFriend,
		ChatConst.ChannelGuild,
		ChatConst.ChannelWorldBoss
	}

	arg0.textSprites = {}
	arg0.textSelectedSprites = {}
	arg0.bottomChannelTextSprites = {}
	arg0.switchTextSprites = {}

	for iter0, iter1 in pairs(var1) do
		local var2 = ChatConst.GetChannelSprite(iter0)

		arg0.textSprites[iter0] = arg0:findTF("text_" .. var2, arg0.resource):GetComponent(typeof(Image)).sprite
		arg0.textSelectedSprites[iter0] = arg0:findTF("text_" .. var2 .. "_selected", arg0.resource):GetComponent(typeof(Image)).sprite
		arg0.switchTextSprites[iter0] = arg0:findTF("text_" .. var2 .. "_switch", arg0.changeRoomPanel):GetComponent(typeof(Image)).sprite

		if table.contains(ChatConst.SendChannels, iter0) then
			arg0.bottomChannelTextSprites[iter0] = arg0:findTF("channel_" .. var2, arg0.resource):GetComponent(typeof(Image)).sprite
		end
	end

	arg0.prefabSelf:SetActive(false)
	arg0.prefabOthers:SetActive(false)
	arg0.prefabPublic:SetActive(false)

	arg0.bubbleCards = {}
	arg0.worldBossCards = {}
	arg0.poolBubble = {
		self = {},
		public = {},
		others = {}
	}
	var0.ChannelBits.recv = getProxy(SettingsProxy):GetChatFlag()
end

function var0.adjustMsgListPanel(arg0)
	arg0.listContainerTF = arg0.contain:Find("ListContainer")
	arg0.listTF = arg0.contain:Find("ListContainer/list")

	local var0 = arg0.listContainerTF.rect.size.y
	local var1 = 69.01791

	GetComponent(arg0.listTF, "LayoutElement").preferredHeight = var0 - var1
end

function var0.didEnter(arg0)
	arg0:adjustMsgListPanel()

	arg0.currentForm = arg0.contextData.form
	arg0.escFlag = false

	onButton(arg0, arg0.close, function()
		arg0:PlayExitAnimation(function()
			if arg0.currentForm == var0.FORM_BATTLE then
				arg0:emit(NotificationMediator.BATTLE_CHAT_CLOSE)
			end

			arg0:emit(BaseUI.ON_CLOSE)
		end)
	end, SFX_CANCEL)
	onButton(arg0, arg0.emoji, function()
		arg0:displayEmojiPanel()
	end, SFX_PANEL)
	onButton(arg0, arg0.send, function()
		local var0 = arg0.input.text

		if var0 == "" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("main_notificationLayer_sendButton"))

			return
		end

		arg0.input.text = ""

		arg0:emit(NotificationMediator.ON_SEND_PUBLIC, var0.ChannelBits.send, var0)
	end, SFX_PANEL)
	onButton(arg0, arg0.roomBtn, function()
		arg0:showChangeRoomPanel()
	end, SFX_PANEL)
	onButton(arg0, findTF(arg0.changeRoomPanel, "frame/cancel"), function()
		arg0:closeChangeRoomPanel()
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.changeRoomPanel, "frame/confirm"), function()
		arg0:emit(NotificationMediator.CHANGE_ROOM, tonumber(arg0.inputTF.text))
	end, SFX_CANCEL)
	onButton(arg0, arg0.channelSend, function()
		setActive(arg0.channelSendPop, not isActive(arg0.channelSendPop))

		if isActive(arg0.channelSendPop) then
			arg0:updateChannelSendPop()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		if isActive(arg0.channelSendPop) then
			setActive(arg0.channelSendPop, false)
		end
	end)
	pg.DelegateInfo.Add(arg0, arg0.scroll.onValueChanged)
	arg0.scroll.onValueChanged:AddListener(function(arg0)
		if arg0.index > 1 and arg0.y >= 1 then
			local var0 = arg0.content.sizeDelta.y * arg0.y
			local var1 = arg0.scroll.velocity
			local var2 = math.max(1, arg0.index - var0.InitCount)

			for iter0 = arg0.index - 1, var2, -1 do
				arg0:append(arg0.filteredMessages[iter0], 0)
			end

			Canvas.ForceUpdateCanvases()

			arg0.scroll.normalizedPosition = Vector2(0, var0 / arg0.content.sizeDelta.y)

			arg0.scroll.onValueChanged:Invoke(arg0.scroll.normalizedPosition)

			arg0.scroll.velocity = var1
			arg0.index = var2
		end
	end)
	arg0:updateRoom()
	arg0:updateChatChannel()
	arg0:initFilter()
	arg0:updateFilter()
	arg0:updateAll()

	if arg0.currentForm == var0.FORM_BATTLE then
		arg0._tf:SetParent(arg0.contextData.chatViewParent, true)

		rtf(arg0.frame.transform).offsetMax = Vector2(0, -120)
	else
		arg0:BlurPanel()
	end

	LeanTween.delayedCall(go(arg0._tf), 0.2, System.Action(function()
		scrollToBottom(arg0.content.parent)
	end))

	rtf(arg0._tf).offsetMax = Vector2(0, 0)
	rtf(arg0._tf).offsetMin = Vector2(0, 0)
end

function var0.BlurPanel(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		groupName = arg0:getGroupNameFromData(),
		weight = arg0:getWeightFromData() + 1
	})
end

function var0.UnblurPanel(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

function var0.onBackPressed(arg0)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if isActive(arg0.changeRoomPanel) then
		arg0:closeChangeRoomPanel()
	else
		triggerButton(arg0.close)
	end
end

function var0.initFilter(arg0)
	local var0 = ChatConst.RecvChannels

	arg0.recvTypes = UIItemList.New(arg0.typeBtns, arg0.typeTpl)

	arg0.recvTypes:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]

			setImageSprite(arg2:Find("text"), arg0.textSprites[var0], true)
			setImageSprite(arg2:Find("text_selected"), arg0.textSelectedSprites[var0], true)
			onButton(arg0, arg2, function()
				local var0 = _.filter(var0, function(arg0)
					return arg0 ~= ChatConst.ChannelGuild or arg0.inGuild
				end)
				local var1 = IndexConst.ToggleBits(var0.ChannelBits.recv, var0, ChatConst.ChannelAll, var0)

				if var0.ChannelBits.recv == var1 then
					return
				end

				var0.ChannelBits.recv = var1

				arg0:updateFilter()
				arg0:updateAll()
				getProxy(SettingsProxy):SetChatFlag(var0.ChannelBits.recv)
			end, SFX_UI_TAG)
		end
	end)
	arg0.recvTypes:align(#var0)
end

function var0.updateFilter(arg0)
	local var0 = ChatConst.RecvChannels

	arg0.recvTypes:each(function(arg0, arg1)
		local var0 = var0[arg0 + 1]

		if var0 == ChatConst.ChannelGuild and not arg0.inGuild then
			setButtonEnabled(arg1, false)
		end

		if bit.band(var0.ChannelBits.recv, bit.lshift(1, var0)) > 0 then
			setImageSprite(arg1, arg0.selectedSprite)
			setActive(arg1:Find("text_selected"), true)
		else
			setImageSprite(arg1, arg0.normalSprite)
			setActive(arg1:Find("text_selected"), false)
		end
	end)

	local var1 = var0.ChannelBits.recv
	local var2 = bit.lshift(1, ChatConst.ChannelAll)

	arg0.filteredMessages = _.filter(arg0.messages, function(arg0)
		return var1 == var2 or bit.band(var1, bit.lshift(1, arg0.type)) > 0
	end)
	arg0.filteredMessages = _.slice(arg0.filteredMessages, #arg0.filteredMessages - var0.MaxCount + 1, var0.MaxCount)
end

function var0.updateChatChannel(arg0)
	setImageSprite(arg0.channelSend:Find("Text"), arg0.bottomChannelTextSprites[var0.ChannelBits.send], true)
end

function var0.updateChannelSendPop(arg0)
	local var0 = ChatConst.SendChannels
	local var1 = UIItemList.New(arg0.channelSendPop:Find("type_send"), arg0.bottomChannelTpl)

	local function var2()
		var1:each(function(arg0, arg1)
			local var0 = var0[arg0 + 1]

			if var0 == ChatConst.ChannelGuild and not arg0.inGuild then
				setButtonEnabled(arg1, false)
			end

			local var1 = var0.ChannelBits.send == var0

			if var1 then
				setImageSprite(arg1:Find("bottom"), arg0.bottomChannelSelectedSprite, true)
			else
				setImageSprite(arg1:Find("bottom"), arg0.bottomChannelNormalSprite, true)
			end

			setActive(arg1:Find("selected"), var1)
			setActive(arg1:Find("text"), not var1)
		end)
	end

	var1:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]

			setImageSprite(arg2:Find("text"), arg0.bottomChannelTextSprites[var0], true)
			setImageSprite(arg2:Find("selected"), arg0.bottomChannelTextSprites[var0], true)
			onButton(arg0, arg2, function()
				setActive(arg0.channelSendPop, false)

				var0.ChannelBits.send = var0

				var2()
				arg0:updateChatChannel()
			end, SFX_UI_TAG)
		end
	end)
	var1:align(#var0)
	var2()
end

function var0.updateRoom(arg0)
	setText(arg0.enterRoomTip:Find("text"), i18n("main_notificationLayer_enter_room", arg0.player.chatRoomId == 0 and "" or arg0.player.chatRoomId))
	setText(arg0:findTF("Text", arg0.roomBtn), arg0.player.chatRoomId == 0 and i18n("common_not_enter_room") or arg0.player.chatRoomId)
	arg0:showEnterRommTip()
end

function var0.showChangeRoomPanel(arg0)
	arg0:UnblurPanel()
	pg.UIMgr.GetInstance():BlurPanel(arg0.changeRoomPanel, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})

	arg0.inputTF.text = tostring(arg0.player.chatRoomId)
	arg0.tempRoomSendBits = var0.ChannelBits.send

	local var0 = ChatConst.SendChannels
	local var1 = UIItemList.New(arg0.roomSendBtns, arg0.switchTpl)

	local function var2()
		var1:each(function(arg0, arg1)
			local var0 = var0[arg0 + 1]

			if var0 == ChatConst.ChannelGuild and not arg0.inGuild then
				setButtonEnabled(arg1, false)
			end

			if arg0.tempRoomSendBits == var0 then
				setImageSprite(arg1, arg0.switchSelectedSprite)
			else
				setImageSprite(arg1, arg0.switchNormalSprite)
			end
		end)
	end

	var1:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]

			setImageSprite(arg2:Find("text"), arg0.switchTextSprites[var0], true)
			onButton(arg0, arg2, function()
				arg0.tempRoomSendBits = var0

				var2()
			end, SFX_UI_TAG)
		end
	end)
	var1:align(#var0)
	var2()

	arg0.tempRoomRecvBits = var0.ChannelBits.recv

	local var3 = ChatConst.RecvChannels
	local var4 = UIItemList.New(arg0.roomRecvBtns, arg0.switchTpl)

	local function var5()
		var4:each(function(arg0, arg1)
			local var0 = var3[arg0 + 1]

			if var0 == ChatConst.ChannelGuild and not arg0.inGuild then
				setButtonEnabled(arg1, false)
			end

			if bit.band(arg0.tempRoomRecvBits, bit.lshift(1, var0)) > 0 then
				setImageSprite(arg1, arg0.switchSelectedSprite)
			else
				setImageSprite(arg1, arg0.switchNormalSprite)
			end
		end)
	end

	var4:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var3[arg1 + 1]

			setImageSprite(arg2:Find("text"), arg0.switchTextSprites[var0], true)
			onButton(arg0, arg2, function()
				local var0 = _.filter(var3, function(arg0)
					return arg0 ~= ChatConst.ChannelGuild or arg0.inGuild
				end)

				arg0.tempRoomRecvBits = IndexConst.ToggleBits(arg0.tempRoomRecvBits, var0, ChatConst.ChannelAll, var0)

				var5()
			end, SFX_UI_TAG)
		end
	end)
	var4:align(#var3)
	var5()
	setActive(arg0.changeRoomPanel, true)
end

function var0.closeChangeRoomPanel(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0.changeRoomPanel, arg0._tf)

	if arg0.currentForm == var0.FORM_BATTLE then
		arg0._tf:SetParent(arg0.contextData.chatViewParent, true)

		rtf(arg0.frame.transform).offsetMax = Vector2(0, -120)
	else
		arg0:BlurPanel()
	end

	setActive(arg0.changeRoomPanel, false)
end

function var0.removeAllBubble(arg0)
	for iter0, iter1 in ipairs(arg0.bubbleCards or {}) do
		setActive(iter1.tf, false)

		local var0 = arg0.poolBubble.others

		if iter1.__cname == "ChatBubblePublic" then
			var0 = arg0.poolBubble.public
		elseif iter1.__cname == "ChatBubble" and iter1.data.player and iter1.data.player.id == arg0.player.id then
			var0 = arg0.poolBubble.self
		end

		iter1:dispose()
		table.insert(var0, iter1)
	end

	arg0.bubbleCards = {}

	for iter2, iter3 in pairs(arg0.worldBossCards) do
		if not IsNil(iter3.tf) then
			Destroy(iter3.tf)
		end
	end

	arg0.worldBossCards = {}
end

function var0.updateAll(arg0)
	arg0:removeAllBubble()

	arg0.index = math.max(1, #arg0.filteredMessages - var0.InitCount)

	for iter0 = arg0.index, #arg0.filteredMessages do
		arg0:append(arg0.filteredMessages[iter0], -1)
	end

	scrollToBottom(arg0.content.parent)
	setActive(arg0.emptySign, PLATFORM_CODE == PLATFORM_JP and #arg0.filteredMessages <= 0)
end

function var0.append(arg0, arg1, arg2, arg3)
	if #arg0.filteredMessages >= var0.MaxCount * 2 then
		arg0:updateFilter()
		arg0:updateAll()
	else
		arg3 = arg3 and arg0.scroll.normalizedPosition.y < 0.1

		if arg1.type == ChatConst.ChannelPublic then
			if arg1.id == 0 then
				arg0:appendTopPublic(arg1)
			else
				arg0:appendPublic(arg1, arg2)
			end
		elseif arg1:IsWorldBossNotify() then
			arg0:appendPublic(arg1, arg2)
		else
			arg0:appendOthers(arg1, arg2)
		end

		if arg3 then
			scrollToBottom(arg0.content.parent)
		end
	end

	setActive(arg0.emptySign, PLATFORM_CODE == PLATFORM_JP and #arg0.filteredMessages <= 0)
end

function var0.appendOthers(arg0, arg1, arg2)
	local var0 = arg1.player
	local var1 = arg0.poolBubble.others
	local var2 = arg0.prefabOthers

	if var0.id == arg0.player.id then
		var1 = arg0.poolBubble.self
		var2 = arg0.prefabSelf
		arg1.isSelf = true
		arg1.player = setmetatable(Clone(arg0.player), {
			__index = arg1.player.__index
		})
	end

	local var3

	if #var1 > 0 then
		var3 = var1[1]

		setActive(var3.tf, true)
		table.remove(var1, 1)
	else
		local var4 = cloneTplTo(var2, arg0.content)

		var3 = ChatBubble.New(var4)
	end

	var3.tf:SetSiblingIndex(arg2)
	table.insert(arg0.bubbleCards, var3)
	var3:update(arg1)
	removeOnButton(var3.headTF)
	onButton(arg0, var3.headTF, function()
		local var0 = arg0:findTF("shipicon/icon", var3.tf).position

		arg0:emit(NotificationMediator.OPEN_INFO, var0, var0, arg1.content)
	end, SFX_PANEL)
end

function var0.appendPublic(arg0, arg1, arg2)
	local var0

	if arg1.id == 4 then
		local var1 = WorldBossConst.__IsCurrBoss(arg1.args.wordBossConfigId) and arg0.prefabWorldBoss or arg0.prefabWorldBossArchives
		local var2 = cloneTplTo(var1, arg0.content)

		var0 = ChatBubbleWorldBoss.New(var2, arg0.currentForm ~= var0.FORM_BATTLE)

		table.insert(arg0.worldBossCards, var0)
	else
		local var3 = arg0.poolBubble.public

		if #var3 > 0 then
			var0 = var3[1]

			setActive(var0.tf, true)
			table.remove(var3, 1)
		else
			local var4 = cloneTplTo(arg0.prefabPublic, arg0.content)

			var0 = ChatBubblePublic.New(var4)
		end

		table.insert(arg0.bubbleCards, var0)
	end

	var0.tf:SetSiblingIndex(arg2)
	var0:update(arg1)
end

function var0.appendTopPublic(arg0, arg1)
	local var0 = 120 - (pg.TimeMgr.GetInstance():GetServerTime() - arg1.timestamp)

	if var0 <= 0 then
		return
	end

	SetActive(arg0.topMsg, true)
	ChatProxy.InjectPublic(findTF(arg0.topPublic, "text"):GetComponent("RichText"), arg1)

	findTF(arg0.topPublic, "channel"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("channel", ChatConst.GetChannelSprite(arg1.type) .. "_1920")

	if arg0._topTimer then
		arg0._topTimer:Stop()

		arg0._topTimer = nil
	end

	arg0._topTimer = Timer.New(function()
		SetActive(arg0.topMsg, false)

		arg0._topTimer = nil
	end, var0, 1)

	arg0._topTimer:Start()
end

function var0.showEnterRommTip(arg0)
	if arg0.player.chatRoomId == 0 then
		return
	end

	if not LeanTween.isTweening(go(arg0.enterRoomTip)) then
		LeanTween.value(go(arg0.enterRoomTip), 1, 0, 2):setOnUpdate(System.Action_float(function(arg0)
			arg0.enterRoomCG.alpha = arg0
		end)):setEase(LeanTweenType.easeInSine):setOnComplete(System.Action(function()
			arg0.enterRoomCG.alpha = 0

			LeanTween.cancel(go(arg0.enterRoomTip))
		end)):setDelay(0.5)
	end
end

function var0.getPos(arg0, arg1)
	return
end

function var0.displayEmojiPanel(arg0)
	local var0 = arg0.emoji.position

	arg0:emit(NotificationMediator.OPEN_EMOJI, function(arg0)
		arg0:emit(NotificationMediator.ON_SEND_PUBLIC, var0.ChannelBits.send, string.gsub(ChatConst.EmojiCode, "code", arg0))
	end, Vector3(var0.x, var0.y, 0))
end

function var0.willExit(arg0)
	if arg0.currentForm == var0.FORM_BATTLE then
		if isActive(arg0.changeRoomPanel) then
			arg0:closeChangeRoomPanel()
		end
	else
		arg0:UnblurPanel()
	end

	LeanTween.cancel(arg0._go)
	LeanTween.cancel(go(arg0.enterRoomTip))

	if arg0._topTimer then
		arg0._topTimer:Stop()

		arg0._topTimer = nil
	end

	for iter0, iter1 in ipairs(arg0.bubbleCards or {}) do
		iter1:dispose()
	end

	for iter2, iter3 in ipairs(arg0.worldBossCards or {}) do
		iter3:dispose()
	end

	arg0.worldBossCards = nil

	for iter4, iter5 in pairs(arg0.poolBubble) do
		for iter6, iter7 in ipairs(iter5) do
			iter7:dispose()
		end
	end

	arg0:removeLateUpdateListener()
	getProxy(GuildProxy):ClearNewChatMsgCnt()
end

function var0.insertEmojiToInputText(arg0, arg1)
	arg0.input.text = arg0.input.text .. string.gsub(ChatConst.EmojiIconCode, "code", arg1)
end

function var0.addLateUpdateListener(arg0)
	return
end

function var0.removeLateUpdateListener(arg0)
	return
end

return var0
