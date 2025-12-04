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

function var0_0.GetPlaceAddPercent(arg0_11, arg1_11)
	local var0_11 = 0
	local var1_11 = getProxy(IslandProxy):GetIsland()
	local var2_11 = var0_0.GetSpeedAddtionTypeByPlaceId(arg1_11)

	if var2_11 then
		var0_11 = var0_11 + var1_11:GetAblityAgency():GetProductAdditionSpeedByAblityType(var2_11)
	end

	return var0_11
end

function var0_0.GetSkillAddPercent(arg0_12, arg1_12)
	local var0_12 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_12)
	local var1_12 = 0

	for iter0_12, iter1_12 in ipairs(var0_12:GetSkill():GetUnlockShipEffectIds()) do
		local var2_12 = pg.island_buff_template[iter1_12]

		if var2_12.buff_type == IslandBuffType.SHIP_PRODUCT_RATIO then
			local var3_12 = var2_12.type_use
			local var4_12 = var3_12[1]

			if underscore.any(var4_12, function(arg0_13)
				return arg0_13 == arg1_12
			end) then
				var1_12 = var1_12 + var3_12[2]
			end
		end
	end

	return var1_12
end

function var0_0.GetShipBuffPercent(arg0_14, arg1_14)
	local var0_14 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_14):GetVaildStatusByType(IslandBuffType.SHIP_PRODUCT_RATIO)
	local var1_14 = 0

	for iter0_14, iter1_14 in ipairs(var0_14) do
		local var2_14 = iter1_14:GetBuffEffect()
		local var3_14 = var2_14[1]

		if underscore.any(var3_14, function(arg0_15)
			return arg0_15 == arg1_14
		end) then
			var1_14 = var1_14 + var2_14[2]
		end
	end

	return var1_14
end

function var0_0.CalculateTimeToProductFormula(arg0_16, arg1_16, arg2_16, arg3_16, arg4_16)
	local var0_16 = getProxy(IslandProxy):GetIsland()
	local var1_16 = var0_16:GetCharacterAgency():GetShipById(arg0_16)
	local var2_16 = pg.island_set.base_efficiency.key_value_int
	local var3_16 = pg.island_formula[arg1_16]
	local var4_16 = var3_16.attribute
	local var5_16 = 0

	for iter0_16, iter1_16 in ipairs(var1_16:GetSkill():GetUnlockShipEffectIds()) do
		local var6_16 = pg.island_buff_template[iter1_16]

		if var6_16.buff_type == IslandBuffType.SHIP_PRODUCT_RATIO then
			local var7_16 = var6_16.type_use
			local var8_16 = var7_16[1]

			if underscore.any(var8_16, function(arg0_17)
				return arg0_17 == arg3_16
			end) then
				var5_16 = var5_16 + var7_16[2]
			end
		end
	end

	local var9_16 = 0
	local var10_16 = var0_0.GetSpeedAddtionTypeByPlaceId(arg3_16)

	if var10_16 then
		var9_16 = var9_16 + var0_16:GetAblityAgency():GetProductAdditionSpeedByAblityType(var10_16)
	end

	local var11_16 = var1_16:GetAttr(IslandShipAttr.ATTRS[var4_16])
	local var12_16 = var1_16:GetAttrGradeByValue(var11_16)
	local var13_16 = pg.island_chara_att[var12_16].effect
	local var14_16 = var5_16 + var9_16
	local var15_16 = var1_16:GetVaildStatusByType(IslandBuffType.SHIP_ATTR)

	table.sort(var15_16, function(arg0_18, arg1_18)
		local var0_18 = arg0_18:GetEndTime()
		local var1_18 = arg1_18:GetEndTime()

		if var0_18 ~= var1_18 then
			return var0_18 < var1_18
		end

		return arg0_18.id < arg1_18.id
	end)

	local var16_16 = pg.TimeMgr.GetInstance():GetServerTime()
	local var17_16 = {}
	local var18_16 = var16_16
	local var19_16 = #var15_16

	for iter2_16, iter3_16 in ipairs(var15_16) do
		local var20_16 = iter3_16:GetEndTime()

		if var18_16 ~= var20_16 then
			local var21_16 = math.max(var20_16 - var18_16, 0)

			var18_16 = var20_16

			table.insert(var17_16, {
				timeLength = var21_16,
				buffCount = var19_16
			})
		end

		var19_16 = var19_16 - 1
	end

	local var22_16 = {}

	for iter4_16, iter5_16 in ipairs(var17_16) do
		local var23_16 = 0
		local var24_16 = iter5_16.buffCount
		local var25_16 = #var15_16

		for iter6_16 = var25_16, var25_16 - var24_16 + 1, -1 do
			local var26_16 = var15_16[iter6_16]:GetBuffEffect()

			for iter7_16, iter8_16 in ipairs(var26_16) do
				if iter8_16[1] == var4_16 then
					var23_16 = var23_16 + iter8_16[2]
				end
			end
		end

		local var27_16 = math.floor(var11_16 * (1 + var23_16 * 0.01))
		local var28_16 = var1_16:GetAttrGradeByValue(var27_16)

		if var28_16 == var12_16 then
			break
		end

		local var29_16 = pg.island_chara_att[var28_16].effect - var13_16

		table.insert(var22_16, {
			buffAddPercent = var29_16,
			timeLength = iter5_16.timeLength
		})
	end

	local var30_16 = var1_16:GetVaildStatusByType(IslandBuffType.SHIP_PRODUCT_RATIO)
	local var31_16 = {}
	local var32_16 = 0

	for iter9_16, iter10_16 in ipairs(var30_16) do
		local var33_16 = iter10_16:GetBuffEffect()
		local var34_16 = var33_16[1]

		if underscore.any(var34_16, function(arg0_19)
			return arg0_19 == arg3_16
		end) then
			table.insert(var31_16, iter10_16)

			var32_16 = var32_16 + var33_16[2]
		end
	end

	table.sort(var31_16, function(arg0_20, arg1_20)
		local var0_20 = arg0_20:GetEndTime()
		local var1_20 = arg1_20:GetEndTime()

		if var0_20 ~= var1_20 then
			return var0_20 < var1_20
		end

		return arg0_20.id < arg1_20.id
	end)

	local var35_16 = var16_16
	local var36_16 = {}
	local var37_16 = 0

	for iter11_16, iter12_16 in ipairs(var31_16) do
		local var38_16 = iter12_16:GetEndTime()
		local var39_16 = iter12_16:GetBuffEffect()[2]

		if var35_16 ~= var38_16 then
			local var40_16 = math.max(var38_16 - var35_16, 0)

			var35_16 = var38_16
			var32_16 = var32_16 - var37_16

			table.insert(var36_16, {
				buffAddPercent = var32_16,
				timeLength = var40_16
			})
		end

		var37_16 = var37_16 + var39_16
	end

	local var41_16 = 1
	local var42_16 = 1
	local var43_16 = (function(arg0_21, arg1_21)
		local var0_21 = {}

		if #arg0_21 == 0 and #arg1_21 == 0 then
			return {}
		end

		if #arg0_21 == 0 then
			return arg1_21
		end

		if #arg1_21 == 0 then
			return arg0_21
		end

		while var41_16 <= #arg0_21 and var42_16 <= #arg1_21 do
			local var1_21 = arg0_21[var41_16]
			local var2_21 = arg1_21[var42_16]
			local var3_21 = math.min(var1_21.timeLength, var2_21.timeLength)

			table.insert(var0_21, {
				timeLength = var3_21,
				buffAddPercent = var1_21.buffAddPercent + var2_21.buffAddPercent
			})

			var1_21.timeLength = var1_21.timeLength - var3_21
			var2_21.timeLength = var2_21.timeLength - var3_21

			if var1_21.timeLength <= 0 then
				var41_16 = var41_16 + 1
			end

			if var2_21.timeLength <= 0 then
				var42_16 = var42_16 + 1
			end
		end

		return var0_21
	end)(var36_16, var22_16)
	local var44_16 = {}
	local var45_16 = var3_16.workload

	for iter13_16 = 1, arg2_16 do
		local var46_16 = var45_16
		local var47_16 = 0

		for iter14_16, iter15_16 in ipairs(var43_16) do
			local var48_16 = var2_16 * (1 + 0.01 * (var13_16 + iter15_16.buffAddPercent + var14_16))
			local var49_16 = math.floor(var46_16 / var48_16)

			if var49_16 <= iter15_16.timeLength then
				iter15_16.timeLength = iter15_16.timeLength - var49_16
				var47_16 = var47_16 + var49_16
				var46_16 = 0

				break
			else
				var47_16 = var47_16 + iter15_16.timeLength
				var46_16 = var46_16 - iter15_16.timeLength * var48_16
				iter15_16.timeLength = 0
			end
		end

		if var46_16 > 0 then
			local var50_16 = var2_16 * (1 + 0.01 * (var13_16 + var14_16))

			var47_16 = var47_16 + math.floor(var46_16 / var50_16)
		end

		table.insert(var44_16, var47_16)
	end

	return var44_16
end

return var0_0
