local var0_0 = class("ChargeCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.go = arg1_1
	arg0_1.tr = tf(arg1_1)
	arg0_1.icon = arg0_1.tr:Find("real_tpl/item_icon")
	arg0_1.iconTF = arg0_1.icon:GetComponent(typeof(Image))
	arg0_1.shipIcon = arg0_1.tr:Find("real_tpl/item_icon/ship")
	arg0_1.tipTF = arg0_1.tr:Find("real_tpl/tip")
	arg0_1.tipText = arg0_1.tipTF:GetComponent(typeof(Text))
	arg0_1.count = arg0_1.tr:Find("real_tpl/count")
	arg0_1.resIcon = arg0_1.tr:Find("real_tpl/count/icon"):GetComponent(typeof(Image))
	arg0_1.resCount = arg0_1.tr:Find("real_tpl/count/Text"):GetComponent(typeof(Text))
	arg0_1.priceTf = arg0_1.tr:Find("real_tpl/prince_bg/contain/Text")
	arg0_1.price = arg0_1.priceTf:GetComponent(typeof(Text))
	arg0_1.freeTag = arg0_1.tr:Find("real_tpl/prince_bg/contain/FreeText")
	arg0_1.tecShipBuyTag = arg0_1.tr:Find("real_tpl/prince_bg/contain/BuyText")
	arg0_1.contain = arg0_1.tr:Find("real_tpl/prince_bg/contain")
	arg0_1.rmb = arg0_1.tr:Find("real_tpl/prince_bg/contain/icon_rmb")
	arg0_1.gem = arg0_1.tr:Find("real_tpl/prince_bg/contain/icon_gem")
	arg0_1.mask = arg0_1.tr:Find("real_tpl/mask")
	arg0_1.maskState = arg0_1.mask:Find("state")
	arg0_1.name = arg0_1.tr:Find("real_tpl/item_name_mask/item_name")
	arg0_1.important = arg0_1.tr:Find("real_tpl/important")
	arg0_1.grid = arg0_1.tr:Find("real_tpl/important/grid")
	arg0_1.importantTip = arg0_1.tr:Find("real_tpl/important/tip")
	arg0_1.desc = arg0_1.tr:Find("real_tpl/desc")
	arg0_1.selfTpl = arg0_1.tr:Find("real_tpl/important/item")
	arg0_1.limitText = arg0_1.tr:Find("real_tpl/LimitText")
	arg0_1.countDown = arg0_1.tr:Find("real_tpl/countDown")
	arg0_1.countDownTm = arg0_1.countDown:Find("Text")
	arg0_1.viewBtn = arg0_1.tr:Find("real_tpl/view")
	arg0_1.timeLeftTag = arg0_1.tr:Find("real_tpl/time_left")
	arg0_1.dayLeftTag = arg0_1.tr:Find("real_tpl/time_left/day")
	arg0_1.hourLeftTag = arg0_1.tr:Find("real_tpl/time_left/hour")
	arg0_1.minLeftTag = arg0_1.tr:Find("real_tpl/time_left/min")
	arg0_1.numLeftText = arg0_1.timeLeftTag:Find("Text")
	arg0_1.focusTip = arg0_1.tr:Find("real_tpl/focus_tip")
	arg0_1.tag = arg0_1.tr:Find("real_tpl/tag")
	arg0_1.tags = {}

	table.insert(arg0_1.tags, arg0_1.tr:Find("real_tpl/tag/hot"))
	table.insert(arg0_1.tags, arg0_1.tr:Find("real_tpl/tag/new"))
	table.insert(arg0_1.tags, arg0_1.tr:Find("real_tpl/tag/advice"))
	table.insert(arg0_1.tags, arg0_1.tr:Find("real_tpl/tag/double"))
	table.insert(arg0_1.tags, arg0_1.tr:Find("real_tpl/tag/activity"))
	table.insert(arg0_1.tags, arg0_1.tr:Find("real_tpl/tag/time"))
	table.insert(arg0_1.tags, arg0_1.tr:Find("real_tpl/tag/discount"))
	setActive(arg0_1.countDown, false)
end

function var0_0.update(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2.goods = arg1_2

	setActive(arg0_2.shipIcon, false)

	local var0_2 = arg1_2:isChargeType() and arg1_2:getShowType() ~= ""

	setActive(arg0_2.desc, true)
	setText(arg0_2.desc, "")
	setActive(arg0_2.rmb, arg1_2:isChargeType() and not var0_2)
	setActive(arg0_2.gem, not arg1_2:isChargeType() and not arg1_2:isFree())
	setText(arg0_2.freeTag, i18n("shop_free_tag"))
	setText(arg0_2.tecShipBuyTag, i18n("word_buy"))
	setActive(arg0_2.tecShipBuyTag, var0_2)
	setActive(arg0_2.freeTag, arg1_2:isFree())
	setActive(arg0_2.priceTf, not arg1_2:isFree() and not var0_2)
	setActive(arg0_2.focusTip, arg1_2:isFree())
	setActive(arg0_2.icon, arg1_2:isChargeType())
	setActive(arg0_2.contain, true)
	setActive(arg0_2.countDown, false)

	if arg0_2.viewBtn then
		setActive(arg0_2.viewBtn, arg1_2:isChargeType() and arg1_2:CanViewSkinProbability())
	end

	if arg1_2:isChargeType() then
		arg0_2:updateCharge(arg1_2, arg2_2, arg3_2)
	else
		arg0_2:updateGemItem(arg1_2, arg2_2)
	end

	arg0_2:destoryTimer()
end

function var0_0.updateCharge(arg0_3, arg1_3, arg2_3, arg3_3)
	setActive(arg0_3.tag, true)
	setActive(arg0_3.mask, false)
	setActive(arg0_3.maskState, false)

	arg0_3.tipText.text = ""

	setText(arg0_3.desc, "")

	local var0_3 = not table.contains(arg3_3, arg1_3.id)
	local var1_3 = var0_3 and arg1_3:firstPayDouble()
	local var2_3 = var1_3 and 4 or arg1_3:getConfig("tag")

	setActive(arg0_3.timeLeftTag, false)
	setActive(arg0_3.tag, var2_3 > 0)

	if var2_3 > 0 then
		for iter0_3, iter1_3 in ipairs(arg0_3.tags) do
			setActive(iter1_3, iter0_3 == var2_3)
		end
	end

	setActive(arg0_3.timeLeftTag, false)

	local var3_3, var4_3 = arg1_3:inTime()

	if var3_3 and not arg1_3:isFree() and var4_3 and var4_3 > 0 then
		local var5_3, var6_3, var7_3 = pg.TimeMgr.GetInstance():parseTimeFrom(var4_3)

		if var5_3 > 0 then
			setActive(arg0_3.timeLeftTag, true)
			setActive(arg0_3.dayLeftTag, true)
			setActive(arg0_3.hourLeftTag, false)
			setActive(arg0_3.minLeftTag, false)
			setText(arg0_3.numLeftText, var5_3)
		elseif var6_3 > 0 then
			setActive(arg0_3.timeLeftTag, true)
			setActive(arg0_3.dayLeftTag, false)
			setActive(arg0_3.hourLeftTag, true)
			setActive(arg0_3.minLeftTag, false)
			setText(arg0_3.numLeftText, var6_3)
		elseif var7_3 > 0 then
			setActive(arg0_3.timeLeftTag, true)
			setActive(arg0_3.dayLeftTag, false)
			setActive(arg0_3.hourLeftTag, false)
			setActive(arg0_3.minLeftTag, true)
			setText(arg0_3.numLeftText, var7_3)
		else
			setActive(arg0_3.timeLeftTag, true)
			setActive(arg0_3.dayLeftTag, false)
			setActive(arg0_3.hourLeftTag, false)
			setActive(arg0_3.minLeftTag, true)
			setText(arg0_3.numLeftText, 0)
		end

		local var8_3 = 60
		local var9_3 = 3600
		local var10_3 = 86400
		local var11_3

		if var10_3 <= var4_3 then
			var11_3 = var4_3 % var10_3
		elseif var9_3 <= var4_3 then
			var11_3 = var4_3 % var9_3
		elseif var8_3 <= var4_3 then
			var11_3 = var4_3 % var8_3
		end

		if var11_3 and var11_3 > 0 then
			if arg0_3.countDownTimer then
				arg0_3.countDownTimer:Stop()

				arg0_3.countDownTimer = nil
			end

			arg0_3.countDownTimer = Timer.New(function()
				arg0_3:updateGemItem(arg1_3, arg2_3)
			end, var11_3, 1)

			arg0_3.countDownTimer:Start()
		end
	end

	setActive(arg0_3.resIcon, not arg1_3:isItemBox())
	setActive(arg0_3.resCount, not arg1_3:isItemBox())

	local var12_3 = arg1_3:isGem()

	setActive(arg0_3.name, not var12_3)
	setScrollText(arg0_3.name, arg1_3:getConfig("name_display"))
	setActive(arg0_3.important, arg1_3:isItemBox() or arg1_3:isGiftBox())
	setActive(arg0_3.count, var12_3 or arg1_3:isMonthCard())

	if arg1_3:isItemBox() or arg1_3:isGiftBox() or arg1_3:isPassItem() then
		arg0_3:updateImport(arg1_3:getConfig("display"), arg1_3:getConfig("descrip"))
	end

	local var13_3 = arg1_3:getConfig("limit_type")
	local var14_3 = arg1_3.buyCount
	local var15_3 = arg1_3:getLimitCount()

	if var13_3 == 2 then
		setText(arg0_3.limitText, i18n("charge_limit_all", var15_3 - var14_3, var15_3))
		setActive(arg0_3.mask, var15_3 - var14_3 <= 0)
	elseif var13_3 == 4 then
		setText(arg0_3.limitText, i18n("charge_limit_daily", var15_3 - var14_3, var15_3))
		setActive(arg0_3.mask, var15_3 - var14_3 <= 0)
	else
		setText(arg0_3.limitText, "")
	end

	if arg1_3:isGem() then
		setActive(arg0_3.tipTF, true)

		if var1_3 then
			local var16_3 = arg1_3:getConfig("gem") * arg1_3:getConfig("first_pay_double")

			arg0_3.tipText.text = i18n("charge_double_gem_tip", var16_3)
		elseif arg1_3:hasExtraGem() then
			arg0_3.tipText.text = i18n("charge_extra_gem_tip", arg1_3:getConfig("extra_gem"))
		else
			setActive(arg0_3.tipTF, false)
		end
	elseif arg1_3:isGiftBox() then
		-- block empty
	elseif arg1_3:isMonthCard() then
		local var17_3 = arg2_3:getCardById(VipCard.MONTH)

		if var17_3 and not var17_3:isExpire() then
			local var18_3 = var17_3:getLeftDate()
			local var19_3 = pg.TimeMgr.GetInstance():GetServerTime()
			local var20_3 = math.floor((var18_3 - var19_3) / 86400)
			local var21_3 = arg1_3:getConfig("limit_arg") or 0

			setActive(arg0_3.mask, var21_3 < var20_3)
			setText(arg0_3.limitText, i18n("charge_month_card_lefttime_tip", var20_3))
		end

		setText(arg0_3.desc, string.gsub(arg1_3:getConfig("descrip"), "$1", var0_3 and arg1_3:getConfig("gem") or arg1_3:getConfig("extra_gem")))
	elseif arg1_3:isItemBox() then
		-- block empty
	elseif arg1_3:isPassItem() then
		-- block empty
	end

	arg0_3.resCount.text = "x" .. arg1_3:getConfig("gem")
	arg0_3.price.text = arg1_3:getConfig("money")

	if PLATFORM_CODE == PLATFORM_CHT and arg1_3:IsLocalPrice() then
		setActive(arg0_3.rmb, false)
	end

	arg0_3.iconTF.sprite = GetSpriteFromAtlas("chargeicon/1", "")

	LoadSpriteAsync("chargeicon/" .. arg1_3:getConfig("picture"), function(arg0_5)
		if arg0_5 and not IsNil(arg0_3.iconTF) then
			arg0_3.iconTF.sprite = arg0_5

			arg0_3.iconTF:SetNativeSize()
		end
	end)
	setButtonEnabled(arg0_3.tr, not isActive(arg0_3.mask))
end

function var0_0.UpdateShipIcon(arg0_6, arg1_6)
	setActive(arg0_6.shipIcon, true)

	local var0_6 = arg0_6.shipIcon:Find("icon"):GetComponent(typeof(Image))
	local var1_6 = arg1_6:getConfigTable().usage_arg[1][1]

	assert(var1_6)

	local var2_6 = pg.shop_template[var1_6].effect_args[1]

	assert(var2_6)

	local var3_6 = pg.ship_skin_template[var2_6]

	LoadSpriteAsync("qicon/" .. var3_6.prefab, function(arg0_7)
		if arg0_7 and not IsNil(arg0_6.shipIcon) then
			var0_6.sprite = arg0_7
		end
	end)
end

function var0_0.updateGemItem(arg0_8, arg1_8, arg2_8)
	setActive(arg0_8.mask, false)
	setActive(arg0_8.maskState, false)
	setText(arg0_8.limitText, "")

	arg0_8.tipText.text = ""

	local var0_8 = arg1_8:getLimitCount()
	local var1_8 = arg1_8.buyCount or 0

	if var0_8 > 0 then
		setText(arg0_8.limitText, i18n("charge_limit_all", var0_8 - var1_8, var0_8))
		setActive(arg0_8.mask, var0_8 <= var1_8)
	end

	local var2_8 = arg1_8:getConfig("group_limit")

	if var2_8 > 0 then
		local var3_8 = arg1_8:getConfig("group_type") or 0

		if var3_8 == 1 then
			setText(arg0_8.limitText, i18n("charge_limit_daily", var2_8 - arg1_8.groupCount, var2_8))
		elseif var3_8 == 2 then
			setText(arg0_8.limitText, i18n("charge_limit_weekly", var2_8 - arg1_8.groupCount, var2_8))
		elseif var3_8 == 3 then
			setText(arg0_8.limitText, i18n("charge_limit_monthly", var2_8 - arg1_8.groupCount, var2_8))
		end
	end

	arg0_8.price.text = arg1_8:getConfig("resource_num")
	arg0_8.tipText.text = ""

	setActive(arg0_8.count, false)
	setActive(arg0_8.icon, true)
	setText(arg0_8.desc, "")

	local var4_8 = arg1_8:getConfig("tag")

	setActive(arg0_8.tag, var4_8 > 0)

	if var4_8 > 0 then
		for iter0_8, iter1_8 in ipairs(arg0_8.tags) do
			setActive(iter1_8, iter0_8 == var4_8)
		end
	end

	setActive(arg0_8.timeLeftTag, false)

	local var5_8, var6_8 = arg1_8:inTime()

	if var5_8 and not arg1_8:isFree() and var6_8 and var6_8 > 0 then
		local var7_8, var8_8, var9_8 = pg.TimeMgr.GetInstance():parseTimeFrom(var6_8)

		if var7_8 > 0 then
			setActive(arg0_8.timeLeftTag, true)
			setActive(arg0_8.dayLeftTag, true)
			setActive(arg0_8.hourLeftTag, false)
			setActive(arg0_8.minLeftTag, false)
			setText(arg0_8.numLeftText, var7_8)
		elseif var8_8 > 0 then
			setActive(arg0_8.timeLeftTag, true)
			setActive(arg0_8.dayLeftTag, false)
			setActive(arg0_8.hourLeftTag, true)
			setActive(arg0_8.minLeftTag, false)
			setText(arg0_8.numLeftText, var8_8)
		elseif var9_8 > 0 then
			setActive(arg0_8.timeLeftTag, true)
			setActive(arg0_8.dayLeftTag, false)
			setActive(arg0_8.hourLeftTag, false)
			setActive(arg0_8.minLeftTag, true)
			setText(arg0_8.numLeftText, var9_8)
		else
			setActive(arg0_8.timeLeftTag, true)
			setActive(arg0_8.dayLeftTag, false)
			setActive(arg0_8.hourLeftTag, false)
			setActive(arg0_8.minLeftTag, true)
			setText(arg0_8.numLeftText, 0)
		end

		local var10_8 = 60
		local var11_8 = 3600
		local var12_8 = 86400
		local var13_8

		if var12_8 <= var6_8 then
			var13_8 = var6_8 % var12_8
		elseif var11_8 <= var6_8 then
			var13_8 = var6_8 % var11_8
		elseif var10_8 <= var6_8 then
			var13_8 = var6_8 % var10_8
		end

		if var13_8 and var13_8 > 0 then
			if arg0_8.countDownTimer then
				arg0_8.countDownTimer:Stop()

				arg0_8.countDownTimer = nil
			end

			arg0_8.countDownTimer = Timer.New(function()
				arg0_8:updateGemItem(arg1_8, arg2_8)
			end, var13_8, 1)

			arg0_8.countDownTimer:Start()
		end
	end

	setActive(arg0_8.name, true)

	local var14_8 = arg1_8:getConfig("effect_args")

	if #var14_8 > 0 then
		local var15_8 = Item.getConfigData(var14_8[1])

		if var15_8 then
			setScrollText(arg0_8.name, var15_8.name)
			arg0_8:updateImport(var15_8.display_icon, var15_8.display)

			local var16_8 = arg0_8:CheckSkinDiscounItem(var15_8.display_icon)

			if var16_8 then
				arg0_8:UpdateShipIcon(var16_8)
			end
		end

		arg0_8.iconTF.sprite = GetSpriteFromAtlas("chargeicon/1", "")

		LoadSpriteAsync(var15_8.icon, function(arg0_10)
			if arg0_10 and not IsNil(arg0_8.iconTF) then
				arg0_8.iconTF.sprite = arg0_10

				arg0_8.iconTF:SetNativeSize()
			end
		end)
	end

	setButtonEnabled(arg0_8.tr, not isActive(arg0_8.mask))
end

function var0_0.CheckSkinDiscounItem(arg0_11, arg1_11)
	for iter0_11, iter1_11 in pairs(arg1_11) do
		local var0_11 = Drop.Create(iter1_11)
		local var1_11 = var0_11:getConfigTable()

		if var1_11.usage and var1_11.usage == ItemUsage.USAGE_SHOP_DISCOUNT then
			return var0_11
		end
	end

	return nil
end

local function var1_0(arg0_12)
	local var0_12 = arg0_12:getConfigTable()

	if var0_12.usage and var0_12.usage == ItemUsage.USAGE_SKIN_EXP then
		return false
	end

	return true
end

function var0_0.updateImport(arg0_13, arg1_13, arg2_13)
	setActive(arg0_13.important, true)

	local var0_13 = {}

	for iter0_13, iter1_13 in ipairs(arg1_13) do
		table.insert(var0_13, Drop.Create(iter1_13))
	end

	for iter2_13 = 1, arg0_13.grid.childCount do
		local var1_13 = arg0_13.grid:GetChild(iter2_13 - 1)

		if iter2_13 <= #var0_13 then
			setActive(var1_13, var1_0(var0_13[iter2_13]))
			updateDrop(var1_13, var0_13[iter2_13])
		else
			setActive(var1_13, false)
		end
	end

	setText(arg0_13.importantTip, string.gsub(arg2_13, "$1", #var0_13))
end

function var0_0.updateCountdown(arg0_14, arg1_14)
	local var0_14 = false

	if arg1_14 then
		local var1_14 = pg.TimeMgr.GetInstance()

		var0_14 = var1_14:DiffDay(var1_14:GetServerTime(), pg.TimeMgr.GetInstance():Table2ServerTime(arg1_14)) < 365
	end

	setActive(arg0_14.countDown, var0_14)

	local var2_14 = pg.TimeMgr.GetInstance()

	local function var3_14()
		if arg0_14.updateTimer then
			arg0_14.updateTimer:Stop()

			arg0_14.updateTimer = nil
		end
	end

	var3_14()

	local var4_14 = var2_14:Table2ServerTime(arg1_14)

	arg0_14.updateTimer = Timer.New(function()
		local var0_16 = var2_14:GetServerTime()

		if var0_16 > var4_14 then
			var3_14()
		end

		local var1_16 = var4_14 - var0_16

		var1_16 = var1_16 < 0 and 0 or var1_16

		local var2_16 = math.floor(var1_16 / 86400)

		if var2_16 > 0 then
			setText(arg0_14.countDownTm, i18n("skin_remain_time") .. var2_16 .. i18n("word_date"))
		else
			local var3_16 = math.floor(var1_16 / 3600)

			if var3_16 > 0 then
				setText(arg0_14.countDownTm, i18n("skin_remain_time") .. var3_16 .. i18n("word_hour"))
			else
				local var4_16 = math.floor(var1_16 / 60)

				if var4_16 > 0 then
					setText(arg0_14.countDownTm, i18n("skin_remain_time") .. var4_16 .. i18n("word_minute"))
				else
					setText(arg0_14.countDownTm, i18n("skin_remain_time") .. var1_16 .. i18n("word_second"))
				end
			end
		end
	end, 1, -1)

	arg0_14.updateTimer:Start()
	arg0_14.updateTimer.func()
end

function var0_0.destoryTimer(arg0_17)
	if arg0_17.updateTimer then
		arg0_17.updateTimer:Stop()

		arg0_17.updateTimer = nil
	end

	if arg0_17.countDownTimer then
		arg0_17.countDownTimer:Stop()

		arg0_17.countDownTimer = nil
	end
end

return var0_0
