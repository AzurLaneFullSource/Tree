local var0 = class("ChargeCard")

function var0.Ctor(arg0, arg1)
	arg0.go = arg1
	arg0.tr = tf(arg1)
	arg0.icon = arg0.tr:Find("real_tpl/item_icon")
	arg0.iconTF = arg0.icon:GetComponent(typeof(Image))
	arg0.tipTF = arg0.tr:Find("real_tpl/tip")
	arg0.tipText = arg0.tipTF:GetComponent(typeof(Text))
	arg0.count = arg0.tr:Find("real_tpl/count")
	arg0.resIcon = arg0.tr:Find("real_tpl/count/icon"):GetComponent(typeof(Image))
	arg0.resCount = arg0.tr:Find("real_tpl/count/Text"):GetComponent(typeof(Text))
	arg0.priceTf = arg0.tr:Find("real_tpl/prince_bg/contain/Text")
	arg0.price = arg0.priceTf:GetComponent(typeof(Text))
	arg0.freeTag = arg0.tr:Find("real_tpl/prince_bg/contain/FreeText")
	arg0.tecShipBuyTag = arg0.tr:Find("real_tpl/prince_bg/contain/BuyText")
	arg0.contain = arg0.tr:Find("real_tpl/prince_bg/contain")
	arg0.rmb = arg0.tr:Find("real_tpl/prince_bg/contain/icon_rmb")
	arg0.gem = arg0.tr:Find("real_tpl/prince_bg/contain/icon_gem")
	arg0.mask = arg0.tr:Find("real_tpl/mask")
	arg0.maskState = arg0.mask:Find("state")
	arg0.name = arg0.tr:Find("real_tpl/item_name_mask/item_name")
	arg0.important = arg0.tr:Find("real_tpl/important")
	arg0.grid = arg0.tr:Find("real_tpl/important/grid")
	arg0.importantTip = arg0.tr:Find("real_tpl/important/tip")
	arg0.desc = arg0.tr:Find("real_tpl/desc")
	arg0.selfTpl = arg0.tr:Find("real_tpl/important/item")
	arg0.limitText = arg0.tr:Find("real_tpl/LimitText")
	arg0.countDown = arg0.tr:Find("real_tpl/countDown")
	arg0.countDownTm = arg0.countDown:Find("Text")
	arg0.viewBtn = arg0.tr:Find("real_tpl/view")
	arg0.timeLeftTag = arg0.tr:Find("real_tpl/time_left")
	arg0.dayLeftTag = arg0.tr:Find("real_tpl/time_left/day")
	arg0.hourLeftTag = arg0.tr:Find("real_tpl/time_left/hour")
	arg0.minLeftTag = arg0.tr:Find("real_tpl/time_left/min")
	arg0.numLeftText = arg0.timeLeftTag:Find("Text")
	arg0.focusTip = arg0.tr:Find("real_tpl/focus_tip")
	arg0.tag = arg0.tr:Find("real_tpl/tag")
	arg0.tags = {}

	table.insert(arg0.tags, arg0.tr:Find("real_tpl/tag/hot"))
	table.insert(arg0.tags, arg0.tr:Find("real_tpl/tag/new"))
	table.insert(arg0.tags, arg0.tr:Find("real_tpl/tag/advice"))
	table.insert(arg0.tags, arg0.tr:Find("real_tpl/tag/double"))
	table.insert(arg0.tags, arg0.tr:Find("real_tpl/tag/activity"))
	table.insert(arg0.tags, arg0.tr:Find("real_tpl/tag/time"))
	table.insert(arg0.tags, arg0.tr:Find("real_tpl/tag/discount"))
	setActive(arg0.countDown, false)
end

function var0.update(arg0, arg1, arg2, arg3)
	arg0.goods = arg1

	local var0 = arg1:isChargeType() and arg1:isTecShipShowGift()

	setActive(arg0.desc, true)
	setText(arg0.desc, "")
	setActive(arg0.rmb, arg1:isChargeType() and not var0)
	setActive(arg0.gem, not arg1:isChargeType() and not arg1:isFree())
	setText(arg0.freeTag, i18n("shop_free_tag"))
	setText(arg0.tecShipBuyTag, i18n("word_buy"))
	setActive(arg0.tecShipBuyTag, var0)
	setActive(arg0.freeTag, arg1:isFree())
	setActive(arg0.priceTf, not arg1:isFree() and not var0)
	setActive(arg0.focusTip, arg1:isFree())
	setActive(arg0.icon, arg1:isChargeType())
	setActive(arg0.contain, true)
	setActive(arg0.countDown, false)

	if arg0.viewBtn then
		setActive(arg0.viewBtn, arg1:isChargeType() and arg1:CanViewSkinProbability())
	end

	if arg1:isChargeType() then
		arg0:updateCharge(arg1, arg2, arg3)
	else
		arg0:updateGemItem(arg1, arg2)
	end

	arg0:destoryTimer()
end

function var0.updateCharge(arg0, arg1, arg2, arg3)
	setActive(arg0.tag, true)
	setActive(arg0.mask, false)
	setActive(arg0.maskState, false)

	arg0.tipText.text = ""

	setText(arg0.desc, "")

	local var0 = not table.contains(arg3, arg1.id)
	local var1 = var0 and arg1:firstPayDouble()
	local var2 = var1 and 4 or arg1:getConfig("tag")

	setActive(arg0.timeLeftTag, false)
	setActive(arg0.tag, var2 > 0)

	if var2 > 0 then
		for iter0, iter1 in ipairs(arg0.tags) do
			setActive(iter1, iter0 == var2)
		end
	end

	setActive(arg0.timeLeftTag, false)

	local var3, var4 = arg1:inTime()

	if var3 and not arg1:isFree() and var4 and var4 > 0 then
		local var5, var6, var7 = pg.TimeMgr.GetInstance():parseTimeFrom(var4)

		if var5 > 0 then
			setActive(arg0.timeLeftTag, true)
			setActive(arg0.dayLeftTag, true)
			setActive(arg0.hourLeftTag, false)
			setActive(arg0.minLeftTag, false)
			setText(arg0.numLeftText, var5)
		elseif var6 > 0 then
			setActive(arg0.timeLeftTag, true)
			setActive(arg0.dayLeftTag, false)
			setActive(arg0.hourLeftTag, true)
			setActive(arg0.minLeftTag, false)
			setText(arg0.numLeftText, var6)
		elseif var7 > 0 then
			setActive(arg0.timeLeftTag, true)
			setActive(arg0.dayLeftTag, false)
			setActive(arg0.hourLeftTag, false)
			setActive(arg0.minLeftTag, true)
			setText(arg0.numLeftText, var7)
		else
			setActive(arg0.timeLeftTag, true)
			setActive(arg0.dayLeftTag, false)
			setActive(arg0.hourLeftTag, false)
			setActive(arg0.minLeftTag, true)
			setText(arg0.numLeftText, 0)
		end

		local var8 = 60
		local var9 = 3600
		local var10 = 86400
		local var11

		if var10 <= var4 then
			var11 = var4 % var10
		elseif var9 <= var4 then
			var11 = var4 % var9
		elseif var8 <= var4 then
			var11 = var4 % var8
		end

		if var11 and var11 > 0 then
			if arg0.countDownTimer then
				arg0.countDownTimer:Stop()

				arg0.countDownTimer = nil
			end

			arg0.countDownTimer = Timer.New(function()
				arg0:updateGemItem(arg1, arg2)
			end, var11, 1)

			arg0.countDownTimer:Start()
		end
	end

	setActive(arg0.resIcon, not arg1:isItemBox())
	setActive(arg0.resCount, not arg1:isItemBox())

	local var12 = arg1:isGem()

	setActive(arg0.name, not var12)
	setScrollText(arg0.name, arg1:getConfig("name_display"))
	setActive(arg0.important, arg1:isItemBox() or arg1:isGiftBox())
	setActive(arg0.count, var12 or arg1:isMonthCard())

	if arg1:isItemBox() or arg1:isGiftBox() or arg1:isPassItem() then
		arg0:updateImport(arg1:getConfig("display"), arg1:getConfig("descrip"))
	end

	local var13 = arg1:getConfig("limit_type")
	local var14 = arg1.buyCount
	local var15 = arg1:getLimitCount()

	if var13 == 2 then
		setText(arg0.limitText, i18n("charge_limit_all", var15 - var14, var15))
		setActive(arg0.mask, var15 - var14 <= 0)
	elseif var13 == 4 then
		setText(arg0.limitText, i18n("charge_limit_daily", var15 - var14, var15))
		setActive(arg0.mask, var15 - var14 <= 0)
	else
		setText(arg0.limitText, "")
	end

	if arg1:isGem() then
		setActive(arg0.tipTF, true)

		if var1 then
			local var16 = arg1:getConfig("gem") * arg1:getConfig("first_pay_double")

			arg0.tipText.text = i18n("charge_double_gem_tip", var16)
		elseif arg1:hasExtraGem() then
			arg0.tipText.text = i18n("charge_extra_gem_tip", arg1:getConfig("extra_gem"))
		else
			setActive(arg0.tipTF, false)
		end
	elseif arg1:isGiftBox() then
		-- block empty
	elseif arg1:isMonthCard() then
		local var17 = arg2:getCardById(VipCard.MONTH)

		if var17 and not var17:isExpire() then
			local var18 = var17:getLeftDate()
			local var19 = pg.TimeMgr.GetInstance():GetServerTime()
			local var20 = math.floor((var18 - var19) / 86400)
			local var21 = arg1:getConfig("limit_arg") or 0

			setActive(arg0.mask, var21 < var20)
			setText(arg0.limitText, i18n("charge_month_card_lefttime_tip", var20))
		end

		setText(arg0.desc, string.gsub(arg1:getConfig("descrip"), "$1", var0 and arg1:getConfig("gem") or arg1:getConfig("extra_gem")))
	elseif arg1:isItemBox() then
		-- block empty
	elseif arg1:isPassItem() then
		-- block empty
	end

	arg0.resCount.text = "x" .. arg1:getConfig("gem")
	arg0.price.text = arg1:getConfig("money")

	if PLATFORM_CODE == PLATFORM_CHT and arg1:IsLocalPrice() then
		setActive(arg0.rmb, false)
	end

	arg0.iconTF.sprite = GetSpriteFromAtlas("chargeicon/1", "")

	LoadSpriteAsync("chargeicon/" .. arg1:getConfig("picture"), function(arg0)
		if arg0 then
			arg0.iconTF.sprite = arg0

			arg0.iconTF:SetNativeSize()
		end
	end)
	setButtonEnabled(arg0.tr, not isActive(arg0.mask))
end

function var0.updateGemItem(arg0, arg1, arg2)
	setActive(arg0.mask, false)
	setActive(arg0.maskState, false)
	setText(arg0.limitText, "")

	arg0.tipText.text = ""

	local var0 = arg1:getLimitCount()
	local var1 = arg1.buyCount or 0

	if var0 > 0 then
		setText(arg0.limitText, i18n("charge_limit_all", var0 - var1, var0))
		setActive(arg0.mask, var0 <= var1)
	end

	local var2 = arg1:getConfig("group_limit")

	if var2 > 0 then
		local var3 = arg1:getConfig("group_type") or 0

		if var3 == 1 then
			setText(arg0.limitText, i18n("charge_limit_daily", var2 - arg1.groupCount, var2))
		elseif var3 == 2 then
			setText(arg0.limitText, i18n("charge_limit_weekly", var2 - arg1.groupCount, var2))
		elseif var3 == 3 then
			setText(arg0.limitText, i18n("charge_limit_monthly", var2 - arg1.groupCount, var2))
		end
	end

	arg0.price.text = arg1:getConfig("resource_num")
	arg0.tipText.text = ""

	setActive(arg0.count, false)
	setActive(arg0.icon, true)
	setText(arg0.desc, "")

	local var4 = arg1:getConfig("tag")

	setActive(arg0.tag, var4 > 0)

	if var4 > 0 then
		for iter0, iter1 in ipairs(arg0.tags) do
			setActive(iter1, iter0 == var4)
		end
	end

	setActive(arg0.timeLeftTag, false)

	local var5, var6 = arg1:inTime()

	if var5 and not arg1:isFree() and var6 and var6 > 0 then
		local var7, var8, var9 = pg.TimeMgr.GetInstance():parseTimeFrom(var6)

		if var7 > 0 then
			setActive(arg0.timeLeftTag, true)
			setActive(arg0.dayLeftTag, true)
			setActive(arg0.hourLeftTag, false)
			setActive(arg0.minLeftTag, false)
			setText(arg0.numLeftText, var7)
		elseif var8 > 0 then
			setActive(arg0.timeLeftTag, true)
			setActive(arg0.dayLeftTag, false)
			setActive(arg0.hourLeftTag, true)
			setActive(arg0.minLeftTag, false)
			setText(arg0.numLeftText, var8)
		elseif var9 > 0 then
			setActive(arg0.timeLeftTag, true)
			setActive(arg0.dayLeftTag, false)
			setActive(arg0.hourLeftTag, false)
			setActive(arg0.minLeftTag, true)
			setText(arg0.numLeftText, var9)
		else
			setActive(arg0.timeLeftTag, true)
			setActive(arg0.dayLeftTag, false)
			setActive(arg0.hourLeftTag, false)
			setActive(arg0.minLeftTag, true)
			setText(arg0.numLeftText, 0)
		end

		local var10 = 60
		local var11 = 3600
		local var12 = 86400
		local var13

		if var12 <= var6 then
			var13 = var6 % var12
		elseif var11 <= var6 then
			var13 = var6 % var11
		elseif var10 <= var6 then
			var13 = var6 % var10
		end

		if var13 and var13 > 0 then
			if arg0.countDownTimer then
				arg0.countDownTimer:Stop()

				arg0.countDownTimer = nil
			end

			arg0.countDownTimer = Timer.New(function()
				arg0:updateGemItem(arg1, arg2)
			end, var13, 1)

			arg0.countDownTimer:Start()
		end
	end

	setActive(arg0.name, true)

	local var14 = arg1:getConfig("effect_args")

	if #var14 > 0 then
		local var15 = Item.getConfigData(var14[1])

		if var15 then
			setScrollText(arg0.name, var15.name)
			arg0:updateImport(var15.display_icon, var15.display)
		end

		arg0.iconTF.sprite = GetSpriteFromAtlas("chargeicon/1", "")

		LoadSpriteAsync(var15.icon, function(arg0)
			if arg0 then
				arg0.iconTF.sprite = arg0

				arg0.iconTF:SetNativeSize()
			end
		end)
	end

	setButtonEnabled(arg0.tr, not isActive(arg0.mask))
end

function var0.updateImport(arg0, arg1, arg2)
	setActive(arg0.important, true)

	local var0 = {}

	for iter0, iter1 in ipairs(arg1) do
		table.insert(var0, Drop.Create(iter1))
	end

	for iter2 = 1, arg0.grid.childCount do
		local var1 = arg0.grid:GetChild(iter2 - 1)

		if iter2 <= #var0 then
			setActive(var1, true)
			updateDrop(var1, var0[iter2])
		else
			setActive(var1, false)
		end
	end

	setText(arg0.importantTip, string.gsub(arg2, "$1", #var0))
end

function var0.updateCountdown(arg0, arg1)
	local var0 = false

	if arg1 then
		local var1 = pg.TimeMgr.GetInstance()

		var0 = var1:DiffDay(var1:GetServerTime(), pg.TimeMgr.GetInstance():Table2ServerTime(arg1)) < 365
	end

	setActive(arg0.countDown, var0)

	local var2 = pg.TimeMgr.GetInstance()

	local function var3()
		if arg0.updateTimer then
			arg0.updateTimer:Stop()

			arg0.updateTimer = nil
		end
	end

	var3()

	local var4 = var2:Table2ServerTime(arg1)

	arg0.updateTimer = Timer.New(function()
		local var0 = var2:GetServerTime()

		if var0 > var4 then
			var3()
		end

		local var1 = var4 - var0

		var1 = var1 < 0 and 0 or var1

		local var2 = math.floor(var1 / 86400)

		if var2 > 0 then
			setText(arg0.countDownTm, i18n("skin_remain_time") .. var2 .. i18n("word_date"))
		else
			local var3 = math.floor(var1 / 3600)

			if var3 > 0 then
				setText(arg0.countDownTm, i18n("skin_remain_time") .. var3 .. i18n("word_hour"))
			else
				local var4 = math.floor(var1 / 60)

				if var4 > 0 then
					setText(arg0.countDownTm, i18n("skin_remain_time") .. var4 .. i18n("word_minute"))
				else
					setText(arg0.countDownTm, i18n("skin_remain_time") .. var1 .. i18n("word_second"))
				end
			end
		end
	end, 1, -1)

	arg0.updateTimer:Start()
	arg0.updateTimer.func()
end

function var0.destoryTimer(arg0)
	if arg0.updateTimer then
		arg0.updateTimer:Stop()

		arg0.updateTimer = nil
	end

	if arg0.countDownTimer then
		arg0.countDownTimer:Stop()

		arg0.countDownTimer = nil
	end
end

return var0
