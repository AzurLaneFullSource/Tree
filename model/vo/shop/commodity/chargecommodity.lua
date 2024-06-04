local var0 = class("ChargeCommodity", import(".BaseCommodity"))

function var0.bindConfigTable(arg0)
	return pg.pay_data_display
end

function var0.isChargeType(arg0)
	return true
end

function var0.canPurchase(arg0)
	local var0 = arg0:getLimitCount()

	return var0 <= 0 or var0 > arg0.buyCount
end

function var0.firstPayDouble(arg0)
	return arg0:getConfig("first_pay_double") ~= 0
end

function var0.hasExtraGem(arg0)
	return arg0:getConfig("extra_gem") ~= 0
end

function var0.GetGemCnt(arg0)
	return arg0:getConfig("gem") + arg0:getConfig("extra_gem")
end

function var0.isGem(arg0)
	return arg0:getConfig("extra_service") == Goods.GEM
end

function var0.isGiftBox(arg0)
	return arg0:getConfig("extra_service") == Goods.GIFT_BOX
end

function var0.isMonthCard(arg0)
	return arg0:getConfig("extra_service") == Goods.MONTH_CARD
end

function var0.isItemBox(arg0)
	return arg0:getConfig("extra_service") == Goods.ITEM_BOX
end

function var0.isPassItem(arg0)
	return arg0:getConfig("extra_service") == Goods.PASS_ITEM
end

function var0.getLimitCount(arg0)
	return arg0:getConfig("limit_arg")
end

function var0.GetName(arg0)
	return arg0:getConfig("name")
end

function var0.GetDropList(arg0)
	local var0 = arg0:getConfig("display")

	if #var0 == 0 then
		var0 = arg0:getConfig("extra_service_item")
	end

	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		table.insert(var1, Drop.Create(iter1))
	end

	return var1
end

function var0.GetExtraServiceItem(arg0)
	local var0 = {}

	if arg0:isPassItem() then
		local var1 = arg0:getConfig("sub_display")[1]
		local var2 = pg.battlepass_event_pt[var1].drop_client_pay

		var0 = PlayerConst.MergePassItemDrop(underscore.map(var2, function(arg0)
			return Drop.Create(arg0)
		end))
	else
		local var3 = arg0:getConfig("extra_service_item")

		var0 = underscore.map(var3, function(arg0)
			return Drop.Create(arg0)
		end)
	end

	local var4 = arg0:GetGemCnt()

	if not arg0:isMonthCard() and var4 > 0 then
		table.insert(var0, Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = PlayerConst.ResDiamond,
			count = var4
		}))
	end

	return var0
end

function var0.GetBonusItem(arg0)
	local var0

	if arg0:isMonthCard() then
		local var1 = arg0:GetGemCnt()

		var0 = {
			id = 4,
			type = 1,
			count = var1
		}
	end

	return var0
end

function var0.GetChargeTip(arg0)
	local var0
	local var1

	if arg0:isPassItem() then
		var0 = i18n("battlepass_pay_tip")
	elseif arg0:isMonthCard() then
		var0 = i18n("charge_title_getitem_month")
		var1 = i18n("charge_title_getitem_soon")
	else
		var0 = i18n("charge_title_getitem")
	end

	return var0, var1
end

function var0.GetExtraDrop(arg0)
	local var0

	if arg0:isPassItem() then
		local var1 = arg0:getConfig("sub_display")
		local var2 = var1[1]
		local var3 = pg.battlepass_event_pt[var2].pt

		var0 = Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = pg.battlepass_event_pt[var2].pt,
			count = var1[2]
		})
	end

	return var0
end

function var0.getConfig(arg0, arg1)
	if arg1 == "money" and PLATFORM_CODE == PLATFORM_CHT then
		local var0 = pg.SdkMgr.GetInstance():GetProduct(arg0:getConfig("id_str"))

		if var0 then
			return var0.price
		else
			return arg0:RawGetConfig(arg1)
		end
	elseif arg1 == "money" and PLATFORM_CODE == PLATFORM_US then
		local var1 = arg0:RawGetConfig(arg1)

		return math.floor(var1 / 100) .. "." .. var1 - math.floor(var1 / 100) * 100
	else
		return arg0:RawGetConfig(arg1)
	end
end

function var0.RawGetConfig(arg0, arg1)
	return var0.super.getConfig(arg0, arg1)
end

function var0.IsLocalPrice(arg0)
	return arg0:getConfig("money") ~= arg0:RawGetConfig("money")
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

function var0.isTecShipGift(arg0)
	if arg0:getConfig("limit_type") == Goods.Tec_Ship_Gift_Type then
		return true
	else
		return false
	end
end

function var0.isTecShipShowGift(arg0)
	if arg0:isTecShipGift() then
		if arg0:getConfig("limit_arg") == Goods.Tec_Ship_Gift_Arg.Show then
			return true
		else
			return false
		end
	else
		return false
	end
end

function var0.getSameGroupTecShipGift(arg0)
	local var0 = {}
	local var1 = arg0:getConfig("limit_group")
	local var2 = arg0:bindConfigTable()

	for iter0, iter1 in ipairs(var2.all) do
		local var3 = var2[iter1]

		if var3.limit_type == Goods.Tec_Ship_Gift_Type and var3.limit_group == var1 then
			local var4 = Goods.Create({
				shop_id = iter1
			}, Goods.TYPE_CHARGE)

			table.insert(var0, var4)
		end
	end

	return var0
end

function var0.CanViewSkinProbability(arg0)
	local var0 = arg0:getConfig("skin_inquire_relation")

	if not var0 or var0 <= 0 then
		return false
	end

	if pg.gameset.package_view_display.key_value == 0 then
		return false
	end

	return true
end

function var0.GetSkinProbability(arg0)
	local var0 = {}

	if arg0:CanViewSkinProbability() then
		local var1 = arg0:getConfig("skin_inquire_relation")

		var0 = Item.getConfigData(var1).combination_display
	end

	return var0
end

function var0.GetSkinProbabilityItem(arg0)
	if not arg0:CanViewSkinProbability() then
		return nil
	end

	local var0 = arg0:getConfig("skin_inquire_relation")

	return {
		count = 1,
		type = DROP_TYPE_ITEM,
		id = var0
	}
end

function var0.GetDropItem(arg0)
	local var0 = arg0:getConfig("drop_item")

	if #var0 > 0 then
		return var0
	else
		assert(false, "should exist drop item")
	end
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

return var0
