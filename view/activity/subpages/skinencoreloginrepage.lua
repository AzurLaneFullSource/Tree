local var0_0 = class("SkinEncoreLoginRePage", import(".SkinEncoreLoginPage"))

function var0_0.GetTips(arg0_1)
	return pg.gametip.SkinDiscountHelp_Carnival.tip
end

function var0_0.GetCouponCountText(arg0_2)
	return string.format("<color=#FFFFFF>%s</color>", arg0_2.couponCount)
end

function var0_0.GetGiftShopType(arg0_3)
	return ChargeScene.TYPE_PICK
end

return var0_0
