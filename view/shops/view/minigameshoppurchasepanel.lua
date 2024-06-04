local var0 = class("MiniGameShopPurchasePanel", import(".GuildShopPurchasePanel"))

function var0.getUIName(arg0)
	return "MiniGameShopPurchaseMsgUI"
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0, arg1)

	arg0.confirmCallback = arg1.confirm
end

function var0.OnConfirm(arg0)
	if arg0.confirmCallback then
		arg0.confirmCallback(arg0.data.id, arg0.selectedList)
	end
end

return var0
