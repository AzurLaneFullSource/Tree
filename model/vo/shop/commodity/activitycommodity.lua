local var0_0 = class("ActivityCommodity", import(".BaseCommodity"))

function var0_0.bindConfigTable(arg0_1)
	return pg.activity_shop_template
end

function var0_0.CheckCntLimit(arg0_2)
	if arg0_2:getConfig("num_limit") == 0 then
		return true
	end

	return arg0_2:GetPurchasableCnt() > 0
end

function var0_0.CheckArgLimit(arg0_3)
	local var0_3 = arg0_3:getConfig("limit_args")

	if not var0_3 or var0_3 == "" or #var0_3 == 0 then
		return true
	end

	local var1_3 = false

	for iter0_3, iter1_3 in ipairs(var0_3) do
		local var2_3 = iter1_3[1]
		local var3_3 = iter1_3[2]
		local var4_3 = iter1_3[3]

		if (var2_3 == ShopArgs.LIMIT_ARGS_META_SHIP_EXISTENCE or var2_3 == ShopArgs.LIMIT_ARGS_TRAN_ITEM_WHEN_FULL) and (var4_3 or 1) == 1 then
			var1_3 = getProxy(BayProxy):getMetaShipByGroupId(var3_3) ~= nil

			if not var1_3 then
				return var1_3, var2_3, i18n("meta_shop_exchange_limit"), var3_3
			end
		elseif var2_3 == ShopArgs.LIMIT_ARGS_SALE_START_TIME then
			var1_3 = pg.TimeMgr.GetInstance():passTime(var3_3)

			if not var1_3 then
				return var1_3, var2_3, i18n("meta_shop_exchange_limit_2"), var3_3
			end
		elseif var2_3 == "pass" then
			local var5_3 = getProxy(ChapterProxy):getChapterById(var3_3)

			var1_3 = var5_3 and var5_3:isClear()

			if not var1_3 then
				return var1_3, var2_3, var4_3, var3_3
			end
		end
	end

	return var1_3
end

local function var1_0(arg0_4, arg1_4)
	local var0_4 = getProxy(BayProxy):getMetaShipByGroupId(arg1_4)

	if var0_4 then
		local var1_4 = var0_4:getMetaCharacter():getSpecialMaterialInfoToMaxStar()
		local var2_4 = getProxy(BagProxy):getItemCountById(var1_4.itemID)

		print(var1_4, var2_4)

		return math.max(var1_4.count - var2_4, 0)
	else
		return arg0_4:getConfig("num_limit") - arg0_4.buyCount
	end

	return 0
end

function var0_0.GetTranCntWhenFull(arg0_5, arg1_5)
	local var0_5 = arg0_5:getConfig("limit_args")
	local var1_5 = 0
	local var2_5

	if not var0_5 or var0_5 == "" or #var0_5 == 0 then
		-- block empty
	else
		for iter0_5, iter1_5 in ipairs(var0_5) do
			local var3_5 = iter1_5[1]
			local var4_5 = iter1_5[2]
			local var5_5 = iter1_5[3]
			local var6_5 = iter1_5[4]

			if var3_5 == ShopArgs.LIMIT_ARGS_TRAN_ITEM_WHEN_FULL then
				local var7_5 = var1_0(arg0_5, var4_5) - arg1_5

				if var7_5 < 0 then
					var1_5 = math.abs(var7_5)
					var2_5 = Drop.Create(var6_5)
				end
			end
		end
	end

	return var1_5, var2_5
end

function var0_0.CheckTimeLimit(arg0_6)
	local var0_6 = false
	local var1_6 = false
	local var2_6 = false
	local var3_6 = arg0_6:getConfig("commodity_type")
	local var4_6 = arg0_6:getConfig("commodity_id")
	local var5_6 = Item.getConfigData(var4_6)

	if var3_6 == DROP_TYPE_VITEM and var5_6.virtual_type == 22 then
		var0_6 = true
		var2_6 = true

		local var6_6 = getProxy(ActivityProxy):getActivityById(var5_6.link_id)

		if var6_6 and not var6_6:isEnd() then
			var1_6 = true
		end
	elseif var3_6 == DROP_TYPE_ITEM and var5_6.time_limit == 1 then
		var0_6 = false
		var1_6 = true
	end

	return var0_6, var1_6, var2_6
end

function var0_0.canPurchase(arg0_7)
	local var0_7, var1_7, var2_7 = arg0_7:CheckCntLimit()
	local var3_7, var4_7, var5_7 = arg0_7:CheckArgLimit()

	if not var0_7 then
		return false, var1_7, var2_7
	end

	if not var3_7 then
		return false, var4_7, var5_7
	end

	return true
end

function var0_0.getSkinId(arg0_8)
	if arg0_8:getConfig("commodity_type") == DROP_TYPE_SKIN then
		return arg0_8:getConfig("commodity_id")
	end

	return nil
end

function var0_0.checkCommodityType(arg0_9, arg1_9)
	return arg0_9:getConfig("commodity_type") == arg1_9
end

function var0_0.GetPurchasableCnt(arg0_10)
	local var0_10 = arg0_10:getConfig("commodity_type")
	local var1_10 = arg0_10:getConfig("commodity_id")

	if var0_10 == DROP_TYPE_SKIN then
		return getProxy(ShipSkinProxy):hasSkin(var1_10) and 0 or 1
	elseif var0_10 == DROP_TYPE_FURNITURE then
		local var2_10 = getProxy(DormProxy):getRawData():GetOwnFurnitureCount(var1_10)
		local var3_10 = pg.furniture_data_template[var1_10]

		return math.min(var3_10.count - var2_10, arg0_10:getConfig("num_limit") - arg0_10.buyCount)
	else
		local var4_10 = arg0_10:getConfig("limit_args")
		local var5_10

		if type(var4_10) == "table" then
			var5_10 = _.detect(var4_10, function(arg0_11)
				return arg0_11[1] == ShopArgs.LIMIT_ARGS_META_SHIP_EXISTENCE
			end)
		end

		if var5_10 then
			return var1_0(arg0_10, var5_10[2])
		else
			return arg0_10:getConfig("num_limit") - arg0_10.buyCount
		end
	end
end

function var0_0.GetConsume(arg0_12)
	return Drop.New({
		type = arg0_12:getConfig("resource_category"),
		id = arg0_12:getConfig("resource_type"),
		count = arg0_12:getConfig("resource_num")
	})
end

return var0_0
