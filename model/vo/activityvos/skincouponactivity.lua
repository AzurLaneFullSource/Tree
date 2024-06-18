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

function var0_0.OwnAllSkin(arg0_19)
	local var0_19 = arg0_19:GetShopIdList()
	local var1_19 = _.map(var0_19, function(arg0_20)
		return arg0_19:ShopId2SkinId(arg0_20)
	end)

	return _.all(var1_19, function(arg0_21)
		return getProxy(ShipSkinProxy):hasSkin(arg0_21)
	end)
end

function var0_0.GetSkinCouponAct()
	local var0_22 = pg.activity_template.get_id_list_by_type[ActivityConst.ACTIVITY_TYPE_SKIN_COUPON] or {}

	if #var0_22 <= 0 then
		return nil
	end

	for iter0_22 = #var0_22, 1, -1 do
		local var1_22 = var0_22[iter0_22]
		local var2_22 = getProxy(ActivityProxy):RawGetActivityById(var1_22)

		if var2_22 and not var2_22:isEnd() then
			return var2_22
		end
	end

	return nil
end

function var0_0.StaticExistActivity()
	local var0_23 = var0_0.GetSkinCouponAct()

	return var0_23 and not var0_23:isEnd()
end

function var0_0.StaticExistActivityAndCoupon()
	if not var0_0.StaticExistActivity() then
		return false
	end

	return var0_0.GetSkinCouponAct():GetCanUsageCnt() > 0
end

function var0_0.StaticOwnMaxCntSkinCoupon()
	if not var0_0.StaticExistActivity() then
		return false
	end

	return var0_0.GetSkinCouponAct():IsMaxCnt()
end

function var0_0.StaticOwnAllSkin()
	if not var0_0.StaticExistActivity() then
		return false
	end

	return var0_0.GetSkinCouponAct():OwnAllSkin()
end

function var0_0.StaticGetEquivalentRes()
	if not var0_0.StaticExistActivity() then
		return false
	end

	return var0_0.GetSkinCouponAct():GetEquivalentRes()
end

function var0_0.StaticCanUsageSkinCoupon(arg0_28)
	if not var0_0.StaticExistActivity() then
		return false
	end

	return var0_0.GetSkinCouponAct():CanUsageSkinCoupon(arg0_28)
end

function var0_0.StaticIsShop(arg0_29)
	if not var0_0.StaticExistActivity() then
		return true
	end

	return var0_0.GetSkinCouponAct():IncludeShop(arg0_29)
end

function var0_0.StaticGetNewPrice(arg0_30)
	if not var0_0.StaticExistActivity() then
		return arg0_30
	end

	return var0_0.GetSkinCouponAct():GetNewPrice(arg0_30)
end

function var0_0.StaticGetItemConfig()
	if not var0_0.StaticExistActivity() then
		return {}
	end

	return var0_0.GetSkinCouponAct():GetItemConfig()
end

function var0_0.AddSkinCoupon(arg0_32)
	if not var0_0.StaticExistActivity() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	local var0_32 = var0_0.GetSkinCouponAct()

	if var0_32:IsMaxCnt() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_already owned"))

		return
	end

	var0_32.data1 = var0_32.data1 + 1

	getProxy(ActivityProxy):updateActivity(var0_32)
end

function var0_0.UseSkinCoupon()
	if not var0_0.StaticExistActivity() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	local var0_33 = var0_0.GetSkinCouponAct()

	var0_33.data2 = var0_33.data2 + 1

	getProxy(ActivityProxy):updateActivity(var0_33)
end

return var0_0
