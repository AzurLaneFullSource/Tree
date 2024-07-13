local var0_0 = class("ChargeDiamondCard")

var0_0.NewTagType = 2
var0_0.DoubleTagType = 4

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.go = arg1_1
	arg0_1.tr = tf(arg1_1)
	arg0_1.iconImg = arg0_1.tr:Find("IconImg")
	arg0_1.diamondCountText = arg0_1.tr:Find("Count/Text")
	arg0_1.priceText = arg0_1.tr:Find("Price/Text")
	arg0_1.beginTimeText = arg0_1.tr:Find("beginTime/text")
	arg0_1.backTimeText = arg0_1.tr:Find("backTime/text")
	arg0_1.beginTimeDesc = arg0_1.tr:Find("beginTime")
	arg0_1.backTimeDesc = arg0_1.tr:Find("backTime")
	arg0_1.leftDesc = arg0_1.tr:Find("lastAmount/text")
	arg0_1.goods = nil
	arg0_1.parentContext = arg2_1
end

function var0_0.update(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2.goods = arg1_2

	if not table.contains(arg3_2, arg1_2.id) and arg1_2:firstPayDouble() then
		local var0_2 = arg1_2:getConfig("gem")
	elseif arg1_2:hasExtraGem() then
		local var1_2 = arg1_2:getConfig("extra_gem")
	end

	setText(arg0_2.diamondCountText, arg1_2:getConfig("gem"))

	if PLATFORM_CODE == PLATFORM_US then
		local var2_2 = arg1_2:getConfig("money")

		setText(arg0_2.priceText, math.floor(var2_2 / 100) .. "." .. var2_2 - math.floor(var2_2 / 100) * 100)
	else
		setText(arg0_2.priceText, arg1_2:getConfig("money"))
	end

	LoadSpriteAsync("chargeicon/" .. arg1_2:getConfig("picture"), function(arg0_3)
		if arg0_3 then
			setImageSprite(arg0_2.iconImg, arg0_3, true)
		end
	end)

	if arg0_2.goods.buyTime then
		local var3_2 = pg.TimeMgr.GetInstance():STimeDescS(arg0_2.goods.buyTime, "%Y-%m-%d %H:%M")

		setText(arg0_2.beginTimeText, var3_2)
	end

	if arg0_2.goods.refundTime then
		local var4_2 = pg.TimeMgr.GetInstance():STimeDescS(arg0_2.goods.refundTime, "%Y-%m-%d %H:%M")

		setText(arg0_2.backTimeText, var4_2)
	end

	setText(arg0_2.beginTimeDesc, i18n("Supplement_pay6"))
	setText(arg0_2.backTimeDesc, i18n("Supplement_pay7"))
	setText(arg0_2.leftDesc, i18n("Supplement_pay8", "1/1"))
end

function var0_0.destoryTimer(arg0_4)
	if arg0_4.updateTimer then
		arg0_4.updateTimer:Stop()

		arg0_4.updateTimer = nil
	end
end

return var0_0
