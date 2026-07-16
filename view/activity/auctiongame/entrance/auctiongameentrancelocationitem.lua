local var0_0 = class("AuctionGameEntranceLocationItem", import("view.base.BasePanel"))

var0_0.SELECTED_LOCATION = "AuctionGameEntranceLocationItem::SELECTED_LOCAITON"

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1
	arg0_1.id = arg3_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	local var0_2 = pg.auction_session[arg0_2.id]

	setText(arg0_2.uiUnselectedLockText, i18n("auction_not_enough_assets", StringHelper.ForamtNumberK(var0_2.threshold)))
	onButton(arg0_2, arg0_2.uiButton, function()
		local var0_3 = pg.auction_session[arg0_2.id]

		if AuctionGameTools.GetCurrencyCnt() >= var0_3.threshold == false then
			return
		end

		getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_AUCTION_GAME):SetLocationTip(arg0_2.id)
		arg0_2:emit(AuctionGameEntranceLocationItem.SELECTED_LOCATION, arg0_2.id)
	end, SFX_PANEL)
end

function var0_0.didEnter(arg0_4, arg1_4)
	getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_AUCTION_GAME):SetLocationTip(arg1_4)
	arg0_4:RefreshState()
	arg0_4:SetSelected(arg1_4 == arg0_4.id)
end

function var0_0.SetSelected(arg0_5, arg1_5)
	setActive(arg0_5.uiSelectedGo, arg1_5)
	setActive(arg0_5.uiUnselectedGo, not arg1_5)

	local var0_5 = pg.auction_session[arg0_5.id]

	if AuctionGameTools.GetCurrencyCnt() >= var0_5.threshold then
		setActive(arg0_5.uiUnlockImage, arg1_5)
		setActive(arg0_5.uiLockImage, not arg1_5)
	else
		setActive(arg0_5.uiUnlockImage, false)
		setActive(arg0_5.uiLockImage, false)
	end
end

function var0_0.RefreshState(arg0_6)
	local var0_6 = pg.auction_session[arg0_6.id]
	local var1_6 = AuctionGameTools.GetCurrencyCnt() >= var0_6.threshold

	setActive(arg0_6.uiUnselectedLockGo, not var1_6)
	setActive(arg0_6.uiSelectedLockGo, not var1_6)
	setActive(arg0_6.uiSelectedUnLockGo, var1_6)
	arg0_6:RefreshTip()
end

function var0_0.RefreshTip(arg0_7)
	local var0_7 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_AUCTION_GAME)

	setActive(arg0_7.uiTipGo, var0_7:GetLocationTip(arg0_7.id))
end

function var0_0.willExit(arg0_8)
	arg0_8:detach()
end

return var0_0
