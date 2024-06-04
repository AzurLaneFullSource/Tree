local var0 = class("ActivityCommodity", import(".BaseCommodity"))

function var0.bindConfigTable(arg0)
	return pg.activity_shop_template
end

function var0.CheckCntLimit(arg0)
	if arg0:getConfig("num_limit") == 0 then
		return true
	end

	return arg0:GetPurchasableCnt() > 0
end

function var0.CheckArgLimit(arg0)
	local var0 = arg0:getConfig("limit_args")

	if not var0 or var0 == "" or #var0 == 0 then
		return true
	end

	local var1 = false

	for iter0, iter1 in ipairs(var0) do
		local var2 = iter1[1]
		local var3 = iter1[2]
		local var4 = iter1[3]

		if (var2 == ShopArgs.LIMIT_ARGS_META_SHIP_EXISTENCE or var2 == ShopArgs.LIMIT_ARGS_TRAN_ITEM_WHEN_FULL) and (var4 or 1) == 1 then
			var1 = getProxy(BayProxy):getMetaShipByGroupId(var3) ~= nil

			if not var1 then
				return var1, var2, i18n("meta_shop_exchange_limit"), var3
			end
		elseif var2 == ShopArgs.LIMIT_ARGS_SALE_START_TIME then
			var1 = pg.TimeMgr.GetInstance():passTime(var3)

			if not var1 then
				return var1, var2, i18n("meta_shop_exchange_limit_2"), var3
			end
		elseif var2 == "pass" then
			local var5 = getProxy(ChapterProxy):getChapterById(var3)

			var1 = var5 and var5:isClear()

			if not var1 then
				return var1, var2, var4, var3
			end
		end
	end

	return var1
end

local function var1(arg0, arg1)
	local var0 = getProxy(BayProxy):getMetaShipByGroupId(arg1)

	if var0 then
		local var1 = var0:getMetaCharacter():getSpecialMaterialInfoToMaxStar()
		local var2 = getProxy(BagProxy):getItemCountById(var1.itemID)

		print(var1, var2)

		return math.max(var1.count - var2, 0)
	else
		return arg0:getConfig("num_limit") - arg0.buyCount
	end

	return 0
end

function var0.GetTranCntWhenFull(arg0, arg1)
	local var0 = arg0:getConfig("limit_args")
	local var1 = 0
	local var2

	if not var0 or var0 == "" or #var0 == 0 then
		-- block empty
	else
		for iter0, iter1 in ipairs(var0) do
			local var3 = iter1[1]
			local var4 = iter1[2]
			local var5 = iter1[3]
			local var6 = iter1[4]

			if var3 == ShopArgs.LIMIT_ARGS_TRAN_ITEM_WHEN_FULL then
				local var7 = var1(arg0, var4) - arg1

				if var7 < 0 then
					var1 = math.abs(var7)
					var2 = Drop.Create(var6)
				end
			end
		end
	end

	return var1, var2
end

function var0.CheckTimeLimit(arg0)
	local var0 = false
	local var1 = false
	local var2 = false
	local var3 = arg0:getConfig("commodity_type")
	local var4 = arg0:getConfig("commodity_id")
	local var5 = Item.getConfigData(var4)

	if var3 == DROP_TYPE_VITEM and var5.virtual_type == 22 then
		var0 = true
		var2 = true

		local var6 = getProxy(ActivityProxy):getActivityById(var5.link_id)

		if var6 and not var6:isEnd() then
			var1 = true
		end
	elseif var3 == DROP_TYPE_ITEM and var5.time_limit == 1 then
		var0 = false
		var1 = true
	end

	return var0, var1, var2
end

function var0.canPurchase(arg0)
	local var0, var1, var2 = arg0:CheckCntLimit()
	local var3, var4, var5 = arg0:CheckArgLimit()

	if not var0 then
		return false, var1, var2
	end

	if not var3 then
		return false, var4, var5
	end

	return true
end

function var0.getSkinId(arg0)
	if arg0:getConfig("commodity_type") == DROP_TYPE_SKIN then
		return arg0:getConfig("commodity_id")
	end

	return nil
end

function var0.checkCommodityType(arg0, arg1)
	return arg0:getConfig("commodity_type") == arg1
end

function var0.GetPurchasableCnt(arg0)
	local var0 = arg0:getConfig("commodity_type")
	local var1 = arg0:getConfig("commodity_id")

	if var0 == DROP_TYPE_SKIN then
		return getProxy(ShipSkinProxy):hasSkin(var1) and 0 or 1
	elseif var0 == DROP_TYPE_FURNITURE then
		local var2 = getProxy(DormProxy):getRawData():GetOwnFurnitureCount(var1)
		local var3 = pg.furniture_data_template[var1]

		return math.min(var3.count - var2, arg0:getConfig("num_limit") - arg0.buyCount)
	else
		local var4 = arg0:getConfig("limit_args")
		local var5

		if type(var4) == "table" then
			var5 = _.detect(var4, function(arg0)
				return arg0[1] == ShopArgs.LIMIT_ARGS_META_SHIP_EXISTENCE
			end)
		end

		if var5 then
			return var1(arg0, var5[2])
		else
			return arg0:getConfig("num_limit") - arg0.buyCount
		end
	end
end

function var0.GetConsume(arg0)
	return Drop.New({
		type = arg0:getConfig("resource_category"),
		id = arg0:getConfig("resource_type"),
		count = arg0:getConfig("resource_num")
	})
end

return var0
