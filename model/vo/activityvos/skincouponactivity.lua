local var0_0 = class("SkinCouponActivity", import("model.vo.Activity"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.dataConfig = pg.activity_event_shop_discount[arg0_1.configId]
end

function var0_0.GetDiscountPrice(arg0_2)
	return arg0_2.dataConfig.discount_price
end

function var0_0.GetNewPrice(arg0_3, arg1_3)
	return arg1_3 - arg0_3:GetDiscountPrice()
end

function var0_0.GetShopIdList(arg0_4)
	return arg0_4.dataConfig.shop_list
end

function var0_0.Left3Day(arg0_5)
	if arg0_5.stopTime - pg.TimeMgr.GetInstance():GetServerTime() < 259200 then
		return true
	end

	return false
end

function var0_0.ShouldTipUsage(arg0_6)
	local function var0_6()
		local var0_7 = getProxy(PlayerProxy):getRawData().id
		local var1_7 = PlayerPrefs.GetInt(arg0_6.id .. "_SkinCouponActivity_Tip" .. var0_7, 0)

		if var1_7 <= 0 then
			return true
		end

		local var2_7 = pg.TimeMgr.GetInstance():GetServerTime()

		return var1_7 < var2_7 and not pg.TimeMgr.GetInstance():IsSameDay(var2_7, var1_7)
	end

	return arg0_6:GetCanUsageCnt() > 0 and arg0_6:Left3Day() and var0_6()
end

function var0_0.SaveTipTime(arg0_8)
	local var0_8 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_8 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(arg0_8.id .. "_SkinCouponActivity_Tip" .. var1_8, var0_8)
	PlayerPrefs.Save()
end

function var0_0.IncludeShop(arg0_9, arg1_9)
	local var0_9 = arg0_9:GetShopIdList()

	return table.contains(var0_9, arg1_9)
end

function var0_0.GetCanUsageCnt(arg0_10)
	return arg0_10.data1 - arg0_10.data2
end

function var0_0.GetEquivalentRes(arg0_11)
	if arg0_11.dataConfig.change_resource_type == 0 or arg0_11.dataConfig.change_resource_num == 0 then
		return nil
	end

	local var0_11 = Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = arg0_11.dataConfig.change_resource_type,
		count = arg0_11.dataConfig.change_resource_num
	})

	var0_11.name = var0_11:getName()
end

function var0_0.GetLimitCnt(arg0_12)
	if arg0_12.dataConfig.max_count == 0 then
		return math.huge
	else
		return arg0_12.dataConfig.max_count
	end
end

function var0_0.IsMaxCnt(arg0_13)
	return arg0_13.data1 > arg0_13:GetLimitCnt()
end

function var0_0.GetItemId(arg0_14)
	return arg0_14.dataConfig.item_id
end

function var0_0.GetItemConfig(arg0_15)
	local var0_15 = arg0_15:GetItemId()

	return Item.getConfigData(var0_15) or {}
end

function var0_0.GetItemName(arg0_16)
	local var0_16 = arg0_16:GetItemId()
	local var1_16 = Item.getConfigData(var0_16)

	return var1_16 and var1_16.name or ""
end

function var0_0.ShopId2SkinId(arg0_17, arg1_17)
	return pg.shop_template[arg1_17].effect_args[1]
end

function var0_0.GetOwnCount(arg0_18)
	local var0_18 = underscore.map(arg0_18:GetShopIdList(), function(arg0_19)
		return arg0_18:ShopId2SkinId(arg0_19)
	end)

	return #underscore.filter(var0_18, function(arg0_20)
		return getProxy(ShipSkinProxy):hasNonLimitSkin(arg0_20)
	end), #var0_18
end

function var0_0.OwnAllSkin(arg0_21)
	local var0_21, var1_21 = arg0_21:GetOwnCount()

	return var0_21 == var1_21
end

function var0_0.GetSkinCouponActivities(arg0_22)
	local var0_22 = {}

	for iter0_22, iter1_22 in ipairs(pg.activity_template.get_id_list_by_type[ActivityConst.ACTIVITY_TYPE_SKIN_COUPON] or {}) do
		local var1_22 = getProxy(ActivityProxy):RawGetActivityById(iter1_22)

		if var1_22 and not var1_22:isEnd() and (not arg0_22 or var1_22:IncludeShop(arg0_22)) then
			table.insert(var0_22, var1_22)
		end
	end

	return var0_22
end

function var0_0.GetBestReadySkinCouponAct(arg0_23)
	local var0_23 = 0
	local var1_23

	for iter0_23, iter1_23 in ipairs(var0_0.GetSkinCouponActivities(arg0_23)) do
		if iter1_23:GetCanUsageCnt() > 0 and var0_23 < iter1_23:GetDiscountPrice() then
			var0_23 = iter1_23:GetDiscountPrice()
			var1_23 = iter1_23
		end
	end

	return var1_23
end

function var0_0.StaticExistActivityAndCoupon(arg0_24)
	return underscore.any(var0_0.GetSkinCouponActivities(arg0_24), function(arg0_25)
		return arg0_25:GetCanUsageCnt() > 0
	end)
end

function var0_0.GetSkinCouponActFromEncoreAct(arg0_26)
	if not arg0_26 then
		return
	end

	local var0_26 = Drop.New({
		type = DROP_TYPE_VITEM,
		id = arg0_26:GetConfigClientSetting("item_id")
	})
	local var1_26 = getProxy(ActivityProxy):getActivityById(var0_26:getConfig("link_id"))

	if var1_26 and not var1_26:isEnd() then
		return var1_26
	end
end

function var0_0.GetSkinCouponEncoreActivities(arg0_27)
	local var0_27 = {}

	for iter0_27, iter1_27 in ipairs(pg.activity_template.get_id_list_by_type[ActivityConst.ACTIVITY_TYPE_SKIN_COUPON_COUNTING] or {}) do
		local var1_27 = getProxy(ActivityProxy):RawGetActivityById(iter1_27)

		if var1_27 and not var1_27:isEnd() and (not arg0_27 or table.contains(var1_27:getConfig("config_data")[2], arg0_27)) then
			table.insert(var0_27, var1_27)
		end
	end

	return var0_27
end

function var0_0.StaticEncoreActTip(arg0_28)
	assert(arg0_28)

	for iter0_28, iter1_28 in ipairs(var0_0.GetSkinCouponEncoreActivities()) do
		local var0_28 = var0_0.GetSkinCouponActFromEncoreAct(iter1_28)

		if var0_28 and not var0_28:isEnd() and iter1_28 and not iter1_28:isEnd() and var0_28:IncludeShop(arg0_28) and var0_28:GetCanUsageCnt() <= 0 and iter1_28:getData1() > 0 then
			return iter1_28
		end
	end
end

function var0_0.GetOvercountEncoreActs(arg0_29)
	local var0_29 = {}

	for iter0_29, iter1_29 in ipairs(var0_0.GetSkinCouponEncoreActivities(arg0_29)) do
		local var1_29 = SkinCouponActivity.GetSkinCouponActFromEncoreAct(iter1_29)

		if var1_29 and not var1_29:isEnd() then
			local var2_29, var3_29 = var1_29:GetOwnCount()

			if var1_29:GetCanUsageCnt() + iter1_29:getData1() + 1 > var3_29 - var2_29 - 1 then
				table.insert(var0_29, iter1_29)
			end
		end
	end

	return var0_29
end

function var0_0.UseSkinCoupon(arg0_30)
	local var0_30 = getProxy(ActivityProxy):getActivityById(arg0_30)

	if not var0_30 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	var0_30.data2 = var0_30.data2 + 1

	getProxy(ActivityProxy):updateActivity(var0_30)
end

return var0_0
