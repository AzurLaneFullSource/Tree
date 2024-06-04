local var0 = class("SkinCouponActivity", import("model.vo.Activity"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.dataConfig = pg.activity_event_shop_discount[arg0.configId]
end

function var0.GetDiscountPrice(arg0)
	return arg0.dataConfig.discount_price
end

function var0.GetNewPrice(arg0, arg1)
	return arg1 - arg0:GetDiscountPrice()
end

function var0.GetShopIdList(arg0)
	return arg0.dataConfig.shop_list
end

function var0.Left3Day(arg0)
	if arg0.stopTime - pg.TimeMgr.GetInstance():GetServerTime() < 259200 then
		return true
	end

	return false
end

function var0.ShouldTipUsage(arg0)
	local function var0()
		local var0 = getProxy(PlayerProxy):getRawData().id
		local var1 = PlayerPrefs.GetInt(arg0.id .. "_SkinCouponActivity_Tip" .. var0, 0)

		if var1 <= 0 then
			return true
		end

		local var2 = pg.TimeMgr.GetInstance():GetServerTime()

		return var1 < var2 and not pg.TimeMgr.GetInstance():IsSameDay(var2, var1)
	end

	return arg0:GetCanUsageCnt() > 0 and arg0:Left3Day() and var0()
end

function var0.SaveTipTime(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(arg0.id .. "_SkinCouponActivity_Tip" .. var1, var0)
	PlayerPrefs.Save()
end

function var0.IncludeShop(arg0, arg1)
	local var0 = arg0:GetShopIdList()

	return table.contains(var0, arg1)
end

function var0.GetCanUsageCnt(arg0)
	return arg0.data1 - arg0.data2
end

function var0.CanUsageSkinCoupon(arg0, arg1)
	return arg0:IncludeShop(arg1) and arg0:GetCanUsageCnt() > 0
end

function var0.GetEquivalentRes(arg0)
	if arg0.dataConfig.change_resource_type == 0 or arg0.dataConfig.change_resource_num == 0 then
		return nil
	end

	local var0 = Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = arg0.dataConfig.change_resource_type,
		count = arg0.dataConfig.change_resource_num
	})

	var0.name = var0:getName()
end

function var0.GetLimitCnt(arg0)
	if arg0.dataConfig.max_count == 0 then
		return math.huge
	else
		return arg0.dataConfig.max_count
	end
end

function var0.IsMaxCnt(arg0)
	return arg0.data1 > arg0:GetLimitCnt()
end

function var0.GetItemId(arg0)
	return arg0.dataConfig.item_id
end

function var0.GetItemConfig(arg0)
	local var0 = arg0:GetItemId()

	return Item.getConfigData(var0) or {}
end

function var0.GetItemName(arg0)
	local var0 = arg0:GetItemId()
	local var1 = Item.getConfigData(var0)

	return var1 and var1.name or ""
end

function var0.ShopId2SkinId(arg0, arg1)
	return pg.shop_template[arg1].effect_args[1]
end

function var0.OwnAllSkin(arg0)
	local var0 = arg0:GetShopIdList()
	local var1 = _.map(var0, function(arg0)
		return arg0:ShopId2SkinId(arg0)
	end)

	return _.all(var1, function(arg0)
		return getProxy(ShipSkinProxy):hasSkin(arg0)
	end)
end

function var0.GetSkinCouponAct()
	local var0 = pg.activity_template.get_id_list_by_type[ActivityConst.ACTIVITY_TYPE_SKIN_COUPON] or {}

	if #var0 <= 0 then
		return nil
	end

	for iter0 = #var0, 1, -1 do
		local var1 = var0[iter0]
		local var2 = getProxy(ActivityProxy):RawGetActivityById(var1)

		if var2 and not var2:isEnd() then
			return var2
		end
	end

	return nil
end

function var0.StaticExistActivity()
	local var0 = var0.GetSkinCouponAct()

	return var0 and not var0:isEnd()
end

function var0.StaticExistActivityAndCoupon()
	if not var0.StaticExistActivity() then
		return false
	end

	return var0.GetSkinCouponAct():GetCanUsageCnt() > 0
end

function var0.StaticOwnMaxCntSkinCoupon()
	if not var0.StaticExistActivity() then
		return false
	end

	return var0.GetSkinCouponAct():IsMaxCnt()
end

function var0.StaticOwnAllSkin()
	if not var0.StaticExistActivity() then
		return false
	end

	return var0.GetSkinCouponAct():OwnAllSkin()
end

function var0.StaticGetEquivalentRes()
	if not var0.StaticExistActivity() then
		return false
	end

	return var0.GetSkinCouponAct():GetEquivalentRes()
end

function var0.StaticCanUsageSkinCoupon(arg0)
	if not var0.StaticExistActivity() then
		return false
	end

	return var0.GetSkinCouponAct():CanUsageSkinCoupon(arg0)
end

function var0.StaticIsShop(arg0)
	if not var0.StaticExistActivity() then
		return true
	end

	return var0.GetSkinCouponAct():IncludeShop(arg0)
end

function var0.StaticGetNewPrice(arg0)
	if not var0.StaticExistActivity() then
		return arg0
	end

	return var0.GetSkinCouponAct():GetNewPrice(arg0)
end

function var0.StaticGetItemConfig()
	if not var0.StaticExistActivity() then
		return {}
	end

	return var0.GetSkinCouponAct():GetItemConfig()
end

function var0.AddSkinCoupon(arg0)
	if not var0.StaticExistActivity() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	local var0 = var0.GetSkinCouponAct()

	if var0:IsMaxCnt() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_already owned"))

		return
	end

	var0.data1 = var0.data1 + 1

	getProxy(ActivityProxy):updateActivity(var0)
end

function var0.UseSkinCoupon()
	if not var0.StaticExistActivity() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	local var0 = var0.GetSkinCouponAct()

	var0.data2 = var0.data2 + 1

	getProxy(ActivityProxy):updateActivity(var0)
end

return var0
