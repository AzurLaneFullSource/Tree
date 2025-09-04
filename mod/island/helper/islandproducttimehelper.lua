local var0_0 = class("IslandProductTimeHelper")

function var0_0.GetSpeedAddtionTypeByPlaceId(arg0_1)
	return switch(arg0_1, {
		[IslandProductSystemVO.FellingPlaceId] = function()
			return IslandAblityAgency.TYPE_PRODUCT_FELLING
		end,
		[IslandProductSystemVO.MinePlaceId] = function()
			return IslandAblityAgency.TYPE_PRODUCT_MINING
		end
	}, function()
		return nil
	end)
end

function var0_0.CalculateTimeToProductFormula(arg0_5, arg1_5, arg2_5, arg3_5)
	local var0_5 = getProxy(IslandProxy):GetIsland()
	local var1_5 = var0_5:GetCharacterAgency():GetShipById(arg0_5)
	local var2_5 = pg.island_set.base_efficiency.key_value_int
	local var3_5 = pg.island_formula[arg1_5]
	local var4_5 = var3_5.attribute
	local var5_5 = 0

	for iter0_5, iter1_5 in ipairs(var1_5:GetSkill():GetUnlockShipEffectIds()) do
		local var6_5 = pg.island_buff_template[iter1_5]

		if var6_5.buff_type == IslandBuffType.SHIP_PRODUCT_RATIO then
			local var7_5 = var6_5.type_use
			local var8_5 = var7_5[1]

			if iter0_5.any(var8_5, function(arg0_6)
				return arg0_6 == arg3_5
			end) then
				var5_5 = var5_5 + var7_5[2]
			end
		end
	end

	local var9_5 = 0
	local var10_5 = var0_0.GetSpeedAddtionTypeByPlaceId(arg3_5)

	if var10_5 then
		var9_5 = var9_5 + var0_5:GetAblityAgency():GetProductAdditionSpeedByAblityType(var10_5)
	end

	local var11_5 = var1_5:GetAttr(IslandShipAttr.ATTRS[var4_5])
	local var12_5 = var1_5:GetAttrGradeByValue(var11_5)
	local var13_5 = pg.island_chara_att[var12_5].effect
	local var14_5 = var2_5 * (1 + 0.01 * (var5_5 + var9_5))
	local var15_5 = var1_5:GetVaildStatusByType(IslandBuffType.SHIP_ATTR)

	table.sort(var15_5, function(arg0_7, arg1_7)
		local var0_7 = arg0_7:GetEndTime()
		local var1_7 = arg1_7:GetEndTime()

		if var0_7 ~= var1_7 then
			return var0_7 < var1_7
		end

		return arg0_7.id < arg1_7.id
	end)

	local var16_5, var17_5 = pg.TimeMgr.GetInstance():GetServerTime(), {}
	local var18_5 = #var15_5

	for iter2_5, iter3_5 in ipairs(var15_5) do
		local var19_5 = iter3_5:GetEndTime()

		if var16_5 ~= var19_5 then
			local var20_5 = math.max(var19_5 - var16_5, 0)

			var16_5 = var19_5

			table.insert(var17_5, {
				timeLength = var20_5,
				buffCount = var18_5
			})
		end

		var18_5 = var18_5 - 1
	end

	local var21_5 = {}

	for iter4_5, iter5_5 in ipairs(var17_5) do
		local var22_5 = 0
		local var23_5 = iter5_5.buffCount
		local var24_5 = #var15_5

		for iter6_5 = var24_5, var24_5 - var23_5 + 1, -1 do
			local var25_5 = var15_5[iter6_5]:GetBuffEffect()

			for iter7_5, iter8_5 in ipairs(var25_5) do
				if iter8_5[1] == var4_5 then
					var22_5 = var22_5 + iter8_5[2]
				end
			end
		end

		local var26_5 = var11_5 * (1 + var22_5 * 0.01)
		local var27_5 = var1_5:GetAttrGradeByValue(var26_5)

		if var27_5 == var12_5 then
			break
		end

		local var28_5 = var14_5 * (1 + 0.01 * pg.island_chara_att[var27_5].effect)

		table.insert(var21_5, {
			buffSpeed = var28_5,
			timeLength = iter5_5.timeLength
		})
	end

	local var29_5 = {}
	local var30_5 = var3_5.workload

	for iter9_5 = 1, arg2_5 do
		local var31_5 = var30_5
		local var32_5 = 0

		for iter10_5, iter11_5 in ipairs(var21_5) do
			local var33_5 = math.floor(var31_5 / iter11_5.buffSpeed)

			if var33_5 <= iter11_5.timeLength then
				iter11_5.timeLength = iter11_5.timeLength - var33_5
				var32_5 = var32_5 + var33_5
				var31_5 = 0

				break
			else
				var32_5 = var32_5 + iter11_5.timeLength
				var31_5 = var31_5 - iter11_5.timeLength * iter11_5.buffSpeed
				iter11_5.timeLength = 0
			end
		end

		if var31_5 > 0 then
			local var34_5 = var14_5 * (1 + 0.01 * var13_5)

			var32_5 = var32_5 + math.floor(var31_5 / var34_5)
		end

		table.insert(var29_5, var32_5)
	end

	return var29_5
end

return var0_0
