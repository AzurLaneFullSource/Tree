local var0_0 = class("IslandTradeProductList4SellPage", import(".IslandTradeProductListPage"))

function var0_0.GetPrice(arg0_1)
	return (arg0_1.island:GetTradeAgency():GetTodaySellPrice())
end

function var0_0.OnClick(arg0_2)
	arg0_2:emit(IslandTradePage.OPEN_CONFIRM_PAGE, IslandConst.TRADE_SELL)
end

return var0_0
