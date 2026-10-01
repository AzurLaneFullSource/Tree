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
		local var1_15, var2_15, var3_15 = arg0_15:GetActData()
		local var4_15

		if var3_15 == 130 then
			local var5_15 = pg.black_friday_battlepass_event_pt[var1_15].award_pay

			var0_15 = PlayerConst.MergePassItemDrop(underscore.map(var5_15, function(arg0_16)
				return Drop.Create(pg.black_friday_battlepass_event_award[arg0_16].drop_client)
			end))
		elseif var3_15 == 54 then
			local var6_15 = pg.battlepass_event_pt[var1_15].award_pay

			var0_15 = PlayerConst.MergePassItemDrop(underscore.map(var6_15, function(arg0_17)
				return Drop.Create(pg.battlepass_event_award[arg0_17].drop_client)
			end))
		end
	else
		var0_15 = underscore.map(arg0_15:getConfig("extra_service_item"), function(arg0_18)
			return Drop.Create(arg0_18)
		end)
	end

	local var7_15 = arg0_15:GetGemCnt()

	if not arg0_15:isMonthCard() and var7_15 > 0 then
		table.insert(var0_15, Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = PlayerConst.ResDiamond,
			count = var7_15
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

function var0_0.GetActData(arg0_21)
	local var0_21, var1_21 = unpack(arg0_21:getConfig("sub_display"))
	local var2_21 = getProxy(ActivityProxy):getActivityById(var0_21)
	local var3_21

	if not var2_21 or var2_21:isEnd() then
		local var4_21, var5_21 = PrevPeriodCrusingActivity.StaticExistPrevPeriodCrusingActivity()

		if var4_21 then
			local var6_21 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING):GetPreviousPeriodAct()

			var0_21 = var6_21.id

			if var6_21 and not var6_21:isEnd() then
				var3_21 = var6_21:getConfig("type")
			end
		end
	else
		var3_21 = var2_21:getConfig("type")
	end

	return var0_21, var1_21, var3_21
end

function var0_0.GetExtraDrop(arg0_22)
	local var0_22

	if arg0_22:isPassItem() then
		local var1_22, var2_22, var3_22 = arg0_22:GetActData()

		assert(var3_22, "activity type is nil")

		if var3_22 == 130 then
			local var4_22 = pg.black_friday_battlepass_event_pt[var1_22].pt

			var0_22 = Drop.New({
				type = DROP_TYPE_VITEM,
				id = pg.black_friday_battlepass_event_pt[var1_22].pt,
				count = var2_22
			})
		elseif var3_22 == 54 then
			local var5_22 = pg.battlepass_event_pt[var1_22].pt

			var0_22 = Drop.New({
				type = DROP_TYPE_VITEM,
				id = pg.battlepass_event_pt[var1_22].pt,
				count = var2_22
			})
		end
	end

	return var0_22
end

function var0_0.getConfig(arg0_23, arg1_23)
	if arg1_23 == "money" and PLATFORM_CODE == PLATFORM_CHT then
		local var0_23 = pg.SdkMgr.GetInstance():GetProduct(arg0_23:getConfig("id_str"))

		if var0_23 then
			return var0_23.price
		else
			return arg0_23:RawGetConfig(arg1_23)
		end
	elseif arg1_23 == "money" and PLATFORM_CODE == PLATFORM_US then
		local var1_23 = arg0_23:RawGetConfig(arg1_23)

		return math.floor(var1_23 / 100) .. "." .. var1_23 - math.floor(var1_23 / 100) * 100
	else
		return arg0_23:RawGetConfig(arg1_23)
	end
end

function var0_0.RawGetConfig(arg0_24, arg1_24)
	return var0_0.super.getConfig(arg0_24, arg1_24)
end

function var0_0.IsLocalPrice(arg0_25)
	return arg0_25:getConfig("money") ~= arg0_25:RawGetConfig("money")
end

function var0_0.isLevelLimit(arg0_26, arg1_26, arg2_26)
	local var0_26, var1_26 = arg0_26:getLevelLimit()

	if arg2_26 and var1_26 then
		return false
	end

	return var0_26 > 0 and arg1_26 < var0_26
end

function var0_0.getLevelLimit(arg0_27)
	local var0_27 = arg0_27:getConfig("limit_args")

	for iter0_27, iter1_27 in ipairs(var0_27) do
		if type(iter1_27) == "table" and iter1_27[1] == "level" then
			return iter1_27[2], iter1_27[3]
		end
	end

	return 0
end

function var0_0.getSameLimitGroupTecGoods(arg0_28)
	local var0_28 = {}
	local var1_28 = arg0_28:getConfig("limit_group")
	local var2_28 = arg0_28:bindConfigTable()

	for iter0_28, iter1_28 in ipairs(var2_28.all) do
		if var2_28[iter1_28].limit_group == var1_28 then
			local var3_28 = Goods.Create({
				shop_id = iter1_28
			}, Goods.TYPE_CHARGE)

			table.insert(var0_28, var3_28)
		end
	end

	return var0_28
end

function var0_0.getShowType(arg0_29)
	local var0_29 = arg0_29:getConfig("show_group")

	if var0_29 == "" then
		-- block empty
	end

	return var0_29
end

function var0_0.CanViewSkinProbability(arg0_30)
	local var0_30 = arg0_30:getConfig("skin_inquire_relation")

	if not var0_30 or var0_30 <= 0 then
		return false
	end

	if pg.gameset.package_view_display.key_value == 0 then
		return false
	end

	return true
end

function var0_0.GetSkinProbability(arg0_31)
	local var0_31 = {}

	if arg0_31:CanViewSkinProbability() then
		local var1_31 = arg0_31:getConfig("skin_inquire_relation")

		var0_31 = Item.getConfigData(var1_31).combination_display
	end

	return var0_31
end

function var0_0.GetSkinProbabilityItem(arg0_32)
	if not arg0_32:CanViewSkinProbability() then
		return nil
	end

	local var0_32 = arg0_32:getConfig("skin_inquire_relation")

	return {
		count = 1,
		type = DROP_TYPE_ITEM,
		id = var0_32
	}
end

function var0_0.GetDropItem(arg0_33)
	local var0_33 = arg0_33:getConfig("drop_item")

	if #var0_33 > 0 then
		return var0_33
	else
		assert(false, "should exist drop item")
	end
end

function var0_0.GetLimitDesc(arg0_34)
	local var0_34 = arg0_34:getLimitCount()
	local var1_34 = arg0_34.buyCount or 0

	if var0_34 > 0 then
		return i18n("charge_limit_all", var0_34 - var1_34, var0_34)
	end

	local var2_34 = arg0_34:getConfig("group_limit")

	if var2_34 > 0 then
		local var3_34 = arg0_34:getConfig("group_type") or 0

		if var3_34 == 1 then
			return i18n("charge_limit_daily", var2_34 - arg0_34.groupCount, var2_34)
		elseif var3_34 == 2 then
			return i18n("charge_limit_weekly", var2_34 - arg0_34.groupCount, var2_34)
		elseif var3_34 == 3 then
			return i18n("charge_limit_monthly", var2_34 - arg0_34.groupCount, var2_34)
		end
	end

	return ""
end

function var0_0.GetInfoTip(arg0_35)
	if not arg0_35:isItemBox() or arg0_35:getConfig("tip_open") == 0 then
		return ""
	else
		return arg0_35:getConfig("tip")
	end
end

function var0_0.GetPackageTag(arg0_36)
	if not arg0_36:isItemBox() or arg0_36:getConfig("package_tag_open") == 0 then
		return ""
	else
		return arg0_36:getConfig("package_tag")
	end
end

function var0_0.isTip(arg0_37)
	if arg0_37:isGiftPackage() or arg0_37:isActGiftPackage() then
		local var0_37 = arg0_37:getConfig("akashi_pick") > 0 and "payshop_pack_red_dot" or "gemshop_pack_red_dot"
		local var1_37, var2_37 = unpack(getGameset(var0_37))

		if PlayerPrefs.GetInt(var0_37, 0) ~= var1_37 and table.contains(var2_37[1], arg0_37.id) then
			return true
		end

		return arg0_37:isFree()
	end
end

function var0_0.isTip(arg0_38)
	local var0_38 = arg0_38:getConfig("akashi_pick") > 0 and "payshop_pack_red_dot" or "gemshop_pack_red_dot"
	local var1_38, var2_38 = unpack(getGameset(var0_38))

	if PlayerPrefs.GetInt(var0_38, 0) ~= var1_38 and table.contains(var2_38[2], arg0_38.id) then
		return true
	end

	return arg0_38:isFree()
end

return var0_0
