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

function var0_0.GetAttributeGradeId(arg0_10, arg1_10)
	local var0_10 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_10)
	local var1_10 = var0_10:GetAttr(IslandShipAttr.ATTRS[arg1_10])
	local var2_10 = var0_10:GetAttrGradeByValue(var1_10)
	local var3_10 = var0_10:GetVaildStatusByType(IslandBuffType.SHIP_ATTR)

	if #var3_10 == 0 then
		return var2_10
	end

	local var4_10 = 0

	for iter0_10, iter1_10 in ipairs(var3_10) do
		local var5_10 = iter1_10:GetBuffEffect()

		for iter2_10, iter3_10 in ipairs(var5_10) do
			if iter3_10[1] == arg1_10 then
				var4_10 = var4_10 + iter3_10[2]
			end
		end
	end

	local var6_10 = math.floor(var1_10 * (1 + var4_10 * 0.01))

	return (var0_10:GetAttrGradeByValue(var6_10))
end

function var0_0.GetAttributeAddPercent(arg0_11, arg1_11)
	local var0_11 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_11)
	local var1_11 = var0_11:GetAttr(IslandShipAttr.ATTRS[arg1_11])
	local var2_11 = var0_11:GetAttrGradeByValue(var1_11)
	local var3_11 = pg.island_chara_att[var2_11].effect
	local var4_11 = var0_11:GetVaildStatusByType(IslandBuffType.SHIP_ATTR)

	if #var4_11 == 0 then
		return var3_11
	end

	local var5_11 = 0

	for iter0_11, iter1_11 in ipairs(var4_11) do
		local var6_11 = iter1_11:GetBuffEffect()

		for iter2_11, iter3_11 in ipairs(var6_11) do
			if iter3_11[1] == arg1_11 then
				var5_11 = var5_11 + iter3_11[2]
			end
		end
	end

	local var7_11 = math.floor(var1_11 * (1 + var5_11 * 0.01))
	local var8_11 = var0_11:GetAttrGradeByValue(var7_11)

	return pg.island_chara_att[var8_11].effect
end

function var0_0.GetAttributeAddPercentByAttribute(arg0_12, arg1_12)
	local var0_12 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_12):GetVaildStatusByType(IslandBuffType.SHIP_ATTR)

	if #var0_12 == 0 then
		return 0
	end

	local var1_12 = 0

	for iter0_12, iter1_12 in ipairs(var0_12) do
		local var2_12 = iter1_12:GetBuffEffect()

		for iter2_12, iter3_12 in ipairs(var2_12) do
			if iter3_12[1] == arg1_12 then
				var1_12 = var1_12 + iter3_12[2]
			end
		end
	end

	return var1_12
end

function var0_0.GetPlaceAddPercent(arg0_13, arg1_13)
	local var0_13 = 0
	local var1_13 = getProxy(IslandProxy):GetIsland()
	local var2_13 = var0_0.GetSpeedAddtionTypeByPlaceId(arg1_13)

	if var2_13 then
		var0_13 = var0_13 + var1_13:GetAblityAgency():GetProductAdditionSpeedByAblityType(var2_13)
	end

	return var0_13
end

function var0_0.GetSkillAddPercent(arg0_14, arg1_14)
	local var0_14 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_14)
	local var1_14 = 0

	for iter0_14, iter1_14 in ipairs(var0_14:GetSkill():GetUnlockShipEffectIds()) do
		local var2_14 = pg.island_buff_template[iter1_14]

		if var2_14.buff_type == IslandBuffType.SHIP_PRODUCT_RATIO then
			local var3_14 = var2_14.type_use
			local var4_14 = var3_14[1]

			if underscore.any(var4_14, function(arg0_15)
				return arg0_15 == arg1_14
			end) then
				var1_14 = var1_14 + var3_14[2]
			end
		end
	end

	return var1_14
end

function var0_0.GetShipBuffPercent(arg0_16, arg1_16)
	local var0_16 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_16):GetVaildStatusByType(IslandBuffType.SHIP_PRODUCT_RATIO)
	local var1_16 = 0

	for iter0_16, iter1_16 in ipairs(var0_16) do
		local var2_16 = iter1_16:GetBuffEffect()
		local var3_16 = var2_16[1]

		if underscore.any(var3_16, function(arg0_17)
			return arg0_17 == arg1_16
		end) then
			var1_16 = var1_16 + var2_16[2]
		end
	end

	return var1_16
end

function var0_0.CalculateTimeToProductFormula(arg0_18, arg1_18, arg2_18, arg3_18, arg4_18)
	local var0_18 = getProxy(IslandProxy):GetIsland()
	local var1_18 = var0_18:GetCharacterAgency():GetShipById(arg0_18)
	local var2_18 = pg.island_set.base_efficiency.key_value_int
	local var3_18 = pg.island_formula[arg1_18]
	local var4_18 = var3_18.attribute
	local var5_18 = 0

	for iter0_18, iter1_18 in ipairs(var1_18:GetSkill():GetUnlockShipEffectIds()) do
		local var6_18 = pg.island_buff_template[iter1_18]

		if var6_18.buff_type == IslandBuffType.SHIP_PRODUCT_RATIO then
			local var7_18 = var6_18.type_use
			local var8_18 = var7_18[1]

			if underscore.any(var8_18, function(arg0_19)
				return arg0_19 == arg3_18
			end) then
				var5_18 = var5_18 + var7_18[2]
			end
		end
	end

	local var9_18 = 0
	local var10_18 = var0_0.GetSpeedAddtionTypeByPlaceId(arg3_18)

	if var10_18 then
		var9_18 = var9_18 + var0_18:GetAblityAgency():GetProductAdditionSpeedByAblityType(var10_18)
	end

	local var11_18 = var1_18:GetAttr(IslandShipAttr.ATTRS[var4_18])
	local var12_18 = var1_18:GetAttrGradeByValue(var11_18)
	local var13_18 = pg.island_chara_att[var12_18].effect
	local var14_18 = var5_18 + var9_18
	local var15_18 = var1_18:GetVaildStatusByType(IslandBuffType.SHIP_ATTR)

	table.sort(var15_18, function(arg0_20, arg1_20)
		local var0_20 = arg0_20:GetEndTime()
		local var1_20 = arg1_20:GetEndTime()

		if var0_20 ~= var1_20 then
			return var0_20 < var1_20
		end

		return arg0_20.id < arg1_20.id
	end)

	local var16_18 = pg.TimeMgr.GetInstance():GetServerTime()
	local var17_18 = {}
	local var18_18 = var16_18
	local var19_18 = #var15_18

	for iter2_18, iter3_18 in ipairs(var15_18) do
		local var20_18 = iter3_18:GetEndTime()

		if var18_18 ~= var20_18 then
			local var21_18 = math.max(var20_18 - var18_18, 0)

			var18_18 = var20_18

			table.insert(var17_18, {
				timeLength = var21_18,
				buffCount = var19_18
			})
		end

		var19_18 = var19_18 - 1
	end

	local var22_18 = {}

	for iter4_18, iter5_18 in ipairs(var17_18) do
		local var23_18 = 0
		local var24_18 = iter5_18.buffCount
		local var25_18 = #var15_18

		for iter6_18 = var25_18, var25_18 - var24_18 + 1, -1 do
			local var26_18 = var15_18[iter6_18]:GetBuffEffect()

			for iter7_18, iter8_18 in ipairs(var26_18) do
				if iter8_18[1] == var4_18 then
					var23_18 = var23_18 + iter8_18[2]
				end
			end
		end

		local var27_18 = math.floor(var11_18 * (1 + var23_18 * 0.01))
		local var28_18 = var1_18:GetAttrGradeByValue(var27_18)

		if var28_18 == var12_18 then
			break
		end

		local var29_18 = pg.island_chara_att[var28_18].effect - var13_18

		table.insert(var22_18, {
			buffAddPercent = var29_18,
			timeLength = iter5_18.timeLength
		})
	end

	local var30_18 = var1_18:GetVaildStatusByType(IslandBuffType.SHIP_PRODUCT_RATIO)
	local var31_18 = {}
	local var32_18 = 0

	for iter9_18, iter10_18 in ipairs(var30_18) do
		local var33_18 = iter10_18:GetBuffEffect()
		local var34_18 = var33_18[1]

		if underscore.any(var34_18, function(arg0_21)
			return arg0_21 == arg3_18
		end) then
			table.insert(var31_18, iter10_18)

			var32_18 = var32_18 + var33_18[2]
		end
	end

	table.sort(var31_18, function(arg0_22, arg1_22)
		local var0_22 = arg0_22:GetEndTime()
		local var1_22 = arg1_22:GetEndTime()

		if var0_22 ~= var1_22 then
			return var0_22 < var1_22
		end

		return arg0_22.id < arg1_22.id
	end)

	local var35_18 = var16_18
	local var36_18 = {}
	local var37_18 = 0

	for iter11_18, iter12_18 in ipairs(var31_18) do
		local var38_18 = iter12_18:GetEndTime()
		local var39_18 = iter12_18:GetBuffEffect()[2]

		if var35_18 ~= var38_18 then
			local var40_18 = math.max(var38_18 - var35_18, 0)

			var35_18 = var38_18
			var32_18 = var32_18 - var37_18

			table.insert(var36_18, {
				buffAddPercent = var32_18,
				timeLength = var40_18
			})
		end

		var37_18 = var37_18 + var39_18
	end

	local var41_18 = 1
	local var42_18 = 1
	local var43_18 = (function(arg0_23, arg1_23)
		local var0_23 = {}

		if #arg0_23 == 0 and #arg1_23 == 0 then
			return {}
		end

		if #arg0_23 == 0 then
			return arg1_23
		end

		if #arg1_23 == 0 then
			return arg0_23
		end

		while var41_18 <= #arg0_23 and var42_18 <= #arg1_23 do
			local var1_23 = arg0_23[var41_18]
			local var2_23 = arg1_23[var42_18]
			local var3_23 = math.min(var1_23.timeLength, var2_23.timeLength)

			table.insert(var0_23, {
				timeLength = var3_23,
				buffAddPercent = var1_23.buffAddPercent + var2_23.buffAddPercent
			})

			var1_23.timeLength = var1_23.timeLength - var3_23
			var2_23.timeLength = var2_23.timeLength - var3_23

			if var1_23.timeLength <= 0 then
				var41_18 = var41_18 + 1
			end

			if var2_23.timeLength <= 0 then
				var42_18 = var42_18 + 1
			end
		end

		return var0_23
	end)(var36_18, var22_18)
	local var44_18 = {}
	local var45_18 = var3_18.workload

	for iter13_18 = 1, arg2_18 do
		local var46_18 = var45_18
		local var47_18 = 0

		for iter14_18, iter15_18 in ipairs(var43_18) do
			local var48_18 = var2_18 * (1 + 0.01 * (var13_18 + iter15_18.buffAddPercent + var14_18))
			local var49_18 = math.floor(var46_18 / var48_18)

			if var49_18 <= iter15_18.timeLength then
				iter15_18.timeLength = iter15_18.timeLength - var49_18
				var47_18 = var47_18 + var49_18
				var46_18 = 0

				break
			else
				var47_18 = var47_18 + iter15_18.timeLength
				var46_18 = var46_18 - iter15_18.timeLength * var48_18
				iter15_18.timeLength = 0
			end
		end

		if var46_18 > 0 then
			local var50_18 = var2_18 * (1 + 0.01 * (var13_18 + var14_18))

			var47_18 = var47_18 + math.floor(var46_18 / var50_18)
		end

		table.insert(var44_18, var47_18)
	end

	return var44_18
end

return var0_0
