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
	setActive(arg0_2.focusTip, arg1_2:isFree())
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

function var0_0.updateCharge(arg0_3, arg1_3, arg2_3, arg3_3)
	setActive(arg0_3.tag, true)

	local var0_3 = not table.contains(arg3_3, arg1_3.id) and arg1_3:firstPayDouble() and 4 or arg1_3:getConfig("tag")

	setActive(arg0_3.tag, var0_3 > 0)

	if var0_3 > 0 then
		for iter0_3, iter1_3 in ipairs(arg0_3.tags) do
			setActive(iter1_3, iter0_3 == var0_3)
		end
	end

	setActive(arg0_3.numLeftText, false)

	local var1_3, var2_3 = arg1_3:inTime()

	if var1_3 and not arg1_3:isFree() and var2_3 and var2_3 > 0 then
		setActive(arg0_3.numLeftText, true)

		local var3_3, var4_3, var5_3 = pg.TimeMgr.GetInstance():parseTimeFrom(var2_3)

		if var3_3 > 0 then
			setText(arg0_3.numLeftText, i18n("shop_goods_left_day", var3_3))
		elseif var4_3 > 0 then
			setText(arg0_3.numLeftText, i18n("shop_goods_left_hour", var4_3))
		elseif var5_3 then
			setText(arg0_3.numLeftText, i18n("shop_goods_left_minute", var5_3 > 0 and var5_3 or 1))
		end

		local var6_3 = 60
		local var7_3 = 3600
		local var8_3 = 86400
		local var9_3

		if var8_3 <= var2_3 then
			var9_3 = var2_3 % var8_3
		elseif var7_3 <= var2_3 then
			var9_3 = var2_3 % var7_3
		elseif var6_3 <= var2_3 then
			var9_3 = var2_3 % var6_3
		end

		if var9_3 and var9_3 > 0 then
			if arg0_3.countDownTimer then
				arg0_3.countDownTimer:Stop()

				arg0_3.countDownTimer = nil
			end

			arg0_3.countDownTimer = Timer.New(function()
				arg0_3:updateGemItem(arg1_3, arg2_3)
			end, var9_3, 1)

			arg0_3.countDownTimer:Start()
		end
	end

	setScrollText(arg0_3.name, arg1_3:getConfig("name_display"))

	if arg1_3:isItemBox() or arg1_3:isGiftBox() or arg1_3:isPassItem() then
		arg0_3:updateImport(arg0_3:GetPayDisplayItemData(arg1_3))
	end

	local var10_3 = arg1_3:getConfig("limit_type")
	local var11_3 = arg1_3.buyCount
	local var12_3 = arg1_3:getLimitCount()

	if var10_3 == 2 then
		setText(arg0_3.limitText, i18n("charge_limit_all", var12_3 - var11_3, var12_3))
	elseif var10_3 == 4 then
		setText(arg0_3.limitText, i18n("charge_limit_daily", var12_3 - var11_3, var12_3))
	else
		setText(arg0_3.limitText, "")
	end

	arg0_3.price.text = arg1_3:getConfig("money")

	if PLATFORM_CODE == PLATFORM_CHT and arg1_3:IsLocalPrice() then
		setActive(arg0_3.rmb, false)
	end

	arg0_3.iconTF.sprite = GetSpriteFromAtlas("chargeicon/1", "")

	LoadSpriteAsync("chargeicon/" .. arg1_3:getConfig("picture"), function(arg0_5)
		if arg0_5 and not IsNil(arg0_3.iconTF) then
			arg0_3.iconTF.sprite = arg0_5
		end
	end)
end

function var0_0.UpdateShipIcon(arg0_6, arg1_6)
	if IsNil(arg0_6.shipIcon) then
		return
	end

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
	setText(arg0_8.limitText, "")

	local var0_8 = arg1_8:getLimitCount()
	local var1_8 = arg1_8.buyCount or 0

	if var0_8 > 0 then
		setText(arg0_8.limitText, i18n("charge_limit_all", var0_8 - var1_8, var0_8))
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

	setActive(arg0_8.icon, true)

	local var4_8 = arg1_8:getConfig("tag")

	setActive(arg0_8.tag, var4_8 > 0)

	if var4_8 > 0 then
		for iter0_8, iter1_8 in ipairs(arg0_8.tags) do
			setActive(iter1_8, iter0_8 == var4_8)
		end
	end

	setActive(arg0_8.numLeftText, false)

	local var5_8, var6_8 = arg1_8:inTime()

	if var5_8 and not arg1_8:isFree() and var6_8 and var6_8 > 0 then
		setActive(arg0_8.numLeftText, true)

		local var7_8, var8_8, var9_8 = pg.TimeMgr.GetInstance():parseTimeFrom(var6_8)

		if var7_8 > 0 then
			setText(arg0_8.numLeftText, i18n("shop_goods_left_day", var7_8))
		elseif var8_8 > 0 then
			setText(arg0_8.numLeftText, i18n("shop_goods_left_hour", var8_8))
		elseif var9_8 then
			setText(arg0_8.numLeftText, i18n("shop_goods_left_minute", var9_8 > 0 and var9_8 or 1))
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
			arg0_8:updateImport(arg0_8:GetShopDisplayItemData(arg1_8))

			local var16_8 = arg0_8:CheckSkinDiscounItem(var15_8.display_icon)

			if var16_8 then
				arg0_8:UpdateShipIcon(var16_8)
			end
		end

		arg0_8.iconTF.sprite = GetSpriteFromAtlas("chargeicon/1", "")

		LoadSpriteAsync(var15_8.icon, function(arg0_10)
			if arg0_10 and not IsNil(arg0_8.iconTF) then
				arg0_8.iconTF.sprite = arg0_10
			end
		end)
	end
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

function var0_0.updateImport(arg0_13, arg1_13)
	local var0_13 = #arg1_13 >= 2

	setActive(arg0_13.itemPanel1, var0_13)

	if var0_13 then
		setActive(arg0_13.itemPanel2, false)
		setActive(arg0_13.itemPanel3, false)
		setScrollText(arg0_13.firstTipText, arg1_13[1].text)
		setScrollText(arg0_13.secondTipText, arg1_13[2].text)

		local var1_13 = {}

		for iter0_13, iter1_13 in ipairs(arg1_13[1].list) do
			table.insert(var1_13, Drop.Create(iter1_13))
		end

		for iter2_13 = 1, arg0_13.grid1.childCount do
			local var2_13 = arg0_13.grid:GetChild(iter2_13 - 1)

			if iter2_13 <= #var1_13 then
				setActive(var2_13, var1_0(var1_13[iter2_13]))
				updateDrop(var2_13:Find("itemBg/item"), var1_13[iter2_13])
			else
				setActive(var2_13, false)
			end
		end

		local var3_13 = {}

		for iter3_13, iter4_13 in ipairs(arg1_13[2].list) do
			table.insert(var3_13, Drop.Create(iter4_13))
		end

		for iter5_13 = 1, arg0_13.grid1.childCount do
			local var4_13 = arg0_13.grid1:GetChild(iter5_13 - 1)

			if iter5_13 <= #var3_13 then
				setActive(var4_13, var1_0(var3_13[iter5_13]))
				updateDrop(var4_13:Find("itemBg/item"), var3_13[iter5_13])
			else
				setActive(var4_13, false)
			end
		end
	else
		local var5_13 = arg1_13[1].text
		local var6_13 = var5_13 == ""

		setActive(arg0_13.itemPanel2, not var6_13)
		setActive(arg0_13.itemPanel3, var6_13)

		if var6_13 then
			setScrollText(arg0_13.firstTipText3, i18n("shop_item_unlock"))

			local var7_13 = {}

			for iter6_13, iter7_13 in ipairs(arg1_13[1].list) do
				table.insert(var7_13, Drop.Create(iter7_13))
			end

			for iter8_13 = 1, arg0_13.grid3.childCount do
				local var8_13 = arg0_13.grid3:GetChild(iter8_13 - 1)

				if iter8_13 <= #var7_13 then
					setActive(var8_13, var1_0(var7_13[iter8_13]))
					updateDrop(var8_13:Find("itemBg/item"), var7_13[iter8_13])
				else
					setActive(var8_13, false)
				end
			end
		else
			setScrollText(arg0_13.firstTipText2, var5_13)

			local var9_13 = {}

			for iter9_13, iter10_13 in ipairs(arg1_13[1].list) do
				table.insert(var9_13, Drop.Create(iter10_13))
			end

			for iter11_13 = 1, arg0_13.grid2.childCount do
				local var10_13 = arg0_13.grid2:GetChild(iter11_13 - 1)

				if iter11_13 <= #var9_13 then
					setActive(var10_13, var1_0(var9_13[iter11_13]))
					updateDrop(var10_13:Find("itemBg/item"), var9_13[iter11_13])
				else
					setActive(var10_13, false)
				end
			end
		end
	end
end

function var0_0.GetPayDisplayItemData(arg0_14, arg1_14)
	local var0_14 = {}
	local var1_14 = arg1_14:getConfig("first_text")

	if var1_14 ~= "" then
		table.insert(var0_14, {
			text = var1_14,
			list = arg1_14:getConfig("first_icon")
		})
	end

	local var2_14 = arg1_14:getConfig("second_text")

	table.insert(var0_14, {
		text = var2_14,
		list = arg1_14:getConfig("display")
	})

	return var0_14
end

function var0_0.GetShopDisplayItemData(arg0_15, arg1_15)
	local var0_15 = {}
	local var1_15 = arg1_15:getConfig("first_text")

	if var1_15 ~= "" then
		table.insert(var0_15, {
			text = var1_15,
			list = arg1_15:getConfig("first_icon")
		})
	end

	local var2_15 = arg1_15:getConfig("second_text")
	local var3_15 = arg1_15:getConfig("effect_args")
	local var4_15 = Item.getConfigData(var3_15[1])

	table.insert(var0_15, {
		text = var2_15,
		list = var4_15.display_icon
	})

	return var0_15
end

function var0_0.destoryTimer(arg0_16)
	if arg0_16.countDownTimer then
		arg0_16.countDownTimer:Stop()

		arg0_16.countDownTimer = nil
	end
end

return var0_0
