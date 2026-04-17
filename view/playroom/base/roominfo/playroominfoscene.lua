local var0_0 = class("PlayRoomInfoScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "IslandPlayRoomInfoUI"
end

function var0_0.init(arg0_2)
	arg0_2:InitData()
	onButton(arg0_2, arg0_2.uiCloseBtn, function()
		arg0_2:OnClickCloseBtn()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiViewerBtn, function()
		arg0_2:emit(PlayRoomInfoMediator.ON_CLICK_VIEWER)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiReadyBtn, function()
		arg0_2:emit(PlayRoomInfoMediator.ON_CLICK_READY, {
			arg = 1
		})
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiCancelReadyBtn, function()
		arg0_2:emit(PlayRoomInfoMediator.ON_CLICK_READY, {
			arg = 0
		})
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiStartBtn, function()
		if not PlayRoomTools.CanStartGame() then
			return
		end

		local var0_7 = {}

		if not PlayRoomTools.IsPlayerFull() then
			table.insert(var0_7, function(arg0_8)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("island_bar_quick_addbot"),
					onYes = arg0_8
				})
			end)
		end

		seriesAsync(var0_7, function()
			arg0_2:emit(PlayRoomInfoMediator.ON_CLICK_START_GAME)
		end)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiRoomSwitchBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("play_room_switch_tip"),
			onYes = function()
				arg0_2:emit(PlayRoomInfoMediator.ON_SWITCH_ROOM_TYPE)
			end
		})
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiSenderPanel, function()
		arg0_2:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = PlayRoomNotificationLayer,
			mediator = PlayRoomNotificationMediator,
			data = {
				inRoom = true
			}
		}))
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiAcceptBtn, function()
		arg0_2:emit(PlayRoomInfoMediator.ON_MATCH_CLICK_READY, {
			arg = 1
		})
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiCopyBtn, function()
		local var0_14 = arg0_2.playRoomProxy:GetRoomData().teamList

		UniPasteBoard.SetClipBoardString(var0_14[1])
		pg.TipsMgr.GetInstance():ShowTips(i18n("friend_id_copy_ok"))
	end, SFX_PANEL)

	arg0_2.playerItemList = {}

	local var0_2 = getProxy(PlayRoomProxy):GetRoomData()

	if var0_2 then
		for iter0_2 = 1, PlayRoomTools.GetMaxTeamCnt(var0_2.gameType) do
			arg0_2.playerItemList[iter0_2] = PlayRoomInfoPlayerItem.New(Object.Instantiate(arg0_2.uiPlayerItem, arg0_2.uiPlayerPanel), arg0_2)
		end
	end

	setText(arg0_2.uiReadyText, i18n("match_ui_room_ready1"))
	setText(arg0_2.uiCancelReadyText, i18n("match_ui_room_ready2"))
	setText(arg0_2.uiStartText, i18n("match_ui_room_startgame"))
	setText(arg0_2.uiAcceptText, i18n("match_ui_accept"))
	setText(arg0_2.uiMatchText, i18n("match_ui_matching"))
	setText(arg0_2.uiLoadText, i18n("match_ui_matching_loading"))
end

function var0_0.InitData(arg0_15)
	arg0_15.sceneRoomType = arg0_15.contextData.sceneRoomType
end

function var0_0.didEnter(arg0_16)
	arg0_16.playRoomProxy = getProxy(PlayRoomProxy)

	if arg0_16.playRoomProxy:GetRoomData() == nil then
		arg0_16.uiCloseBtn.onClick:Invoke()

		return
	end

	arg0_16:InitUIDisplay()

	if arg0_16.sceneRoomType == IslandCheaterTavernConst.SceneRoomType.CustomRoom then
		arg0_16:RefreshUI()
	elseif arg0_16.sceneRoomType == IslandCheaterTavernConst.SceneRoomType.MatchInfoRoom then
		arg0_16:RefreshMatchInfoUI()
	else
		arg0_16:RefreshLoadInfoUI()
	end

	arg0_16:RefreshMessage()
end

function var0_0.InitUIDisplay(arg0_17)
	local var0_17 = arg0_17.sceneRoomType == IslandCheaterTavernConst.SceneRoomType.CustomRoom

	setActive(arg0_17.uiImage_2, var0_17)
	setActive(arg0_17.uiAcceptPanel, not var0_17)
	setActive(arg0_17.uiSenderPanel, var0_17)
	setActive(arg0_17.uiBtnList, var0_17)
	setActive(arg0_17.uiViewerBtn, false)
	setActive(arg0_17.uiloadPanel, false)

	arg0_17.isLoading = false

	if arg0_17.sceneRoomType == IslandCheaterTavernConst.SceneRoomType.CustomRoom then
		-- block empty
	elseif arg0_17.sceneRoomType == IslandCheaterTavernConst.SceneRoomType.MatchInfoRoom then
		setText(arg0_17.uiTitleText, i18n("match_ui_point_match"))
	end
end

function var0_0.willExit(arg0_18)
	for iter0_18, iter1_18 in ipairs(arg0_18.playerItemList) do
		iter1_18:willExit()
	end

	arg0_18.playerItemList = nil

	arg0_18:StopLeanTween()
	arg0_18:StopLoadLeanTween()
end

function var0_0.RefreshUI(arg0_19)
	local var0_19 = arg0_19.playRoomProxy:GetRoomData()
	local var1_19 = var0_19.roomType
	local var2_19 = var0_19.playerDataList
	local var3_19 = var0_19.teamList
	local var4_19 = PlayRoomTools.GetHostID()

	if var1_19 == PlayRoomConst.PLAY_ROOM_TYPE.PERSON then
		setText(arg0_19.uiTitleText, i18n("match_ui_room_filter6"))
	else
		setText(arg0_19.uiTitleText, i18n("match_ui_room_filter5"))
	end

	setText(arg0_19.uiIdText, var4_19)
	setText(arg0_19.uiViewerText, i18n("play_room_viewer_tip", #var0_19.viewerList, PlayRoomTools.GetMaxViewerCnt(var0_19.gameType)))

	local var5_19 = getProxy(PlayerProxy):getPlayerId()
	local var6_19 = var4_19 == var5_19

	setActive(arg0_19.uiStartBtn, var6_19)
	setActive(arg0_19.uiRoomSwitchBtn, var6_19)

	local var7_19 = PlayRoomTools.IsViewer()

	setActive(arg0_19.uiBtnList, not var7_19)

	if not var7_19 then
		local var8_19 = table.contains(var0_19.readyList, var5_19)

		setActive(arg0_19.uiReadyBtn, not var8_19 and not var6_19)
		setActive(arg0_19.uiCancelReadyBtn, var8_19 and not var6_19)
	end

	arg0_19:RefreshPlayerList()
	setGray(arg0_19.uiStartBtn, not PlayRoomTools.CanStartGame(), true)
end

function var0_0.RefreshPlayerList(arg0_20)
	local var0_20 = arg0_20.playRoomProxy:GetRoomData()
	local var1_20 = var0_20.teamPosList
	local var2_20 = getProxy(PlayerProxy):getPlayerId()

	for iter0_20, iter1_20 in ipairs(arg0_20.playerItemList) do
		if var1_20[iter0_20] then
			local var3_20 = var1_20[iter0_20][1]
			local var4_20 = table.contains(var0_20.readyList, var2_20)

			iter1_20:didEnter(var0_20.playerDataList[var3_20], PlayRoomTools.GetHostID(), arg0_20.sceneRoomType, var4_20)
		end
	end
end

function var0_0.OnClickCloseBtn(arg0_21)
	if arg0_21.isLoading then
		return
	end

	if arg0_21.sceneRoomType == IslandCheaterTavernConst.SceneRoomType.MatchInfoRoom then
		arg0_21:emit(PlayRoomInfoMediator.ON_MATCH_CLICK_READY, {
			arg = 0
		})
	end

	arg0_21:emit(PlayRoomInfoMediator.ON_CLICK_CLOSE, {
		sceneRoomType = arg0_21.sceneRoomType
	})
end

function var0_0.closeView(arg0_22)
	arg0_22.contextData.onClose()
end

function var0_0.RefreshMatchInfoUI(arg0_23)
	arg0_23:RefreshMatchInfoPlayerList()

	local var0_23 = arg0_23.playRoomProxy:GetMatchRoomData()

	if not var0_23 then
		return
	end

	local var1_23 = getProxy(PlayerProxy):getPlayerId()

	if table.contains(var0_23.readyList, var1_23) then
		arg0_23:StopLeanTween()
		arg0_23:ShowTimePanel(false)
	else
		arg0_23:ShowTimePanel(true)
		arg0_23:StartLeanTween(pg.TimeMgr.GetInstance():GetServerTime(), arg0_23.playRoomProxy:GetMatchRoomData().endTimestamp)
	end

	setActive(arg0_23.uiRoomSwitchBtn, false)
end

function var0_0.RefreshMatchInfoPlayerList(arg0_24)
	local var0_24 = arg0_24.playRoomProxy:GetMatchRoomData()

	if not var0_24 then
		return
	end

	local var1_24 = var0_24.teamPosList
	local var2_24 = getProxy(PlayerProxy):getPlayerId()

	for iter0_24, iter1_24 in ipairs(arg0_24.playerItemList) do
		local var3_24 = var1_24[iter0_24][1]
		local var4_24 = table.contains(var0_24.readyList, var2_24)

		iter1_24:didEnter(var0_24.playerDataList[var3_24], nil, arg0_24.sceneRoomType, var4_24)
	end
end

function var0_0.StartLeanTween(arg0_25, arg1_25, arg2_25)
	arg0_25:StopLeanTween()

	if arg2_25 <= arg1_25 then
		return
	end

	LeanTween.value(arg0_25._go, (arg2_25 - arg1_25) / pg.gameset.match_refuseCD.key_value, 0, arg2_25 - arg1_25):setOnUpdate(System.Action_float(function(arg0_26)
		arg0_25.uiSlider.value = arg0_26

		local var0_26 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1_26 = arg2_25 - var0_26

		setText(arg0_25.uiTimeText, string.format("%02d:%02d", math.floor(var1_26 / 60), var1_26 % 60))
	end)):setOnComplete(System.Action(function()
		arg0_25:OnClickCloseBtn()
		arg0_25:StopLeanTween()
	end))
end

function var0_0.StopLeanTween(arg0_28)
	LeanTween.cancel(arg0_28._go)
end

function var0_0.StartLoadLeanTween(arg0_29, arg1_29)
	arg0_29:StopLoadLeanTween()
	LeanTween.value(arg0_29._go, 0, 1, arg1_29):setOnUpdate(System.Action_float(function(arg0_30)
		arg0_29.uiLoadSlider.value = arg0_30

		for iter0_30, iter1_30 in ipairs(arg0_29.playerItemList) do
			iter1_30:RefreshSelfLoad(arg0_30 * 100)
		end
	end)):setOnComplete(System.Action(function()
		arg0_29:StopLoadLeanTween()
	end))
end

function var0_0.StopLoadLeanTween(arg0_32)
	LeanTween.cancel(arg0_32._go)
end

function var0_0.ShowTimePanel(arg0_33, arg1_33)
	setActive(arg0_33.uiAcceptPanel, arg1_33)
end

function var0_0.RefreshLoadInfoUI(arg0_34)
	local var0_34 = arg0_34.playRoomProxy:GetGameLoadData()

	if not var0_34 then
		return
	end

	local var1_34 = var0_34.teamPosList
	local var2_34 = getProxy(PlayerProxy):getPlayerId()
	local var3_34 = table.contains(var0_34.readyList, var2_34)

	for iter0_34, iter1_34 in ipairs(arg0_34.playerItemList) do
		local var4_34 = var1_34[iter0_34][1]

		iter1_34:didEnter(var0_34.playerDataList[var4_34], nil, arg0_34.sceneRoomType, var3_34, var0_34.loadList[var4_34])
	end

	setActive(arg0_34.uiSenderPanel, false)
	setActive(arg0_34.uiBtnList, false)
	arg0_34:StartLoadLeanTween(2)
end

function var0_0.EnterLoadInfoUI(arg0_35)
	arg0_35.uiLoadSlider.value = 0

	setActive(arg0_35.uiloadPanel, true)

	arg0_35.isLoading = true

	arg0_35:RefreshLoadInfoUI()
end

function var0_0.RefreshMessage(arg0_36)
	arg0_36:GetMessages()

	local var0_36 = arg0_36.displays

	setActive(arg0_36.uiChatItemGo, #var0_36 > 0)

	if #var0_36 <= 0 then
		return
	end

	local var1_36 = var0_36[#var0_36]

	arg0_36.uiChannelImage.sprite = GetSpriteFromAtlas("channel", ChatConst.GetChannelSprite(var1_36.type) .. "_mel")

	local var2_36 = arg0_36.uiChatText:GetComponent("RichText")

	if var1_36.type == ChatConst.ChannelPublic then
		var2_36.supportRichText = true

		ChatProxy.InjectPublic(var2_36, var1_36, true)
	elseif var1_36:IsWorldBossNotify() then
		var2_36.supportRichText = true

		local var3_36 = var1_36.args.playerName
		local var4_36 = var1_36.args.bossName
		local var5_36 = GetPerceptualSize(var3_36 .. var4_36) - 18

		if var5_36 > 0 then
			local var6_36 = GetPerceptualSize(var4_36) - var5_36

			var4_36 = shortenString(var4_36, var6_36)
		end

		var2_36.text = i18n("ad_4", var1_36.args.supportType, var3_36, var4_36, var1_36.args.level)
	else
		var2_36.supportRichText = var1_36.emojiId ~= nil
		var2_36.text = arg0_36:MatchEmoji(var2_36, var1_36)
	end
end

function var0_0.MatchEmoji(arg0_37, arg1_37, arg2_37)
	local var0_37 = false
	local var1_37 = arg2_37.player.name .. ": " .. arg2_37.content
	local var2_37 = false

	for iter0_37 in string.gmatch(var1_37, ChatConst.EmojiIconCodeMatch) do
		if table.contains(pg.emoji_small_template.all, tonumber(iter0_37)) then
			var2_37 = true

			local var3_37 = pg.emoji_small_template[tonumber(iter0_37)]
			local var4_37 = LoadSprite("emoji/" .. var3_37.pic .. "_small", nil)

			arg1_37:AddSprite(iter0_37, var4_37)
		end
	end

	if not arg2_37.emojiId then
		var1_37 = var2_37 and shortenString(var1_37, 16) or shortenString(var1_37, 20)
	end

	return (string.gsub(var1_37, ChatConst.EmojiIconCodeMatch, function(arg0_38)
		if table.contains(pg.emoji_small_template.all, tonumber(arg0_38)) then
			return string.format("<icon name=%s w=0.7 h=0.7/>", arg0_38)
		end
	end))
end

function var0_0.GetMessages(arg0_39)
	arg0_39.displays = {}

	local var0_39 = getProxy(ChatProxy)

	_.each(var0_39:getRawData(), function(arg0_40)
		arg0_39:InsertMsg(arg0_39.displays, arg0_40)
	end)

	local var1_39 = getProxy(GuildProxy)

	if var1_39:getRawData() then
		_.each(var1_39:getChatMsgs(), function(arg0_41)
			arg0_39:InsertMsg(arg0_39.displays, arg0_41)
		end)
	end

	local var2_39 = getProxy(FriendProxy)

	_.each(var2_39:getCacheMsgList(), function(arg0_42)
		arg0_39:InsertMsg(arg0_39.displays, arg0_42)
	end)
	_.each(getProxy(PlayRoomProxy):GetChatMsgs(), function(arg0_43)
		arg0_39:InsertMsg(arg0_39.displays, arg0_43)
	end)
	table.sort(arg0_39.displays, function(arg0_44, arg1_44)
		return arg0_44.timestamp < arg1_44.timestamp
	end)
end

function var0_0.InsertMsg(arg0_45, arg1_45, arg2_45)
	if getProxy(FriendProxy):isInBlackList(arg2_45.playerId) then
		return
	end

	if arg2_45.player and arg2_45.content then
		table.insert(arg1_45, arg2_45)
	end
end

function var0_0.onBackPressed(arg0_46)
	arg0_46:OnClickCloseBtn()
end

return var0_0
