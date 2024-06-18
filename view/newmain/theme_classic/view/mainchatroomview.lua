local var0_0 = class("MainChatRoomView", import("...base.MainBaseView"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	local var0_1 = arg1_1:Find("item")

	arg0_1.items = {
		var0_1
	}
	arg0_1.tplInitPosY = var0_1.anchoredPosition.y
	arg0_1.MAX_COUNT = 4
	arg0_1.enableBtn = arg1_1:Find("enable")
	arg0_1.disableBtn = arg1_1:Find("disable")
	arg0_1.btn = arg1_1:GetComponent(typeof(Button))
	arg0_1.empty = arg1_1:Find("empty"):GetComponent(typeof(Text))

	arg0_1:RegisterEvent(arg2_1)
end

function var0_0.RegisterEvent(arg0_2, arg1_2)
	arg0_2:bind(GAME.REMOVE_LAYERS, function(arg0_3, arg1_3)
		arg0_2:OnRemoveLayer(arg1_3.context)
	end)
	arg0_2:bind(GAME.ANY_CHAT_MSG_UPDATE, function(arg0_4)
		arg0_2:OnUpdateChatMsg()
	end)

	arg0_2.hideChatFlag = PlayerPrefs.GetInt(HIDE_CHAT_FLAG)

	onButton(arg0_2, arg0_2._tf, function()
		if not arg0_2.hideChatFlag or arg0_2.hideChatFlag ~= 1 then
			arg0_2:GoChatView()
		end
	end, SFX_MAIN)
	onButton(arg0_2, arg0_2.enableBtn, function()
		arg0_2:SwitchState()
	end, SFX_MAIN)
	onButton(arg0_2, arg0_2.disableBtn, function()
		arg0_2:SwitchState()
	end, SFX_MAIN)
	arg0_2:UpdateBtnState()
end

function var0_0.GoChatView(arg0_8)
	arg0_8:emit(NewMainMediator.OPEN_CHATVIEW)
end

function var0_0.SwitchState(arg0_9)
	local var0_9 = arg0_9.hideChatFlag and arg0_9.hideChatFlag == 1
	local var1_9 = var0_9 and "show_chat_warning" or "hide_chat_warning"

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n(var1_9),
		onYes = function()
			local var0_10 = var0_9 and 0 or 1

			PlayerPrefs.SetInt(HIDE_CHAT_FLAG, var0_10)

			arg0_9.hideChatFlag = PlayerPrefs.GetInt(HIDE_CHAT_FLAG)

			arg0_9:UpdateBtnState()
		end
	})
end

function var0_0.UpdateBtnState(arg0_11)
	local var0_11 = arg0_11.hideChatFlag and arg0_11.hideChatFlag == 1

	setActive(arg0_11.enableBtn, var0_11)
	setActive(arg0_11.disableBtn, not var0_11)

	if var0_11 then
		arg0_11:Clear()
	end

	arg0_11.btn.enabled = not var0_11
end

function var0_0.OnRemoveLayer(arg0_12, arg1_12)
	if arg1_12.mediator == NotificationMediator then
		arg0_12:Update()
	end
end

function var0_0.OnUpdateChatMsg(arg0_13)
	arg0_13:Update()
end

function var0_0.Init(arg0_14)
	arg0_14:Update()
end

function var0_0.Refresh(arg0_15)
	arg0_15:Update()
end

function var0_0.Update(arg0_16)
	if arg0_16.hideChatFlag and arg0_16.hideChatFlag == 1 then
		return
	end

	local var0_16 = getProxy(ChatProxy):GetAllTypeChatMessages(arg0_16.MAX_COUNT)

	arg0_16:UpdateMessages(var0_16)
end

function var0_0.InstantiateMsgTpl(arg0_17, arg1_17)
	for iter0_17 = #arg0_17.items + 1, arg1_17 do
		local var0_17 = Object.Instantiate(arg0_17.items[1], arg0_17.items[1].parent)

		table.insert(arg0_17.items, var0_17)
	end

	for iter1_17 = #arg0_17.items, arg1_17 + 1, -1 do
		setActive(arg0_17.items[iter1_17], false)
	end
end

function var0_0.UpdateMessages(arg0_18, arg1_18)
	arg0_18:InstantiateMsgTpl(#arg1_18)

	for iter0_18 = 1, #arg1_18 do
		local var0_18 = arg0_18.items[iter0_18]
		local var1_18 = arg1_18[iter0_18]
		local var2_18 = var0_18.sizeDelta.y + 14
		local var3_18 = arg0_18.tplInitPosY - (iter0_18 - 1) * var2_18

		var0_18.anchoredPosition = Vector2(var0_18.anchoredPosition.x, var3_18)

		arg0_18:UpdateMessage(var0_18, var1_18)
	end

	local var4_18 = PLATFORM_CODE == PLATFORM_JP and #arg1_18 <= 0 and "ログはありません" or ""

	arg0_18.empty.text = var4_18
end

function var0_0.UpdateMessage(arg0_19, arg1_19, arg2_19)
	setActive(arg1_19, true)

	findTF(arg1_19, "channel"):GetComponent("Image").sprite = GetSpriteFromAtlas("channel", ChatConst.GetChannelSprite(arg2_19.type) .. "_1920")

	local var0_19 = findTF(arg1_19, "text"):GetComponent("RichText")

	if arg2_19.type == ChatConst.ChannelPublic then
		var0_19.supportRichText = true

		ChatProxy.InjectPublic(var0_19, arg2_19, true)
	elseif arg2_19:IsWorldBossNotify() then
		var0_19.supportRichText = true

		local var1_19 = arg2_19.args.playerName
		local var2_19 = arg2_19.args.bossName
		local var3_19 = GetPerceptualSize(var1_19 .. var2_19) - 18

		if var3_19 > 0 then
			local var4_19 = GetPerceptualSize(var2_19) - var3_19

			var2_19 = shortenString(var2_19, var4_19)
		end

		var0_19.text = i18n("ad_4", arg2_19.args.supportType, var1_19, var2_19, arg2_19.args.level)
	else
		var0_19.supportRichText = arg2_19.emojiId ~= nil
		var0_19.text = arg0_19:MatchEmoji(var0_19, arg2_19)
	end
end

function var0_0.MatchEmoji(arg0_20, arg1_20, arg2_20)
	local var0_20 = false
	local var1_20 = arg2_20.player.name .. ": " .. arg2_20.content
	local var2_20 = false

	for iter0_20 in string.gmatch(var1_20, ChatConst.EmojiIconCodeMatch) do
		if table.contains(pg.emoji_small_template.all, tonumber(iter0_20)) then
			var2_20 = true

			local var3_20 = pg.emoji_small_template[tonumber(iter0_20)]
			local var4_20 = LoadSprite("emoji/" .. var3_20.pic .. "_small", nil)

			arg1_20:AddSprite(iter0_20, var4_20)
		end
	end

	if not arg2_20.emojiId then
		var1_20 = var2_20 and shortenString(var1_20, 16) or shortenString(var1_20, 20)
	end

	return (string.gsub(var1_20, ChatConst.EmojiIconCodeMatch, function(arg0_21)
		if table.contains(pg.emoji_small_template.all, tonumber(arg0_21)) then
			return string.format("<icon name=%s w=0.7 h=0.7/>", arg0_21)
		end
	end))
end

function var0_0.Clear(arg0_22)
	for iter0_22, iter1_22 in ipairs(arg0_22.items) do
		setActive(iter1_22, false)
	end
end

function var0_0.GetDirection(arg0_23)
	return Vector2(1, 0)
end

return var0_0
