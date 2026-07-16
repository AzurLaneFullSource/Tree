local var0_0 = class("AuctionGameMainBidLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "AuctionGameMainBidUI"
end

function var0_0.init(arg0_2)
	arg0_2.bidEventCom = GetComponent(arg0_2.uiBidAnimationTf, typeof(DftAniEvent))

	arg0_2.bidEventCom:SetEndEvent(function()
		arg0_2:OnClickBidBtn()
	end)
	onButton(arg0_2, arg0_2.uiCloseBtn, function()
		arg0_2:closeView()
	end, SOUND_BACK)

	for iter0_2 = 0, 9 do
		onButton(arg0_2, arg0_2[string.format("uiNumBtn%s", iter0_2)], function()
			arg0_2:AddNum(iter0_2)
			arg0_2:RefreshNumText()
		end, AuctionGameConst.SOUND_EFFECT.BID_KEYPAD)
	end

	onButton(arg0_2, arg0_2.uiBtn00, function()
		arg0_2:MultiplierNum(100)
		arg0_2:RefreshNumText()
	end, AuctionGameConst.SOUND_EFFECT.BID_KEYPAD)
	onButton(arg0_2, arg0_2.uiBtn000, function()
		arg0_2:MultiplierNum(1000)
		arg0_2:RefreshNumText()
	end, AuctionGameConst.SOUND_EFFECT.BID_KEYPAD)
	onButton(arg0_2, arg0_2.uiMultiplierBtn, function()
		arg0_2:MultiplierNum(arg0_2.multiplierNum)
		arg0_2:RefreshNumText()
	end, AuctionGameConst.SOUND_EFFECT.BID_KEYPAD)
	onButton(arg0_2, arg0_2.uiDeleteBtn, function()
		arg0_2:DeleteNum()
		arg0_2:RefreshNumText()
	end, AuctionGameConst.SOUND_EFFECT.BID_KEYPAD)
	onButton(arg0_2, arg0_2.uiClearBtn, function()
		arg0_2.inputNum = 0

		arg0_2:RefreshNumText()
	end, AuctionGameConst.SOUND_EFFECT.BID_KEYPAD)
	onButton(arg0_2, arg0_2.uiBidBtn, function()
		if arg0_2.startBid == true then
			return
		end

		local var0_11 = arg0_2.inputNum

		if arg0_2.bided then
			return
		end

		local var1_11 = getProxy(AuctionGameProxy)
		local var2_11 = var1_11:GetAuctionState()

		if pg.TimeMgr.GetInstance():GetServerTime() < var1_11:GetTimestamp() and var2_11 ~= AuctionGameConst.AUCTION_PHASE.BID then
			pg.TipsMgr.GetInstance():ShowTips(i18n("auction_game_wait_bid_phase"))

			return
		end

		local var3_11 = pg.auction_session[var1_11:GetAuctionID()].bottom_price

		if var0_11 < var3_11 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("auction_game_min_bid", var3_11))

			return
		end

		if var0_11 > getProxy(AuctionGameBaseProxy).gold then
			pg.TipsMgr.GetInstance():ShowTips(i18n("auction_game_exceeds_max_value"))

			return
		end

		arg0_2:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = AuctionGameMainMsgLayer,
			mediator = AuctionGameMainMsgMediator,
			data = {
				content = i18n("auction_game_bid_confirm", StringHelper.ForamtNumber(var0_11)),
				comformCallback = function()
					arg0_2.startBid = true

					quickPlayAnimation(arg0_2.uiBidAnimationTf, "Anim_AuctionGameEntranceUI_matchBtn_click")
				end
			}
		}))
	end, AuctionGameConst.SOUND_EFFECT.BID)
	setText(arg0_2.uiCurrencyTitleText, i18n("auction_main_pt"))

	local var0_2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_AUCTION_GAME):getConfig("config_client").itemID

	LoadSpriteAsync(Drop.New({
		type = DROP_TYPE_VITEM,
		id = var0_2
	}):getIcon(), function(arg0_13)
		if not IsNil(arg0_2.uiCurrencyIcon) then
			arg0_2.uiCurrencyIcon.sprite = arg0_13
		end
	end)
	setText(arg0_2.uiCurrencyText, StringHelper.ForamtNumber(AuctionGameTools.GetCurrencyCnt()))
	setText(arg0_2.uiClearText, i18n("auction_bid_keyboard_clear"))
end

function var0_0.didEnter(arg0_14)
	arg0_14:OverlayPanel(arg0_14._tf, {
		pbList = {
			arg0_14.uiBg
		}
	})
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(AuctionGameConst.SOUND_EFFECT.EXPAND_POPUP)

	local var0_14 = getProxy(AuctionGameProxy)
	local var1_14 = var0_14:GetRound()

	if var1_14 <= 1 then
		arg0_14.inputNum = 0
	else
		local var2_14 = getProxy(PlayerProxy):getPlayerId()

		arg0_14.inputNum = var0_14:GetRoundEventAndBidInfoList()[var1_14 - 1][var2_14].bidValue or 0
	end

	arg0_14.maxValue = AuctionGameTools.GetCurrencyCnt()

	arg0_14:RefreshUI()

	if var1_14 >= 5 then
		setText(arg0_14.uiMultiplierDescText, i18n("auction_round_instant_buy", "--"))
	else
		setText(arg0_14.uiMultiplierDescText, i18n("auction_round_instant_buy", arg0_14.multiplierNum))
	end
end

function var0_0.RefreshUI(arg0_15)
	local var0_15 = getProxy(AuctionGameProxy):GetRound()

	var0_15 = var0_15 == 0 and 1 or var0_15
	arg0_15.multiplierNum = tonumber(pg.auction_round[var0_15].one_hit)

	setText(arg0_15.uiMultiplierText, string.format("%s", arg0_15.multiplierNum))
	arg0_15:RefreshNumText()
end

function var0_0.AddNum(arg0_16, arg1_16)
	if arg1_16 == 0 and arg0_16.inputNum == 0 then
		return
	end

	arg0_16.inputNum = arg0_16.inputNum * 10 + arg1_16

	if arg0_16.inputNum > arg0_16.maxValue then
		arg0_16.inputNum = arg0_16.maxValue
	end
end

function var0_0.DeleteNum(arg0_17)
	if arg0_17.inputNum == 0 then
		return
	end

	arg0_17.inputNum = math.floor(arg0_17.inputNum / 10)
end

function var0_0.MultiplierNum(arg0_18, arg1_18)
	if arg0_18.inputNum == 0 then
		return
	end

	arg0_18.inputNum = math.ceil(arg0_18.inputNum * arg1_18)

	if arg0_18.inputNum > arg0_18.maxValue then
		arg0_18.inputNum = arg0_18.maxValue
	end
end

function var0_0.RefreshNumText(arg0_19)
	setText(arg0_19.uiInputText, StringHelper.ForamtNumber(arg0_19.inputNum))
end

function var0_0.OnClickBidBtn(arg0_20)
	arg0_20.startBid = false

	local var0_20 = getProxy(AuctionGameProxy)
	local var1_20 = pg.gameset.auction_bid_time.key_value - (var0_20:GetTimestamp() - pg.TimeMgr.GetInstance():GetServerTime())

	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildAuctionBid(var0_20:GetAuctionID(), var0_20:GetRound(), var1_20, arg0_20.inputNum, 0))

	local var2_20 = arg0_20.inputNum

	arg0_20:emit(AuctionGameMainBidMediator.BID, var2_20)
end

function var0_0.willExit(arg0_21)
	arg0_21:UnOverlayPanel(arg0_21._tf)
	arg0_21.bidEventCom:SetEndEvent(nil)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(AuctionGameConst.SOUND_EFFECT.COLLAPSE_POPUP)
end

return var0_0
