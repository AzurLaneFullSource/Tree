local var0_0 = class("MainOverDueSkinDiscountItemSequence", import(".MainOverDueAttireSequence"))

function var0_0.Execute(arg0_1, arg1_1)
	local var0_1, var1_1 = arg0_1:CollectExpiredItems()
	local var2_1

	seriesAsync({
		function(arg0_2)
			arg0_1:RecycleItems(var0_1, var1_1, function(arg0_3)
				var2_1 = arg0_3

				arg0_2()
			end)
		end,
		function(arg0_4)
			if not var2_1 then
				arg0_4()

				return
			end

			arg0_1:DisplayResult(var0_1, arg0_4)
		end,
		function(arg0_5)
			if not var2_1 then
				arg0_5()

				return
			end

			arg0_1:ShowAwardInfo(var2_1, arg0_5)
		end,
		function(arg0_6)
			onNextTick(arg0_6)
		end
	}, arg1_1)
end

function var0_0.ShowAwardInfo(arg0_7, arg1_7, arg2_7)
	pg.m02:sendNotification(NewMainMediator.ON_AWRADS, {
		items = arg1_7,
		callback = arg2_7
	})
end

function var0_0.RecycleItems(arg0_8, arg1_8, arg2_8, arg3_8)
	local var0_8 = {}

	for iter0_8, iter1_8 in ipairs(arg1_8) do
		table.insert(var0_8, iter1_8)
	end

	for iter2_8, iter3_8 in ipairs(arg2_8) do
		table.insert(var0_8, iter3_8)
	end

	pg.m02:sendNotification(GAME.SELL_ITEM, {
		items = var0_8,
		callback = arg3_8
	})
end

function var0_0.DisplayResult(arg0_9, arg1_9, arg2_9)
	if #arg1_9 > 0 then
		arg0_9:Display(SkinDiscountItemExpireDisplayPage, arg1_9, arg2_9)
	else
		arg2_9()
	end
end

function var0_0.CollectExpiredItems(arg0_10)
	local var0_10 = arg0_10:_CollectExpiredItems(ItemUsage.USAGE_SHOP_DISCOUNT)
	local var1_10 = arg0_10:_CollectExpiredItems(ItemUsage.USAGE_SKIN_EXP)

	return var0_10, var1_10
end

function var0_0._CollectExpiredItems(arg0_11, arg1_11)
	local var0_11 = {}
	local var1_11 = pg.shop_template.get_id_list_by_genre.gift_package

	for iter0_11, iter1_11 in pairs(var1_11) do
		local var2_11 = pg.shop_template[iter1_11]

		if arg0_11:InTime(var2_11.time) then
			local var3_11 = var2_11.effect_args[1] or 0
			local var4_11 = pg.item_data_statistics[var3_11]

			if var4_11 then
				arg0_11:GetExpiredItemIdFromDropList(var0_11, var4_11.display_icon, arg1_11)
			end
		end
	end

	return var0_11
end

function var0_0.InTime(arg0_12, arg1_12)
	if type(arg1_12) == "table" then
		return pg.TimeMgr.GetInstance():passTime(arg1_12[2])
	elseif arg1_12 == "stop" then
		return true
	end
end

function var0_0.GetExpiredItemIdFromDropList(arg0_13, arg1_13, arg2_13, arg3_13)
	local function var0_13(arg0_14)
		local var0_14 = pg.item_data_statistics[arg0_14]

		assert(var0_14, arg0_14)

		return var0_14 and var0_14.usage == arg3_13
	end

	local var1_13 = getProxy(BagProxy)

	local function var2_13(arg0_15)
		return var1_13:getItemCountById(arg0_15) > 0
	end

	for iter0_13, iter1_13 in pairs(arg2_13) do
		local var3_13 = iter1_13[1]
		local var4_13 = iter1_13[2]

		if var3_13 == DROP_TYPE_ITEM and var2_13(var4_13) and var0_13(var4_13) then
			local var5_13 = var1_13:RawGetItemById(var4_13)

			if not _.any(arg1_13, function(arg0_16)
				return arg0_16.id == var4_13
			end) then
				table.insert(arg1_13, {
					id = var5_13.id,
					count = var5_13.count
				})
			end
		end
	end
end

return var0_0
