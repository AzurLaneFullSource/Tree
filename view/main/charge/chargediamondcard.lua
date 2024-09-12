local var0_0 = class("ChargeDiamondCard")

var0_0.NewTagType = 2
var0_0.DoubleTagType = 4

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.go = arg1_1
	arg0_1.tr = tf(arg1_1)
	arg0_1.firstTag = arg0_1.tr:Find("FirstTag")
	arg0_1.iconImg = arg0_1.tr:Find("IconImg")
	arg0_1.diamondCountText = arg0_1.tr:Find("Count/Text")
	arg0_1.tipTF = arg0_1.tr:Find("Tip")
	arg0_1.firstTipTag = arg0_1.tr:Find("Tip/Text/FirstTag")
	arg0_1.exTipTag = arg0_1.tr:Find("Tip/Text/EXTag")
	arg0_1.firstEXTip = arg0_1.tr:Find("Tip/Text/NumText")
	arg0_1.priceText = arg0_1.tr:Find("Price/Text")
	arg0_1.priceIcon = arg0_1.tr:Find("Price/Icon")
	arg0_1.monthTF = arg2_1
	arg0_1.goods = nil
	arg0_1.parentContext = arg3_1
end

function var0_0.update(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2.goods = arg1_2

	if arg1_2:isMonthCard() then
		setActive(arg0_2.tr, false)
		arg0_2:updateForMonthTF(arg1_2, arg2_2)

		return
	end

	local var0_2 = not table.contains(arg3_2, arg1_2.id) and arg1_2:firstPayDouble()
	local var1_2 = var0_2 and var0_0.DoubleTagType or arg1_2:getConfig("tag")

	setActive(arg0_2.firstTag, var1_2 == var0_0.DoubleTagType)

	if var0_2 then
		local var2_2 = arg1_2:getConfig("gem")

		setText(arg0_2.firstEXTip, var2_2)
		setActive(arg0_2.firstTipTag, true)
		setActive(arg0_2.exTipTag, false)
		setActive(arg0_2.firstEXTip, true)
		setActive(arg0_2.tipTF, true)
	elseif arg1_2:hasExtraGem() then
		local var3_2 = arg1_2:getConfig("extra_gem")

		setText(arg0_2.firstEXTip, var3_2)
		setActive(arg0_2.firstTipTag, false)
		setActive(arg0_2.exTipTag, true)
		setActive(arg0_2.firstEXTip, true)
		setActive(arg0_2.tipTF, true)
	else
		setActive(arg0_2.tipTF, false)
	end

	setText(arg0_2.diamondCountText, arg1_2:getConfig("gem"))
	setText(arg0_2.priceText, arg1_2:getConfig("money"))

	if PLATFORM_CODE == PLATFORM_CHT then
		setActive(arg0_2.priceIcon, not arg1_2:IsLocalPrice())
	end

	LoadSpriteAsync("chargeicon/" .. arg1_2:getConfig("picture"), function(arg0_3)
		if arg0_3 then
			setImageSprite(arg0_2.iconImg, arg0_3, true)
		end
	end)
end

function var0_0.updateForMonthTF(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg0_4.monthTF:Find("IconImg")
	local var1_4 = arg0_4.monthTF:Find("ResCountText")
	local var2_4 = arg0_4.monthTF:Find("Price/Text")
	local var3_4 = arg0_4.monthTF:Find("ItemIconTpl")
	local var4_4 = arg0_4.monthTF:Find("ItemIconList")
	local var5_4 = arg0_4.monthTF:Find("Mask")
	local var6_4 = arg0_4.monthTF:Find("Mask/LimitText")
	local var7_4 = arg0_4.monthTF:Find("Price/Icon")

	setText(arg0_4.monthTF:Find("Tip/Text"), i18n("monthly_card_tip"))

	local var8_4 = arg1_4:getConfig("gem") + arg1_4:getConfig("extra_gem")

	setText(var1_4, "x" .. var8_4)
	setText(var2_4, arg1_4:getConfig("money"))

	if PLATFORM_CODE == PLATFORM_CHT then
		setActive(var7_4, not arg1_4:IsLocalPrice())
	end

	local var9_4 = arg1_4:GetDropList()

	if #var9_4 > 0 then
		local var10_4 = UIItemList.New(var4_4, var3_4)

		var10_4:make(function(arg0_5, arg1_5, arg2_5)
			if arg0_5 == UIItemList.EventUpdate then
				updateDrop(arg2_5, var9_4[arg1_5 + 1])
			end
		end)
		var10_4:align(#var9_4)
	end

	local var11_4 = arg2_4:getCardById(VipCard.MONTH)

	if var11_4 and not var11_4:isExpire() then
		local var12_4 = var11_4:getLeftDate()
		local var13_4 = pg.TimeMgr.GetInstance():GetServerTime()
		local var14_4 = math.floor((var12_4 - var13_4) / 86400)
		local var15_4 = arg1_4:getConfig("limit_arg") or 0

		setActive(var5_4, var15_4 < var14_4)
		setText(var6_4, i18n("charge_month_card_lefttime_tip", var14_4))
	else
		setActive(var5_4, false)
	end

	local var16_4 = MonthCardOutDateTipPanel.GetShowMonthCardTag()

	setActive(arg0_4.monthTF:Find("monthcard_tag"), var16_4)
	setActive(arg0_4.monthTF:Find("NewTag"), not var16_4)
	onButton(arg0_4.parentContext, var0_4, function()
		triggerButton(arg0_4.tr)
	end, SFX_PANEL)
end

function var0_0.destoryTimer(arg0_7)
	return
end

return var0_0
