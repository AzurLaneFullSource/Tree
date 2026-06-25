local var0_0 = class("ChargeCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.go = arg1_1
	arg0_1.tr = tf(arg1_1)
	arg0_1.icon = arg0_1.tr:Find("real_tpl/item_icon")
	arg0_1.iconTF = arg0_1.icon:GetComponent(typeof(Image))
	arg0_1.shipIcon = arg0_1.tr:Find("real_tpl/item_icon/ship")
	arg0_1.priceTf = arg0_1.tr:Find("real_tpl/Price/Text")
	arg0_1.price = arg0_1.priceTf:GetComponent(typeof(Text))
	arg0_1.freeTag = arg0_1.tr:Find("real_tpl/Price/FreeText")
	arg0_1.tecShipBuyTag = arg0_1.tr:Find("real_tpl/Price/BuyText")
	arg0_1.contain = arg0_1.tr:Find("real_tpl/Price")
	arg0_1.rmb = arg0_1.tr:Find("real_tpl/Price/icon_rmb")
	arg0_1.gem = arg0_1.tr:Find("real_tpl/Price/icon_gem")
	arg0_1.name = arg0_1.tr:Find("real_tpl/item_name_mask/item_name")
	arg0_1.itemPanel1 = arg0_1.tr:Find("real_tpl/itemPanel1")
	arg0_1.firstTipText = arg0_1.tr:Find("real_tpl/itemPanel1/Tip/Text")
	arg0_1.secondTipText = arg0_1.tr:Find("real_tpl/itemPanel1/Tip2/Text")
	arg0_1.grid = arg0_1.tr:Find("real_tpl/itemPanel1/grid")
	arg0_1.grid1 = arg0_1.tr:Find("real_tpl/itemPanel1/grid1")
	arg0_1.itemPanel2 = arg0_1.tr:Find("real_tpl/itemPanel2")
	arg0_1.firstTipText2 = arg0_1.tr:Find("real_tpl/itemPanel2/Tip/Text")
	arg0_1.addImage = arg0_1.tr:Find("real_tpl/itemPanel2/addImg")
	arg0_1.grid2 = arg0_1.tr:Find("real_tpl/itemPanel2/grid")
	arg0_1.itemPanel3 = arg0_1.tr:Find("real_tpl/itemPanel3")
	arg0_1.firstTipText3 = arg0_1.tr:Find("real_tpl/itemPanel3/Tip/Text")
	arg0_1.grid3 = arg0_1.tr:Find("real_tpl/itemPanel3/grid")
	arg0_1.limitText = arg0_1.tr:Find("real_tpl/LimitText")
	arg0_1.viewBtn = arg0_1.tr:Find("real_tpl/view")
	arg0_1.numLeftText = arg0_1.tr:Find("real_tpl/leftTimeText")
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

	arg0_1.packageTag = arg0_1.tr:Find("real_tpl/package_tag")
end

function var0_0.update(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2.goods = arg1_2

	if not IsNil(arg0_2.shipIcon) then
		setActive(arg0_2.shipIcon, false)
	end

	local var0_2 = arg1_2:isChargeType() and arg1_2:getShowType() ~= ""

	setActive(arg0_2.rmb, arg1_2:isChargeType() and not var0_2)
	setActive(arg0_2.gem, not arg1_2:isChargeType() and not arg1_2:isFree())
	setText(arg0_2.freeTag, i18n("shop_free_tag"))
	setText(arg0_2.tecShipBuyTag, i18n("word_buy"))
	setActive(arg0_2.tecShipBuyTag, var0_2)
	setActive(arg0_2.freeTag, arg1_2:isFree())
	setActive(arg0_2.priceTf, not arg1_2:isFree() and not var0_2)
	pg.EasyRedDotMgr.GetInstance():RegisterRedDot(arg0_2.focusTip, {
		"Charge_Page_Exposure"
	}, function(arg0_3)
		setActive(arg0_3, arg1_2:isTip())
	end)
	setActive(arg0_2.icon, arg1_2:isChargeType())
	setActive(arg0_2.contain, true)

	if arg0_2.viewBtn then
		setActive(arg0_2.viewBtn, arg1_2:isChargeType() and arg1_2:CanViewSkinProbability())
	end

	if arg0_2.packageTag then
		local var1_2 = arg1_2:GetPackageTag()

		setActive(arg0_2.packageTag, var1_2 ~= "")
		setText(arg0_2.packageTag:Find("Text"), var1_2)
	end

	if arg1_2:isChargeType() then
		arg0_2:updateCharge(arg1_2, arg2_2, arg3_2)
	else
		arg0_2:updateGemItem(arg1_2, arg2_2)
	end

	arg0_2:destoryTimer()
end

function var0_0.updateCharge(arg0_4, arg1_4, arg2_4, arg3_4)
	setActive(arg0_4.tag, true)

	local var0_4 = not table.contains(arg3_4, arg1_4.id) and arg1_4:firstPayDouble() and 4 or arg1_4:getConfig("tag")

	setActive(arg0_4.tag, var0_4 > 0)

	if var0_4 > 0 then
		for iter0_4, iter1_4 in ipairs(arg0_4.tags) do
			setActive(iter1_4, iter0_4 == var0_4)
		end
	end

	setActive(arg0_4.numLeftText, false)

	local var1_4, var2_4 = arg1_4:inTime()
	local var3_4 = arg1_4:getConfig("id") == ActivityConst.FREE_PACKAGE_SHOW_TIME_ID

	if var1_4 and (not arg1_4:isFree() or var3_4) and var2_4 and var2_4 > 0 then
		setActive(arg0_4.numLeftText, true)

		local var4_4, var5_4, var6_4 = pg.TimeMgr.GetInstance():parseTimeFrom(var2_4)

		if var4_4 > 0 then
			setText(arg0_4.numLeftText, i18n("shop_goods_left_day", var4_4))
		elseif var5_4 > 0 then
			setText(arg0_4.numLeftText, i18n("shop_goods_left_hour", var5_4))
		elseif var6_4 then
			setText(arg0_4.numLeftText, i18n("shop_goods_left_minute", var6_4 > 0 and var6_4 or 1))
		end

		local var7_4 = 60
		local var8_4 = 3600
		local var9_4 = 86400
		local var10_4

		if var9_4 <= var2_4 then
			var10_4 = var2_4 % var9_4
		elseif var8_4 <= var2_4 then
			var10_4 = var2_4 % var8_4
		elseif var7_4 <= var2_4 then
			var10_4 = var2_4 % var7_4
		end

		if var10_4 and var10_4 > 0 then
			if arg0_4.countDownTimer then
				arg0_4.countDownTimer:Stop()

				arg0_4.countDownTimer = nil
			end

			arg0_4.countDownTimer = Timer.New(function()
				arg0_4:updateGemItem(arg1_4, arg2_4)
			end, var10_4, 1)

			arg0_4.countDownTimer:Start()
		end
	end

	setScrollText(arg0_4.name, arg1_4:getConfig("name_display"))

	if arg1_4:isItemBox() or arg1_4:isGiftBox() or arg1_4:isPassItem() then
		arg0_4:updateImport(arg0_4:GetPayDisplayItemData(arg1_4))
	end

	local var11_4 = arg1_4:getConfig("limit_type")
	local var12_4 = arg1_4.buyCount
	local var13_4 = arg1_4:getLimitCount()

	if var11_4 == 2 then
		setText(arg0_4.limitText, i18n("charge_limit_all", var13_4 - var12_4, var13_4))
	elseif var11_4 == 4 then
		setText(arg0_4.limitText, i18n("charge_limit_daily", var13_4 - var12_4, var13_4))
	else
		setText(arg0_4.limitText, "")
	end

	arg0_4.price.text = arg1_4:getConfig("money")

	if PLATFORM_CODE == PLATFORM_CHT and arg1_4:IsLocalPrice() then
		setActive(arg0_4.rmb, false)
	end

	arg0_4.iconTF.sprite = GetSpriteFromAtlas("chargeicon/1", "")

	LoadSpriteAsync("chargeicon/" .. arg1_4:getConfig("picture"), function(arg0_6)
		if arg0_6 and not IsNil(arg0_4.iconTF) then
			arg0_4.iconTF.sprite = arg0_6
		end
	end)
end

function var0_0.UpdateShipIcon(arg0_7, arg1_7)
	if IsNil(arg0_7.shipIcon) then
		return
	end

	setActive(arg0_7.shipIcon, true)

	local var0_7 = arg0_7.shipIcon:Find("icon"):GetComponent(typeof(Image))
	local var1_7 = arg1_7:getConfigTable().usage_arg[1][1]

	assert(var1_7)

	local var2_7 = pg.shop_template[var1_7].effect_args[1]

	assert(var2_7)

	local var3_7 = pg.ship_skin_template[var2_7]

	LoadSpriteAsync("qicon/" .. var3_7.prefab, function(arg0_8)
		if arg0_8 and not IsNil(arg0_7.shipIcon) then
			var0_7.sprite = arg0_8
		end
	end)
end

function var0_0.updateGemItem(arg0_9, arg1_9, arg2_9)
	setText(arg0_9.limitText, "")

	local var0_9 = arg1_9:getLimitCount()
	local var1_9 = arg1_9.buyCount or 0

	if var0_9 > 0 then
		setText(arg0_9.limitText, i18n("charge_limit_all", var0_9 - var1_9, var0_9))
	end

	local var2_9 = arg1_9:getConfig("group_limit")

	if var2_9 > 0 then
		local var3_9 = arg1_9:getConfig("group_type") or 0

		if var3_9 == 1 then
			setText(arg0_9.limitText, i18n("charge_limit_daily", var2_9 - arg1_9.groupCount, var2_9))
		elseif var3_9 == 2 then
			setText(arg0_9.limitText, i18n("charge_limit_weekly", var2_9 - arg1_9.groupCount, var2_9))
		elseif var3_9 == 3 then
			setText(arg0_9.limitText, i18n("charge_limit_monthly", var2_9 - arg1_9.groupCount, var2_9))
		end
	end

	arg0_9.price.text = arg1_9:GetPrice()

	setActive(arg0_9.icon, true)

	local var4_9 = arg1_9:getConfig("tag")

	setActive(arg0_9.tag, var4_9 > 0)

	if var4_9 > 0 then
		for iter0_9, iter1_9 in ipairs(arg0_9.tags) do
			setActive(iter1_9, iter0_9 == var4_9)
		end
	end

	setActive(arg0_9.numLeftText, false)

	local var5_9, var6_9 = arg1_9:inTime()
	local var7_9 = arg1_9:getConfig("id") == ActivityConst.FREE_PACKAGE_SHOW_TIME_ID

	if var5_9 and (not arg1_9:isFree() or var7_9) and var6_9 and var6_9 > 0 then
		setActive(arg0_9.numLeftText, true)

		local var8_9, var9_9, var10_9 = pg.TimeMgr.GetInstance():parseTimeFrom(var6_9)

		if var8_9 > 0 then
			setText(arg0_9.numLeftText, i18n("shop_goods_left_day", var8_9))
		elseif var9_9 > 0 then
			setText(arg0_9.numLeftText, i18n("shop_goods_left_hour", var9_9))
		elseif var10_9 then
			setText(arg0_9.numLeftText, i18n("shop_goods_left_minute", var10_9 > 0 and var10_9 or 1))
		end

		local var11_9 = 60
		local var12_9 = 3600
		local var13_9 = 86400
		local var14_9

		if var13_9 <= var6_9 then
			var14_9 = var6_9 % var13_9
		elseif var12_9 <= var6_9 then
			var14_9 = var6_9 % var12_9
		elseif var11_9 <= var6_9 then
			var14_9 = var6_9 % var11_9
		end

		if var14_9 and var14_9 > 0 then
			if arg0_9.countDownTimer then
				arg0_9.countDownTimer:Stop()

				arg0_9.countDownTimer = nil
			end

			arg0_9.countDownTimer = Timer.New(function()
				arg0_9:updateGemItem(arg1_9, arg2_9)
			end, var14_9, 1)

			arg0_9.countDownTimer:Start()
		end
	end

	setActive(arg0_9.name, true)

	local var15_9 = arg1_9:getConfig("effect_args")

	if #var15_9 > 0 then
		local var16_9 = Item.getConfigData(var15_9[1])

		if var16_9 then
			setScrollText(arg0_9.name, var16_9.name)
			arg0_9:updateImport(arg0_9:GetShopDisplayItemData(arg1_9))

			local var17_9 = arg0_9:CheckSkinDiscounItem(var16_9.display_icon)

			if var17_9 then
				arg0_9:UpdateShipIcon(var17_9)
			end
		end

		arg0_9.iconTF.sprite = GetSpriteFromAtlas("chargeicon/1", "")

		LoadSpriteAsync(var16_9.icon, function(arg0_11)
			if arg0_11 and not IsNil(arg0_9.iconTF) then
				arg0_9.iconTF.sprite = arg0_11
			end
		end)
	end
end

function var0_0.CheckSkinDiscounItem(arg0_12, arg1_12)
	for iter0_12, iter1_12 in pairs(arg1_12) do
		local var0_12 = Drop.Create(iter1_12)
		local var1_12 = var0_12:getConfigTable()

		if var1_12.usage and var1_12.usage == ItemUsage.USAGE_SHOP_DISCOUNT then
			return var0_12
		end
	end

	return nil
end

local function var1_0(arg0_13)
	local var0_13 = arg0_13:getConfigTable()

	if var0_13.usage and var0_13.usage == ItemUsage.USAGE_SKIN_EXP then
		return false
	end

	return true
end

function var0_0.updateImport(arg0_14, arg1_14)
	local var0_14 = #arg1_14 >= 2

	setActive(arg0_14.itemPanel1, var0_14)

	if var0_14 then
		setActive(arg0_14.itemPanel2, false)
		setActive(arg0_14.itemPanel3, false)
		setScrollText(arg0_14.firstTipText, arg1_14[1].text)
		setScrollText(arg0_14.secondTipText, arg1_14[2].text)

		local var1_14 = {}

		for iter0_14, iter1_14 in ipairs(arg1_14[1].list) do
			table.insert(var1_14, Drop.Create(iter1_14))
		end

		for iter2_14 = 1, arg0_14.grid1.childCount do
			local var2_14 = arg0_14.grid:GetChild(iter2_14 - 1)

			if iter2_14 <= #var1_14 then
				setActive(var2_14, var1_0(var1_14[iter2_14]))
				updateDrop(var2_14:Find("itemBg/item"), var1_14[iter2_14])
			else
				setActive(var2_14, false)
			end
		end

		local var3_14 = {}

		for iter3_14, iter4_14 in ipairs(arg1_14[2].list) do
			table.insert(var3_14, Drop.Create(iter4_14))
		end

		for iter5_14 = 1, arg0_14.grid1.childCount do
			local var4_14 = arg0_14.grid1:GetChild(iter5_14 - 1)

			if iter5_14 <= #var3_14 then
				setActive(var4_14, var1_0(var3_14[iter5_14]))
				updateDrop(var4_14:Find("itemBg/item"), var3_14[iter5_14])
			else
				setActive(var4_14, false)
			end
		end
	else
		local var5_14 = arg1_14[1].text
		local var6_14 = var5_14 == ""

		setActive(arg0_14.itemPanel2, not var6_14)
		setActive(arg0_14.itemPanel3, var6_14)

		if var6_14 then
			setScrollText(arg0_14.firstTipText3, i18n("shop_item_unlock"))

			local var7_14 = {}

			for iter6_14, iter7_14 in ipairs(arg1_14[1].list) do
				table.insert(var7_14, Drop.Create(iter7_14))
			end

			for iter8_14 = 1, arg0_14.grid3.childCount do
				local var8_14 = arg0_14.grid3:GetChild(iter8_14 - 1)

				if iter8_14 <= #var7_14 then
					setActive(var8_14, var1_0(var7_14[iter8_14]))
					updateDrop(var8_14:Find("itemBg/item"), var7_14[iter8_14])
				else
					setActive(var8_14, false)
				end
			end
		else
			setScrollText(arg0_14.firstTipText2, var5_14)

			local var9_14 = {}

			for iter9_14, iter10_14 in ipairs(arg1_14[1].list) do
				table.insert(var9_14, Drop.Create(iter10_14))
			end

			for iter11_14 = 1, arg0_14.grid2.childCount do
				local var10_14 = arg0_14.grid2:GetChild(iter11_14 - 1)

				if iter11_14 <= #var9_14 then
					setActive(var10_14, var1_0(var9_14[iter11_14]))
					updateDrop(var10_14:Find("itemBg/item"), var9_14[iter11_14])
				else
					setActive(var10_14, false)
				end
			end
		end
	end
end

function var0_0.GetPayDisplayItemData(arg0_15, arg1_15)
	local var0_15 = {}
	local var1_15 = arg1_15:getConfig("first_text")

	if var1_15 ~= "" then
		table.insert(var0_15, {
			text = var1_15,
			list = arg1_15:getConfig("first_icon")
		})
	end

	local var2_15 = arg1_15:getConfig("second_text")

	table.insert(var0_15, {
		text = var2_15,
		list = arg1_15:getConfig("display")
	})

	return var0_15
end

function var0_0.GetShopDisplayItemData(arg0_16, arg1_16)
	local var0_16 = {}
	local var1_16 = arg1_16:getConfig("first_text")

	if var1_16 ~= "" then
		table.insert(var0_16, {
			text = var1_16,
			list = arg1_16:getConfig("first_icon")
		})
	end

	local var2_16 = arg1_16:getConfig("second_text")
	local var3_16 = arg1_16:getConfig("effect_args")
	local var4_16 = Item.getConfigData(var3_16[1])

	table.insert(var0_16, {
		text = var2_16,
		list = var4_16.display_icon
	})

	return var0_16
end

function var0_0.destoryTimer(arg0_17)
	if arg0_17.countDownTimer then
		arg0_17.countDownTimer:Stop()

		arg0_17.countDownTimer = nil
	end
end

function var0_0.Dispose(arg0_18)
	arg0_18:destoryTimer()
	pg.EasyRedDotMgr.GetInstance():UnRegisterRedDot(arg0_18.focusTip)
end

return var0_0
