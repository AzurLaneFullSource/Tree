local var0_0 = class("AuctionGameMainScene", import("view.base.BaseUI"))

var0_0.SHOW_FILTER_EVENT = "AuctionGameMainScene::SHOW_FILTER_EVENT"

function var0_0.getUIName(arg0_1)
	return "AuctionGameMainUI"
end

function var0_0.init(arg0_2)
	arg0_2.leftPanelView = AuctionGameMainLeftView.New(arg0_2.uiLeftPanel, arg0_2)

	arg0_2:InitRightView()
	setText(arg0_2.uiCdText, "--")
	arg0_2:RefreshRoundText(1)
	setText(arg0_2.uiCollectionText, i18n("auction_main_handbook"))
	setText(arg0_2.uiBoardText, i18n("auction_main_public_notice"))
	onButton(arg0_2, arg0_2.uiCollectionBtn, function()
		arg0_2:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = AuctionGameCollectionListLayer,
			mediator = AuctionGameCollectionListMediator
		}))
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiBoardBtn, function()
		arg0_2:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = AuctionGameMainNoticeBoardLayer,
			mediator = AuctionGameMainNoticeBoardMediator
		}))
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiHideBtn, function()
		arg0_2:HideFilterEventPanel()
	end, SFX_PANEL)
end

function var0_0.didEnter(arg0_6)
	Screen.sleepTimeout = SleepTimeout.NeverSleep

	arg0_6.leftPanelView:didEnter()
	arg0_6.rightPanelView:didEnter()

	local var0_6 = getProxy(AuctionGameProxy)

	if var0_6:GetRound() < 1 then
		if table.keyof(var0_6:GetLeaverList(), getProxy(PlayerProxy):getPlayerId()) then
			arg0_6:OnKick()
		else
			arg0_6:RefreshReadyPanel()
		end
	else
		arg0_6:RefreshRound()
	end

	arg0_6.eventList = {
		arg0_6:bind(var0_0.SHOW_FILTER_EVENT, handler(arg0_6, arg0_6.OnShowFilterEventPanel))
	}
end

function var0_0.InitRightView(arg0_7)
	arg0_7.rightPanelView = AuctionGameMainRightView.New(arg0_7.uiRightPanel, arg0_7)
end

function var0_0.OnStartBid(arg0_8)
	pg.TipsMgr.GetInstance():ShowTips(i18n("auction_game_bid_phase"))
	arg0_8.rightPanelView:StartBid()
	arg0_8:AddTimer()
end

function var0_0.OnBidDone(arg0_9, arg1_9)
	arg0_9.rightPanelView:RefreshBidDone(arg1_9)
end

function var0_0.OnStartRoundOver(arg0_10)
	arg0_10:HideFilterEventPanel()
	arg0_10:AddTimer()

	if getProxy(AuctionGameProxy):GetTimestamp() - pg.TimeMgr.GetInstance():GetServerTime() > 0 then
		arg0_10:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = AuctionGameMainRoundOverLayer,
			mediator = AuctionGameMainRoundOverMediator
		}))
	end
end

function var0_0.OnKick(arg0_11)
	local var0_11 = getProxy(AuctionGameProxy)

	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildAuctionExit(var0_11:GetAuctionID(), var0_11:GetRound()))
	arg0_11:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
		viewComponent = AuctionGameMainMsgLayer,
		mediator = AuctionGameMainMsgMediator,
		data = {
			content = i18n("auction_game_kick"),
			comformCallback = function()
				arg0_11:closeView()
			end,
			cancelCallback = function()
				arg0_11:closeView()
			end
		}
	}))
end

function var0_0.OnReconnection(arg0_14)
	arg0_14:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
		viewComponent = AuctionGameMainMsgLayer,
		mediator = AuctionGameMainMsgMediator,
		data = {
			content = i18n("auction_network_timeout"),
			comformCallback = function()
				arg0_14:closeView()
			end,
			cancelCallback = function()
				arg0_14:closeView()
			end
		}
	}))
end

function var0_0.OnNoBid(arg0_17)
	local var0_17 = getProxy(AuctionGameProxy)

	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildAuctionFinish(var0_17:GetAuctionID(), var0_17:GetRound(), 1))
	arg0_17:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
		viewComponent = AuctionGameMainMsgLayer,
		mediator = AuctionGameMainMsgMediator,
		data = {
			content = i18n("auction_game_nobid_tip"),
			comformCallback = function()
				arg0_17:emit(AuctionGameMainMediator.EXIT)
			end,
			cancelCallback = function()
				arg0_17:emit(AuctionGameMainMediator.EXIT)
			end
		}
	}))
end

function var0_0.RefreshReadyPanel(arg0_20)
	arg0_20:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
		viewComponent = AuctionGameMainReadyLayer,
		mediator = AuctionGameMainReadyMediator
	}))
end

function var0_0.RefreshRound(arg0_21)
	local var0_21 = getProxy(AuctionGameProxy):GetRound()

	if var0_21 == 1 then
		SetParent(arg0_21.uiTopPanel, pg.UIMgr.GetInstance().OverlayMain)
	end

	arg0_21:RefreshRoundText(var0_21)
	arg0_21.leftPanelView:RefreshRound()
	arg0_21.rightPanelView:RefreshRound()
	arg0_21:AddTimer()
end

function var0_0.RefreshRoundText(arg0_22, arg1_22)
	local var0_22 = pg.auction_round[arg1_22]

	LoadSpriteAtlasAsync("ui/auctiongameui_atlas", string.format("main_round_%s", arg1_22), function(arg0_23)
		if not IsNil(arg0_22.uiRoundImage) then
			arg0_22.uiRoundImage.sprite = arg0_23
		end
	end)
end

function var0_0.AddTimer(arg0_24)
	arg0_24:StopTimer()

	arg0_24.timer = Timer.New(function()
		local var0_25 = getProxy(AuctionGameProxy):GetTimestamp() - pg.TimeMgr.GetInstance():GetServerTime()

		if var0_25 < 0 then
			var0_25 = 0

			if getProxy(AuctionGameProxy):GetAuctionState() == AuctionGameConst.AUCTION_PHASE.ROUND_OVER and AuctionGameTools.IsNoBid() then
				arg0_24:StopTimer()
				arg0_24:OnNoBid()
			end
		end

		if var0_25 < 10 then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(AuctionGameConst.SOUND_EFFECT.COUNTDOWN)
		end

		setText(arg0_24.uiCdText, var0_25 .. "<size=30>s</size>")
	end, 1, -1)

	arg0_24.timer:Start()
	arg0_24.timer.func()
end

function var0_0.StopTimer(arg0_26)
	if arg0_26.timer then
		arg0_26.timer:Stop()

		arg0_26.timer = nil
	end
end

function var0_0.OnShowFilterEventPanel(arg0_27, arg1_27, arg2_27)
	setActive(arg0_27.uiHideBtn, true)
	setParent(arg2_27, arg0_27.uiHideBtn, true)
	setParent(arg0_27.uiHideBtn, pg.UIMgr.GetInstance().OverlayMain)
end

function var0_0.HideFilterEventPanel(arg0_28)
	setActive(arg0_28.uiHideBtn, false)
end

function var0_0.willExit(arg0_29)
	setParent(arg0_29.uiHideBtn, arg0_29._tf)

	for iter0_29, iter1_29 in ipairs(arg0_29.eventList) do
		arg0_29:disconnect(iter1_29)
	end

	arg0_29.eventList = nil

	local var0_29 = getProxy(SettingsProxy):GetMainSceneScreenSleepTime()

	Screen.sleepTimeout = var0_29

	arg0_29:StopTimer()
	SetParent(arg0_29.uiTopPanel, arg0_29._tf)
	arg0_29.leftPanelView:willExit()

	arg0_29.leftPanelView = nil

	arg0_29.rightPanelView:willExit()

	arg0_29.rightPanelView = nil
end

function var0_0.onBackPressed(arg0_30)
	if getProxy(AuctionGameProxy):GetForfeit() then
		arg0_30:emit(PlayRoomCommonMediator.PLAY_ROOM_MATCH_STOP)
		arg0_30:emit(AuctionGameMainMediator.EXIT)
	end
end

return var0_0
