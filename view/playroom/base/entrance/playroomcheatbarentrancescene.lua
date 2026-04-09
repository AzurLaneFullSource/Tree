local var0_0 = class("PlayRoomCheatBarEntranceScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "IslandCheatBarEntranceUI"
end

function var0_0.init(arg0_2)
	setText(arg0_2.uiPointTipsText, i18n("match_ui_point"))
	setText(arg0_2.uiRoomText, i18n("match_ui_room_list"))
	setText(arg0_2.uiMatchText, i18n("match_ui_point_match"))
	onButton(arg0_2, arg0_2.uiCloseBtn, function()
		arg0_2:closeView()
	end, SPX_PANEL)
	onButton(arg0_2, arg0_2.uiRoomBtn, function()
		if getProxy(PlayRoomProxy):GetMatchFlag() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("match_ui_matching2"))

			return
		end

		arg0_2:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = PlayRoomMainScene,
			mediator = PlayRoomMainMediator,
			data = {
				gameType = arg0_2:GetGameType()
			}
		}))
	end, SPX_PANEL)
	onButton(arg0_2, arg0_2.uiMatchBtn, function()
		local var0_5 = getProxy(PlayRoomProxy)

		if var0_5:GetMatchFlag() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("match_ui_matching2"))

			return
		end

		local var1_5 = var0_5:GetMatchCD()

		if var1_5 > pg.TimeMgr.GetInstance():GetServerTime() then
			PlayRoomTools.ShowPunishementBox(var1_5)

			return
		end

		arg0_2:emit(PlayRoomEntranceMediator.ON_CLICK_MATCH, {
			type = PlayRoomConst.PLAY_ROOM_TYPE.MATCH,
			gameType = arg0_2:GetGameType()
		})
	end, SPX_PANEL)
	onButton(arg0_2, arg0_2.uiRankBtn, function()
		arg0_2:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = PlayRoomRankScene,
			mediator = PlayRoomRankMediator,
			data = {
				gameType = arg0_2:GetGameType()
			}
		}))
	end, SPX_PANEL)
	onButton(arg0_2, arg0_2.uiHelpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.island_help_bar.tip
		})
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiSwitchBtn, function()
		arg0_2:emit(PlayRoomEntranceMediator.ON_CLICK_CHANGE_CHARACTER)
	end, SPX_PANEL)
end

function var0_0.didEnter(arg0_9)
	setText(arg0_9.uiPointText, PlayRoomTools.GetPtScrore(arg0_9:GetGameType()))

	local var0_9 = PlayRoomTools.GetPtScoreIcon(arg0_9:GetGameType())

	GetImageSpriteFromAtlasAsync("Island/IslandCheaterTavernIcon/" .. var0_9, "", arg0_9.uiPointImage, true)

	if arg0_9.contextData.params and arg0_9.contextData.params.skipInit then
		arg0_9.contextData.params.skipInit = false
	else
		arg0_9:emit(PlayRoomEntranceMediator.REFRESH_ROOM_INFO)
	end

	local var1_9 = getProxy(PlayerProxy):getRawData().id

	if PlayerPrefs.GetInt("barHelp" .. var1_9, 0) == 0 then
		PlayerPrefs.SetInt("barHelp" .. var1_9, 1)
		triggerButton(arg0_9.uiHelpBtn)
	end

	local var2_9 = getProxy(PlayRoomProxy):GetMatchFlag()

	setActive(arg0_9.uiSwitchBtn, not var2_9)
end

function var0_0.willExit(arg0_10)
	return
end

function var0_0.GetGameType(arg0_11)
	return PlayRoomConst.GAME_TYPE.CHEATER_TAVERN
end

function var0_0.OnStartMatch(arg0_12)
	setActive(arg0_12.uiSwitchBtn, false)
end

function var0_0.OnStopMatch(arg0_13)
	setActive(arg0_13.uiSwitchBtn, true)
end

function var0_0.closeView(arg0_14)
	arg0_14.contextData.onClose()
end

function var0_0.onBackPressed(arg0_15)
	return
end

return var0_0
