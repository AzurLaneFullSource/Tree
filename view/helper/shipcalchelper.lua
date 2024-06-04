local var0 = class("ShipCalcHelper")

function var0.CalcDestoryRes(arg0)
	local var0 = {}
	local var1 = 0
	local var2 = 0
	local var3 = false

	for iter0, iter1 in ipairs(arg0) do
		local var4, var5, var6 = iter1:calReturnRes()

		var1 = var1 + var4
		var2 = var2 + var5
		var0 = table.mergeArray(var0, underscore.map(var6, function(arg0)
			return Drop.Create(arg0)
		end))
	end

	local var7 = PlayerConst.MergeSameDrops(var0)

	for iter2 = #var7, 1, -1 do
		local var8 = var7[iter2]

		if var8.type == DROP_TYPE_VITEM and var8:getConfig("virtual_type") == 20 then
			local var9, var10 = unpack(pg.gameset.urpt_chapter_max.description)
			local var11 = math.min(var8.count, var10 - getProxy(BagProxy):GetLimitCntById(var9))

			var3 = var11 < var8.count

			if var11 > 0 then
				var8.count = var11
			else
				table.remove(var7, iter2)
			end
		end
	end

	for iter3, iter4 in pairs(var7) do
		if iter4.count > 0 and iter4.type == DROP_TYPE_VITEM and Item.getConfigData(iter4.id).virtual_type == 20 then
			local var12 = iter4.count
			local var13 = pg.gameset.urpt_chapter_max.description
			local var14 = var13[1]
			local var15 = var13[2]
			local var16 = getProxy(BagProxy):GetLimitCntById(var14)
			local var17 = math.min(var15 - var16, var12)

			var3 = var17 < var12

			if var17 <= 0 then
				var7[iter3].count = 0
			else
				var7[iter3].count = var17
			end
		end
	end

	table.sort(var7, CompareFuncs({
		function(arg0)
			return arg0.id
		end
	}))

	return var1, var2, var7, var3
end

function var0.GetEliteAndHightLevelShips(arg0)
	local var0 = {}
	local var1 = {}

	for iter0, iter1 in ipairs(arg0) do
		if iter1:getRarity() >= 4 then
			table.insert(var0, iter1)
		elseif iter1.level > 1 then
			table.insert(var1, iter1)
		end
	end

	return var0, var1
end

function var0.GetEliteAndHightLevelAndResOverflow(arg0, arg1)
	local var0 = _.map(arg0, function(arg0)
		assert(arg1[arg0], arg0)

		return arg1[arg0]
	end)
	local var1, var2 = var0.GetEliteAndHightLevelShips(var0)
	local var3, var4, var5, var6 = var0.CalcDestoryRes(var0)

	return var1, var2, var6
end

return var0
