local var0_0 = class("NewEducateBenefit")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.buffs = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.actives) do
		arg0_1.buffs[iter1_1.id] = NewEducateBuff.New(iter1_1)
	end

	arg0_1:InitDisplayPct(arg2_1.benefit_display)
	arg0_1:InitDisplayNum(arg2_1.dollar_num_display)
	arg0_1:InitDisplayCounter(arg2_1.counter)
end

function var0_0.AddBuff(arg0_2, arg1_2)
	arg0_2.buffs[arg1_2.id] = NewEducateBuff.New(arg1_2)
end

function var0_0.RemoveBuff(arg0_3, arg1_3)
	arg0_3.buffs[arg1_3] = nil
end

function var0_0.GetBuff(arg0_4, arg1_4)
	return arg0_4.buffs[arg1_4]
end

function var0_0.GetListByType(arg0_5, arg1_5)
	local var0_5 = {}

	for iter0_5, iter1_5 in pairs(arg0_5.buffs) do
		if NewEducateBuff.IsVisible(iter1_5.id) and iter1_5:getConfig("type") == arg1_5 then
			table.insert(var0_5, iter1_5)
		end
	end

	table.sort(var0_5, CompareFuncs({
		function(arg0_6)
			return arg0_6.round
		end,
		function(arg0_7)
			return arg0_7.id
		end
	}))

	return var0_5
end

function var0_0.GetAllBuffList(arg0_8)
	local var0_8 = {}

	for iter0_8, iter1_8 in pairs(arg0_8.buffs) do
		table.insert(var0_8, iter1_8)
	end

	return var0_8
end

function var0_0.OnNextRound(arg0_9, arg1_9)
	for iter0_9, iter1_9 in pairs(arg0_9.buffs) do
		iter1_9:OnNextRound(arg1_9)

		if arg1_9 == iter1_9:GetEndRound() then
			arg0_9.buffs[iter1_9.id] = nil
		end
	end
end

function var0_0.ExistBuff(arg0_10, arg1_10)
	return arg0_10.buffs[arg1_10]
end

function var0_0.GetAllIds(arg0_11)
	local var0_11 = {}
	local var1_11 = {}

	for iter0_11, iter1_11 in pairs(arg0_11.buffs) do
		if iter1_11:IsPending() then
			table.insert(var1_11, iter1_11.id)
		else
			table.insert(var0_11, iter1_11.id)
		end
	end

	return var0_11, var1_11
end

function var0_0.InitDisplayPct(arg0_12, arg1_12)
	arg0_12.displayPctData = {}

	for iter0_12, iter1_12 in ipairs(arg1_12) do
		if not arg0_12.displayPctData[iter1_12.type] then
			arg0_12.displayPctData[iter1_12.type] = {}
		end

		arg0_12.displayPctData[iter1_12.type][iter1_12.id] = iter1_12.number
	end
end

function var0_0.UpdateDisplayPct(arg0_13, arg1_13)
	for iter0_13, iter1_13 in ipairs(arg1_13) do
		if not arg0_13.displayPctData[iter1_13.type] then
			arg0_13.displayPctData[iter1_13.type] = {}
		end

		arg0_13.displayPctData[iter1_13.type][iter1_13.id] = iter1_13.number
	end
end

function var0_0.GetDisplayPctData(arg0_14, arg1_14, arg2_14)
	if not arg0_14.displayPctData[arg1_14] then
		return 0
	end

	return arg0_14.displayPctData[arg1_14][arg2_14] and calcFloor(arg0_14.displayPctData[arg1_14][arg2_14] / 100) or 0
end

function var0_0.GetDisplayPctList(arg0_15)
	local var0_15 = {}

	table.insert(var0_15, {
		type = NewEducateConst.DROP_TYPE.RES,
		id = arg0_15:GetResIdByType(NewEducateChar.RES_TYPE.MONEY)
	})

	for iter0_15, iter1_15 in ipairs(arg0_15:GetAttrIds()) do
		table.insert(var0_15, {
			type = NewEducateConst.DROP_TYPE.ATTR,
			id = iter1_15
		})
	end

	return var0_15
end

function var0_0.IsMoodBenefit(arg0_16)
	return arg0_16 >= 10001 and arg0_16 <= 10100
end

function var0_0.GetFinalPct(arg0_17, arg1_17)
	local var0_17 = arg0_17 / 10000

	for iter0_17, iter1_17 in ipairs(arg1_17) do
		var0_17 = var0_17 * (iter1_17 / 10000)
	end

	return var0_17 * 100
end

function var0_0.GetDisplayPctByDrop(arg0_18, arg1_18)
	local var0_18 = 0
	local var1_18 = 0
	local var2_18 = {}
	local var3_18 = {}

	for iter0_18, iter1_18 in pairs(arg0_18.buffs) do
		for iter2_18, iter3_18 in ipairs(pg.child2_benefit_list[iter0_18].content) do
			if not var0_0.IsMoodBenefit(iter3_18) then
				local var4_18, var5_18 = var0_0.GetDisplayPctByBenefitId(iter3_18, arg1_18)

				var0_18 = var0_18 + var4_18[1]
				var2_18 = table.mergeArray(var2_18, var4_18[2])
				var1_18 = var1_18 + var5_18[1]
				var3_18 = table.mergeArray(var3_18, var5_18[2])
			end
		end
	end

	return var0_0.GetFinalPct(var0_18, var2_18), var0_0.GetFinalPct(var1_18, var3_18)
end

function var0_0.GetDisplayPctByBenefitId(arg0_19, arg1_19)
	local var0_19 = 0
	local var1_19 = 0
	local var2_19 = {}
	local var3_19 = {}
	local var4_19 = pg.child2_benefit[arg0_19]
	local var5_19 = var4_19.trigger == NewEducateConst.TRIGGER_TYPE.PERMANENT and #var4_19.condition == 0

	for iter0_19, iter1_19 in ipairs(var4_19.effect) do
		switch(iter1_19[1], {
			[NewEducateConst.EFFECT_TYPE.ADD_PPT] = function()
				local var0_20 = iter1_19[2]

				if var0_20[1] == arg1_19.type and var0_20[2] == arg1_19.id then
					var1_19 = var1_19 + var0_20[3]

					if var5_19 then
						var0_19 = var0_19 + var0_20[3]
					end
				end
			end,
			[NewEducateConst.EFFECT_TYPE.MULT_PPT] = function()
				local var0_21 = iter1_19[2]

				if var0_21[1] == arg1_19.type and var0_21[2] == arg1_19.id then
					table.insert(var3_19, var0_21[3])

					if var5_19 then
						table.insert(var2_19, var0_21[3])
					end
				end
			end
		})
	end

	return {
		var0_19,
		var2_19
	}, {
		var1_19,
		var3_19
	}
end

function var0_0.InitDisplayNum(arg0_22, arg1_22)
	arg0_22:UpdateDisplayNum(arg1_22)
end

function var0_0.UpdateDisplayNum(arg0_23, arg1_23)
	for iter0_23, iter1_23 in ipairs(arg1_23) do
		if not arg0_23.buffs[iter1_23.buffid] then
			warning("not exist buff: ", iter1_23.buffid)
		else
			arg0_23.buffs[iter1_23.buffid]:UpdateDisplayNum(iter1_23.benefitval)
		end
	end
end

function var0_0.InitDisplayCounter(arg0_24, arg1_24)
	arg0_24.displayCounterData = {}

	for iter0_24, iter1_24 in ipairs(arg1_24) do
		arg0_24.displayCounterData[iter1_24.group] = NewEducateBenefitCounter.New(iter1_24)
	end
end

function var0_0.UpdateDisplayCounter(arg0_25, arg1_25)
	for iter0_25, iter1_25 in ipairs(arg1_25) do
		local var0_25 = arg0_25.displayCounterData[iter1_25.group]

		arg0_25.displayCounterData[iter1_25.group] = NewEducateBenefitCounter.New(iter1_25)
	end
end

function var0_0.GetDisplayCounterData(arg0_26, arg1_26)
	return arg0_26.displayCounterData[arg1_26]
end

function var0_0.GetActiveEffectsByType(arg0_27, arg1_27, arg2_27)
	local var0_27 = {}

	for iter0_27, iter1_27 in pairs(arg0_27.buffs) do
		local var1_27 = iter1_27:GetBenefitIdsByEffectType(arg2_27)

		if #var1_27 > 0 then
			for iter2_27, iter3_27 in ipairs(var1_27) do
				if arg1_27:IsMatchComplex(pg.child2_benefit[iter3_27].condition) then
					for iter4_27, iter5_27 in ipairs(pg.child2_benefit[iter3_27].effect) do
						if iter5_27[1] == arg2_27 then
							table.insert(var0_27, iter5_27)
						end
					end
				end
			end
		end
	end

	return var0_27
end

function var0_0.GetExtraPlan(arg0_28, arg1_28)
	local var0_28 = {}
	local var1_28 = arg0_28:GetActiveEffectsByType(arg1_28, NewEducateConst.EFFECT_TYPE.EXTRA_PLAN)

	underscore.each(var1_28, function(arg0_29)
		var0_28 = table.mergeArray(var0_28, arg0_29[2], true)
	end)

	return var0_28
end

function var0_0.GetGoodsDiscountInfos(arg0_30, arg1_30)
	local var0_30 = arg0_30:GetActiveEffectsByType(arg1_30, NewEducateConst.EFFECT_TYPE.REDUCE_GOODS_COST)

	return arg0_30:GetCommonDiscountInfos(var0_30)
end

function var0_0.GetCommonDiscountInfos(arg0_31, arg1_31)
	local var0_31 = {}

	underscore.each(arg1_31, function(arg0_32)
		local var0_32 = arg0_32[2][1]
		local var1_32 = arg0_32[2][2]
		local var2_32 = arg0_32[2][3]
		local var3_32 = arg0_32[2][4]

		if not var0_31[var0_32] then
			var0_31[var0_32] = {}
		end

		if not var0_31[var0_32][var1_32] then
			var0_31[var0_32][var1_32] = {
				value = 0,
				ratio = 0
			}
		end

		if var2_32 == 1 then
			var0_31[var0_32][var1_32].value = var0_31[var0_32][var1_32].value + var3_32
		elseif var2_32 == 2 then
			var0_31[var0_32][var1_32].ratio = var0_31[var0_32][var1_32].ratio + var3_32
		end
	end)

	return var0_31
end

function var0_0.GetActivePlanDiscountEffects(arg0_33, arg1_33)
	local var0_33 = {}

	for iter0_33, iter1_33 in pairs(arg0_33.buffs) do
		local var1_33 = iter1_33:GetBenefitIdsByEffectType(NewEducateConst.EFFECT_TYPE.REDUCE_PLAN_COST)

		if #var1_33 > 0 then
			for iter2_33, iter3_33 in ipairs(var1_33) do
				local var2_33 = pg.child2_benefit[iter3_33].condition
				local var3_33 = arg1_33:GetConditionIdsFromComplex(var2_33)

				for iter4_33, iter5_33 in ipairs(var3_33) do
					local var4_33 = pg.child2_condition[iter5_33]

					if var4_33.type == 8 or var4_33.type == 15 then
						local var5_33 = {}

						for iter6_33, iter7_33 in ipairs(pg.child2_benefit[iter3_33].effect) do
							if iter7_33[1] == NewEducateConst.EFFECT_TYPE.REDUCE_PLAN_COST then
								table.insert(var5_33, iter7_33)
							end
						end

						for iter8_33, iter9_33 in ipairs(var4_33.param[1]) do
							if not var0_33[iter9_33] then
								var0_33[iter9_33] = {}
							end

							var0_33[iter9_33] = table.mergeArray(var0_33[iter9_33], var5_33)
						end
					end
				end
			end
		end
	end

	return var0_33
end

function var0_0.GetPlanDiscountInfos(arg0_34, arg1_34)
	local var0_34 = {}
	local var1_34 = arg0_34:GetActivePlanDiscountEffects(arg1_34)

	for iter0_34, iter1_34 in pairs(var1_34) do
		var0_34[iter0_34] = arg0_34:GetCommonDiscountInfos(iter1_34)
	end

	return var0_34
end

return var0_0
