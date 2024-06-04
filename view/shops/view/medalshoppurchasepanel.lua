local var0 = class("MedalShopPurchasePanel", import(".GuildShopPurchasePanel"))

function var0.getUIName(arg0)
	return "MedalShopPurchaseMsgUI"
end

function var0.OnConfirm(arg0)
	arg0:emit(NewShopsMediator.ON_MEDAL_SHOPPING, arg0.data.id, arg0.selectedList)
end

return var0
