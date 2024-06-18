local var0_0 = class("CommonCalcHelper")

function var0_0.CalcDungeonHp(arg0_1, arg1_1)
	local var0_1 = 0
	local var1_1 = {}
	local var2_1 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(arg0_1)

	for iter0_1, iter1_1 in ipairs(var2_1.stages) do
		for iter2_1, iter3_1 in ipairs(iter1_1.waves) do
			if iter3_1.triggerType == ys.Battle.BattleConst.WaveTriggerType.NORMAL then
				for iter4_1, iter5_1 in ipairs(iter3_1.spawn) do
					local var3_1 = iter5_1.monsterTemplateID

					var1_1[#var1_1 + 1] = var3_1
				end

				if iter3_1.reinforcement then
					for iter6_1, iter7_1 in ipairs(iter3_1.reinforcement) do
						local var4_1 = iter7_1.monsterTemplateID

						var1_1[#var1_1 + 1] = var4_1
					end
				end
			end
		end
	end

	for iter8_1, iter9_1 in ipairs(var1_1) do
		local var5_1 = ys.Battle.BattleDataFunction.GetMonsterTmpDataFromID(iter9_1)

		var0_1 = var0_1 + (var5_1.durability + var5_1.durability_growth * ((arg1_1 - 1) / 1000))
	end

	return var0_1
end

return var0_0
