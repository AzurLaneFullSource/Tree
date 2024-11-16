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
	elseif arg0_3.type == Goods.TYPE_CRUISE then
		return arg0_3:getLimitCount() - arg0_3:GetOwnedCnt() > 0
	else
		return var0_0.super.canPurchase(arg0_3)
	end
end

function var0_0.isDisCount(arg0_4)
	if arg0_4:IsItemDiscountType() then
		return true
	else
		return arg0_4:getConfig("discount") ~= 0 and var0_0.InCommodityDiscountTime(arg0_4.id)
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

function var0_0.GetOwnedCnt(arg0_8)
	return arg0_8:getDropInfo():getOwnedCount()
end

function var0_0.GetPrice(arg0_9)
	local var0_9 = arg0_9:getConfig("resource_num")
	local var1_9 = var0_9
	local var2_9 = 0

	if arg0_9:isDisCount() then
		if arg0_9:IsItemDiscountType() then
			var0_9 = SkinCouponActivity.StaticGetNewPrice(var1_9)
			var2_9 = (var1_9 - var0_9) / var1_9 * 100
		else
			var2_9 = arg0_9:getConfig("discount")
			var0_9 = var1_9 * (100 - var2_9) / 100
		end
	end

	return var0_9, var2_9, var1_9
end

function var0_0.GetName(arg0_10)
	return arg0_10:getDropInfo():getName()
end

function var0_0.GetResType(arg0_11)
	return arg0_11:getConfig("resource_type")
end

function var0_0.GetResIcon(arg0_12)
	local var0_12 = arg0_12:GetResType()

	if var0_12 == 4 or var0_12 == 14 then
		return "diamond"
	elseif var0_12 == 1 then
		return "gold"
	end
end

function var0_0.IsItemDiscountType(arg0_13)
	return arg0_13:getConfig("genre") == ShopArgs.SkinShop and SkinCouponActivity.StaticCanUsageSkinCoupon(arg0_13.id)
end

function var0_0.CanUseVoucherType(arg0_14)
	local var0_14 = getProxy(BagProxy):GetSkinShopDiscountItemList()

	return arg0_14:StaticCanUseVoucherType(var0_14)
end

function var0_0.StaticCanUseVoucherType(arg0_15, arg1_15)
	if #arg1_15 <= 0 then
		return false
	end

	for iter0_15, iter1_15 in ipairs(arg1_15) do
		if iter1_15:CanUseForShop(arg0_15.id) then
			return true
		end
	end

	return false
end

function var0_0.GetVoucherIdList(arg0_16)
	local var0_16 = {}
	local var1_16 = getProxy(BagProxy):GetSkinShopDiscountItemList()

	for iter0_16, iter1_16 in pairs(var1_16) do
		if iter1_16:CanUseForShop(arg0_16.id) then
			table.insert(var0_16, iter1_16.id)
		end
	end

	return var0_16
end

function var0_0.getLimitCount(arg0_17)
	local var0_17 = arg0_17:getConfig("limit_args") or {}

	for iter0_17, iter1_17 in ipairs(var0_17) do
		if iter1_17[1] == "time" then
			return iter1_17[2]
		end
	end

	return 0
end

function var0_0.GetDiscountItem(arg0_18)
	if arg0_18:IsItemDiscountType() then
		return SkinCouponActivity.StaticGetItemConfig()
	end

	return nil
end

function var0_0.isLevelLimit(arg0_19, arg1_19, arg2_19)
	local var0_19, var1_19 = arg0_19:getLevelLimit()

	if arg2_19 and var1_19 then
		return false
	end

	return var0_19 > 0 and arg1_19 < var0_19
end

function var0_0.getLevelLimit(arg0_20)
	local var0_20 = arg0_20:getConfig("limit_args")

	for iter0_20, iter1_20 in ipairs(var0_20) do
		if type(iter1_20) == "table" and iter1_20[1] == "level" then
			return iter1_20[2], iter1_20[3]
		end
	end

	return 0
end

function var0_0.isTimeLimit(arg0_21)
	local var0_21 = arg0_21:getLimitCount()

	return var0_21 <= 0 or var0_21 < arg0_21.buyCount
end

function var0_0.getSkinId(arg0_22)
	if arg0_22.type == Goods.TYPE_SKIN then
		return arg0_22:getConfig("effect_args")[1]
	end

	assert(false)
end

function var0_0.getDropInfo(arg0_23)
	local var0_23 = switch(arg0_23:getConfig("effect_args"), {
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
		if arg0_23:getConfig("genre") == ShopArgs.WorldCollection then
			return {
				type = DROP_TYPE_WORLD_ITEM,
				id = arg0_23:getConfig("effect_args")[1],
				count = arg0_23:getConfig("num")
			}
		elseif arg0_23:getConfig("genre") == ShopArgs.CruiseSkin then
			return {
				type = DROP_TYPE_SKIN,
				id = arg0_23:getConfig("effect_args")[1],
				count = arg0_23:getConfig("num")
			}
		elseif arg0_23:getConfig("genre") == ShopArgs.CruiseGearSkin then
			return {
				type = DROP_TYPE_EQUIPMENT_SKIN,
				id = arg0_23:getConfig("effect_args")[1],
				count = arg0_23:getConfig("num")
			}
		else
			return {
				type = arg0_23:getConfig("type"),
				id = arg0_23:getConfig("effect_args")[1],
				count = arg0_23:getConfig("num")
			}
		end
	end)

	return Drop.New(var0_23)
end

function var0_0.GetDropList(arg0_31)
	local var0_31 = {}
	local var1_31 = Item.getConfigData(arg0_31:getConfig("effect_args")[1]).display_icon

	if type(var1_31) == "table" then
		for iter0_31, iter1_31 in ipairs(var1_31) do
			table.insert(var0_31, {
				type = iter1_31[1],
				id = iter1_31[2],
				count = iter1_31[3]
			})
		end
	end

	return var0_31
end

function var0_0.IsGroupLimit(arg0_32)
	if arg0_32:getConfig("group") <= 0 then
		return false
	end

	local var0_32 = arg0_32:getConfig("group_limit")

	return var0_32 > 0 and var0_32 <= (arg0_32.groupCount or 0)
end

function var0_0.GetLimitDesc(arg0_33)
	local var0_33 = arg0_33:getLimitCount()
	local var1_33 = arg0_33.buyCount or 0

	if var0_33 > 0 then
		return i18n("charge_limit_all", var0_33 - var1_33, var0_33)
	end

	local var2_33 = arg0_33:getConfig("group_limit")

	if var2_33 > 0 then
		local var3_33 = arg0_33:getConfig("group_type") or 0

		if var3_33 == 1 then
			return i18n("charge_limit_daily", var2_33 - arg0_33.groupCount, var2_33)
		elseif var3_33 == 2 then
			return i18n("charge_limit_weekly", var2_33 - arg0_33.groupCount, var2_33)
		elseif var3_33 == 3 then
			return i18n("charge_limit_monthly", var2_33 - arg0_33.groupCount, var2_33)
		end
	end

	return ""
end

function var0_0.GetGiftList(arg0_34)
	if arg0_34:getConfig("genre") == ShopArgs.SkinShop then
		local var0_34 = arg0_34:getSkinId()

		return ShipSkin.New({
			id = var0_34
		}):GetRewardList()
	else
		return var0_0.super.GetGiftList(arg0_34)
	end
end

return var0_0
