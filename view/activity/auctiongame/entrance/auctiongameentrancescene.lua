local var0_0 = class("AuctionGameEntranceScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "AuctionGameEntranceUI"
end

function var0_0.init(arg0_2)
	setText(arg0_2.uiAuctionValueTitleText, i18n("auction_value"))
	setText(arg0_2.uiAuctionTicketTitleText, i18n("auction_ticket"))
	setText(arg0_2.uiAuctionMatchingText, i18n("auction_matching"))
	setText(arg0_2.uiAuctionAssistantText, i18n("auction_assistant"))
	setText(arg0_2.uiPreorderEndText, i18n("auction_activity_closed"))
	setText(arg0_2.uiReliefText, i18n("auction_relief_tip"))

	arg0_2.matchEventCom = GetComponent(arg0_2.uiMatchBtn, typeof(DftAniEvent))

	arg0_2.matchEventCom:SetEndEvent(function(arg0_3)
		arg0_2.startMatch = false

		arg0_2:emit(PlayRoomCommonMediator.ON_CLICK_QUICK_MATCH, {
			type = pg.auction_session[arg0_2.curSelectedID].game_type
		})
	end)
	onButton(arg0_2, arg0_2.uiBackBtn, function()
		arg0_2:onBackPressed()
	end, SOUND_BACK)
	onButton(arg0_2, arg0_2.uiHelpBtn, function()
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildAuctionHelp())
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.auction_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiCollectionBtn, function()
		arg0_2:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = AuctionGameCollectionListLayer,
			mediator = AuctionGameCollectionListMediator
		}))
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiTaskBtn, function()
		if not arg0_2.quickMatchSuccess and arg0_2.startQuickMatch == true then
			arg0_2:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
				viewComponent = AuctionGameMainMsgLayer,
				mediator = AuctionGameMainMsgMediator,
				data = {
					content = i18n("auction_main_match_exit"),
					comformCallback = function()
						arg0_2:OnClickStopQuickMatch()
						arg0_2:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
							viewComponent = AuctionGameTaskScene,
							mediator = AuctionGameTaskMediator,
							data = {}
						}))
					end,
					cancelCallback = function()
						return
					end
				}
			}))
		else
			arg0_2:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
				viewComponent = AuctionGameTaskScene,
				mediator = AuctionGameTaskMediator,
				data = {}
			}))
		end
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiPreorderBtn, function()
		if arg0_2.startQuickMatch == true then
			return
		end

		getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_AUCTION_GAME):SetPreorderTip()
		arg0_2:RefreshPreorderTip()

		local var0_10 = getProxy(AuctionGameBaseProxy)
		local var1_10 = AuctionGameTools.GetPreorderCurrentyCnt()

		if var1_10 > AuctionGameTools.GetCurrencyCnt() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("auction_currency_noenough"))

			return
		end

		arg0_2:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = AuctionGameMainMsgLayer,
			mediator = AuctionGameMainMsgMediator,
			data = {
				content = i18n("auction_preorder_tips", var1_10),
				comformCallback = function()
					arg0_2:emit(AuctionGameEntranceMediator.CLICK_PREORDER_BOX)
				end,
				cancelCallback = function()
					return
				end
			}
		}))
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiOpenPreorderBtn, function()
		if arg0_2.startQuickMatch == true then
			return
		end

		local var0_13 = getProxy(AuctionGameBaseProxy)
		local var1_13 = var0_13:GetPreorderState()
		local var2_13 = var0_13:GetPreorderTimestamp()
		local var3_13 = pg.TimeMgr.GetInstance():GetServerTime()

		if var1_13 == 1 and var3_13 < var2_13 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("auction_preorder_tips_1"))

			return
		end

		arg0_2:emit(AuctionGameEntranceMediator.CLICK_OPEN_BOX)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiMatchBtn, function()
		if arg0_2.startMatch == true then
			return
		end

		if not pg.NewStoryMgr.GetInstance():IsPlayed("AUCTION_GUIDE_6") then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.AUCTION_GAME_MAIN_GUIDE)

			return
		end

		local var0_14 = getProxy(AuctionGameBaseProxy)

		if var0_14.serverForbidden == 1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("auction_game_match_forbidden"))

			return
		end

		if var0_14.isForbidden == 1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("auction_game_match_forbidden"))

			return
		end

		if var0_14.inactiveNum == 1 and var0_14.isMatchWarning == 0 then
			arg0_2:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
				viewComponent = AuctionGameMainMsgLayer,
				mediator = AuctionGameMainMsgMediator,
				data = {
					content = i18n("auction_game_match_warning"),
					comformCallback = function()
						return
					end,
					cancelCallback = function()
						return
					end
				}
			}))
			arg0_2:emit(AuctionGameEntranceMediator.SHOW_WARNING_TIP)
		end

		if AuctionGameTools.GetCurrencyCnt() < pg.auction_session[arg0_2.lastSelectedID].threshold then
			pg.TipsMgr.GetInstance():ShowTips(i18n("auction_currency_noenough"))

			return
		end

		arg0_2.curSelectedID = arg0_2.lastSelectedID
		arg0_2.startMatch = true

		quickPlayAnimation(arg0_2.uiMatchBtn, "Anim_AuctionGameEntranceUI_matchBtn_click")
	end, AuctionGameConst.SOUND_EFFECT.START_MATCHING)
	onButton(arg0_2, arg0_2.uiCancelMatchBtn, function()
		arg0_2:OnClickStopQuickMatch()
	end, AuctionGameConst.SOUND_EFFECT.CANCEL_MATCHING)
	onButton(arg0_2, arg0_2.uiReliefBtn, function()
		local var0_18 = getProxy(AuctionGameBaseProxy)
		local var1_18 = pg.gameset.auction_relief_payment_count.key_value

		arg0_2:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = AuctionGameMainMsgLayer,
			mediator = AuctionGameMainMsgMediator,
			data = {
				content = i18n("auction_relief_tip_2", var1_18 - var0_18.reliefCnt, var1_18),
				comformCallback = function()
					arg0_2:emit(AuctionGameEntranceMediator.CLICK_GET_RELIEF)
				end,
				cancelCallback = function()
					return
				end
			}
		}))
	end, SFX_PANEL)

	arg0_2.paintingPanelView = AuctionGameEntrancePaintingPanel.New(arg0_2.uiLeftPanel, arg0_2)
	arg0_2.locationItemList = {}

	for iter0_2, iter1_2 in ipairs(pg.auction_session.all) do
		if pg.auction_session[iter1_2].game_type ~= 0 then
			table.insert(arg0_2.locationItemList, AuctionGameEntranceLocationItem.New(arg0_2[string.format("uiLocationTf%s", #arg0_2.locationItemList + 1)], arg0_2, iter1_2))
		end
	end

	arg0_2.playerPanelView = AuctionGamePlayerPanel.New(arg0_2.uiPlayerInfo, arg0_2)
end

function var0_0.didEnter(arg0_21)
	Screen.sleepTimeout = SleepTimeout.NeverSleep

	arg0_21:OverlayPanel(arg0_21.uiAdaptTf, {
		pbList = {
			arg0_21.uiLocationInfoTf
		}
	})
	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildAuctionEnter())
	arg0_21:OnClickStopQuickMatch()
	arg0_21.paintingPanelView:didEnter()
	arg0_21.playerPanelView:didEnter()

	arg0_21.lastSelectedID = AuctionGameTools.GetLastLocationSelectedID()
	arg0_21.eventList = {
		arg0_21:bind(AuctionGameEntranceLocationItem.SELECTED_LOCATION, handler(arg0_21, arg0_21.OnSelectedLocation))
	}

	arg0_21:RefreshUI()

	local var0_21 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_AUCTION_GAME)

	pg.SystemGuideMgr.GetInstance():PlayByGuideId("AUCTION_GUIDE_1", {
		var0_21:GetTaskTip() and 1 or 0
	}, nil, true)

	if pg.NewStoryMgr.GetInstance():IsPlayed("AUCTION_GUIDE_6") then
		pg.SystemGuideMgr.GetInstance():PlayByGuideId("AUCTION_GUIDE_3")
	end

	arg0_21:RefreshRelief()
end

function var0_0.RefreshUI(arg0_22)
	arg0_22:RefreshLocationList()
	arg0_22:RefreshPreorderBtn()
	arg0_22:RefreshTaskTip()
	arg0_22:RefreshPreorderTip()
	arg0_22:RefreshOpenPreorderTip()
	arg0_22:RefreshForbidden()
	arg0_22:ShowWarning()
end

function var0_0.OnUpdateCurrency(arg0_23)
	arg0_23:RefreshLocationList()
	arg0_23:RefreshPreorderBtn()
	arg0_23.playerPanelView:didEnter()
	arg0_23:RefreshRelief()
	arg0_23:RefreshPreorderTip()
end

function var0_0.OnSelectedLocation(arg0_24, arg1_24, arg2_24)
	if arg2_24 == arg0_24.lastSelectedID then
		return
	end

	if arg0_24.startQuickMatch == true then
		return
	end

	AuctionGameTools.SetLastLocationSelectedID(arg2_24)

	arg0_24.lastSelectedID = arg2_24

	arg0_24:RefreshLocationList()
end

function var0_0.RefreshLocationList(arg0_25)
	for iter0_25, iter1_25 in ipairs(arg0_25.locationItemList) do
		iter1_25:didEnter(arg0_25.lastSelectedID)
	end

	local var0_25 = pg.auction_session[arg0_25.lastSelectedID]

	setText(arg0_25.uiAuctionValueText, var0_25.auction_value)

	local var1_25 = AuctionGameTools.GetCurrencyCnt() >= var0_25.ticket

	setText(arg0_25.uiAuctionTicketText, string.format("<color=%s>%s</color>", var1_25 and "#393a3c" or "#bf5050", StringHelper.ForamtNumberK(var0_25.ticket)))
end

function var0_0.FormatMatchDuration(arg0_26, arg1_26)
	arg1_26 = math.max(0, math.floor(arg1_26 or 0))

	local var0_26 = math.floor(arg1_26 / 60)
	local var1_26 = arg1_26 % 60

	return string.format("%02d:%02d", var0_26, var1_26)
end

function var0_0.OnQuickMatch(arg0_27)
	getProxy(AuctionGameProxy):InitGameData(arg0_27.curSelectedID)

	arg0_27.startQuickMatch = true
	arg0_27.startTime = pg.TimeMgr.GetInstance():GetServerTime()

	arg0_27:AddMatchTimer()
	setActive(arg0_27.uiMatchTimeGo, true)
	setActive(arg0_27.uiCancelMatchBtn, true)
	setActive(arg0_27.uiMatchBtn, false)
	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildAuctionMatching(0, 0, arg0_27.curSelectedID))
end

function var0_0.OnClickStopQuickMatch(arg0_28)
	if arg0_28.startQuickMatch == true then
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildAuctionMatching(1, pg.TimeMgr.GetInstance():GetServerTime() - arg0_28.startTime, arg0_28.curSelectedID))
	end

	arg0_28:emit(PlayRoomCommonMediator.PLAY_ROOM_MATCH_STOP)
end

function var0_0.OnQuickMatchSuccess(arg0_29)
	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildAuctionMatching(2, pg.TimeMgr.GetInstance():GetServerTime() - arg0_29.startTime, arg0_29.curSelectedID))

	arg0_29.quickMatchSuccess = true

	local var0_29 = getProxy(AuctionGameBaseProxy)

	var0_29:AddGold(pg.auction_session[arg0_29.curSelectedID].ticket * -1)
	var0_29:SetNeedInitFlag(true)

	if getProxy(ContextProxy):getContextByMediator(AuctionGameMainMsgMediator) then
		LoadContextCommand.RemoveLayerByMediator(AuctionGameMainMsgMediator)
	end

	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.AUCTION_GAME_MAIN)
	arg0_29:StopMatchTimer()
end

function var0_0.OnStopMatch(arg0_30)
	arg0_30.startQuickMatch = false

	arg0_30:StopMatchTimer()
	setActive(arg0_30.uiMatchTimeGo, false)
	setActive(arg0_30.uiCancelMatchBtn, false)
	setActive(arg0_30.uiMatchBtn, true)
end

function var0_0.IsQuickMatch(arg0_31)
	return arg0_31.startQuickMatch
end

function var0_0.AddMatchTimer(arg0_32)
	arg0_32:StopMatchTimer()

	arg0_32.matchTimer = Timer.New(function()
		local var0_33 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_32.startTime

		setText(arg0_32.uiMatchTimeText, arg0_32:FormatMatchDuration(var0_33))
	end, 1, -1)

	arg0_32.matchTimer:Start()
	arg0_32.matchTimer.func()
end

function var0_0.StopMatchTimer(arg0_34)
	if arg0_34.matchTimer then
		arg0_34.matchTimer:Stop()

		arg0_34.matchTimer = nil
	end
end

function var0_0.RefreshForbidden(arg0_35)
	local var0_35 = getProxy(AuctionGameBaseProxy).forbiddenTime

	if var0_35 > pg.TimeMgr.GetInstance():GetServerTime() then
		setActive(arg0_35.uiForbiddenGo, true)
		arg0_35:AddForbiddenTimer(var0_35)
	else
		setActive(arg0_35.uiForbiddenGo, false)
	end
end

function var0_0.AddForbiddenTimer(arg0_36, arg1_36)
	arg0_36:StopForbiddenTimer()

	arg0_36.forbiddenTimer = Timer.New(function()
		local var0_37 = pg.TimeMgr.GetInstance():GetServerTime()

		if var0_37 < arg1_36 then
			setText(arg0_36.uiForbiddenText, i18n("auction_forbidden_tip", arg0_36:FormatPreorderDuration(arg1_36 - var0_37)))
		else
			arg0_36:StopForbiddenTimer()
			arg0_36:RefreshForbidden()
		end
	end, 1, -1)

	arg0_36.forbiddenTimer.func()
	arg0_36.forbiddenTimer:Start()
end

function var0_0.StopForbiddenTimer(arg0_38)
	if arg0_38.forbiddenTimer then
		arg0_38.forbiddenTimer:Stop()

		arg0_38.forbiddenTimer = nil
	end
end

function var0_0.RefreshPreorderBtn(arg0_39)
	local var0_39 = getProxy(AuctionGameBaseProxy)
	local var1_39 = var0_39:GetPreorderState()
	local var2_39 = var0_39:GetPreorderTimestamp()
	local var3_39 = pg.TimeMgr.GetInstance():GetServerTime()

	if var1_39 == 1 then
		setActive(arg0_39.uiPreorderEndGo, false)

		if var3_39 < var2_39 then
			setActive(arg0_39.uiPreorderBtn, false)
			setActive(arg0_39.uiPreorderTimeGo, true)
			setActive(arg0_39.uiOpenPreorderBtn, true)
			arg0_39:AddPreorderTimer()
		else
			setActive(arg0_39.uiPreorderBtn, false)
			setActive(arg0_39.uiPreorderTimeGo, false)
			setActive(arg0_39.uiOpenPreorderBtn, true)
			arg0_39:StopPreorderTimer()
		end
	else
		local var4_39 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_AUCTION_GAME).stopTime
		local var5_39 = pg.TimeMgr.GetInstance():IsSameDay(var3_39, var4_39)

		setActive(arg0_39.uiPreorderBtn, not var5_39)
		setActive(arg0_39.uiPreorderEndGo, var5_39)
		setActive(arg0_39.uiPreorderTimeGo, false)
		setActive(arg0_39.uiOpenPreorderBtn, false)

		local var6_39 = AuctionGameTools.GetPreorderCurrentyCnt()

		setText(arg0_39.uiPreorderPriceText, string.format("<color=%s>%s</color>", var6_39 > AuctionGameTools.GetCurrencyCnt() and "#bf5050" or "#ffffff", StringHelper.ForamtNumberK(var6_39)))
	end
end

function var0_0.AddPreorderTimer(arg0_40)
	arg0_40:StopPreorderTimer()

	local var0_40 = getProxy(AuctionGameBaseProxy):GetPreorderTimestamp()

	arg0_40.preorderTimer = Timer.New(function()
		local var0_41 = pg.TimeMgr.GetInstance():GetServerTime()

		if var0_41 >= var0_40 then
			arg0_40:StopPreorderTimer()
			arg0_40:RefreshPreorderBtn()
		else
			setText(arg0_40.uiPreorderTimeText, arg0_40:FormatPreorderDuration(var0_40 - var0_41))
		end
	end, 1, -1)

	arg0_40.preorderTimer:Start()
	arg0_40.preorderTimer.func()
end

function var0_0.FormatPreorderDuration(arg0_42, arg1_42)
	arg1_42 = math.max(0, math.floor(arg1_42 or 0))

	local var0_42 = math.floor(arg1_42 / 3600)
	local var1_42 = math.floor(arg1_42 / 60) % 60
	local var2_42 = arg1_42 % 60

	return string.format("%02d:%02d:%02d", var0_42, var1_42, var2_42)
end

function var0_0.StopPreorderTimer(arg0_43)
	if arg0_43.preorderTimer then
		arg0_43.preorderTimer:Stop()

		arg0_43.preorderTimer = nil
	end
end

function var0_0.RefreshTaskTip(arg0_44)
	local var0_44 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_AUCTION_GAME)

	setActive(arg0_44.uiTaskTipGo, var0_44:GetTaskTip())
end

function var0_0.RefreshPreorderTip(arg0_45)
	local var0_45 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_AUCTION_GAME)

	setActive(arg0_45.uiPreorderTipGo, var0_45:GetPreorderTip())
end

function var0_0.RefreshOpenPreorderTip(arg0_46)
	local var0_46 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_AUCTION_GAME)

	setActive(arg0_46.uiOpenPreorderTipGo, var0_46:GetOpenPreorderTip())
end

function var0_0.RefreshLocationTip(arg0_47)
	for iter0_47, iter1_47 in ipairs(arg0_47.locationItemList) do
		iter1_47:RefreshState()
	end
end

function var0_0.RefreshRelief(arg0_48)
	if pg.NewGuideMgr.GetInstance():IsBusy() then
		setActive(arg0_48.uiReliefBtn, false)

		return
	end

	local var0_48 = getProxy(AuctionGameBaseProxy)
	local var1_48 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_AUCTION_GAME):GetReliefTip()

	setActive(arg0_48.uiReliefBtn, var1_48)
end

function var0_0.ShowWarning(arg0_49)
	local var0_49 = getProxy(AuctionGameBaseProxy)
	local var1_49 = pg.TimeMgr.GetInstance():STimeDescC(pg.TimeMgr.GetInstance():GetServerTime(), "%Y/%m/%d")
	local var2_49 = getProxy(PlayerProxy):getPlayerId()
	local var3_49 = PlayerPrefs.GetInt(string.format("AUCTION_GAME_WARNING_%s_%s", var2_49, var1_49), 0)

	if var0_49.inactiveNum ~= var3_49 then
		arg0_49:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = AuctionGameMainMsgLayer,
			mediator = AuctionGameMainMsgMediator,
			data = {
				content = i18n("auction_game_punishment", var0_49.inactiveNum),
				comformCallback = function()
					return
				end,
				cancelCallback = function()
					return
				end
			}
		}))
	end

	PlayerPrefs.SetInt(string.format("AUCTION_GAME_WARNING_%s_%s", var2_49, var1_49), var0_49.inactiveNum)
end

function var0_0.willExit(arg0_52)
	local var0_52 = getProxy(SettingsProxy):GetMainSceneScreenSleepTime()

	Screen.sleepTimeout = var0_52

	arg0_52:UnOverlayPanel(arg0_52.uiAdaptTf, arg0_52._tf)
	arg0_52:StopMatchTimer()
	arg0_52:StopPreorderTimer()
	arg0_52:StopForbiddenTimer()
	arg0_52.matchEventCom:SetEndEvent(nil)

	for iter0_52, iter1_52 in ipairs(arg0_52.eventList) do
		arg0_52:disconnect(iter1_52)
	end

	arg0_52.eventList = nil

	arg0_52.paintingPanelView:willExit()

	arg0_52.paintingPanelView = nil

	for iter2_52, iter3_52 in ipairs(arg0_52.locationItemList) do
		iter3_52:willExit()
	end

	arg0_52.locationItemList = nil

	arg0_52.playerPanelView:willExit()

	arg0_52.playerPanelView = nil
end

function var0_0.onBackPressed(arg0_53)
	if not arg0_53.quickMatchSuccess and arg0_53.startQuickMatch == true then
		arg0_53:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = AuctionGameMainMsgLayer,
			mediator = AuctionGameMainMsgMediator,
			data = {
				content = i18n("auction_main_match_exit"),
				comformCallback = function()
					arg0_53:OnClickStopQuickMatch()
					var0_0.super.onBackPressed(arg0_53)
				end,
				cancelCallback = function()
					return
				end
			}
		}))
	else
		var0_0.super.onBackPressed(arg0_53)
	end
end

return var0_0
