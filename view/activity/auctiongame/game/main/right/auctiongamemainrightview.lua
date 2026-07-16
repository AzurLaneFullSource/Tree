local var0_0 = class("AuctionGameMainRightView", import("view.base.BasePanel"))

var0_0.FORFEIT_DONE = "AuctionGameMainRightView::FORFEIT_DONE"
var0_0.PLAYER_OPT_STATE_UPDATE = "AuctionGameMainRightView::PLAYER_OPT_STATE_UPDATE"
var0_0.POP_EVENT_LAYER = "AuctionGameMainRightView::POP_EVENT_LAYER"
var0_0.EVENT_SELECTED = "AuctionGameMainRightView::EVENT_SELECTED"
var0_0.SHOW_EMOJI = "AuctionGameMainRightView::SHOW_EMOJI"
var0_0.SWITCH_EMOJI = "AuctionGameMainRightView::SWITCH_EMOJI"

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()

	arg0_1.infoView = AuctionGameMainRightInfoView.New(arg0_1.uiInfoPanel, arg2_1)
end

function var0_0.Init(arg0_2)
	setText(arg0_2.uiCurrencyTitleText, i18n("auction_main_pt"))
	setText(arg0_2.uiEventBtnText, i18n("auction_main_select_event"))

	arg0_2.bidEventCom = GetComponent(arg0_2.uiBidAnimationTf, typeof(DftAniEvent))

	arg0_2.bidEventCom:SetEndEvent(function()
		arg0_2.startBid = false

		arg0_2:OnPopBidLayer()
	end)

	local var0_2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_AUCTION_GAME):getConfig("config_client").itemID

	LoadSpriteAsync(Drop.New({
		type = DROP_TYPE_VITEM,
		id = var0_2
	}):getIcon(), function(arg0_4)
		if not IsNil(arg0_2.uiCurrencyIcon) then
			arg0_2.uiCurrencyIcon.sprite = arg0_4
		end
	end)
	onButton(arg0_2, arg0_2.uiEventBtn, function()
		arg0_2:OnPopEventLayer()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiForfeitGreyBtn, function()
		if getProxy(AuctionGameProxy):GetAuctionState() >= AuctionGameConst.AUCTION_PHASE.WAIT_OVER then
			pg.TipsMgr.GetInstance():ShowTips(i18n("auction_game_cannot_forfeit"))

			return
		end
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiForfeitBtn, function()
		if getProxy(AuctionGameProxy):GetForfeit() then
			return
		end

		arg0_2:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = AuctionGameMainMsgLayer,
			mediator = AuctionGameMainMsgMediator,
			data = {
				content = i18n("auction_game_forfeit_tip"),
				comformCallback = function()
					local var0_8 = getProxy(AuctionGameProxy)
					local var1_8 = pg.TimeMgr.GetInstance():GetServerTime() - var0_8:GetTimestamp()

					if var0_8:GetAuctionState() == AuctionGameConst.AUCTION_PHASE.BID then
						var1_8 = pg.gameset.auction_bid_time.key_value + var1_8
					else
						var1_8 = pg.gameset.auction_event_choose_time.key_value + var1_8
					end

					pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildAuctionBid(var0_8:GetAuctionID(), var0_8:GetRound(), var1_8, 0, 1))
					arg0_2:emit(AuctionGameMainMediator.FORFEIT)
				end
			}
		}))
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiBidBtn, function()
		if arg0_2.startBid == true then
			return
		end

		if arg0_2.waitBid then
			pg.TipsMgr.GetInstance():ShowTips(i18n("auction_game_wait_bid_phase"))

			return
		end

		if arg0_2.bided then
			return
		end

		arg0_2.startBid = true

		quickPlayAnimation(arg0_2.uiBidAnimationTf, "Anim_AuctionGameEntranceUI_matchBtn_click")
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiCloseBtn, function()
		arg0_2:emit(PlayRoomCommonMediator.PLAY_ROOM_MATCH_STOP)
		arg0_2:emit(AuctionGameMainMediator.EXIT)
	end, SOUND_BACK)

	arg0_2.playerViewList = {}

	local var1_2 = getProxy(AuctionGameProxy):GetPlayerList()

	for iter0_2 = 1, #var1_2 do
		arg0_2.playerViewList[iter0_2] = AuctionGameMainRightPlayerInfo.New(arg0_2[string.format("uiPlayerTf%s", iter0_2)], arg0_2._parentClass)
	end

	for iter1_2 = #var1_2 + 1, 4 do
		setActive(arg0_2[string.format("uiPlayerTf%s", iter1_2)], false)
	end

	setText(arg0_2.uiFilterPersonalEventText, i18n("auction_show_personal_event"))
	setText(arg0_2.uiFilterCommonEventText, i18n("auction_show_common_event"))
	setActive(arg0_2.uiFilterPanelTf, false)
	onButton(arg0_2, arg0_2.uiFilterBtn, function()
		setActive(arg0_2.uiFilterPanelTf, true)
		arg0_2:emit(AuctionGameMainScene.SHOW_FILTER_EVENT, arg0_2.uiFilterPanelTf)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiFilterPersonalEventBtn, function()
		arg0_2.filterPersonalFlag = not arg0_2.filterPersonalFlag

		arg0_2:RefreshFilterPersonalEvent()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiFilterCommonEventBtn, function()
		arg0_2.filterCommonFlag = not arg0_2.filterCommonFlag

		arg0_2:RefreshFilterCommonEvent()
	end, SFX_PANEL)
end

function var0_0.didEnter(arg0_14)
	arg0_14.filterPersonalFlag = true
	arg0_14.filterCommonFlag = true

	arg0_14.infoView:didEnter()
	arg0_14.infoView:RefreshUI(arg0_14.filterPersonalFlag, arg0_14.filterCommonFlag)

	local var0_14 = getProxy(AuctionGameProxy):GetPlayerList()

	for iter0_14, iter1_14 in ipairs(arg0_14.playerViewList) do
		iter1_14:didEnter(var0_14[iter0_14])
	end

	arg0_14.eventList = {
		arg0_14:bind(var0_0.FORFEIT_DONE, handler(arg0_14, arg0_14.OnRefreshForfeit)),
		arg0_14:bind(var0_0.PLAYER_OPT_STATE_UPDATE, handler(arg0_14, arg0_14.OnRefreshPlayerState)),
		arg0_14:bind(var0_0.POP_EVENT_LAYER, handler(arg0_14, arg0_14.OnPopEventLayer)),
		arg0_14:bind(var0_0.EVENT_SELECTED, handler(arg0_14, arg0_14.OnEventSelected)),
		arg0_14:bind(var0_0.SHOW_EMOJI, handler(arg0_14, arg0_14.OnShowEmoji)),
		arg0_14:bind(var0_0.SWITCH_EMOJI, handler(arg0_14, arg0_14.OnSwitchEmoji))
	}

	setText(arg0_14.uiCurrencyText, StringHelper.ForamtNumber(AuctionGameTools.GetCurrencyCnt()))

	local var1_14 = getProxy(AuctionGameProxy)

	if var1_14.personalEventSelectedID == 0 and #var1_14.personalEventList > 0 then
		arg0_14:OnPopEventLayer()
	end
end

function var0_0.RefreshRound(arg0_15)
	arg0_15.startBid = false

	setActive(arg0_15.uiBidCompleteGo, false)
	setActive(arg0_15.uiBidBtn, true)

	if arg0_15.forfeit then
		setActive(arg0_15.uiForfeitBtn, false)
		setActive(arg0_15.uiForfeitGreyGo, true)
	else
		setActive(arg0_15.uiForfeitBtn, true)
		setActive(arg0_15.uiForfeitGreyGo, false)
	end

	arg0_15.bided = false
	arg0_15.waitBid = true

	arg0_15:RefreshEventTip()
	arg0_15.infoView:RefreshUI(arg0_15.filterPersonalFlag, arg0_15.filterCommonFlag)
end

function var0_0.StartBid(arg0_16)
	arg0_16.bided = false
	arg0_16.waitBid = false

	arg0_16:RefreshEventTip()
end

function var0_0.RefreshEventTip(arg0_17)
	local var0_17 = getProxy(AuctionGameProxy)

	setActive(arg0_17.uiEventTipGo, var0_17:GetPersonalEventSelectedID() == 0)
end

function var0_0.RefreshBidDone(arg0_18, arg1_18)
	setActive(arg0_18.uiBidCompleteGo, true)
	setActive(arg0_18.uiBidBtn, false)
	setActive(arg0_18.uiForfeitBtn, false)
	setActive(arg0_18.uiForfeitGreyGo, true)

	arg0_18.bided = true

	setText(arg0_18.uiBidCompleteText, i18n("auction_main_bid_price") .. StringHelper.ForamtNumber(arg1_18))
end

function var0_0.OnRefreshForfeit(arg0_19)
	arg0_19.forfeit = true

	setActive(arg0_19.uiCloseBtn, true)
	setActive(arg0_19.uiBidBtn, false)
	setActive(arg0_19.uiForfeitBtn, false)
	setActive(arg0_19.uiForfeitGreyGo, true)
end

function var0_0.OnRefreshPlayerState(arg0_20)
	for iter0_20, iter1_20 in ipairs(arg0_20.playerViewList) do
		iter1_20:RefreshUI()
	end
end

function var0_0.OnPopBidLayer(arg0_21)
	arg0_21:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
		viewComponent = AuctionGameMainBidLayer,
		mediator = AuctionGameMainBidMediator
	}))
end

function var0_0.OnPopEventLayer(arg0_22)
	arg0_22:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
		viewComponent = AuctionGameMainEventLayer,
		mediator = AuctionGameMainEventMediator
	}))
end

function var0_0.OnEventSelected(arg0_23)
	arg0_23:RefreshEventTip()
	arg0_23.infoView:RefreshUI(arg0_23.filterPersonalFlag, arg0_23.filterCommonFlag)
end

function var0_0.OnShowEmoji(arg0_24, arg1_24, arg2_24)
	local var0_24 = arg2_24.userID
	local var1_24 = getProxy(AuctionGameProxy):GetPlayerList()

	for iter0_24, iter1_24 in ipairs(var1_24) do
		arg0_24.playerViewList[iter0_24]:ShowEmoji(var0_24, arg2_24.emojiID)
	end
end

function var0_0.OnSwitchEmoji(arg0_25)
	local var0_25 = getProxy(AuctionGameProxy):GetPlayerList()

	for iter0_25, iter1_25 in ipairs(var0_25) do
		arg0_25.playerViewList[iter0_25]:RefreshEmojiBtn()
	end
end

function var0_0.RefreshFilterPersonalEvent(arg0_26)
	setActive(arg0_26.uiFilterPersonalEventSelectedGo, arg0_26.filterPersonalFlag)
	arg0_26.infoView:RefreshUI(arg0_26.filterPersonalFlag, arg0_26.filterCommonFlag)
end

function var0_0.RefreshFilterCommonEvent(arg0_27)
	setActive(arg0_27.uiFilterCommonEventSelectedGo, arg0_27.filterCommonFlag)
	arg0_27.infoView:RefreshUI(arg0_27.filterPersonalFlag, arg0_27.filterCommonFlag)
end

function var0_0.willExit(arg0_28)
	arg0_28.bidEventCom:SetEndEvent(nil)

	for iter0_28, iter1_28 in ipairs(arg0_28.eventList) do
		arg0_28:disconnect(iter1_28)
	end

	arg0_28.eventList = nil

	arg0_28.infoView:willExit()

	arg0_28.infoView = nil

	for iter2_28, iter3_28 in ipairs(arg0_28.playerViewList) do
		iter3_28:willExit()
	end

	arg0_28.playerViewList = nil

	arg0_28:detach()
end

return var0_0
