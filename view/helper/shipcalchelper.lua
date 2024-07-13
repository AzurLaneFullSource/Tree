local var0_0 = class("ShipCalcHelper")

function var0_0.CalcDestoryRes(arg0_1)
	local var0_1 = {}
	local var1_1 = 0
	local var2_1 = 0
	local var3_1 = false

	for iter0_1, iter1_1 in ipairs(arg0_1) do
		local var4_1, var5_1, var6_1 = iter1_1:calReturnRes()

		var1_1 = var1_1 + var4_1
		var2_1 = var2_1 + var5_1
		var0_1 = table.mergeArray(var0_1, underscore.map(var6_1, function(arg0_2)
			return Drop.Create(arg0_2)
		end))
	end

	local var7_1 = PlayerConst.MergeSameDrops(var0_1)

	for iter2_1 = #var7_1, 1, -1 do
		local var8_1 = var7_1[iter2_1]

		if var8_1.type == DROP_TYPE_VITEM and var8_1:getConfig("virtual_type") == 20 then
			local var9_1, var10_1 = unpack(pg.gameset.urpt_chapter_max.description)
			local var11_1 = math.min(var8_1.count, var10_1 - getProxy(BagProxy):GetLimitCntById(var9_1))

			var3_1 = var11_1 < var8_1.count

			if var11_1 > 0 then
				var8_1.count = var11_1
			else
				table.remove(var7_1, iter2_1)
			end
		end
	end

	for iter3_1, iter4_1 in pairs(var7_1) do
		if iter4_1.count > 0 and iter4_1.type == DROP_TYPE_VITEM and Item.getConfigData(iter4_1.id).virtual_type == 20 then
			local var12_1 = iter4_1.count
			local var13_1 = pg.gameset.urpt_chapter_max.description
			local var14_1 = var13_1[1]
			local var15_1 = var13_1[2]
			local var16_1 = getProxy(BagProxy):GetLimitCntById(var14_1)
			local var17_1 = math.min(var15_1 - var16_1, var12_1)

			var3_1 = var17_1 < var12_1

			if var17_1 <= 0 then
				var7_1[iter3_1].count = 0
			else
				var7_1[iter3_1].count = var17_1
			end
		end
	end

	table.sort(var7_1, CompareFuncs({
		function(arg0_3)
			return arg0_3.id
		end
	}))

	return var1_1, var2_1, var7_1, var3_1
end

function var0_0.GetEliteAndHightLevelShips(arg0_4)
	local var0_4 = {}
	local var1_4 = {}

	for iter0_4, iter1_4 in ipairs(arg0_4) do
		if iter1_4:getRarity() >= 4 then
			table.insert(var0_4, iter1_4)
		elseif iter1_4.level > 1 then
			table.insert(var1_4, iter1_4)
		end
	end

	return var0_4, var1_4
end

function var0_0.GetEliteAndHightLevelAndResOverflow(arg0_5, arg1_5)
	local var0_5 = _.map(arg0_5, function(arg0_6)
		assert(arg1_5[arg0_6], arg0_6)

		return arg1_5[arg0_6]
	end)
	local var1_5, var2_5 = var0_0.GetEliteAndHightLevelShips(var0_5)
	local var3_5, var4_5, var5_5, var6_5 = var0_0.CalcDestoryRes(var0_5)

	return var1_5, var2_5, var6_5
end

return var0_0
