local var0_0 = class("NewEducateBenefit")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.actives = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.actives) do
		arg0_1.actives[iter1_1.id] = NewEducateBuff.New(iter1_1.id, iter1_1.round)
	end

	arg0_1.pendings = arg1_1.pendings
end

function var0_0.AddActiveBuff(arg0_2, arg1_2, arg2_2)
	arg0_2.actives[arg1_2] = NewEducateBuff.New(arg1_2, arg2_2)
end

function var0_0.AddPendingBuff(arg0_3, arg1_3)
	if not table.contains(arg0_3.pendings, arg1_3) then
		table.insert(arg0_3.pendings, arg1_3)
	end
end

function var0_0.RemoveBuff(arg0_4, arg1_4)
	arg0_4.actives[arg1_4] = nil
end

function var0_0.GetBuff(arg0_5, arg1_5)
	return arg0_5.actives[arg1_5]
end

function var0_0.GetListByType(arg0_6, arg1_6)
	local var0_6 = {}

	for iter0_6, iter1_6 in pairs(arg0_6.actives) do
		if iter1_6:getConfig("is_show") == 1 and iter1_6:getConfig("type") == arg1_6 then
			table.insert(var0_6, iter1_6)
		end
	end

	table.sort(var0_6, CompareFuncs({
		function(arg0_7)
			return arg0_7.round
		end,
		function(arg0_8)
			return arg0_8.id
		end
	}))

	return var0_6
end

function var0_0.GetAllBuffList(arg0_9)
	local var0_9 = {}

	for iter0_9, iter1_9 in pairs(arg0_9.actives) do
		table.insert(var0_9, iter1_9)
	end

	return var0_9
end

function var0_0.OnNextRound(arg0_10, arg1_10)
	for iter0_10, iter1_10 in pairs(arg0_10.actives) do
		if arg1_10 == iter1_10:GetEndRound() then
			arg0_10.actives[iter1_10.id] = nil
		end
	end

	for iter2_10, iter3_10 in ipairs(arg0_10.pendings) do
		arg0_10:AddActiveBuff(iter3_10, arg1_10)
	end

	arg0_10.pendings = {}
end

function var0_0.ExistBuff(arg0_11, arg1_11)
	return arg0_11.actives[arg1_11] or table.contains(arg0_11.pendings, arg1_11)
end

function var0_0.GetAllIds(arg0_12)
	local var0_12 = {}

	for iter0_12, iter1_12 in pairs(arg0_12.actives) do
		table.insert(var0_12, iter1_12.id)
	end

	return var0_12, arg0_12.pendings
end

function var0_0.GetActiveEffectsByType(arg0_13, arg1_13, arg2_13)
	local var0_13 = {}

	for iter0_13, iter1_13 in pairs(arg0_13.actives) do
		local var1_13 = iter1_13:GetBenefitIdsByEffectType(arg2_13)

		if #var1_13 > 0 then
			for iter2_13, iter3_13 in ipairs(var1_13) do
				if arg1_13:IsMatchComplex(pg.child2_benefit[iter3_13].condition) then
					for iter4_13, iter5_13 in ipairs(pg.child2_benefit[iter3_13].effect) do
						if iter5_13[1] == arg2_13 then
							table.insert(var0_13, iter5_13)
						end
					end
				end
			end
		end
	end

	return var0_13
end

function var0_0.GetExtraPlan(arg0_14, arg1_14)
	local var0_14 = {}
	local var1_14 = arg0_14:GetActiveEffectsByType(arg1_14, NewEducateConst.EFFECT_TYPE.EXTRA_PLAN)

	underscore.each(var1_14, function(arg0_15)
		var0_14 = table.mergeArray(var0_14, arg0_15[2], true)
	end)

	return var0_14
end

function var0_0.GetGoodsDiscountInfos(arg0_16, arg1_16)
	local var0_16 = arg0_16:GetActiveEffectsByType(arg1_16, NewEducateConst.EFFECT_TYPE.REDUCE_GOODS_CSOT)

	return arg0_16:GetCommonDiscountInfos(var0_16)
end

function var0_0.GetActivePlanDiscountEffects(arg0_17, arg1_17)
	local var0_17 = {}

	for iter0_17, iter1_17 in pairs(arg0_17.actives) do
		local var1_17 = iter1_17:GetBenefitIdsByEffectType(NewEducateConst.EFFECT_TYPE.REDUCE_PLAN_COST)

		if #var1_17 > 0 then
			for iter2_17, iter3_17 in ipairs(var1_17) do
				local var2_17 = pg.child2_benefit[iter3_17].condition
				local var3_17 = arg1_17:GetConditionIdsFromComplex(var2_17)

				for iter4_17, iter5_17 in ipairs(var3_17) do
					local var4_17 = pg.child2_condition[iter5_17]

					if var4_17.type == 8 or var4_17.type == 15 then
						local var5_17 = {}

						for iter6_17, iter7_17 in ipairs(pg.child2_benefit[iter3_17].effect) do
							if iter7_17[1] == NewEducateConst.EFFECT_TYPE.REDUCE_PLAN_COST then
								table.insert(var5_17, iter7_17)
							end
						end

						for iter8_17, iter9_17 in ipairs(var4_17.param[1]) do
							if not var0_17[iter9_17] then
								var0_17[iter9_17] = {}
							end

							var0_17[iter9_17] = table.mergeArray(var0_17[iter9_17], var5_17)
						end
					end
				end
			end
		end
	end

	return var0_17
end

function var0_0.GetPlanDiscountInfos(arg0_18, arg1_18)
	local var0_18 = {}
	local var1_18 = arg0_18:GetActivePlanDiscountEffects(arg1_18)

	for iter0_18, iter1_18 in pairs(var1_18) do
		var0_18[iter0_18] = arg0_18:GetCommonDiscountInfos(iter1_18)
	end

	return var0_18
end

function var0_0.GetCommonDiscountInfos(arg0_19, arg1_19)
	local var0_19 = {}

	underscore.each(arg1_19, function(arg0_20)
		local var0_20 = arg0_20[2][1]
		local var1_20 = arg0_20[2][2]
		local var2_20 = arg0_20[2][3]
		local var3_20 = arg0_20[2][4]

		if not var0_19[var0_20] then
			var0_19[var0_20] = {}
		end

		if not var0_19[var0_20][var1_20] then
			var0_19[var0_20][var1_20] = {
				value = 0,
				ratio = 0
			}
		end

		if var2_20 == 1 then
			var0_19[var0_20][var1_20].value = var0_19[var0_20][var1_20].value + var3_20
		elseif var2_20 == 2 then
			var0_19[var0_20][var1_20].ratio = var0_19[var0_20][var1_20].ratio + var3_20
		end
	end)

	return var0_19
end

return var0_0
