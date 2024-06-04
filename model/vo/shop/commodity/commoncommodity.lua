local var0 = class("CommonCommodity", import(".BaseCommodity"))

function var0.InCommodityDiscountTime(arg0)
	local var0 = pg.shop_template[arg0].discount_time

	if var0 == "always" then
		return true
	end

	if type(var0) == "table" then
		return table.getCount(var0) == 0 or pg.TimeMgr.GetInstance():inTime(var0)
	end

	return false
end

function var0.bindConfigTable(arg0)
	return pg.shop_template
end

function var0.canPurchase(arg0)
	if arg0.type == Goods.TYPE_MILITARY then
		return arg0.buyCount == 0
	elseif arg0.type == Goods.TYPE_GIFT_PACKAGE or arg0.type == Goods.TYPE_SKIN or arg0.type == Goods.TYPE_WORLD or arg0.type == Goods.TYPE_NEW_SERVER then
		local var0 = arg0:getLimitCount()

		return var0 <= 0 or var0 > arg0.buyCount
	else
		return var0.super.canPurchase(arg0)
	end
end

function var0.isDisCount(arg0)
	local var0 = var0.InCommodityDiscountTime(arg0.id)

	if arg0:IsItemDiscountType() then
		return true
	else
		return arg0:getConfig("discount") ~= 0 and var0
	end
end

function var0.GetDiscountEndTime(arg0)
	local var0 = arg0:getConfig("discount_time")
	local var1, var2 = unpack(var0)
	local var3 = var2[1]
	local var4, var5, var6 = unpack(var3)

	return (pg.TimeMgr.GetInstance():Table2ServerTime({
		year = var4,
		month = var5,
		day = var6,
		hour = var2[2][1],
		min = var2[2][2],
		sec = var2[2][3]
	}))
end

function var0.IsGroupSale(arg0)
	local var0 = arg0:getConfig("group") > 0
	local var1 = arg0:getConfig("limit_args2")[1]

	return arg0.type == Goods.TYPE_MILITARY and var0 and var1[1] == "purchase"
end

function var0.IsShowWhenGroupSale(arg0, arg1)
	if arg0:IsGroupSale() then
		local var0 = arg0:getConfig("limit_args2")[1]
		local var1 = var0[2]
		local var2 = var0[3]

		if arg1 == var2 and var2 == arg0:getConfig("group_limit") then
			return true
		end

		arg1 = arg1 + 1

		return var1 <= arg1 and arg1 <= var2
	end

	return true
end

function var0.GetPrice(arg0)
	local var0 = 0
	local var1 = arg0:getConfig("resource_num")
	local var2 = arg0:isDisCount()

	if var2 and arg0:IsItemDiscountType() then
		local var3 = SkinCouponActivity.StaticGetNewPrice(var1)

		var0 = (var1 - var3) / var1 * 100
		var1 = var3
	elseif var2 then
		var0 = arg0:getConfig("discount")
		var1 = (100 - var0) / 100 * var1
	end

	return var1, var0
end

function var0.GetBasePrice(arg0)
	return arg0:getConfig("resource_num")
end

function var0.GetName(arg0)
	return arg0:getDropInfo():getName()
end

function var0.GetResType(arg0)
	return arg0:getConfig("resource_type")
end

function var0.IsItemDiscountType(arg0)
	return arg0:getConfig("genre") == ShopArgs.SkinShop and SkinCouponActivity.StaticCanUsageSkinCoupon(arg0.id)
end

function var0.CanUseVoucherType(arg0)
	local var0 = getProxy(BagProxy):GetSkinShopDiscountItemList()

	return arg0:StaticCanUseVoucherType(var0)
end

function var0.StaticCanUseVoucherType(arg0, arg1)
	if #arg1 <= 0 then
		return false
	end

	for iter0, iter1 in ipairs(arg1) do
		if iter1:CanUseForShop(arg0.id) then
			return true
		end
	end

	return false
end

function var0.GetVoucherIdList(arg0)
	local var0 = {}
	local var1 = getProxy(BagProxy):GetSkinShopDiscountItemList()

	for iter0, iter1 in pairs(var1) do
		if iter1:CanUseForShop(arg0.id) then
			table.insert(var0, iter1.id)
		end
	end

	return var0
end

function var0.getLimitCount(arg0)
	local var0 = arg0:getConfig("limit_args") or {}

	for iter0, iter1 in ipairs(var0) do
		if iter1[1] == "time" then
			return iter1[2]
		end
	end

	return 0
end

function var0.GetDiscountItem(arg0)
	if arg0:IsItemDiscountType() then
		return SkinCouponActivity.StaticGetItemConfig()
	end

	return nil
end

function var0.isLevelLimit(arg0, arg1, arg2)
	local var0, var1 = arg0:getLevelLimit()

	if arg2 and var1 then
		return false
	end

	return var0 > 0 and arg1 < var0
end

function var0.getLevelLimit(arg0)
	local var0 = arg0:getConfig("limit_args")

	for iter0, iter1 in ipairs(var0) do
		if type(iter1) == "table" and iter1[1] == "level" then
			return iter1[2], iter1[3]
		end
	end

	return 0
end

function var0.isTimeLimit(arg0)
	local var0 = arg0:getLimitCount()

	return var0 <= 0 or var0 < arg0.buyCount
end

function var0.getSkinId(arg0)
	if arg0.type == Goods.TYPE_SKIN then
		return arg0:getConfig("effect_args")[1]
	end

	assert(false)
end

function var0.getDropInfo(arg0)
	local var0 = switch(arg0:getConfig("effect_args"), {
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
		if arg0:getConfig("genre") == ShopArgs.WorldCollection then
			return {
				type = DROP_TYPE_WORLD_ITEM,
				id = arg0:getConfig("effect_args")[1],
				count = arg0:getConfig("num")
			}
		else
			return {
				type = arg0:getConfig("type"),
				id = arg0:getConfig("effect_args")[1],
				count = arg0:getConfig("num")
			}
		end
	end)

	return Drop.New(var0)
end

function var0.GetDropList(arg0)
	local var0 = {}
	local var1 = Item.getConfigData(arg0:getConfig("effect_args")[1]).display_icon

	if type(var1) == "table" then
		for iter0, iter1 in ipairs(var1) do
			table.insert(var0, {
				type = iter1[1],
				id = iter1[2],
				count = iter1[3]
			})
		end
	end

	return var0
end

function var0.IsGroupLimit(arg0)
	if arg0:getConfig("group") <= 0 then
		return false
	end

	local var0 = arg0:getConfig("group_limit")

	return var0 > 0 and var0 <= (arg0.groupCount or 0)
end

function var0.GetLimitDesc(arg0)
	local var0 = arg0:getLimitCount()
	local var1 = arg0.buyCount or 0

	if var0 > 0 then
		return i18n("charge_limit_all", var0 - var1, var0)
	end

	local var2 = arg0:getConfig("group_limit")

	if var2 > 0 then
		local var3 = arg0:getConfig("group_type") or 0

		if var3 == 1 then
			return i18n("charge_limit_daily", var2 - arg0.groupCount, var2)
		elseif var3 == 2 then
			return i18n("charge_limit_weekly", var2 - arg0.groupCount, var2)
		elseif var3 == 3 then
			return i18n("charge_limit_monthly", var2 - arg0.groupCount, var2)
		end
	end

	return ""
end

function var0.GetGiftList(arg0)
	if arg0:getConfig("genre") == ShopArgs.SkinShop then
		local var0 = arg0:getSkinId()

		return ShipSkin.New({
			id = var0
		}):GetRewardList()
	else
		return var0.super.GetGiftList(arg0)
	end
end

return var0
