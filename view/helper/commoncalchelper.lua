local var0 = class("CommonCalcHelper")

function var0.CalcDungeonHp(arg0, arg1)
	local var0 = 0
	local var1 = {}
	local var2 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(arg0)

	for iter0, iter1 in ipairs(var2.stages) do
		for iter2, iter3 in ipairs(iter1.waves) do
			if iter3.triggerType == ys.Battle.BattleConst.WaveTriggerType.NORMAL then
				for iter4, iter5 in ipairs(iter3.spawn) do
					local var3 = iter5.monsterTemplateID

					var1[#var1 + 1] = var3
				end

				if iter3.reinforcement then
					for iter6, iter7 in ipairs(iter3.reinforcement) do
						local var4 = iter7.monsterTemplateID

						var1[#var1 + 1] = var4
					end
				end
			end
		end
	end

	for iter8, iter9 in ipairs(var1) do
		local var5 = ys.Battle.BattleDataFunction.GetMonsterTmpDataFromID(iter9)

		var0 = var0 + (var5.durability + var5.durability_growth * ((arg1 - 1) / 1000))
	end

	return var0
end

return var0
