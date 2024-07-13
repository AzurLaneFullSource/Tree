local var0_0 = class("MiniGameShopPurchasePanel", import(".GuildShopPurchasePanel"))

function var0_0.getUIName(arg0_1)
	return "MiniGameShopPurchaseMsgUI"
end

function var0_0.Show(arg0_2, arg1_2)
	var0_0.super.Show(arg0_2, arg1_2)

	arg0_2.confirmCallback = arg1_2.confirm
end

function var0_0.OnConfirm(arg0_3)
	if arg0_3.confirmCallback then
		arg0_3.confirmCallback(arg0_3.data.id, arg0_3.selectedList)
	end
end

return var0_0
