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
		local var2_15 = getProxy(ActivityProxy):getActivityById(var1_15):getConfig("type")
		local var3_15

		if var2_15 == 130 then
			local var4_15 = pg.black_friday_battlepass_event_pt[var1_15].award_pay

			var0_15 = PlayerConst.MergePassItemDrop(underscore.map(var4_15, function(arg0_16)
				return Drop.Create(pg.black_friday_battlepass_event_award[arg0_16].drop_client)
			end))
		elseif var2_15 == 54 then
			local var5_15 = pg.battlepass_event_pt[var1_15].award_pay

			var0_15 = PlayerConst.MergePassItemDrop(underscore.map(var5_15, function(arg0_17)
				return Drop.Create(pg.battlepass_event_award[arg0_17].drop_client)
			end))
		end
	else
		var0_15 = underscore.map(arg0_15:getConfig("extra_service_item"), function(arg0_18)
			return Drop.Create(arg0_18)
		end)
	end

	local var6_15 = arg0_15:GetGemCnt()

	if not arg0_15:isMonthCard() and var6_15 > 0 then
		table.insert(var0_15, Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = PlayerConst.ResDiamond,
			count = var6_15
		}))
	end

	return var0_15
end

function var0_0.GetBonusItem(arg0_19)
	if arg0_19:isMonthCard() then
		return Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = PlayerConst.ResDiamond,
			count = arg0_19:GetGemCnt()
		})
	end

	return nil
end

function var0_0.GetChargeTip(arg0_20)
	local var0_20
	local var1_20

	if arg0_20:isPassItem() then
		var0_20 = i18n("battlepass_pay_tip")
	elseif arg0_20:isMonthCard() then
		var0_20 = i18n("charge_title_getitem_month")
		var1_20 = i18n("charge_title_getitem_soon")
	else
		var0_20 = i18n("charge_title_getitem")
	end

	return var0_20, var1_20
end

function var0_0.GetExtraDrop(arg0_21)
	local var0_21

	if arg0_21:isPassItem() then
		local var1_21, var2_21 = unpack(arg0_21:getConfig("sub_display"))
		local var3_21 = getProxy(ActivityProxy):getActivityById(var1_21):getConfig("type")

		if var3_21 == 130 then
			local var4_21 = pg.black_friday_battlepass_event_pt[var1_21].pt

			var0_21 = Drop.New({
				type = DROP_TYPE_VITEM,
				id = pg.black_friday_battlepass_event_pt[var1_21].pt,
				count = var2_21
			})
		elseif var3_21 == 54 then
			local var5_21 = pg.battlepass_event_pt[var1_21].pt

			var0_21 = Drop.New({
				type = DROP_TYPE_VITEM,
				id = pg.battlepass_event_pt[var1_21].pt,
				count = var2_21
			})
		end
	end

	return var0_21
end

function var0_0.getConfig(arg0_22, arg1_22)
	if arg1_22 == "money" and PLATFORM_CODE == PLATFORM_CHT then
		local var0_22 = pg.SdkMgr.GetInstance():GetProduct(arg0_22:getConfig("id_str"))

		if var0_22 then
			return var0_22.price
		else
			return arg0_22:RawGetConfig(arg1_22)
		end
	elseif arg1_22 == "money" and PLATFORM_CODE == PLATFORM_US then
		local var1_22 = arg0_22:RawGetConfig(arg1_22)

		return math.floor(var1_22 / 100) .. "." .. var1_22 - math.floor(var1_22 / 100) * 100
	else
		return arg0_22:RawGetConfig(arg1_22)
	end
end

function var0_0.RawGetConfig(arg0_23, arg1_23)
	return var0_0.super.getConfig(arg0_23, arg1_23)
end

function var0_0.IsLocalPrice(arg0_24)
	return arg0_24:getConfig("money") ~= arg0_24:RawGetConfig("money")
end

function var0_0.isLevelLimit(arg0_25, arg1_25, arg2_25)
	local var0_25, var1_25 = arg0_25:getLevelLimit()

	if arg2_25 and var1_25 then
		return false
	end

	return var0_25 > 0 and arg1_25 < var0_25
end

function var0_0.getLevelLimit(arg0_26)
	local var0_26 = arg0_26:getConfig("limit_args")

	for iter0_26, iter1_26 in ipairs(var0_26) do
		if type(iter1_26) == "table" and iter1_26[1] == "level" then
			return iter1_26[2], iter1_26[3]
		end
	end

	return 0
end

function var0_0.getSameLimitGroupTecGoods(arg0_27)
	local var0_27 = {}
	local var1_27 = arg0_27:getConfig("limit_group")
	local var2_27 = arg0_27:bindConfigTable()

	for iter0_27, iter1_27 in ipairs(var2_27.all) do
		if var2_27[iter1_27].limit_group == var1_27 then
			local var3_27 = Goods.Create({
				shop_id = iter1_27
			}, Goods.TYPE_CHARGE)

			table.insert(var0_27, var3_27)
		end
	end

	return var0_27
end

function var0_0.getShowType(arg0_28)
	local var0_28 = arg0_28:getConfig("show_group")

	if var0_28 == "" then
		-- block empty
	end

	return var0_28
end

function var0_0.CanViewSkinProbability(arg0_29)
	local var0_29 = arg0_29:getConfig("skin_inquire_relation")

	if not var0_29 or var0_29 <= 0 then
		return false
	end

	if pg.gameset.package_view_display.key_value == 0 then
		return false
	end

	return true
end

function var0_0.GetSkinProbability(arg0_30)
	local var0_30 = {}

	if arg0_30:CanViewSkinProbability() then
		local var1_30 = arg0_30:getConfig("skin_inquire_relation")

		var0_30 = Item.getConfigData(var1_30).combination_display
	end

	return var0_30
end

function var0_0.GetSkinProbabilityItem(arg0_31)
	if not arg0_31:CanViewSkinProbability() then
		return nil
	end

	local var0_31 = arg0_31:getConfig("skin_inquire_relation")

	return {
		count = 1,
		type = DROP_TYPE_ITEM,
		id = var0_31
	}
end

function var0_0.GetDropItem(arg0_32)
	local var0_32 = arg0_32:getConfig("drop_item")

	if #var0_32 > 0 then
		return var0_32
	else
		assert(false, "should exist drop item")
	end
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

function var0_0.GetInfoTip(arg0_34)
	if not arg0_34:isItemBox() or arg0_34:getConfig("tip_open") == 0 then
		return ""
	else
		return arg0_34:getConfig("tip")
	end
end

function var0_0.GetPackageTag(arg0_35)
	if not arg0_35:isItemBox() or arg0_35:getConfig("package_tag_open") == 0 then
		return ""
	else
		return arg0_35:getConfig("package_tag")
	end
end

function var0_0.isTip(arg0_36)
	if arg0_36:isGiftPackage() or arg0_36:isActGiftPackage() then
		local var0_36 = arg0_36:getConfig("akashi_pick") > 0 and "payshop_pack_red_dot" or "gemshop_pack_red_dot"
		local var1_36, var2_36 = unpack(getGameset(var0_36))

		if PlayerPrefs.GetInt(var0_36, 0) ~= var1_36 and table.contains(var2_36[1], arg0_36.id) then
			return true
		end

		return arg0_36:isFree()
	end
end

function var0_0.isTip(arg0_37)
	local var0_37 = arg0_37:getConfig("akashi_pick") > 0 and "payshop_pack_red_dot" or "gemshop_pack_red_dot"
	local var1_37, var2_37 = unpack(getGameset(var0_37))

	if PlayerPrefs.GetInt(var0_37, 0) ~= var1_37 and table.contains(var2_37[2], arg0_37.id) then
		return true
	end

	return arg0_37:isFree()
end

return var0_0
