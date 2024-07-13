local var0_0 = class("ChatRoomLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "ChatRoomUI"
end

function var0_0.setFriendVO(arg0_2, arg1_2)
	arg0_2.friendVO = arg1_2
end

function var0_0.setFriends(arg0_3, arg1_3)
	arg0_3.friendVOs = arg1_3
end

function var0_0.setPlayer(arg0_4, arg1_4)
	arg0_4.playerVO = arg1_4
end

function var0_0.setCacheMsgs(arg0_5, arg1_5)
	arg0_5.cacheMsgsVOs = arg1_5
end

function var0_0.init(arg0_6)
	arg0_6.frame = arg0_6:findTF("frame")
	arg0_6.friendView = arg0_6:findTF("left_length/scrollView", arg0_6.frame)
	arg0_6.chatPanel = arg0_6:findTF("notification_panel", arg0_6.frame)
	arg0_6.chatPanelTitle = arg0_6:findTF("notification_panel/frame/top/name", arg0_6.frame)
	arg0_6.sendBtn = arg0_6:findTF("frame/bottom/send", arg0_6.chatPanel)
	arg0_6.inputTF = arg0_6:findTF("frame/bottom/input", arg0_6.chatPanel)
	arg0_6.chatsRect = arg0_6:findTF("frame/list", arg0_6.chatPanel)
	arg0_6.chatsContainer = arg0_6:findTF("frame/list/content", arg0_6.chatPanel)
	arg0_6.closeBtn = arg0_6:findTF("frame/notification_panel/frame/top/close_btn")
	arg0_6.otherPopTpl = arg0_6:getTpl("frame/list/popo_other", arg0_6.chatPanel)
	arg0_6.selfPopTpl = arg0_6:getTpl("frame/list/popo_self", arg0_6.chatPanel)

	pg.UIMgr.GetInstance():BlurPanel(arg0_6.frame, false, {
		groupName = LayerWeightConst.GROUP_CHATROOM
	})

	arg0_6.mainPanel = pg.UIMgr.GetInstance().UIMain
end

function var0_0.didEnter(arg0_7)
	local var0_7 = arg0_7:findTF("frame/bottom/emoji", arg0_7.chatPanel)

	onButton(arg0_7, var0_7, function()
		local var0_8 = var0_7.position

		arg0_7:emit(ChatRoomMediator.OPEN_EMOJI, Vector3(var0_8.x, var0_8.y, 0), function(arg0_9)
			arg0_7:sendMessage(string.gsub(ChatConst.EmojiCode, "code", arg0_9))
		end)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7._tf, function()
		arg0_7:emit(var0_0.ON_CLOSE)
	end, SOUND_BACK)
	onButton(arg0_7, arg0_7.closeBtn, function()
		arg0_7:emit(var0_0.ON_CLOSE)
	end, SOUND_BACK)
	arg0_7:initFriends()
end

function var0_0.initFriends(arg0_12)
	arg0_12.friendItems = {}
	arg0_12.friendRect = arg0_12.friendView:GetComponent("LScrollRect")

	function arg0_12.friendRect.onInitItem(arg0_13)
		arg0_12:initFriend(arg0_13)
	end

	function arg0_12.friendRect.onUpdateItem(arg0_14, arg1_14)
		arg0_12:updateFriend(arg0_14, arg1_14)
	end

	arg0_12:sortFriend()
end

function var0_0.createFriendItem(arg0_15, arg1_15)
	local var0_15 = {
		tf = tf(arg1_15)
	}

	var0_15.nameTF = var0_15.tf:Find("name"):GetComponent(typeof(Text))
	var0_15.iconTF = var0_15.tf:Find("shipicon/icon"):GetComponent(typeof(Image))
	var0_15.circle = var0_15.tf:Find("shipicon/frame")
	var0_15.toggle = var0_15.tf:GetComponent(typeof(Toggle))
	var0_15.tipTF = var0_15.tf:Find("tip")
	var0_15.dateTF = var0_15.tf:Find("lv_bg/date"):GetComponent(typeof(Text))
	var0_15.onlineTF = var0_15.tf:Find("lv_bg/online")
	var0_15.levelTF = var0_15.tf:Find("lv_bg/Text"):GetComponent(typeof(Text))

	local var1_15 = arg0_15.friendVO

	function var0_15.update(arg0_16, arg1_16, arg2_16)
		arg0_16:clear()
		setActive(var0_15.tipTF, false)

		arg0_16.friendVO = arg1_16
		var0_15.nameTF.text = arg1_16.name
		var0_15.levelTF.text = "LV." .. arg1_16.level

		local var0_16 = pg.ship_data_statistics[arg1_16.icon]
		local var1_16 = Ship.New({
			configId = arg1_16.icon,
			skin_id = arg1_16.skinId
		})

		assert(var0_16, "shipCfg is nil >> id ==" .. arg1_16.icon)
		LoadSpriteAsync("qicon/" .. var1_16:getPainting(), function(arg0_17)
			if not arg0_17 then
				var0_15.iconTF.sprite = GetSpriteFromAtlas("heroicon/unknown", "")
			else
				var0_15.iconTF.sprite = arg0_17
			end
		end)

		local var2_16 = AttireFrame.attireFrameRes(arg1_16, arg1_16.id == getProxy(PlayerProxy):getRawData().id, AttireConst.TYPE_ICON_FRAME, arg1_16.propose)

		PoolMgr.GetInstance():GetPrefab("IconFrame/" .. var2_16, var2_16, true, function(arg0_18)
			if arg0_16.circle then
				arg0_18.name = var2_16
				findTF(arg0_18.transform, "icon"):GetComponent(typeof(Image)).raycastTarget = false

				setParent(arg0_18, arg0_16.circle, false)
			else
				PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var2_16, var2_16, arg0_18)
			end
		end)

		if var1_15.id == arg1_16.id and var0_15.toggle.isOn == false then
			triggerToggle(var0_15.tf, true)
		end

		setActive(arg0_16.onlineTF, arg1_16.online == Friend.ONLINE)
		setActive(var0_15.dateTF, arg1_16.online == Friend.OFFLINE)

		var0_15.dateTF.text = pg.TimeMgr.GetInstance():STimeDescC(arg1_16.preOnLineTime, "%Y/%m/%d")
	end

	function var0_15.clear(arg0_19)
		if arg0_19.circle.childCount > 0 then
			local var0_19 = arg0_19.circle:GetChild(0).gameObject

			PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var0_19.name, var0_19.name, var0_19)
		end
	end

	function var0_15.dispose(arg0_20)
		arg0_20:clear()
	end

	return var0_15
end

function var0_0.updateFriend(arg0_21, arg1_21, arg2_21)
	local var0_21 = arg0_21.friendItems[arg2_21]

	if not var0_21 then
		arg0_21:initFriend(arg2_21)

		var0_21 = arg0_21.friendItems[arg2_21]
	end

	local var1_21 = arg0_21.friendVOs[arg1_21 + 1]

	var0_21:update(var1_21)
end

function var0_0.initFriend(arg0_22, arg1_22)
	local var0_22 = arg0_22:createFriendItem(arg1_22)

	onToggle(arg0_22, var0_22.tf, function(arg0_23)
		if arg0_23 and var0_22.friendVO then
			arg0_22:openChatPanel(var0_22.friendVO)

			arg0_22.contextData.friendVO = var0_22.friendVO

			arg0_22:setFriendVO(var0_22.friendVO)
			arg0_22:emit(ChatRoomMediator.CLEAR_UNREADCOUNT, var0_22.friendVO.id)
		end
	end)

	arg0_22.friendItems[arg1_22] = var0_22
end

function var0_0.updateFriendVO(arg0_24, arg1_24)
	for iter0_24, iter1_24 in ipairs(arg0_24.friendVOs) do
		if iter1_24.id == arg1_24.id then
			arg0_24.friendVOs[iter0_24] = arg1_24

			break
		end
	end

	if arg1_24.id == arg0_24.friendVO.id then
		arg0_24.friendVO = arg1_24
	end

	arg0_24:sortFriend()
end

function var0_0.sortFriend(arg0_25)
	table.sort(arg0_25.friendVOs, function(arg0_26, arg1_26)
		local var0_26 = arg0_26.id == arg0_25.friendVO.id and 1 or 0
		local var1_26 = arg1_26.id == arg0_25.friendVO.id and 1 or 0

		if var0_26 == var1_26 then
			if arg0_26.online == arg1_26.online then
				if arg0_26.level == arg1_26.level then
					return arg0_26.id < arg1_26.id
				else
					return arg0_26.level > arg1_26.level
				end
			else
				return arg0_26.online > arg1_26.online
			end
		else
			return var1_26 < var0_26
		end
	end)
	arg0_25.friendRect:SetTotalCount(#arg0_25.friendVOs, -1)
end

function var0_0.openChatPanel(arg0_27, arg1_27)
	arg0_27.friendVO = arg1_27

	removeAllChildren(arg0_27.chatsContainer)

	local var0_27 = arg0_27.cacheMsgsVOs[arg1_27.id]

	for iter0_27, iter1_27 in pairs(var0_27 or {}) do
		arg0_27:appendMsg(iter1_27)
	end

	setText(arg0_27.chatPanelTitle, arg0_27.friendVO.name)
	setActive(arg0_27.chatPanel, true)
	onButton(arg0_27, arg0_27.sendBtn, function()
		local var0_28 = getInputText(arg0_27.inputTF)

		setInputText(arg0_27.inputTF, "")
		arg0_27:sendMessage(var0_28)
	end)
end

function var0_0.sendMessage(arg0_29, arg1_29)
	if arg1_29 == "" then
		pg.TipsMgr.GetInstance():ShowTips(i18n("friend_send_msg_null_tip"))

		return
	end

	arg0_29:emit(ChatRoomMediator.SEND_FRIEND_MSG, arg0_29.friendVO.id, arg1_29)
end

function var0_0.getPlayer(arg0_30, arg1_30)
	if arg1_30 == arg0_30.playerVO.id then
		return arg0_30.playerVO
	end

	for iter0_30, iter1_30 in ipairs(arg0_30.friendVOs) do
		if iter1_30.id == arg1_30 then
			return iter1_30
		end
	end
end

function var0_0.appendMsg(arg0_31, arg1_31)
	if arg1_31.playerId ~= arg0_31.playerVO.id and arg1_31.playerId ~= arg0_31.friendVO.id then
		return
	end

	arg0_31:emit(ChatRoomMediator.CLEAR_UNREADCOUNT, arg0_31.friendVO.id)

	local var0_31 = arg0_31.otherPopTpl
	local var1_31 = arg0_31:getPlayer(arg1_31.playerId)

	if arg1_31.playerId == arg0_31.playerVO.id then
		var0_31 = arg0_31.selfPopTpl
		arg1_31.player = setmetatable(Clone(arg0_31.playerVO), {
			__index = var1_31
		})
		arg1_31.isSelf = true
	end

	local var2_31 = cloneTplTo(var0_31, arg0_31.chatsContainer)

	ChatRoomBubble.New(var2_31):update(arg1_31)
	scrollToBottom(arg0_31.chatsRect)
end

function var0_0.closeChatPanel(arg0_32)
	setActive(arg0_32.chatPanel, false)
end

function var0_0.willExit(arg0_33)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_33.frame, arg0_33._tf)
	eachChild(arg0_33.chatsContainer, function(arg0_34)
		local var0_34 = arg0_33:findTF("face", arg0_34)

		if var0_34.childCount > 0 then
			local var1_34 = var0_34:GetChild(0).gameObject

			PoolMgr.GetInstance():ReturnPrefab("emoji/" .. var1_34.name, var1_34.name, var1_34)
		end
	end)

	for iter0_33, iter1_33 in pairs(arg0_33.friendItems) do
		iter1_33:dispose()
	end
end

function var0_0.insertEmojiToInputText(arg0_35, arg1_35)
	setInputText(arg0_35.inputTF, getInputText(arg0_35.inputTF) .. string.gsub(ChatConst.EmojiIconCode, "code", arg1_35))
end

return var0_0
