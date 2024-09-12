local var0_0 = class("ChargeCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.go = arg1_1
	arg0_1.tr = tf(arg1_1)
	arg0_1.icon = arg0_1.tr:Find("real_tpl/item_icon")
	arg0_1.iconTF = arg0_1.icon:GetComponent(typeof(Image))
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
		if arg0_5 then
			arg0_3.iconTF.sprite = arg0_5

			arg0_3.iconTF:SetNativeSize()
		end
	end)
	setButtonEnabled(arg0_3.tr, not isActive(arg0_3.mask))
end

function var0_0.updateGemItem(arg0_6, arg1_6, arg2_6)
	setActive(arg0_6.mask, false)
	setActive(arg0_6.maskState, false)
	setText(arg0_6.limitText, "")

	arg0_6.tipText.text = ""

	local var0_6 = arg1_6:getLimitCount()
	local var1_6 = arg1_6.buyCount or 0

	if var0_6 > 0 then
		setText(arg0_6.limitText, i18n("charge_limit_all", var0_6 - var1_6, var0_6))
		setActive(arg0_6.mask, var0_6 <= var1_6)
	end

	local var2_6 = arg1_6:getConfig("group_limit")

	if var2_6 > 0 then
		local var3_6 = arg1_6:getConfig("group_type") or 0

		if var3_6 == 1 then
			setText(arg0_6.limitText, i18n("charge_limit_daily", var2_6 - arg1_6.groupCount, var2_6))
		elseif var3_6 == 2 then
			setText(arg0_6.limitText, i18n("charge_limit_weekly", var2_6 - arg1_6.groupCount, var2_6))
		elseif var3_6 == 3 then
			setText(arg0_6.limitText, i18n("charge_limit_monthly", var2_6 - arg1_6.groupCount, var2_6))
		end
	end

	arg0_6.price.text = arg1_6:getConfig("resource_num")
	arg0_6.tipText.text = ""

	setActive(arg0_6.count, false)
	setActive(arg0_6.icon, true)
	setText(arg0_6.desc, "")

	local var4_6 = arg1_6:getConfig("tag")

	setActive(arg0_6.tag, var4_6 > 0)

	if var4_6 > 0 then
		for iter0_6, iter1_6 in ipairs(arg0_6.tags) do
			setActive(iter1_6, iter0_6 == var4_6)
		end
	end

	setActive(arg0_6.timeLeftTag, false)

	local var5_6, var6_6 = arg1_6:inTime()

	if var5_6 and not arg1_6:isFree() and var6_6 and var6_6 > 0 then
		local var7_6, var8_6, var9_6 = pg.TimeMgr.GetInstance():parseTimeFrom(var6_6)

		if var7_6 > 0 then
			setActive(arg0_6.timeLeftTag, true)
			setActive(arg0_6.dayLeftTag, true)
			setActive(arg0_6.hourLeftTag, false)
			setActive(arg0_6.minLeftTag, false)
			setText(arg0_6.numLeftText, var7_6)
		elseif var8_6 > 0 then
			setActive(arg0_6.timeLeftTag, true)
			setActive(arg0_6.dayLeftTag, false)
			setActive(arg0_6.hourLeftTag, true)
			setActive(arg0_6.minLeftTag, false)
			setText(arg0_6.numLeftText, var8_6)
		elseif var9_6 > 0 then
			setActive(arg0_6.timeLeftTag, true)
			setActive(arg0_6.dayLeftTag, false)
			setActive(arg0_6.hourLeftTag, false)
			setActive(arg0_6.minLeftTag, true)
			setText(arg0_6.numLeftText, var9_6)
		else
			setActive(arg0_6.timeLeftTag, true)
			setActive(arg0_6.dayLeftTag, false)
			setActive(arg0_6.hourLeftTag, false)
			setActive(arg0_6.minLeftTag, true)
			setText(arg0_6.numLeftText, 0)
		end

		local var10_6 = 60
		local var11_6 = 3600
		local var12_6 = 86400
		local var13_6

		if var12_6 <= var6_6 then
			var13_6 = var6_6 % var12_6
		elseif var11_6 <= var6_6 then
			var13_6 = var6_6 % var11_6
		elseif var10_6 <= var6_6 then
			var13_6 = var6_6 % var10_6
		end

		if var13_6 and var13_6 > 0 then
			if arg0_6.countDownTimer then
				arg0_6.countDownTimer:Stop()

				arg0_6.countDownTimer = nil
			end

			arg0_6.countDownTimer = Timer.New(function()
				arg0_6:updateGemItem(arg1_6, arg2_6)
			end, var13_6, 1)

			arg0_6.countDownTimer:Start()
		end
	end

	setActive(arg0_6.name, true)

	local var14_6 = arg1_6:getConfig("effect_args")

	if #var14_6 > 0 then
		local var15_6 = Item.getConfigData(var14_6[1])

		if var15_6 then
			setScrollText(arg0_6.name, var15_6.name)
			arg0_6:updateImport(var15_6.display_icon, var15_6.display)
		end

		arg0_6.iconTF.sprite = GetSpriteFromAtlas("chargeicon/1", "")

		LoadSpriteAsync(var15_6.icon, function(arg0_8)
			if arg0_8 then
				arg0_6.iconTF.sprite = arg0_8

				arg0_6.iconTF:SetNativeSize()
			end
		end)
	end

	setButtonEnabled(arg0_6.tr, not isActive(arg0_6.mask))
end

function var0_0.updateImport(arg0_9, arg1_9, arg2_9)
	setActive(arg0_9.important, true)

	local var0_9 = {}

	for iter0_9, iter1_9 in ipairs(arg1_9) do
		table.insert(var0_9, Drop.Create(iter1_9))
	end

	for iter2_9 = 1, arg0_9.grid.childCount do
		local var1_9 = arg0_9.grid:GetChild(iter2_9 - 1)

		if iter2_9 <= #var0_9 then
			setActive(var1_9, true)
			updateDrop(var1_9, var0_9[iter2_9])
		else
			setActive(var1_9, false)
		end
	end

	setText(arg0_9.importantTip, string.gsub(arg2_9, "$1", #var0_9))
end

function var0_0.updateCountdown(arg0_10, arg1_10)
	local var0_10 = false

	if arg1_10 then
		local var1_10 = pg.TimeMgr.GetInstance()

		var0_10 = var1_10:DiffDay(var1_10:GetServerTime(), pg.TimeMgr.GetInstance():Table2ServerTime(arg1_10)) < 365
	end

	setActive(arg0_10.countDown, var0_10)

	local var2_10 = pg.TimeMgr.GetInstance()

	local function var3_10()
		if arg0_10.updateTimer then
			arg0_10.updateTimer:Stop()

			arg0_10.updateTimer = nil
		end
	end

	var3_10()

	local var4_10 = var2_10:Table2ServerTime(arg1_10)

	arg0_10.updateTimer = Timer.New(function()
		local var0_12 = var2_10:GetServerTime()

		if var0_12 > var4_10 then
			var3_10()
		end

		local var1_12 = var4_10 - var0_12

		var1_12 = var1_12 < 0 and 0 or var1_12

		local var2_12 = math.floor(var1_12 / 86400)

		if var2_12 > 0 then
			setText(arg0_10.countDownTm, i18n("skin_remain_time") .. var2_12 .. i18n("word_date"))
		else
			local var3_12 = math.floor(var1_12 / 3600)

			if var3_12 > 0 then
				setText(arg0_10.countDownTm, i18n("skin_remain_time") .. var3_12 .. i18n("word_hour"))
			else
				local var4_12 = math.floor(var1_12 / 60)

				if var4_12 > 0 then
					setText(arg0_10.countDownTm, i18n("skin_remain_time") .. var4_12 .. i18n("word_minute"))
				else
					setText(arg0_10.countDownTm, i18n("skin_remain_time") .. var1_12 .. i18n("word_second"))
				end
			end
		end
	end, 1, -1)

	arg0_10.updateTimer:Start()
	arg0_10.updateTimer.func()
end

function var0_0.destoryTimer(arg0_13)
	if arg0_13.updateTimer then
		arg0_13.updateTimer:Stop()

		arg0_13.updateTimer = nil
	end

	if arg0_13.countDownTimer then
		arg0_13.countDownTimer:Stop()

		arg0_13.countDownTimer = nil
	end
end

return var0_0
