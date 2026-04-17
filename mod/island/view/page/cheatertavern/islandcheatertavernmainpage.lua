local var0_0 = class("IslandCheaterTavernMainPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandCheaterTavernMainUI"
end

function var0_0.NeedCache(arg0_2)
	return false
end

function var0_0.CreateViews(arg0_3)
	arg0_3.views = {
		arg0_3:CreateCheaterTavernStartGameView(),
		arg0_3:CreateCheaterTavernInGamingView()
	}
end

function var0_0.GetSubView(arg0_4, arg1_4)
	for iter0_4, iter1_4 in ipairs(arg0_4.views) do
		if isa(iter1_4, arg1_4) then
			return iter1_4
		end
	end

	return nil
end

function var0_0.ExecuteAction(arg0_5, arg1_5, arg2_5)
	arg0_5:Load(arg2_5)
	arg0_5:ActionInvoke(arg1_5, arg2_5)

	arg0_5.initShow = true
end

function var0_0.CreateCheaterTavernStartGameView(arg0_6)
	local var0_6 = IslandCheaterTavernStartGameView.New(arg0_6.uiStartGamePanel)

	var0_6:attach(arg0_6)

	return var0_6
end

function var0_0.CreateCheaterTavernInGamingView(arg0_7)
	local var0_7 = IslandCheaterTavernInGamingView.New(arg0_7.uiInGamingPanel, arg0_7)

	var0_7:attach(arg0_7)

	return var0_7
end

function var0_0.OnLoaded(arg0_8)
	return
end

function var0_0.Preload(arg0_9, arg1_9)
	arg0_9.numDicCache = {}

	local var0_9 = 0

	for iter0_9 = 1, 10 do
		local var1_9 = iter0_9 % 10

		GetSpriteFromAtlasAsync("Island/IslandCheaterTavernIcon/" .. var1_9, "", function(arg0_10)
			arg0_9.numDicCache[var1_9] = arg0_10
			var0_9 = var0_9 + 1

			if var0_9 == 1 then
				arg1_9()
			end
		end)
	end
end

function var0_0.GetNumSpriteByIndex(arg0_11, arg1_11)
	local var0_11 = arg1_11 % 10

	return arg0_11.numDicCache[var0_11]
end

function var0_0.AddListeners(arg0_12)
	arg0_12:AddListener(GAME.ISLAND_CHEATER_FIRSTROND_START, arg0_12.OnCheaterEveryRoundStart)

	if not IslandCheaterTavernConst.putCardTest then
		arg0_12:AddListener(GAME.ISLAND_PLAYER_CHEATER_OPERATE_DONE, arg0_12.OnCheaterOperateDone)
		arg0_12:AddListener(GAME.ISLAND_CHEATER_OPERATE_DONE_NOTIFY, arg0_12.OnCheaterOperateDoneNotify)
		arg0_12:AddListener(GAME.ISLAND_CHEATER_END_SCORE_NOTIFY, arg0_12.OnCheaterEndScoreNotify)
		arg0_12:AddListener(GAME.ISLAND_CHEATER_REAL_END_NOTIFY, arg0_12.OnGameEndNotify)
		arg0_12:AddListener(CheaterTavernEvent.FINSH_PAGE_QUIT, arg0_12.OnCheaterFinishQuit)
		arg0_12:AddListener(GAME.ISLAND_CHEATER_DELEGATE_NOTIFY, arg0_12.OnCheaterDelegateNotify)
		arg0_12:AddListener(GAME.ISLAND_CHEATER_RECONNECT, arg0_12.OnCheaterReconected)
	end

	arg0_12:AddListener(ChatProxy.NEW_MSG, arg0_12.RefreshMessage)
	arg0_12:AddListener(FriendProxy.FRIEND_NEW_MSG, arg0_12.RefreshMessage)
	arg0_12:AddListener(GuildProxy.NEW_MSG_ADDED, arg0_12.RefreshMessage)
	arg0_12:AddListener(PlayRoomProxy.CHAT_MSG_UPDATE, arg0_12.RefreshMessage)
	arg0_12:AddListener(GAME.CHANGE_CHAT_ROOM_DONE, arg0_12.RefreshMessage)
	arg0_12:AddListener(IslandProxy.PRESS_BACK, arg0_12.OnPressBack)
end

function var0_0.RemoveListeners(arg0_13)
	arg0_13:RemoveListener(GAME.ISLAND_CHEATER_FIRSTROND_START, arg0_13.OnCheaterEveryRoundStart)

	if not IslandCheaterTavernConst.putCardTest then
		arg0_13:RemoveListener(GAME.ISLAND_PLAYER_CHEATER_OPERATE_DONE, arg0_13.OnCheaterOperateDone)
		arg0_13:RemoveListener(GAME.ISLAND_CHEATER_OPERATE_DONE_NOTIFY, arg0_13.OnCheaterOperateDoneNotify)
		arg0_13:RemoveListener(GAME.ISLAND_CHEATER_END_SCORE_NOTIFY, arg0_13.OnCheaterEndScoreNotify)
		arg0_13:RemoveListener(GAME.ISLAND_CHEATER_REAL_END_NOTIFY, arg0_13.OnGameEndNotify)
		arg0_13:RemoveListener(CheaterTavernEvent.FINSH_PAGE_QUIT, arg0_13.OnCheaterFinishQuit)
		arg0_13:RemoveListener(GAME.ISLAND_CHEATER_DELEGATE_NOTIFY, arg0_13.OnCheaterDelegateNotify)
		arg0_13:RemoveListener(GAME.ISLAND_CHEATER_RECONNECT, arg0_13.OnCheaterReconected)
	end

	arg0_13:RemoveListener(ChatProxy.NEW_MSG, arg0_13.RefreshMessage)
	arg0_13:RemoveListener(FriendProxy.FRIEND_NEW_MSG, arg0_13.RefreshMessage)
	arg0_13:RemoveListener(GuildProxy.NEW_MSG_ADDED, arg0_13.RefreshMessage)
	arg0_13:RemoveListener(PlayRoomProxy.CHAT_MSG_UPDATE, arg0_13.RefreshMessage)
	arg0_13:RemoveListener(GAME.CHANGE_CHAT_ROOM_DONE, arg0_13.RefreshMessage)
	arg0_13:RemoveListener(IslandProxy.PRESS_BACK, arg0_13.OnPressBack)
end

function var0_0.OnCheaterFinishQuit(arg0_14)
	arg0_14:Hide()
	arg0_14:emit(IslandMediator.PLAY_ROOM_MATCH_STOP)
	getProxy(PlayRoomProxy):SetPlayingGameState(false)
	IslandCheaterTavernRecordTools.RecordResult(IslandCheaterTavernRecordTools.LEAVE)
end

function var0_0.OnCheaterEndScoreNotify(arg0_15)
	arg0_15:GetSubView(IslandCheaterTavernInGamingView):DestroyMainCard()

	arg0_15.isFinish = true

	arg0_15:emit(IslandMediator.OPEN_PAGE, "IslandCheaterTavernFinishPage", {
		IslandCheaterTavernConst.SettlementType.ByScore
	})
end

function var0_0.OnGameEndNotify(arg0_16, arg1_16)
	local var0_16 = arg0_16:GetIsland():GetCheaterTavernAgency()
	local var1_16 = arg1_16.win_user
	local var2_16 = var1_16 == getProxy(PlayerProxy):getRawData().id
	local var3_16 = var0_16:GetPlayerData(var1_16)

	arg0_16:emitCore(CheaterTavernEvent.PLAY_WIN_ANIMATION, var1_16, var2_16, var3_16.seat)

	if var2_16 then
		return
	end

	if arg0_16:GetPage(IslandCheaterTavernFinishPage) then
		return
	end

	arg0_16:emit(IslandMediator.OPEN_PAGE, "IslandCheaterTavernFinishPage", {
		IslandCheaterTavernConst.SettlementType.ByFinal
	})
end

function var0_0.OnCheaterDelegateNotify(arg0_17)
	arg0_17:GetSubView(IslandCheaterTavernInGamingView):UpdateDelegateState()
end

function var0_0.OnCheaterOperateDoneNotify(arg0_18, arg1_18)
	arg0_18:GetSubView(IslandCheaterTavernInGamingView):OnCheaterOperateDoneNotify(arg1_18)
end

function var0_0.OnCheaterOperateDone(arg0_19, arg1_19)
	arg0_19:GetSubView(IslandCheaterTavernInGamingView):OnCheaterOperateDone(arg1_19)
end

function var0_0.OnCheaterReconected(arg0_20, arg1_20)
	arg0_20:GetSubView(IslandCheaterTavernInGamingView):OnCheaterReconected(arg1_20.operation)
end

function var0_0.OnCheaterEveryRoundStart(arg0_21, arg1_21)
	for iter0_21, iter1_21 in ipairs(arg0_21.views) do
		iter1_21:OnCheaterEveryRoundStart()
	end

	arg0_21.animation:Play("Anim_IslandCheaterTavernMainUI_in")
	arg0_21:RemoveEveryRondStartTimer()

	local var0_21 = pg.gameset.bar_showcard_time.key_value

	arg0_21.everyRondStartTimer = Timer.New(function()
		for iter0_22, iter1_22 in ipairs(arg0_21.views) do
			iter1_22:OnCheaterEveryRoundStartDone(arg1_21.operation)
		end
	end, var0_21, 1)

	arg0_21.everyRondStartTimer:Start()
end

function var0_0.RemoveEveryRondStartTimer(arg0_23)
	if arg0_23.everyRondStartTimer then
		arg0_23.everyRondStartTimer:Stop()
	end
end

function var0_0.OnInit(arg0_24)
	onButton(arg0_24, arg0_24.uicloseBtn, function()
		arg0_24:OnClickCloseBtn()
	end, SFX_PANEL)
	onButton(arg0_24, arg0_24.uiSenderPanel, function()
		arg0_24:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = PlayRoomNotificationLayer,
			mediator = PlayRoomNotificationMediator,
			data = {
				inRoom = true
			}
		}))
	end, SFX_PANEL)
	onButton(arg0_24, arg0_24.uiHelpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.island_help_bar.tip
		})
	end, SFX_PANEL)

	arg0_24.animation = arg0_24.uiAdapt:GetComponent(typeof(Animation))
end

function var0_0.OnShow(arg0_28, arg1_28, arg2_28)
	arg0_28.isFinish = false

	arg0_28:CreateViews()
	arg0_28:GetSubView(IslandCheaterTavernInGamingView):SetActiveState(false)
	arg0_28:GetSubView(IslandCheaterTavernStartGameView):SetActiveState(false)
	arg0_28:Flush()
	arg0_28:RefreshMessage()

	for iter0_28, iter1_28 in ipairs(arg0_28.views) do
		iter1_28:Init()
	end
end

function var0_0.Flush(arg0_29)
	return
end

function var0_0.OnDestroy(arg0_30)
	arg0_30:OnHide()
	var0_0.super.OnDestroy(arg0_30)
end

function var0_0.OnHide(arg0_31)
	arg0_31:GetIsland():GetCheaterTavernAgency():SetUILoadOver(false)
	arg0_31:RemoveEveryRondStartTimer()

	for iter0_31, iter1_31 in ipairs(arg0_31.views) do
		iter1_31:Hide()
	end
end

function var0_0.RefreshMessage(arg0_32)
	arg0_32:GetMessages()

	local var0_32 = arg0_32.displays

	setActive(arg0_32.uiChatItemGo, #var0_32 > 0)

	if #var0_32 <= 0 then
		return
	end

	local var1_32 = var0_32[#var0_32]

	arg0_32.uiChannelImage.sprite = GetSpriteFromAtlas("channel", ChatConst.GetChannelSprite(var1_32.type) .. "_mel")

	local var2_32 = arg0_32.uiChatText:GetComponent("RichText")

	if var1_32.type == ChatConst.ChannelPublic then
		var2_32.supportRichText = true

		ChatProxy.InjectPublic(var2_32, var1_32, true)
	elseif var1_32:IsWorldBossNotify() then
		var2_32.supportRichText = true

		local var3_32 = var1_32.args.playerName
		local var4_32 = var1_32.args.bossName
		local var5_32 = GetPerceptualSize(var3_32 .. var4_32) - 18

		if var5_32 > 0 then
			local var6_32 = GetPerceptualSize(var4_32) - var5_32

			var4_32 = shortenString(var4_32, var6_32)
		end

		var2_32.text = i18n("ad_4", var1_32.args.supportType, var3_32, var4_32, var1_32.args.level)
	else
		var2_32.supportRichText = var1_32.emojiId ~= nil
		var2_32.text = arg0_32:MatchEmoji(var2_32, var1_32)
	end
end

function var0_0.MatchEmoji(arg0_33, arg1_33, arg2_33)
	local var0_33 = false
	local var1_33 = arg2_33.player.name .. ": " .. arg2_33.content
	local var2_33 = false

	for iter0_33 in string.gmatch(var1_33, ChatConst.EmojiIconCodeMatch) do
		if table.contains(pg.emoji_small_template.all, tonumber(iter0_33)) then
			var2_33 = true

			local var3_33 = pg.emoji_small_template[tonumber(iter0_33)]
			local var4_33 = LoadSprite("emoji/" .. var3_33.pic .. "_small", nil)

			arg1_33:AddSprite(iter0_33, var4_33)
		end
	end

	if not arg2_33.emojiId then
		var1_33 = var2_33 and shortenString(var1_33, 16) or shortenString(var1_33, 20)
	end

	return (string.gsub(var1_33, ChatConst.EmojiIconCodeMatch, function(arg0_34)
		if table.contains(pg.emoji_small_template.all, tonumber(arg0_34)) then
			return string.format("<icon name=%s w=0.7 h=0.7/>", arg0_34)
		end
	end))
end

function var0_0.GetMessages(arg0_35)
	arg0_35.displays = {}

	local var0_35 = getProxy(ChatProxy)

	_.each(var0_35:getRawData(), function(arg0_36)
		arg0_35:InsertMsg(arg0_35.displays, arg0_36)
	end)

	local var1_35 = getProxy(GuildProxy)

	if var1_35:getRawData() then
		_.each(var1_35:getChatMsgs(), function(arg0_37)
			arg0_35:InsertMsg(arg0_35.displays, arg0_37)
		end)
	end

	local var2_35 = getProxy(FriendProxy)

	_.each(var2_35:getCacheMsgList(), function(arg0_38)
		arg0_35:InsertMsg(arg0_35.displays, arg0_38)
	end)
	_.each(getProxy(PlayRoomProxy):GetChatMsgs(), function(arg0_39)
		arg0_35:InsertMsg(arg0_35.displays, arg0_39)
	end)
	table.sort(arg0_35.displays, function(arg0_40, arg1_40)
		return arg0_40.timestamp < arg1_40.timestamp
	end)
end

function var0_0.InsertMsg(arg0_41, arg1_41, arg2_41)
	if getProxy(FriendProxy):isInBlackList(arg2_41.playerId) then
		return
	end

	if arg2_41.player and arg2_41.content then
		table.insert(arg1_41, arg2_41)
	end
end

function var0_0.OnClickCloseBtn(arg0_42)
	local var0_42 = {}
	local var1_42 = getProxy(PlayRoomProxy):GetRoomData()

	if not arg0_42.isFinish then
		if var1_42.roomType == PlayRoomConst.PLAY_ROOM_TYPE.MATCH then
			table.insert(var0_42, function(arg0_43)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("bar_tips_game6"),
					onYes = arg0_43
				})
			end)
		else
			table.insert(var0_42, function(arg0_44)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("bar_tips_game7"),
					onYes = arg0_44
				})
			end)
		end
	end

	seriesAsync(var0_42, function()
		arg0_42:Hide()
		arg0_42:emit(IslandMediator.PLAY_ROOM_MATCH_STOP)
		getProxy(PlayRoomProxy):SetPlayingGameState(false)
		IslandCheaterTavernRecordTools.RecordResult(IslandCheaterTavernRecordTools.LEAVE)
	end)
end

function var0_0.OnPressBack(arg0_46)
	arg0_46:OnClickCloseBtn()
end

return var0_0
