local var0_0 = class("ChargeCommodity", import(".BaseCommodity"))

function var0_0.bindConfigTable(arg0_1)
	return pg.pay_data_display
end

function var0_0.isChargeType(arg0_2)
	return true
end

function var0_0.canPurchase(arg0_3)
	local var0_3 = arg0_3:getLimitCount()

	return var0_3 <= 0 or var0_3 > arg0_3.buyCount
end

function var0_0.firstPayDouble(arg0_4)
	return arg0_4:getConfig("first_pay_double") ~= 0
end

function var0_0.hasExtraGem(arg0_5)
	return arg0_5:getConfig("extra_gem") ~= 0
end

function var0_0.GetGemCnt(arg0_6)
	return arg0_6:getConfig("gem") + arg0_6:getConfig("extra_gem")
end

function var0_0.isGem(arg0_7)
	return arg0_7:getConfig("extra_service") == Goods.GEM
end

function var0_0.isGiftBox(arg0_8)
	return arg0_8:getConfig("extra_service") == Goods.GIFT_BOX
end

function var0_0.isMonthCard(arg0_9)
	return arg0_9:getConfig("extra_service") == Goods.MONTH_CARD
end

function var0_0.isItemBox(arg0_10)
	return arg0_10:getConfig("extra_service") == Goods.ITEM_BOX
end

function var0_0.isPassItem(arg0_11)
	return arg0_11:getConfig("extra_service") == Goods.PASS_ITEM
end

function var0_0.getLimitCount(arg0_12)
	return arg0_12:getConfig("limit_arg")
end

function var0_0.GetName(arg0_13)
	return arg0_13:getConfig("name")
end

function var0_0.GetDropList(arg0_14)
	local var0_14 = arg0_14:getConfig("display")

	if #var0_14 == 0 then
		var0_14 = arg0_14:getConfig("extra_service_item")
	end

	local var1_14 = {}

	for iter0_14, iter1_14 in ipairs(var0_14) do
		table.insert(var1_14, Drop.Create(iter1_14))
	end

	return var1_14
end

function var0_0.GetExtraServiceItem(arg0_15)
	local var0_15

	if arg0_15:isPassItem() then
		local var1_15 = arg0_15:getConfig("sub_display")[1]
		local var2_15 = pg.battlepass_event_pt[var1_15].award_pay

		var0_15 = PlayerConst.MergePassItemDrop(underscore.map(var2_15, function(arg0_16)
			return Drop.Create(pg.battlepass_event_award[arg0_16].drop_client)
		end))
	else
		var0_15 = underscore.map(arg0_15:getConfig("extra_service_item"), function(arg0_17)
			return Drop.Create(arg0_17)
		end)
	end

	local var3_15 = arg0_15:GetGemCnt()

	if not arg0_15:isMonthCard() and var3_15 > 0 then
		table.insert(var0_15, Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = PlayerConst.ResDiamond,
			count = var3_15
		}))
	end

	return var0_15
end

function var0_0.GetBonusItem(arg0_18)
	if arg0_18:isMonthCard() then
		return Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = PlayerConst.ResDiamond,
			count = arg0_18:GetGemCnt()
		})
	end

	return nil
end

function var0_0.GetChargeTip(arg0_19)
	local var0_19
	local var1_19

	if arg0_19:isPassItem() then
		var0_19 = i18n("battlepass_pay_tip")
	elseif arg0_19:isMonthCard() then
		var0_19 = i18n("charge_title_getitem_month")
		var1_19 = i18n("charge_title_getitem_soon")
	else
		var0_19 = i18n("charge_title_getitem")
	end

	return var0_19, var1_19
end

function var0_0.GetExtraDrop(arg0_20)
	local var0_20

	if arg0_20:isPassItem() then
		local var1_20, var2_20 = unpack(arg0_20:getConfig("sub_display"))
		local var3_20 = pg.battlepass_event_pt[var1_20].pt

		var0_20 = Drop.New({
			type = DROP_TYPE_VITEM,
			id = pg.battlepass_event_pt[var1_20].pt,
			count = var2_20
		})
	end

	return var0_20
end

function var0_0.getConfig(arg0_21, arg1_21)
	if arg1_21 == "money" and PLATFORM_CODE == PLATFORM_CHT then
		local var0_21 = pg.SdkMgr.GetInstance():GetProduct(arg0_21:getConfig("id_str"))

		if var0_21 then
			return var0_21.price
		else
			return arg0_21:RawGetConfig(arg1_21)
		end
	elseif arg1_21 == "money" and PLATFORM_CODE == PLATFORM_US then
		local var1_21 = arg0_21:RawGetConfig(arg1_21)

		return math.floor(var1_21 / 100) .. "." .. var1_21 - math.floor(var1_21 / 100) * 100
	else
		return arg0_21:RawGetConfig(arg1_21)
	end
end

function var0_0.RawGetConfig(arg0_22, arg1_22)
	return var0_0.super.getConfig(arg0_22, arg1_22)
end

function var0_0.IsLocalPrice(arg0_23)
	return arg0_23:getConfig("money") ~= arg0_23:RawGetConfig("money")
end

function var0_0.isLevelLimit(arg0_24, arg1_24, arg2_24)
	local var0_24, var1_24 = arg0_24:getLevelLimit()

	if arg2_24 and var1_24 then
		return false
	end

	return var0_24 > 0 and arg1_24 < var0_24
end

function var0_0.getLevelLimit(arg0_25)
	local var0_25 = arg0_25:getConfig("limit_args")

	for iter0_25, iter1_25 in ipairs(var0_25) do
		if type(iter1_25) == "table" and iter1_25[1] == "level" then
			return iter1_25[2], iter1_25[3]
		end
	end

	return 0
end

function var0_0.getSameLimitGroupTecGoods(arg0_26)
	local var0_26 = {}
	local var1_26 = arg0_26:getConfig("limit_group")
	local var2_26 = arg0_26:bindConfigTable()

	for iter0_26, iter1_26 in ipairs(var2_26.all) do
		if var2_26[iter1_26].limit_group == var1_26 then
			local var3_26 = Goods.Create({
				shop_id = iter1_26
			}, Goods.TYPE_CHARGE)

			table.insert(var0_26, var3_26)
		end
	end

	return var0_26
end

function var0_0.getShowType(arg0_27)
	local var0_27 = arg0_27:getConfig("show_group")

	if var0_27 == "" then
		-- block empty
	end

	return var0_27
end

function var0_0.CanViewSkinProbability(arg0_28)
	local var0_28 = arg0_28:getConfig("skin_inquire_relation")

	if not var0_28 or var0_28 <= 0 then
		return false
	end

	if pg.gameset.package_view_display.key_value == 0 then
		return false
	end

	return true
end

function var0_0.GetSkinProbability(arg0_29)
	local var0_29 = {}

	if arg0_29:CanViewSkinProbability() then
		local var1_29 = arg0_29:getConfig("skin_inquire_relation")

		var0_29 = Item.getConfigData(var1_29).combination_display
	end

	return var0_29
end

function var0_0.GetSkinProbabilityItem(arg0_30)
	if not arg0_30:CanViewSkinProbability() then
		return nil
	end

	local var0_30 = arg0_30:getConfig("skin_inquire_relation")

	return {
		count = 1,
		type = DROP_TYPE_ITEM,
		id = var0_30
	}
end

function var0_0.GetDropItem(arg0_31)
	local var0_31 = arg0_31:getConfig("drop_item")

	if #var0_31 > 0 then
		return var0_31
	else
		assert(false, "should exist drop item")
	end
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

return var0_0
