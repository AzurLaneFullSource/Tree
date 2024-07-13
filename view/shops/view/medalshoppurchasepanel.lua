local var0_0 = class("MedalShopPurchasePanel", import(".GuildShopPurchasePanel"))

function var0_0.getUIName(arg0_1)
	return "MedalShopPurchaseMsgUI"
end

function var0_0.OnConfirm(arg0_2)
	arg0_2:emit(NewShopsMediator.ON_MEDAL_SHOPPING, arg0_2.data.id, arg0_2.selectedList)
end

return var0_0
