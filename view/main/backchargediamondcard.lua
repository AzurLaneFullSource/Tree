local var0 = class("ChargeDiamondCard")

var0.NewTagType = 2
var0.DoubleTagType = 4

function var0.Ctor(arg0, arg1, arg2)
	arg0.go = arg1
	arg0.tr = tf(arg1)
	arg0.iconImg = arg0.tr:Find("IconImg")
	arg0.diamondCountText = arg0.tr:Find("Count/Text")
	arg0.priceText = arg0.tr:Find("Price/Text")
	arg0.beginTimeText = arg0.tr:Find("beginTime/text")
	arg0.backTimeText = arg0.tr:Find("backTime/text")
	arg0.beginTimeDesc = arg0.tr:Find("beginTime")
	arg0.backTimeDesc = arg0.tr:Find("backTime")
	arg0.leftDesc = arg0.tr:Find("lastAmount/text")
	arg0.goods = nil
	arg0.parentContext = arg2
end

function var0.update(arg0, arg1, arg2, arg3)
	arg0.goods = arg1

	if not table.contains(arg3, arg1.id) and arg1:firstPayDouble() then
		local var0 = arg1:getConfig("gem")
	elseif arg1:hasExtraGem() then
		local var1 = arg1:getConfig("extra_gem")
	end

	setText(arg0.diamondCountText, arg1:getConfig("gem"))

	if PLATFORM_CODE == PLATFORM_US then
		local var2 = arg1:getConfig("money")

		setText(arg0.priceText, math.floor(var2 / 100) .. "." .. var2 - math.floor(var2 / 100) * 100)
	else
		setText(arg0.priceText, arg1:getConfig("money"))
	end

	LoadSpriteAsync("chargeicon/" .. arg1:getConfig("picture"), function(arg0)
		if arg0 then
			setImageSprite(arg0.iconImg, arg0, true)
		end
	end)

	if arg0.goods.buyTime then
		local var3 = pg.TimeMgr.GetInstance():STimeDescS(arg0.goods.buyTime, "%Y-%m-%d %H:%M")

		setText(arg0.beginTimeText, var3)
	end

	if arg0.goods.refundTime then
		local var4 = pg.TimeMgr.GetInstance():STimeDescS(arg0.goods.refundTime, "%Y-%m-%d %H:%M")

		setText(arg0.backTimeText, var4)
	end

	setText(arg0.beginTimeDesc, i18n("Supplement_pay6"))
	setText(arg0.backTimeDesc, i18n("Supplement_pay7"))
	setText(arg0.leftDesc, i18n("Supplement_pay8", "1/1"))
end

function var0.destoryTimer(arg0)
	if arg0.updateTimer then
		arg0.updateTimer:Stop()

		arg0.updateTimer = nil
	end
end

return var0
