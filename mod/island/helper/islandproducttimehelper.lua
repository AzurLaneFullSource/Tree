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
	local var3_8 = var0_0.GetShipBuffPercent(arg0_8, arg1_8)

	return var0_8, var1_8, var2_8, var3_8
end

function var0_0.GetAttributeAddPercent(arg0_9, arg1_9)
	local var0_9 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_9)
	local var1_9 = var0_9:GetAttr(IslandShipAttr.ATTRS[arg1_9])
	local var2_9 = var0_9:GetAttrGradeByValue(var1_9)
	local var3_9 = pg.island_chara_att[var2_9].effect
	local var4_9 = var0_9:GetVaildStatusByType(IslandBuffType.SHIP_ATTR)

	if #var4_9 == 0 then
		return var3_9
	end

	local var5_9 = 0

	for iter0_9, iter1_9 in ipairs(var4_9) do
		local var6_9 = iter1_9:GetBuffEffect()

		for iter2_9, iter3_9 in ipairs(var6_9) do
			if iter3_9[1] == arg1_9 then
				var5_9 = var5_9 + iter3_9[2]
			end
		end
	end

	local var7_9 = math.floor(var1_9 * (1 + var5_9 * 0.01))
	local var8_9 = var0_9:GetAttrGradeByValue(var7_9)

	return pg.island_chara_att[var8_9].effect
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

function var0_0.GetShipBuffPercent(arg0_13, arg1_13)
	local var0_13 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_13):GetVaildStatusByType(IslandBuffType.SHIP_PRODUCT_RATIO)
	local var1_13 = 0

	for iter0_13, iter1_13 in ipairs(var0_13) do
		local var2_13 = iter1_13:GetBuffEffect()
		local var3_13 = var2_13[1]

		if underscore.any(var3_13, function(arg0_14)
			return arg0_14 == arg1_13
		end) then
			var1_13 = var1_13 + var2_13[2]
		end
	end

	return var1_13
end

function var0_0.CalculateTimeToProductFormula(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15)
	local var0_15 = getProxy(IslandProxy):GetIsland()
	local var1_15 = var0_15:GetCharacterAgency():GetShipById(arg0_15)
	local var2_15 = pg.island_set.base_efficiency.key_value_int
	local var3_15 = pg.island_formula[arg1_15]
	local var4_15 = var3_15.attribute
	local var5_15 = 0

	for iter0_15, iter1_15 in ipairs(var1_15:GetSkill():GetUnlockShipEffectIds()) do
		local var6_15 = pg.island_buff_template[iter1_15]

		if var6_15.buff_type == IslandBuffType.SHIP_PRODUCT_RATIO then
			local var7_15 = var6_15.type_use
			local var8_15 = var7_15[1]

			if underscore.any(var8_15, function(arg0_16)
				return arg0_16 == arg3_15
			end) then
				var5_15 = var5_15 + var7_15[2]
			end
		end
	end

	local var9_15 = 0
	local var10_15 = var0_0.GetSpeedAddtionTypeByPlaceId(arg3_15)

	if var10_15 then
		var9_15 = var9_15 + var0_15:GetAblityAgency():GetProductAdditionSpeedByAblityType(var10_15)
	end

	local var11_15 = var1_15:GetAttr(IslandShipAttr.ATTRS[var4_15])
	local var12_15 = var1_15:GetAttrGradeByValue(var11_15)
	local var13_15 = pg.island_chara_att[var12_15].effect
	local var14_15 = var5_15 + var9_15
	local var15_15 = var1_15:GetVaildStatusByType(IslandBuffType.SHIP_ATTR)

	table.sort(var15_15, function(arg0_17, arg1_17)
		local var0_17 = arg0_17:GetEndTime()
		local var1_17 = arg1_17:GetEndTime()

		if var0_17 ~= var1_17 then
			return var0_17 < var1_17
		end

		return arg0_17.id < arg1_17.id
	end)

	local var16_15 = pg.TimeMgr.GetInstance():GetServerTime()
	local var17_15 = {}
	local var18_15 = var16_15
	local var19_15 = #var15_15

	for iter2_15, iter3_15 in ipairs(var15_15) do
		local var20_15 = iter3_15:GetEndTime()

		if var18_15 ~= var20_15 then
			local var21_15 = math.max(var20_15 - var18_15, 0)

			var18_15 = var20_15

			table.insert(var17_15, {
				timeLength = var21_15,
				buffCount = var19_15
			})
		end

		var19_15 = var19_15 - 1
	end

	local var22_15 = {}

	for iter4_15, iter5_15 in ipairs(var17_15) do
		local var23_15 = 0
		local var24_15 = iter5_15.buffCount
		local var25_15 = #var15_15

		for iter6_15 = var25_15, var25_15 - var24_15 + 1, -1 do
			local var26_15 = var15_15[iter6_15]:GetBuffEffect()

			for iter7_15, iter8_15 in ipairs(var26_15) do
				if iter8_15[1] == var4_15 then
					var23_15 = var23_15 + iter8_15[2]
				end
			end
		end

		local var27_15 = math.floor(var11_15 * (1 + var23_15 * 0.01))
		local var28_15 = var1_15:GetAttrGradeByValue(var27_15)

		if var28_15 == var12_15 then
			break
		end

		local var29_15 = pg.island_chara_att[var28_15].effect - var13_15

		table.insert(var22_15, {
			buffAddPercent = var29_15,
			timeLength = iter5_15.timeLength
		})
	end

	local var30_15 = var1_15:GetVaildStatusByType(IslandBuffType.SHIP_PRODUCT_RATIO)
	local var31_15 = {}
	local var32_15 = 0

	for iter9_15, iter10_15 in ipairs(var30_15) do
		local var33_15 = iter10_15:GetBuffEffect()
		local var34_15 = var33_15[1]

		if underscore.any(var34_15, function(arg0_18)
			return arg0_18 == arg3_15
		end) then
			table.insert(var31_15, iter10_15)

			var32_15 = var32_15 + var33_15[2]
		end
	end

	table.sort(var31_15, function(arg0_19, arg1_19)
		local var0_19 = arg0_19:GetEndTime()
		local var1_19 = arg1_19:GetEndTime()

		if var0_19 ~= var1_19 then
			return var0_19 < var1_19
		end

		return arg0_19.id < arg1_19.id
	end)

	local var35_15 = var16_15
	local var36_15 = {}
	local var37_15 = 0

	for iter11_15, iter12_15 in ipairs(var31_15) do
		local var38_15 = iter12_15:GetEndTime()
		local var39_15 = iter12_15:GetBuffEffect()[2]

		if var35_15 ~= var38_15 then
			local var40_15 = math.max(var38_15 - var35_15, 0)

			var35_15 = var38_15
			var32_15 = var32_15 - var37_15

			table.insert(var36_15, {
				buffAddPercent = var32_15,
				timeLength = var40_15
			})
		end

		var37_15 = var37_15 + var39_15
	end

	local var41_15 = 1
	local var42_15 = 1
	local var43_15 = (function(arg0_20, arg1_20)
		local var0_20 = {}

		if #arg0_20 == 0 and #arg1_20 == 0 then
			return {}
		end

		if #arg0_20 == 0 then
			return arg1_20
		end

		if #arg1_20 == 0 then
			return arg0_20
		end

		while var41_15 <= #arg0_20 and var42_15 <= #arg1_20 do
			local var1_20 = arg0_20[var41_15]
			local var2_20 = arg1_20[var42_15]
			local var3_20 = math.min(var1_20.timeLength, var2_20.timeLength)

			table.insert(var0_20, {
				timeLength = var3_20,
				buffAddPercent = var1_20.buffAddPercent + var2_20.buffAddPercent
			})

			var1_20.timeLength = var1_20.timeLength - var3_20
			var2_20.timeLength = var2_20.timeLength - var3_20

			if var1_20.timeLength <= 0 then
				var41_15 = var41_15 + 1
			end

			if var2_20.timeLength <= 0 then
				var42_15 = var42_15 + 1
			end
		end

		return var0_20
	end)(var36_15, var22_15)
	local var44_15 = {}
	local var45_15 = var3_15.workload

	for iter13_15 = 1, arg2_15 do
		local var46_15 = var45_15
		local var47_15 = 0

		for iter14_15, iter15_15 in ipairs(var43_15) do
			local var48_15 = var2_15 * (1 + 0.01 * (var13_15 + iter15_15.buffAddPercent + var14_15))
			local var49_15 = math.floor(var46_15 / var48_15)

			if var49_15 <= iter15_15.timeLength then
				iter15_15.timeLength = iter15_15.timeLength - var49_15
				var47_15 = var47_15 + var49_15
				var46_15 = 0

				break
			else
				var47_15 = var47_15 + iter15_15.timeLength
				var46_15 = var46_15 - iter15_15.timeLength * var48_15
				iter15_15.timeLength = 0
			end
		end

		if var46_15 > 0 then
			local var50_15 = var2_15 * (1 + 0.01 * (var13_15 + var14_15))

			var47_15 = var47_15 + math.floor(var46_15 / var50_15)
		end

		table.insert(var44_15, var47_15)
	end

	return var44_15
end

return var0_0
