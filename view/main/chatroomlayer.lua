local var0 = class("ChatRoomLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "ChatRoomUI"
end

function var0.setFriendVO(arg0, arg1)
	arg0.friendVO = arg1
end

function var0.setFriends(arg0, arg1)
	arg0.friendVOs = arg1
end

function var0.setPlayer(arg0, arg1)
	arg0.playerVO = arg1
end

function var0.setCacheMsgs(arg0, arg1)
	arg0.cacheMsgsVOs = arg1
end

function var0.init(arg0)
	arg0.frame = arg0:findTF("frame")
	arg0.friendView = arg0:findTF("left_length/scrollView", arg0.frame)
	arg0.chatPanel = arg0:findTF("notification_panel", arg0.frame)
	arg0.chatPanelTitle = arg0:findTF("notification_panel/frame/top/name", arg0.frame)
	arg0.sendBtn = arg0:findTF("frame/bottom/send", arg0.chatPanel)
	arg0.inputTF = arg0:findTF("frame/bottom/input", arg0.chatPanel)
	arg0.chatsRect = arg0:findTF("frame/list", arg0.chatPanel)
	arg0.chatsContainer = arg0:findTF("frame/list/content", arg0.chatPanel)
	arg0.closeBtn = arg0:findTF("frame/notification_panel/frame/top/close_btn")
	arg0.otherPopTpl = arg0:getTpl("frame/list/popo_other", arg0.chatPanel)
	arg0.selfPopTpl = arg0:getTpl("frame/list/popo_self", arg0.chatPanel)

	pg.UIMgr.GetInstance():BlurPanel(arg0.frame, false, {
		groupName = LayerWeightConst.GROUP_CHATROOM
	})

	arg0.mainPanel = pg.UIMgr.GetInstance().UIMain
end

function var0.didEnter(arg0)
	local var0 = arg0:findTF("frame/bottom/emoji", arg0.chatPanel)

	onButton(arg0, var0, function()
		local var0 = var0.position

		arg0:emit(ChatRoomMediator.OPEN_EMOJI, Vector3(var0.x, var0.y, 0), function(arg0)
			arg0:sendMessage(string.gsub(ChatConst.EmojiCode, "code", arg0))
		end)
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		arg0:emit(var0.ON_CLOSE)
	end, SOUND_BACK)
	onButton(arg0, arg0.closeBtn, function()
		arg0:emit(var0.ON_CLOSE)
	end, SOUND_BACK)
	arg0:initFriends()
end

function var0.initFriends(arg0)
	arg0.friendItems = {}
	arg0.friendRect = arg0.friendView:GetComponent("LScrollRect")

	function arg0.friendRect.onInitItem(arg0)
		arg0:initFriend(arg0)
	end

	function arg0.friendRect.onUpdateItem(arg0, arg1)
		arg0:updateFriend(arg0, arg1)
	end

	arg0:sortFriend()
end

function var0.createFriendItem(arg0, arg1)
	local var0 = {
		tf = tf(arg1)
	}

	var0.nameTF = var0.tf:Find("name"):GetComponent(typeof(Text))
	var0.iconTF = var0.tf:Find("shipicon/icon"):GetComponent(typeof(Image))
	var0.circle = var0.tf:Find("shipicon/frame")
	var0.toggle = var0.tf:GetComponent(typeof(Toggle))
	var0.tipTF = var0.tf:Find("tip")
	var0.dateTF = var0.tf:Find("lv_bg/date"):GetComponent(typeof(Text))
	var0.onlineTF = var0.tf:Find("lv_bg/online")
	var0.levelTF = var0.tf:Find("lv_bg/Text"):GetComponent(typeof(Text))

	local var1 = arg0.friendVO

	function var0.update(arg0, arg1, arg2)
		arg0:clear()
		setActive(var0.tipTF, false)

		arg0.friendVO = arg1
		var0.nameTF.text = arg1.name
		var0.levelTF.text = "LV." .. arg1.level

		local var0 = pg.ship_data_statistics[arg1.icon]
		local var1 = Ship.New({
			configId = arg1.icon,
			skin_id = arg1.skinId
		})

		assert(var0, "shipCfg is nil >> id ==" .. arg1.icon)
		LoadSpriteAsync("qicon/" .. var1:getPainting(), function(arg0)
			if not arg0 then
				var0.iconTF.sprite = GetSpriteFromAtlas("heroicon/unknown", "")
			else
				var0.iconTF.sprite = arg0
			end
		end)

		local var2 = AttireFrame.attireFrameRes(arg1, arg1.id == getProxy(PlayerProxy):getRawData().id, AttireConst.TYPE_ICON_FRAME, arg1.propose)

		PoolMgr.GetInstance():GetPrefab("IconFrame/" .. var2, var2, true, function(arg0)
			if arg0.circle then
				arg0.name = var2
				findTF(arg0.transform, "icon"):GetComponent(typeof(Image)).raycastTarget = false

				setParent(arg0, arg0.circle, false)
			else
				PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var2, var2, arg0)
			end
		end)

		if var1.id == arg1.id and var0.toggle.isOn == false then
			triggerToggle(var0.tf, true)
		end

		setActive(arg0.onlineTF, arg1.online == Friend.ONLINE)
		setActive(var0.dateTF, arg1.online == Friend.OFFLINE)

		var0.dateTF.text = pg.TimeMgr.GetInstance():STimeDescC(arg1.preOnLineTime, "%Y/%m/%d")
	end

	function var0.clear(arg0)
		if arg0.circle.childCount > 0 then
			local var0 = arg0.circle:GetChild(0).gameObject

			PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var0.name, var0.name, var0)
		end
	end

	function var0.dispose(arg0)
		arg0:clear()
	end

	return var0
end

function var0.updateFriend(arg0, arg1, arg2)
	local var0 = arg0.friendItems[arg2]

	if not var0 then
		arg0:initFriend(arg2)

		var0 = arg0.friendItems[arg2]
	end

	local var1 = arg0.friendVOs[arg1 + 1]

	var0:update(var1)
end

function var0.initFriend(arg0, arg1)
	local var0 = arg0:createFriendItem(arg1)

	onToggle(arg0, var0.tf, function(arg0)
		if arg0 and var0.friendVO then
			arg0:openChatPanel(var0.friendVO)

			arg0.contextData.friendVO = var0.friendVO

			arg0:setFriendVO(var0.friendVO)
			arg0:emit(ChatRoomMediator.CLEAR_UNREADCOUNT, var0.friendVO.id)
		end
	end)

	arg0.friendItems[arg1] = var0
end

function var0.updateFriendVO(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.friendVOs) do
		if iter1.id == arg1.id then
			arg0.friendVOs[iter0] = arg1

			break
		end
	end

	if arg1.id == arg0.friendVO.id then
		arg0.friendVO = arg1
	end

	arg0:sortFriend()
end

function var0.sortFriend(arg0)
	table.sort(arg0.friendVOs, function(arg0, arg1)
		local var0 = arg0.id == arg0.friendVO.id and 1 or 0
		local var1 = arg1.id == arg0.friendVO.id and 1 or 0

		if var0 == var1 then
			if arg0.online == arg1.online then
				if arg0.level == arg1.level then
					return arg0.id < arg1.id
				else
					return arg0.level > arg1.level
				end
			else
				return arg0.online > arg1.online
			end
		else
			return var1 < var0
		end
	end)
	arg0.friendRect:SetTotalCount(#arg0.friendVOs, -1)
end

function var0.openChatPanel(arg0, arg1)
	arg0.friendVO = arg1

	removeAllChildren(arg0.chatsContainer)

	local var0 = arg0.cacheMsgsVOs[arg1.id]

	for iter0, iter1 in pairs(var0 or {}) do
		arg0:appendMsg(iter1)
	end

	setText(arg0.chatPanelTitle, arg0.friendVO.name)
	setActive(arg0.chatPanel, true)
	onButton(arg0, arg0.sendBtn, function()
		local var0 = getInputText(arg0.inputTF)

		setInputText(arg0.inputTF, "")
		arg0:sendMessage(var0)
	end)
end

function var0.sendMessage(arg0, arg1)
	if arg1 == "" then
		pg.TipsMgr.GetInstance():ShowTips(i18n("friend_send_msg_null_tip"))

		return
	end

	arg0:emit(ChatRoomMediator.SEND_FRIEND_MSG, arg0.friendVO.id, arg1)
end

function var0.getPlayer(arg0, arg1)
	if arg1 == arg0.playerVO.id then
		return arg0.playerVO
	end

	for iter0, iter1 in ipairs(arg0.friendVOs) do
		if iter1.id == arg1 then
			return iter1
		end
	end
end

function var0.appendMsg(arg0, arg1)
	if arg1.playerId ~= arg0.playerVO.id and arg1.playerId ~= arg0.friendVO.id then
		return
	end

	arg0:emit(ChatRoomMediator.CLEAR_UNREADCOUNT, arg0.friendVO.id)

	local var0 = arg0.otherPopTpl
	local var1 = arg0:getPlayer(arg1.playerId)

	if arg1.playerId == arg0.playerVO.id then
		var0 = arg0.selfPopTpl
		arg1.player = setmetatable(Clone(arg0.playerVO), {
			__index = var1
		})
		arg1.isSelf = true
	end

	local var2 = cloneTplTo(var0, arg0.chatsContainer)

	ChatRoomBubble.New(var2):update(arg1)
	scrollToBottom(arg0.chatsRect)
end

function var0.closeChatPanel(arg0)
	setActive(arg0.chatPanel, false)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0.frame, arg0._tf)
	eachChild(arg0.chatsContainer, function(arg0)
		local var0 = arg0:findTF("face", arg0)

		if var0.childCount > 0 then
			local var1 = var0:GetChild(0).gameObject

			PoolMgr.GetInstance():ReturnPrefab("emoji/" .. var1.name, var1.name, var1)
		end
	end)

	for iter0, iter1 in pairs(arg0.friendItems) do
		iter1:dispose()
	end
end

function var0.insertEmojiToInputText(arg0, arg1)
	setInputText(arg0.inputTF, getInputText(arg0.inputTF) .. string.gsub(ChatConst.EmojiIconCode, "code", arg1))
end

return var0
