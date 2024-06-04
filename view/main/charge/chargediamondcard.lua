local var0 = class("ChargeDiamondCard")

var0.NewTagType = 2
var0.DoubleTagType = 4

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0.go = arg1
	arg0.tr = tf(arg1)
	arg0.firstTag = arg0.tr:Find("FirstTag")
	arg0.iconImg = arg0.tr:Find("IconImg")
	arg0.diamondCountText = arg0.tr:Find("Count/Text")
	arg0.tipTF = arg0.tr:Find("Tip")
	arg0.firstTipTag = arg0.tr:Find("Tip/Text/FirstTag")
	arg0.exTipTag = arg0.tr:Find("Tip/Text/EXTag")
	arg0.firstEXTip = arg0.tr:Find("Tip/Text/NumText")
	arg0.priceText = arg0.tr:Find("Price/Text")
	arg0.priceIcon = arg0.tr:Find("Price/Icon")
	arg0.monthTF = arg2
	arg0.goods = nil
	arg0.parentContext = arg3
end

function var0.update(arg0, arg1, arg2, arg3)
	arg0.goods = arg1

	if arg1:isMonthCard() then
		setActive(arg0.tr, false)
		arg0:updateForMonthTF(arg1, arg2)

		return
	end

	local var0 = not table.contains(arg3, arg1.id) and arg1:firstPayDouble()
	local var1 = var0 and var0.DoubleTagType or arg1:getConfig("tag")

	setActive(arg0.firstTag, var1 == var0.DoubleTagType)

	if var0 then
		local var2 = arg1:getConfig("gem")

		setText(arg0.firstEXTip, var2)
		setActive(arg0.firstTipTag, true)
		setActive(arg0.exTipTag, false)
		setActive(arg0.firstEXTip, true)
		setActive(arg0.tipTF, true)
	elseif arg1:hasExtraGem() then
		local var3 = arg1:getConfig("extra_gem")

		setText(arg0.firstEXTip, var3)
		setActive(arg0.firstTipTag, false)
		setActive(arg0.exTipTag, true)
		setActive(arg0.firstEXTip, true)
		setActive(arg0.tipTF, true)
	else
		setActive(arg0.tipTF, false)
	end

	setText(arg0.diamondCountText, arg1:getConfig("gem"))
	setText(arg0.priceText, arg1:getConfig("money"))

	if PLATFORM_CODE == PLATFORM_CHT then
		setActive(arg0.priceIcon, not arg1:IsLocalPrice())
	end

	LoadSpriteAsync("chargeicon/" .. arg1:getConfig("picture"), function(arg0)
		if arg0 then
			setImageSprite(arg0.iconImg, arg0, true)
		end
	end)
end

function var0.updateForMonthTF(arg0, arg1, arg2)
	local var0 = arg0.monthTF:Find("IconImg")
	local var1 = arg0.monthTF:Find("ResCountText")
	local var2 = arg0.monthTF:Find("Price/Text")
	local var3 = arg0.monthTF:Find("ItemIconTpl")
	local var4 = arg0.monthTF:Find("ItemIconList")
	local var5 = arg0.monthTF:Find("Mask")
	local var6 = arg0.monthTF:Find("Mask/LimitText")
	local var7 = arg0.monthTF:Find("Price/Icon")

	setText(arg0.monthTF:Find("Tip/Text"), i18n("monthly_card_tip"))

	local var8 = arg1:getConfig("gem") + arg1:getConfig("extra_gem")

	setText(var1, "x" .. var8)
	setText(var2, arg1:getConfig("money"))

	if PLATFORM_CODE == PLATFORM_CHT then
		setActive(var7, not arg1:IsLocalPrice())
	end

	local var9 = arg1:getConfig("display")

	if #var9 == 0 then
		var9 = arg1:getConfig("extra_service_item")
	end

	if var9 and #var9 > 0 then
		local var10 = {}

		for iter0, iter1 in ipairs(var9) do
			table.insert(var10, {
				type = iter1[1],
				id = iter1[2],
				count = iter1[3]
			})
		end

		local var11 = UIItemList.New(var4, var3)

		var11:make(function(arg0, arg1, arg2)
			if arg0 == UIItemList.EventUpdate then
				updateDrop(arg2, var10[arg1 + 1])
			end
		end)
		var11:align(#var10)
	end

	local var12 = arg2:getCardById(VipCard.MONTH)

	if var12 and not var12:isExpire() then
		local var13 = var12:getLeftDate()
		local var14 = pg.TimeMgr.GetInstance():GetServerTime()
		local var15 = math.floor((var13 - var14) / 86400)
		local var16 = arg1:getConfig("limit_arg") or 0

		setActive(var5, var16 < var15)
		setText(var6, i18n("charge_month_card_lefttime_tip", var15))
	else
		setActive(var5, false)
	end

	local var17 = MonthCardOutDateTipPanel.GetShowMonthCardTag()

	setActive(arg0.monthTF:Find("monthcard_tag"), var17)
	setActive(arg0.monthTF:Find("NewTag"), not var17)
	onButton(arg0.parentContext, var0, function()
		triggerButton(arg0.tr)
	end, SFX_PANEL)
end

function var0.destoryTimer(arg0)
	return
end

return var0
