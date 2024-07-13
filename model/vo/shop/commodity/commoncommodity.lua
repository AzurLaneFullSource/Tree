local var0_0 = class("CommonCommodity", import(".BaseCommodity"))

function var0_0.InCommodityDiscountTime(arg0_1)
	local var0_1 = pg.shop_template[arg0_1].discount_time

	if var0_1 == "always" then
		return true
	end

	if type(var0_1) == "table" then
		return table.getCount(var0_1) == 0 or pg.TimeMgr.GetInstance():inTime(var0_1)
	end

	return false
end

function var0_0.bindConfigTable(arg0_2)
	return pg.shop_template
end

function var0_0.canPurchase(arg0_3)
	if arg0_3.type == Goods.TYPE_MILITARY then
		return arg0_3.buyCount == 0
	elseif arg0_3.type == Goods.TYPE_GIFT_PACKAGE or arg0_3.type == Goods.TYPE_SKIN or arg0_3.type == Goods.TYPE_WORLD or arg0_3.type == Goods.TYPE_NEW_SERVER then
		local var0_3 = arg0_3:getLimitCount()

		return var0_3 <= 0 or var0_3 > arg0_3.buyCount
	else
		return var0_0.super.canPurchase(arg0_3)
	end
end

function var0_0.isDisCount(arg0_4)
	local var0_4 = var0_0.InCommodityDiscountTime(arg0_4.id)

	if arg0_4:IsItemDiscountType() then
		return true
	else
		return arg0_4:getConfig("discount") ~= 0 and var0_4
	end
end

function var0_0.GetDiscountEndTime(arg0_5)
	local var0_5 = arg0_5:getConfig("discount_time")
	local var1_5, var2_5 = unpack(var0_5)
	local var3_5 = var2_5[1]
	local var4_5, var5_5, var6_5 = unpack(var3_5)

	return (pg.TimeMgr.GetInstance():Table2ServerTime({
		year = var4_5,
		month = var5_5,
		day = var6_5,
		hour = var2_5[2][1],
		min = var2_5[2][2],
		sec = var2_5[2][3]
	}))
end

function var0_0.IsGroupSale(arg0_6)
	local var0_6 = arg0_6:getConfig("group") > 0
	local var1_6 = arg0_6:getConfig("limit_args2")[1]

	return arg0_6.type == Goods.TYPE_MILITARY and var0_6 and var1_6[1] == "purchase"
end

function var0_0.IsShowWhenGroupSale(arg0_7, arg1_7)
	if arg0_7:IsGroupSale() then
		local var0_7 = arg0_7:getConfig("limit_args2")[1]
		local var1_7 = var0_7[2]
		local var2_7 = var0_7[3]

		if arg1_7 == var2_7 and var2_7 == arg0_7:getConfig("group_limit") then
			return true
		end

		arg1_7 = arg1_7 + 1

		return var1_7 <= arg1_7 and arg1_7 <= var2_7
	end

	return true
end

function var0_0.GetPrice(arg0_8)
	local var0_8 = 0
	local var1_8 = arg0_8:getConfig("resource_num")
	local var2_8 = arg0_8:isDisCount()

	if var2_8 and arg0_8:IsItemDiscountType() then
		local var3_8 = SkinCouponActivity.StaticGetNewPrice(var1_8)

		var0_8 = (var1_8 - var3_8) / var1_8 * 100
		var1_8 = var3_8
	elseif var2_8 then
		var0_8 = arg0_8:getConfig("discount")
		var1_8 = (100 - var0_8) / 100 * var1_8
	end

	return var1_8, var0_8
end

function var0_0.GetBasePrice(arg0_9)
	return arg0_9:getConfig("resource_num")
end

function var0_0.GetName(arg0_10)
	return arg0_10:getDropInfo():getName()
end

function var0_0.GetResType(arg0_11)
	return arg0_11:getConfig("resource_type")
end

function var0_0.IsItemDiscountType(arg0_12)
	return arg0_12:getConfig("genre") == ShopArgs.SkinShop and SkinCouponActivity.StaticCanUsageSkinCoupon(arg0_12.id)
end

function var0_0.CanUseVoucherType(arg0_13)
	local var0_13 = getProxy(BagProxy):GetSkinShopDiscountItemList()

	return arg0_13:StaticCanUseVoucherType(var0_13)
end

function var0_0.StaticCanUseVoucherType(arg0_14, arg1_14)
	if #arg1_14 <= 0 then
		return false
	end

	for iter0_14, iter1_14 in ipairs(arg1_14) do
		if iter1_14:CanUseForShop(arg0_14.id) then
			return true
		end
	end

	return false
end

function var0_0.GetVoucherIdList(arg0_15)
	local var0_15 = {}
	local var1_15 = getProxy(BagProxy):GetSkinShopDiscountItemList()

	for iter0_15, iter1_15 in pairs(var1_15) do
		if iter1_15:CanUseForShop(arg0_15.id) then
			table.insert(var0_15, iter1_15.id)
		end
	end

	return var0_15
end

function var0_0.getLimitCount(arg0_16)
	local var0_16 = arg0_16:getConfig("limit_args") or {}

	for iter0_16, iter1_16 in ipairs(var0_16) do
		if iter1_16[1] == "time" then
			return iter1_16[2]
		end
	end

	return 0
end

function var0_0.GetDiscountItem(arg0_17)
	if arg0_17:IsItemDiscountType() then
		return SkinCouponActivity.StaticGetItemConfig()
	end

	return nil
end

function var0_0.isLevelLimit(arg0_18, arg1_18, arg2_18)
	local var0_18, var1_18 = arg0_18:getLevelLimit()

	if arg2_18 and var1_18 then
		return false
	end

	return var0_18 > 0 and arg1_18 < var0_18
end

function var0_0.getLevelLimit(arg0_19)
	local var0_19 = arg0_19:getConfig("limit_args")

	for iter0_19, iter1_19 in ipairs(var0_19) do
		if type(iter1_19) == "table" and iter1_19[1] == "level" then
			return iter1_19[2], iter1_19[3]
		end
	end

	return 0
end

function var0_0.isTimeLimit(arg0_20)
	local var0_20 = arg0_20:getLimitCount()

	return var0_20 <= 0 or var0_20 < arg0_20.buyCount
end

function var0_0.getSkinId(arg0_21)
	if arg0_21.type == Goods.TYPE_SKIN then
		return arg0_21:getConfig("effect_args")[1]
	end

	assert(false)
end

function var0_0.getDropInfo(arg0_22)
	local var0_22 = switch(arg0_22:getConfig("effect_args"), {
		ship_bag_size = function()
			return {
				count = 1,
				type = DROP_TYPE_ITEM,
				id = Goods.SHIP_BAG_SIZE_ITEM
			}
		end,
		equip_bag_size = function()
			return {
				count = 1,
				type = DROP_TYPE_ITEM,
				id = Goods.EQUIP_BAG_SIZE_ITEM
			}
		end,
		commander_bag_size = function()
			return {
				count = 1,
				type = DROP_TYPE_ITEM,
				id = Goods.COMMANDER_BAG_SIZE_ITEM
			}
		end,
		spweapon_bag_size = function()
			return {
				count = 1,
				type = DROP_TYPE_ITEM,
				id = Goods.SPWEAPON_BAG_SIZE_ITEM
			}
		end,
		ship_bag_size = function()
			return {
				count = 1,
				type = DROP_TYPE_ITEM,
				id = Goods.SHIP_BAG_SIZE_ITEM
			}
		end,
		ship_bag_size = function()
			return {
				count = 1,
				type = DROP_TYPE_ITEM,
				id = Goods.SHIP_BAG_SIZE_ITEM
			}
		end
	}, function()
		if arg0_22:getConfig("genre") == ShopArgs.WorldCollection then
			return {
				type = DROP_TYPE_WORLD_ITEM,
				id = arg0_22:getConfig("effect_args")[1],
				count = arg0_22:getConfig("num")
			}
		else
			return {
				type = arg0_22:getConfig("type"),
				id = arg0_22:getConfig("effect_args")[1],
				count = arg0_22:getConfig("num")
			}
		end
	end)

	return Drop.New(var0_22)
end

function var0_0.GetDropList(arg0_30)
	local var0_30 = {}
	local var1_30 = Item.getConfigData(arg0_30:getConfig("effect_args")[1]).display_icon

	if type(var1_30) == "table" then
		for iter0_30, iter1_30 in ipairs(var1_30) do
			table.insert(var0_30, {
				type = iter1_30[1],
				id = iter1_30[2],
				count = iter1_30[3]
			})
		end
	end

	return var0_30
end

function var0_0.IsGroupLimit(arg0_31)
	if arg0_31:getConfig("group") <= 0 then
		return false
	end

	local var0_31 = arg0_31:getConfig("group_limit")

	return var0_31 > 0 and var0_31 <= (arg0_31.groupCount or 0)
end

function var0_0.GetLimitDesc(arg0_32)
	local var0_32 = arg0_32:getLimitCount()
	local var1_32 = arg0_32.buyCount or 0

	if var0_32 > 0 then
		return i18n("charge_limit_all", var0_32 - var1_32, var0_32)
	end

	local var2_32 = arg0_32:getConfig("group_limit")

	if var2_32 > 0 then
		local var3_32 = arg0_32:getConfig("group_type") or 0

		if var3_32 == 1 then
			return i18n("charge_limit_daily", var2_32 - arg0_32.groupCount, var2_32)
		elseif var3_32 == 2 then
			return i18n("charge_limit_weekly", var2_32 - arg0_32.groupCount, var2_32)
		elseif var3_32 == 3 then
			return i18n("charge_limit_monthly", var2_32 - arg0_32.groupCount, var2_32)
		end
	end

	return ""
end

function var0_0.GetGiftList(arg0_33)
	if arg0_33:getConfig("genre") == ShopArgs.SkinShop then
		local var0_33 = arg0_33:getSkinId()

		return ShipSkin.New({
			id = var0_33
		}):GetRewardList()
	else
		return var0_0.super.GetGiftList(arg0_33)
	end
end

return var0_0
