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

function var0_0.CanUsageSkinCoupon(arg0_11, arg1_11)
	return arg0_11:IncludeShop(arg1_11) and arg0_11:GetCanUsageCnt() > 0
end

function var0_0.GetEquivalentRes(arg0_12)
	if arg0_12.dataConfig.change_resource_type == 0 or arg0_12.dataConfig.change_resource_num == 0 then
		return nil
	end

	local var0_12 = Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = arg0_12.dataConfig.change_resource_type,
		count = arg0_12.dataConfig.change_resource_num
	})

	var0_12.name = var0_12:getName()
end

function var0_0.GetLimitCnt(arg0_13)
	if arg0_13.dataConfig.max_count == 0 then
		return math.huge
	else
		return arg0_13.dataConfig.max_count
	end
end

function var0_0.IsMaxCnt(arg0_14)
	return arg0_14.data1 > arg0_14:GetLimitCnt()
end

function var0_0.GetItemId(arg0_15)
	return arg0_15.dataConfig.item_id
end

function var0_0.GetItemConfig(arg0_16)
	local var0_16 = arg0_16:GetItemId()

	return Item.getConfigData(var0_16) or {}
end

function var0_0.GetItemName(arg0_17)
	local var0_17 = arg0_17:GetItemId()
	local var1_17 = Item.getConfigData(var0_17)

	return var1_17 and var1_17.name or ""
end

function var0_0.ShopId2SkinId(arg0_18, arg1_18)
	return pg.shop_template[arg1_18].effect_args[1]
end

function var0_0.GetOwnCount(arg0_19)
	local var0_19 = underscore.map(arg0_19:GetShopIdList(), function(arg0_20)
		return arg0_19:ShopId2SkinId(arg0_20)
	end)

	return #underscore.filter(var0_19, function(arg0_21)
		return getProxy(ShipSkinProxy):hasNonLimitSkin(arg0_21)
	end), #var0_19
end

function var0_0.OwnAllSkin(arg0_22)
	local var0_22, var1_22 = arg0_22:GetOwnCount()

	return var0_22 == var1_22
end

function var0_0.GetSkinCouponAct(arg0_23)
	for iter0_23, iter1_23 in ipairs(pg.activity_template.get_id_list_by_type[ActivityConst.ACTIVITY_TYPE_SKIN_COUPON] or {}) do
		local var0_23 = getProxy(ActivityProxy):RawGetActivityById(iter1_23)

		if var0_23 and not var0_23:isEnd() and (not arg0_23 or var0_23:IncludeShop(arg0_23)) then
			return var0_23
		end
	end

	return nil
end

function var0_0.GetSkinCouponEncoreAct(arg0_24)
	for iter0_24, iter1_24 in ipairs(pg.activity_template.get_id_list_by_type[ActivityConst.ACTIVITY_TYPE_SKIN_COUPON_COUNTING] or {}) do
		local var0_24 = getProxy(ActivityProxy):RawGetActivityById(iter1_24)

		if var0_24 and not var0_24:isEnd() and (not arg0_24 or table.contains(var0_24:getConfig("config_data")[2], arg0_24)) then
			return var0_24
		end
	end

	return nil
end

function var0_0.StaticExistActivityAndCoupon(arg0_25)
	local var0_25 = var0_0.GetSkinCouponAct(arg0_25)

	return var0_25 and var0_25:GetCanUsageCnt() > 0
end

function var0_0.StaticOwnMaxCntSkinCoupon(arg0_26)
	local var0_26 = var0_0.GetSkinCouponAct(arg0_26)

	return var0_26 and var0_26:IsMaxCnt()
end

function var0_0.StaticCanUsageSkinCoupon(arg0_27)
	local var0_27 = var0_0.GetSkinCouponAct(arg0_27)

	return var0_27 and var0_27:CanUsageSkinCoupon(arg0_27)
end

function var0_0.StaticGetItemDrop(arg0_28)
	local var0_28 = var0_0.GetSkinCouponAct(arg0_28)

	return var0_28 and Drop.New({
		type = DROP_TYPE_VITEM,
		id = var0_28:GetItemId(),
		count = var0_28:GetCanUsageCnt()
	})
end

function var0_0.StaticEncoreActTip(arg0_29)
	assert(arg0_29)

	local var0_29 = var0_0.GetSkinCouponAct(arg0_29)
	local var1_29 = var0_0.GetSkinCouponEncoreAct(arg0_29)

	if not var0_29 or not var1_29 then
		return false
	end

	return var0_29:GetCanUsageCnt() <= 0 and var1_29:getData1() > 0
end

function var0_0.UseSkinCoupon(arg0_30)
	local var0_30 = var0_0.GetSkinCouponAct(arg0_30)

	if not var0_30 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	var0_30.data2 = var0_30.data2 + 1

	getProxy(ActivityProxy):updateActivity(var0_30)
end

return var0_0
