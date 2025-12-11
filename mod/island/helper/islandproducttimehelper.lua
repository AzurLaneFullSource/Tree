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
		end,
		[IslandProductConst.FisheryPlaceId] = function()
			return IslandAblityAgency.TYPE_PRODUCT_FISH
		end
	}, function()
		return nil
	end)
end

function var0_0.GetAllAddPercent(arg0_9, arg1_9, arg2_9)
	local var0_9 = var0_0.GetAttributeAddPercent(arg0_9, arg2_9)
	local var1_9 = var0_0.GetPlaceAddPercent(arg0_9, arg1_9)
	local var2_9 = var0_0.GetSkillAddPercent(arg0_9, arg1_9)
	local var3_9 = var0_0.GetShipBuffPercent(arg0_9, arg1_9)

	return var0_9, var1_9, var2_9, var3_9
end

function var0_0.GetAttributeAddPercent(arg0_10, arg1_10)
	local var0_10 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_10)
	local var1_10 = var0_10:GetAttr(IslandShipAttr.ATTRS[arg1_10])
	local var2_10 = var0_10:GetAttrGradeByValue(var1_10)
	local var3_10 = pg.island_chara_att[var2_10].effect
	local var4_10 = var0_10:GetVaildStatusByType(IslandBuffType.SHIP_ATTR)

	if #var4_10 == 0 then
		return var3_10
	end

	local var5_10 = 0

	for iter0_10, iter1_10 in ipairs(var4_10) do
		local var6_10 = iter1_10:GetBuffEffect()

		for iter2_10, iter3_10 in ipairs(var6_10) do
			if iter3_10[1] == arg1_10 then
				var5_10 = var5_10 + iter3_10[2]
			end
		end
	end

	local var7_10 = math.floor(var1_10 * (1 + var5_10 * 0.01))
	local var8_10 = var0_10:GetAttrGradeByValue(var7_10)

	return pg.island_chara_att[var8_10].effect
end

function var0_0.GetAttributeAddPercentByAttribute(arg0_11, arg1_11)
	local var0_11 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_11):GetVaildStatusByType(IslandBuffType.SHIP_ATTR)

	if #var0_11 == 0 then
		return 0
	end

	local var1_11 = 0

	for iter0_11, iter1_11 in ipairs(var0_11) do
		local var2_11 = iter1_11:GetBuffEffect()

		for iter2_11, iter3_11 in ipairs(var2_11) do
			if iter3_11[1] == arg1_11 then
				var1_11 = var1_11 + iter3_11[2]
			end
		end
	end

	return var1_11
end

function var0_0.GetPlaceAddPercent(arg0_12, arg1_12)
	local var0_12 = 0
	local var1_12 = getProxy(IslandProxy):GetIsland()
	local var2_12 = var0_0.GetSpeedAddtionTypeByPlaceId(arg1_12)

	if var2_12 then
		var0_12 = var0_12 + var1_12:GetAblityAgency():GetProductAdditionSpeedByAblityType(var2_12)
	end

	return var0_12
end

function var0_0.GetSkillAddPercent(arg0_13, arg1_13)
	local var0_13 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_13)
	local var1_13 = 0

	for iter0_13, iter1_13 in ipairs(var0_13:GetSkill():GetUnlockShipEffectIds()) do
		local var2_13 = pg.island_buff_template[iter1_13]

		if var2_13.buff_type == IslandBuffType.SHIP_PRODUCT_RATIO then
			local var3_13 = var2_13.type_use
			local var4_13 = var3_13[1]

			if underscore.any(var4_13, function(arg0_14)
				return arg0_14 == arg1_13
			end) then
				var1_13 = var1_13 + var3_13[2]
			end
		end
	end

	return var1_13
end

function var0_0.GetShipBuffPercent(arg0_15, arg1_15)
	local var0_15 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_15):GetVaildStatusByType(IslandBuffType.SHIP_PRODUCT_RATIO)
	local var1_15 = 0

	for iter0_15, iter1_15 in ipairs(var0_15) do
		local var2_15 = iter1_15:GetBuffEffect()
		local var3_15 = var2_15[1]

		if underscore.any(var3_15, function(arg0_16)
			return arg0_16 == arg1_15
		end) then
			var1_15 = var1_15 + var2_15[2]
		end
	end

	return var1_15
end

function var0_0.CalculateTimeToProductFormula(arg0_17, arg1_17, arg2_17, arg3_17, arg4_17)
	local var0_17 = getProxy(IslandProxy):GetIsland()
	local var1_17 = var0_17:GetCharacterAgency():GetShipById(arg0_17)
	local var2_17 = pg.island_set.base_efficiency.key_value_int
	local var3_17 = pg.island_formula[arg1_17]
	local var4_17 = var3_17.attribute
	local var5_17 = 0

	for iter0_17, iter1_17 in ipairs(var1_17:GetSkill():GetUnlockShipEffectIds()) do
		local var6_17 = pg.island_buff_template[iter1_17]

		if var6_17.buff_type == IslandBuffType.SHIP_PRODUCT_RATIO then
			local var7_17 = var6_17.type_use
			local var8_17 = var7_17[1]

			if underscore.any(var8_17, function(arg0_18)
				return arg0_18 == arg3_17
			end) then
				var5_17 = var5_17 + var7_17[2]
			end
		end
	end

	local var9_17 = 0
	local var10_17 = var0_0.GetSpeedAddtionTypeByPlaceId(arg3_17)

	if var10_17 then
		var9_17 = var9_17 + var0_17:GetAblityAgency():GetProductAdditionSpeedByAblityType(var10_17)
	end

	local var11_17 = var1_17:GetAttr(IslandShipAttr.ATTRS[var4_17])
	local var12_17 = var1_17:GetAttrGradeByValue(var11_17)
	local var13_17 = pg.island_chara_att[var12_17].effect
	local var14_17 = var5_17 + var9_17
	local var15_17 = var1_17:GetVaildStatusByType(IslandBuffType.SHIP_ATTR)

	table.sort(var15_17, function(arg0_19, arg1_19)
		local var0_19 = arg0_19:GetEndTime()
		local var1_19 = arg1_19:GetEndTime()

		if var0_19 ~= var1_19 then
			return var0_19 < var1_19
		end

		return arg0_19.id < arg1_19.id
	end)

	local var16_17 = pg.TimeMgr.GetInstance():GetServerTime()
	local var17_17 = {}
	local var18_17 = var16_17
	local var19_17 = #var15_17

	for iter2_17, iter3_17 in ipairs(var15_17) do
		local var20_17 = iter3_17:GetEndTime()

		if var18_17 ~= var20_17 then
			local var21_17 = math.max(var20_17 - var18_17, 0)

			var18_17 = var20_17

			table.insert(var17_17, {
				timeLength = var21_17,
				buffCount = var19_17
			})
		end

		var19_17 = var19_17 - 1
	end

	local var22_17 = {}

	for iter4_17, iter5_17 in ipairs(var17_17) do
		local var23_17 = 0
		local var24_17 = iter5_17.buffCount
		local var25_17 = #var15_17

		for iter6_17 = var25_17, var25_17 - var24_17 + 1, -1 do
			local var26_17 = var15_17[iter6_17]:GetBuffEffect()

			for iter7_17, iter8_17 in ipairs(var26_17) do
				if iter8_17[1] == var4_17 then
					var23_17 = var23_17 + iter8_17[2]
				end
			end
		end

		local var27_17 = math.floor(var11_17 * (1 + var23_17 * 0.01))
		local var28_17 = var1_17:GetAttrGradeByValue(var27_17)

		if var28_17 == var12_17 then
			break
		end

		local var29_17 = pg.island_chara_att[var28_17].effect - var13_17

		table.insert(var22_17, {
			buffAddPercent = var29_17,
			timeLength = iter5_17.timeLength
		})
	end

	local var30_17 = var1_17:GetVaildStatusByType(IslandBuffType.SHIP_PRODUCT_RATIO)
	local var31_17 = {}
	local var32_17 = 0

	for iter9_17, iter10_17 in ipairs(var30_17) do
		local var33_17 = iter10_17:GetBuffEffect()
		local var34_17 = var33_17[1]

		if underscore.any(var34_17, function(arg0_20)
			return arg0_20 == arg3_17
		end) then
			table.insert(var31_17, iter10_17)

			var32_17 = var32_17 + var33_17[2]
		end
	end

	table.sort(var31_17, function(arg0_21, arg1_21)
		local var0_21 = arg0_21:GetEndTime()
		local var1_21 = arg1_21:GetEndTime()

		if var0_21 ~= var1_21 then
			return var0_21 < var1_21
		end

		return arg0_21.id < arg1_21.id
	end)

	local var35_17 = var16_17
	local var36_17 = {}
	local var37_17 = 0

	for iter11_17, iter12_17 in ipairs(var31_17) do
		local var38_17 = iter12_17:GetEndTime()
		local var39_17 = iter12_17:GetBuffEffect()[2]

		if var35_17 ~= var38_17 then
			local var40_17 = math.max(var38_17 - var35_17, 0)

			var35_17 = var38_17
			var32_17 = var32_17 - var37_17

			table.insert(var36_17, {
				buffAddPercent = var32_17,
				timeLength = var40_17
			})
		end

		var37_17 = var37_17 + var39_17
	end

	local var41_17 = 1
	local var42_17 = 1
	local var43_17 = (function(arg0_22, arg1_22)
		local var0_22 = {}

		if #arg0_22 == 0 and #arg1_22 == 0 then
			return {}
		end

		if #arg0_22 == 0 then
			return arg1_22
		end

		if #arg1_22 == 0 then
			return arg0_22
		end

		while var41_17 <= #arg0_22 and var42_17 <= #arg1_22 do
			local var1_22 = arg0_22[var41_17]
			local var2_22 = arg1_22[var42_17]
			local var3_22 = math.min(var1_22.timeLength, var2_22.timeLength)

			table.insert(var0_22, {
				timeLength = var3_22,
				buffAddPercent = var1_22.buffAddPercent + var2_22.buffAddPercent
			})

			var1_22.timeLength = var1_22.timeLength - var3_22
			var2_22.timeLength = var2_22.timeLength - var3_22

			if var1_22.timeLength <= 0 then
				var41_17 = var41_17 + 1
			end

			if var2_22.timeLength <= 0 then
				var42_17 = var42_17 + 1
			end
		end

		return var0_22
	end)(var36_17, var22_17)
	local var44_17 = {}
	local var45_17 = var3_17.workload

	for iter13_17 = 1, arg2_17 do
		local var46_17 = var45_17
		local var47_17 = 0

		for iter14_17, iter15_17 in ipairs(var43_17) do
			local var48_17 = var2_17 * (1 + 0.01 * (var13_17 + iter15_17.buffAddPercent + var14_17))
			local var49_17 = math.floor(var46_17 / var48_17)

			if var49_17 <= iter15_17.timeLength then
				iter15_17.timeLength = iter15_17.timeLength - var49_17
				var47_17 = var47_17 + var49_17
				var46_17 = 0

				break
			else
				var47_17 = var47_17 + iter15_17.timeLength
				var46_17 = var46_17 - iter15_17.timeLength * var48_17
				iter15_17.timeLength = 0
			end
		end

		if var46_17 > 0 then
			local var50_17 = var2_17 * (1 + 0.01 * (var13_17 + var14_17))

			var47_17 = var47_17 + math.floor(var46_17 / var50_17)
		end

		table.insert(var44_17, var47_17)
	end

	return var44_17
end

return var0_0
