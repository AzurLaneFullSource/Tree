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

function var0_0.GetAllAddPercent(arg0_8, arg1_8, arg2_8)
	local var0_8 = var0_0.GetAttributeAddPercent(arg0_8, arg2_8)
	local var1_8 = var0_0.GetPlaceAddPercent(arg0_8, arg1_8)
	local var2_8 = var0_0.GetSkillAddPercent(arg0_8, arg1_8)

	return var0_8, var1_8, var2_8
end

function var0_0.GetAttributeAddPercent(arg0_9, arg1_9)
	local var0_9 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_9)
	local var1_9 = var0_9:GetAttr(IslandShipAttr.ATTRS[arg1_9])
	local var2_9 = var0_9:GetAttrGradeByValue(var1_9)

	return pg.island_chara_att[var2_9].effect
end

function var0_0.GetPlaceAddPercent(arg0_10, arg1_10)
	local var0_10 = 0
	local var1_10 = getProxy(IslandProxy):GetIsland()
	local var2_10 = var0_0.GetSpeedAddtionTypeByPlaceId(arg1_10)

	if var2_10 then
		var0_10 = var0_10 + var1_10:GetAblityAgency():GetProductAdditionSpeedByAblityType(var2_10)
	end

	return var0_10
end

function var0_0.GetSkillAddPercent(arg0_11, arg1_11)
	local var0_11 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_11)
	local var1_11 = 0

	for iter0_11, iter1_11 in ipairs(var0_11:GetSkill():GetUnlockShipEffectIds()) do
		local var2_11 = pg.island_buff_template[iter1_11]

		if var2_11.buff_type == IslandBuffType.SHIP_PRODUCT_RATIO then
			local var3_11 = var2_11.type_use
			local var4_11 = var3_11[1]

			if underscore.any(var4_11, function(arg0_12)
				return arg0_12 == arg1_11
			end) then
				var1_11 = var1_11 + var3_11[2]
			end
		end
	end

	return var1_11
end

function var0_0.CalculateTimeToProductFormula(arg0_13, arg1_13, arg2_13, arg3_13, arg4_13)
	local var0_13 = getProxy(IslandProxy):GetIsland()
	local var1_13 = var0_13:GetCharacterAgency():GetShipById(arg0_13)
	local var2_13 = pg.island_set.base_efficiency.key_value_int
	local var3_13 = pg.island_formula[arg1_13]
	local var4_13 = var3_13.attribute
	local var5_13 = 0

	for iter0_13, iter1_13 in ipairs(var1_13:GetSkill():GetUnlockShipEffectIds()) do
		local var6_13 = pg.island_buff_template[iter1_13]

		if var6_13.buff_type == IslandBuffType.SHIP_PRODUCT_RATIO then
			local var7_13 = var6_13.type_use
			local var8_13 = var7_13[1]

			if underscore.any(var8_13, function(arg0_14)
				return arg0_14 == arg3_13
			end) then
				var5_13 = var5_13 + var7_13[2]
			end
		end
	end

	local var9_13 = 0
	local var10_13 = var0_0.GetSpeedAddtionTypeByPlaceId(arg3_13)

	if var10_13 then
		var9_13 = var9_13 + var0_13:GetAblityAgency():GetProductAdditionSpeedByAblityType(var10_13)
	end

	local var11_13 = 0
	local var12_13 = var1_13:GetAttr(IslandShipAttr.ATTRS[var4_13])
	local var13_13 = var1_13:GetAttrGradeByValue(var12_13)
	local var14_13 = pg.island_chara_att[var13_13].effect
	local var15_13 = var5_13 + var9_13 + var11_13
	local var16_13 = var1_13:GetVaildStatusByType(IslandBuffType.SHIP_ATTR)

	table.sort(var16_13, function(arg0_15, arg1_15)
		local var0_15 = arg0_15:GetEndTime()
		local var1_15 = arg1_15:GetEndTime()

		if var0_15 ~= var1_15 then
			return var0_15 < var1_15
		end

		return arg0_15.id < arg1_15.id
	end)

	local var17_13, var18_13 = pg.TimeMgr.GetInstance():GetServerTime(), {}
	local var19_13 = #var16_13

	for iter2_13, iter3_13 in ipairs(var16_13) do
		local var20_13 = iter3_13:GetEndTime()

		if var17_13 ~= var20_13 then
			local var21_13 = math.max(var20_13 - var17_13, 0)

			var17_13 = var20_13

			table.insert(var18_13, {
				timeLength = var21_13,
				buffCount = var19_13
			})
		end

		var19_13 = var19_13 - 1
	end

	local var22_13 = {}

	for iter4_13, iter5_13 in ipairs(var18_13) do
		local var23_13 = 0
		local var24_13 = iter5_13.buffCount
		local var25_13 = #var16_13

		for iter6_13 = var25_13, var25_13 - var24_13 + 1, -1 do
			local var26_13 = var16_13[iter6_13]:GetBuffEffect()

			for iter7_13, iter8_13 in ipairs(var26_13) do
				if iter8_13[1] == var4_13 then
					var23_13 = var23_13 + iter8_13[2]
				end
			end
		end

		local var27_13 = var12_13 * (1 + var23_13 * 0.01)
		local var28_13 = var1_13:GetAttrGradeByValue(var27_13)

		if var28_13 == var13_13 then
			break
		end

		local var29_13 = var2_13 * (1 + 0.01 * (pg.island_chara_att[var28_13].effect + var15_13))

		table.insert(var22_13, {
			buffSpeed = var29_13,
			timeLength = iter5_13.timeLength
		})
	end

	local var30_13 = {}
	local var31_13 = var3_13.workload

	for iter9_13 = 1, arg2_13 do
		local var32_13 = var31_13
		local var33_13 = 0

		for iter10_13, iter11_13 in ipairs(var22_13) do
			local var34_13 = math.floor(var32_13 / iter11_13.buffSpeed)

			if var34_13 <= iter11_13.timeLength then
				iter11_13.timeLength = iter11_13.timeLength - var34_13
				var33_13 = var33_13 + var34_13
				var32_13 = 0

				break
			else
				var33_13 = var33_13 + iter11_13.timeLength
				var32_13 = var32_13 - iter11_13.timeLength * iter11_13.buffSpeed
				iter11_13.timeLength = 0
			end
		end

		if var32_13 > 0 then
			local var35_13 = var2_13 * (1 + 0.01 * (var14_13 + var15_13))

			var33_13 = var33_13 + math.floor(var32_13 / var35_13)
		end

		table.insert(var30_13, var33_13)
	end

	return var30_13
end

return var0_0
