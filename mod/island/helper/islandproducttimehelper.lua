local var0_0 = class("IslandProductTimeHelper")

function var0_0.GetSpeedAddtionTypeByPlaceId(arg0_1)
	return switch(arg0_1, {
		[IslandProductConst.FellingPlaceId] = function()
			return IslandAblityAgency.TYPE_PRODUCT_FELLING
		end,
		[IslandProductConst.MinePlaceId] = function()
			return IslandAblityAgency.TYPE_PRODUCT_MINING
		end,
		[IslandProductConst.FarmlandPlaceId] = function()
			return IslandAblityAgency.TYPE_PRODUCT_FARM
		end,
		[IslandProductConst.OrchardPlaceId] = function()
			return IslandAblityAgency.TYPE_PRODUCT_ORCHARD
		end,
		[IslandProductConst.GardenPlaceId] = function()
			return IslandAblityAgency.TYPE_PRODUCT_GARDEN
		end
	}, function()
		return nil
	end)
end

function var0_0.CalculateTimeToProductFormula(arg0_8, arg1_8, arg2_8, arg3_8, arg4_8)
	local var0_8 = getProxy(IslandProxy):GetIsland()
	local var1_8 = var0_8:GetCharacterAgency():GetShipById(arg0_8)
	local var2_8 = pg.island_set.base_efficiency.key_value_int
	local var3_8 = pg.island_formula[arg1_8]
	local var4_8 = var3_8.attribute
	local var5_8 = 0

	for iter0_8, iter1_8 in ipairs(var1_8:GetSkill():GetUnlockShipEffectIds()) do
		local var6_8 = pg.island_buff_template[iter1_8]

		if var6_8.buff_type == IslandBuffType.SHIP_PRODUCT_RATIO then
			local var7_8 = var6_8.type_use
			local var8_8 = var7_8[1]

			if underscore.any(var8_8, function(arg0_9)
				return arg0_9 == arg3_8
			end) then
				var5_8 = var5_8 + var7_8[2]
			end
		end
	end

	local var9_8 = 0
	local var10_8 = var0_0.GetSpeedAddtionTypeByPlaceId(arg3_8)

	if var10_8 then
		var9_8 = var9_8 + var0_8:GetAblityAgency():GetProductAdditionSpeedByAblityType(var10_8)
	end

	local var11_8 = 0

	if arg3_8 == IslandProductConst.PasturePlaceId then
		local var12_8 = var0_8:GetBuildingAgency():GetBuilding(arg3_8):GetDelegationSlotData(arg4_8):GetPartList()

		for iter2_8, iter3_8 in ipairs(var12_8) do
			var11_8 = var11_8 + pg.island_ranch_animal[iter3_8].efficiency_gains
		end
	end

	local var13_8 = var1_8:GetAttr(IslandShipAttr.ATTRS[var4_8])
	local var14_8 = var1_8:GetAttrGradeByValue(var13_8)
	local var15_8 = pg.island_chara_att[var14_8].effect
	local var16_8 = var2_8 * (1 + 0.01 * (var5_8 + var9_8 + var11_8))
	local var17_8 = var1_8:GetVaildStatusByType(IslandBuffType.SHIP_ATTR)

	table.sort(var17_8, function(arg0_10, arg1_10)
		local var0_10 = arg0_10:GetEndTime()
		local var1_10 = arg1_10:GetEndTime()

		if var0_10 ~= var1_10 then
			return var0_10 < var1_10
		end

		return arg0_10.id < arg1_10.id
	end)

	local var18_8, var19_8 = pg.TimeMgr.GetInstance():GetServerTime(), {}
	local var20_8 = #var17_8

	for iter4_8, iter5_8 in ipairs(var17_8) do
		local var21_8 = iter5_8:GetEndTime()

		if var18_8 ~= var21_8 then
			local var22_8 = math.max(var21_8 - var18_8, 0)

			var18_8 = var21_8

			table.insert(var19_8, {
				timeLength = var22_8,
				buffCount = var20_8
			})
		end

		var20_8 = var20_8 - 1
	end

	local var23_8 = {}

	for iter6_8, iter7_8 in ipairs(var19_8) do
		local var24_8 = 0
		local var25_8 = iter7_8.buffCount
		local var26_8 = #var17_8

		for iter8_8 = var26_8, var26_8 - var25_8 + 1, -1 do
			local var27_8 = var17_8[iter8_8]:GetBuffEffect()

			for iter9_8, iter10_8 in ipairs(var27_8) do
				if iter10_8[1] == var4_8 then
					var24_8 = var24_8 + iter10_8[2]
				end
			end
		end

		local var28_8 = var13_8 * (1 + var24_8 * 0.01)
		local var29_8 = var1_8:GetAttrGradeByValue(var28_8)

		if var29_8 == var14_8 then
			break
		end

		local var30_8 = var16_8 * (1 + 0.01 * pg.island_chara_att[var29_8].effect)

		table.insert(var23_8, {
			buffSpeed = var30_8,
			timeLength = iter7_8.timeLength
		})
	end

	local var31_8 = {}
	local var32_8 = var3_8.workload

	for iter11_8 = 1, arg2_8 do
		local var33_8 = var32_8
		local var34_8 = 0

		for iter12_8, iter13_8 in ipairs(var23_8) do
			local var35_8 = math.floor(var33_8 / iter13_8.buffSpeed)

			if var35_8 <= iter13_8.timeLength then
				iter13_8.timeLength = iter13_8.timeLength - var35_8
				var34_8 = var34_8 + var35_8
				var33_8 = 0

				break
			else
				var34_8 = var34_8 + iter13_8.timeLength
				var33_8 = var33_8 - iter13_8.timeLength * iter13_8.buffSpeed
				iter13_8.timeLength = 0
			end
		end

		if var33_8 > 0 then
			local var36_8 = var16_8 * (1 + 0.01 * var15_8)

			var34_8 = var34_8 + math.floor(var33_8 / var36_8)
		end

		table.insert(var31_8, var34_8)
	end

	return var31_8
end

return var0_0
