local var0_0 = class("AuctionGamePlayerPanel", import("view.base.BasePanel"))

var0_0.REFRESH_CURRENCY = "AuctionGamePlayerPanel::REFRESH_CURRENCY"

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	onButton(arg0_2, arg0_2.uiDisplayBtn, function()
		arg0_2:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = AuctionGameNameCardLayer,
			mediator = AuctionGameNameCardMediator
		}))
	end, SFX_PANEL)

	local var0_2 = getProxy(PlayerProxy)
	local var1_2 = getProxy(PlayerProxy):getRawData()

	setText(arg0_2.uiNameText, var1_2.name)

	local var2_2 = var1_2:GetShipPhantomMarks()[1]
	local var3_2 = getProxy(BayProxy):GetShipPhantom(var2_2)

	GetImageSpriteFromAtlasAsync("SquareIcon/" .. var3_2:getPainting(), "", arg0_2.uiIconTf)

	local var4_2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_AUCTION_GAME):getConfig("config_client").itemID

	LoadSpriteAsync(Drop.New({
		type = DROP_TYPE_VITEM,
		id = var4_2
	}):getIcon(), function(arg0_4)
		if not IsNil(arg0_2.uiCurrencyIcon) then
			arg0_2.uiCurrencyIcon.sprite = arg0_4
		end
	end)
end

function var0_0.didEnter(arg0_5)
	arg0_5:RefreshCurrency()

	arg0_5.eventIDList = {
		arg0_5:bind(var0_0.REFRESH_CURRENCY, handler(arg0_5, arg0_5.RefreshCurrency))
	}
end

function var0_0.RefreshCurrency(arg0_6)
	setText(arg0_6.uiCntText, StringHelper.ForamtNumberK(AuctionGameTools.GetCurrencyCnt()))
end

function var0_0.willExit(arg0_7)
	for iter0_7, iter1_7 in ipairs(arg0_7.eventIDList) do
		arg0_7:disconnect(iter1_7)
	end

	arg0_7.eventIDList = nil

	arg0_7:detach()
end

return var0_0
