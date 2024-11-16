local var0_0 = class("BlackFridayChargeCard", import(".ChargeCard"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.unlockBlock = arg0_1.tr:Find("real_tpl/unlock_block")
	arg0_1.unlockBlockLabel = arg0_1.tr:Find("real_tpl/unlock_block/label/Text")
end

function var0_0.update(arg0_2, arg1_2, arg2_2, arg3_2)
	var0_0.super.update(arg0_2, arg1_2, arg2_2, arg3_2)

	if arg0_2:inTime(unlockTime) then
		setActive(arg0_2.unlockBlock, false)
	else
		setActive(arg0_2.unlockBlock, true)

		local var0_2 = arg1_2:getConfig("time")
		local var1_2 = var0_2[1][1][3]
		local var2_2 = var0_2[1][2][1]

		setText(arg0_2.unlockBlockLabel, i18n("blackfriday_shop_tip", var1_2, var2_2))
	end

	setActive(arg0_2.focusTip, arg1_2:isFree() and arg0_2:inTime())
end

function var0_0.inTime(arg0_3)
	local var0_3 = arg0_3.goods:getConfig("time")

	return pg.TimeMgr.GetInstance():inTime(var0_3)
end

return var0_0
