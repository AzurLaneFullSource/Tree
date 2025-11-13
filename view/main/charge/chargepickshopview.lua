local var0_0 = class("ChargePickShopView", import(".ChargeGiftShopView"))

var0_0.ShowPickUp = true

function var0_0.getUIName(arg0_1)
	return "ChargePickShopUI"
end

function var0_0.GetViewSkinWrap(arg0_2)
	return ChargeScene.TYPE_PICK
end

return var0_0
