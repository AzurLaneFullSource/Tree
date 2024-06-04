local var0 = class("MainChatRoomView", import("...base.MainBaseView"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1, arg2)

	local var0 = arg1:Find("item")

	arg0.items = {
		var0
	}
	arg0.tplInitPosY = var0.anchoredPosition.y
	arg0.MAX_COUNT = 4
	arg0.enableBtn = arg1:Find("enable")
	arg0.disableBtn = arg1:Find("disable")
	arg0.btn = arg1:GetComponent(typeof(Button))
	arg0.empty = arg1:Find("empty"):GetComponent(typeof(Text))

	arg0:RegisterEvent(arg2)
end

function var0.RegisterEvent(arg0, arg1)
	arg0:bind(GAME.REMOVE_LAYERS, function(arg0, arg1)
		arg0:OnRemoveLayer(arg1.context)
	end)
	arg0:bind(GAME.ANY_CHAT_MSG_UPDATE, function(arg0)
		arg0:OnUpdateChatMsg()
	end)

	arg0.hideChatFlag = PlayerPrefs.GetInt(HIDE_CHAT_FLAG)

	onButton(arg0, arg0._tf, function()
		if not arg0.hideChatFlag or arg0.hideChatFlag ~= 1 then
			arg0:GoChatView()
		end
	end, SFX_MAIN)
	onButton(arg0, arg0.enableBtn, function()
		arg0:SwitchState()
	end, SFX_MAIN)
	onButton(arg0, arg0.disableBtn, function()
		arg0:SwitchState()
	end, SFX_MAIN)
	arg0:UpdateBtnState()
end

function var0.GoChatView(arg0)
	arg0:emit(NewMainMediator.OPEN_CHATVIEW)
end

function var0.SwitchState(arg0)
	local var0 = arg0.hideChatFlag and arg0.hideChatFlag == 1
	local var1 = var0 and "show_chat_warning" or "hide_chat_warning"

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n(var1),
		onYes = function()
			local var0 = var0 and 0 or 1

			PlayerPrefs.SetInt(HIDE_CHAT_FLAG, var0)

			arg0.hideChatFlag = PlayerPrefs.GetInt(HIDE_CHAT_FLAG)

			arg0:UpdateBtnState()
		end
	})
end

function var0.UpdateBtnState(arg0)
	local var0 = arg0.hideChatFlag and arg0.hideChatFlag == 1

	setActive(arg0.enableBtn, var0)
	setActive(arg0.disableBtn, not var0)

	if var0 then
		arg0:Clear()
	end

	arg0.btn.enabled = not var0
end

function var0.OnRemoveLayer(arg0, arg1)
	if arg1.mediator == NotificationMediator then
		arg0:Update()
	end
end

function var0.OnUpdateChatMsg(arg0)
	arg0:Update()
end

function var0.Init(arg0)
	arg0:Update()
end

function var0.Refresh(arg0)
	arg0:Update()
end

function var0.Update(arg0)
	if arg0.hideChatFlag and arg0.hideChatFlag == 1 then
		return
	end

	local var0 = getProxy(ChatProxy):GetAllTypeChatMessages(arg0.MAX_COUNT)

	arg0:UpdateMessages(var0)
end

function var0.InstantiateMsgTpl(arg0, arg1)
	for iter0 = #arg0.items + 1, arg1 do
		local var0 = Object.Instantiate(arg0.items[1], arg0.items[1].parent)

		table.insert(arg0.items, var0)
	end

	for iter1 = #arg0.items, arg1 + 1, -1 do
		setActive(arg0.items[iter1], false)
	end
end

function var0.UpdateMessages(arg0, arg1)
	arg0:InstantiateMsgTpl(#arg1)

	for iter0 = 1, #arg1 do
		local var0 = arg0.items[iter0]
		local var1 = arg1[iter0]
		local var2 = var0.sizeDelta.y + 14
		local var3 = arg0.tplInitPosY - (iter0 - 1) * var2

		var0.anchoredPosition = Vector2(var0.anchoredPosition.x, var3)

		arg0:UpdateMessage(var0, var1)
	end

	local var4 = PLATFORM_CODE == PLATFORM_JP and #arg1 <= 0 and "ログはありません" or ""

	arg0.empty.text = var4
end

function var0.UpdateMessage(arg0, arg1, arg2)
	setActive(arg1, true)

	findTF(arg1, "channel"):GetComponent("Image").sprite = GetSpriteFromAtlas("channel", ChatConst.GetChannelSprite(arg2.type) .. "_1920")

	local var0 = findTF(arg1, "text"):GetComponent("RichText")

	if arg2.type == ChatConst.ChannelPublic then
		var0.supportRichText = true

		ChatProxy.InjectPublic(var0, arg2, true)
	elseif arg2:IsWorldBossNotify() then
		var0.supportRichText = true

		local var1 = arg2.args.playerName
		local var2 = arg2.args.bossName
		local var3 = GetPerceptualSize(var1 .. var2) - 18

		if var3 > 0 then
			local var4 = GetPerceptualSize(var2) - var3

			var2 = shortenString(var2, var4)
		end

		var0.text = i18n("ad_4", arg2.args.supportType, var1, var2, arg2.args.level)
	else
		var0.supportRichText = arg2.emojiId ~= nil
		var0.text = arg0:MatchEmoji(var0, arg2)
	end
end

function var0.MatchEmoji(arg0, arg1, arg2)
	local var0 = false
	local var1 = arg2.player.name .. ": " .. arg2.content
	local var2 = false

	for iter0 in string.gmatch(var1, ChatConst.EmojiIconCodeMatch) do
		if table.contains(pg.emoji_small_template.all, tonumber(iter0)) then
			var2 = true

			local var3 = pg.emoji_small_template[tonumber(iter0)]
			local var4 = LoadSprite("emoji/" .. var3.pic .. "_small", nil)

			arg1:AddSprite(iter0, var4)
		end
	end

	if not arg2.emojiId then
		var1 = var2 and shortenString(var1, 16) or shortenString(var1, 20)
	end

	return (string.gsub(var1, ChatConst.EmojiIconCodeMatch, function(arg0)
		if table.contains(pg.emoji_small_template.all, tonumber(arg0)) then
			return string.format("<icon name=%s w=0.7 h=0.7/>", arg0)
		end
	end))
end

function var0.Clear(arg0)
	for iter0, iter1 in ipairs(arg0.items) do
		setActive(iter1, false)
	end
end

function var0.GetDirection(arg0)
	return Vector2(1, 0)
end

return var0
