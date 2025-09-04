local var0_0 = class("IslandBuffHelper")

function var0_0.GetAllBuffsByType(arg0_1, arg1_1)
	return table.mergeArray(var0_0.GetShipBuffsByType(arg0_1, arg1_1), var0_0.GetGlobalBuffsByType(arg1_1))
end

function var0_0.GetShipBuffsByType(arg0_2, arg1_2)
	local var0_2 = {}

	for iter0_2, iter1_2 in ipairs(arg0_2) do
		for iter2_2, iter3_2 in ipairs(iter1_2:GetSkill():GetUnlockShipEffectIds()) do
			if pg.island_buff_template[iter3_2].buff_type == arg1_2 then
				table.insert(var0_2, IslandShipStatus.New({
					isSkill = true,
					id = iter3_2
				}))
			end
		end

		var0_2 = table.mergeArray(var0_2, iter1_2:GetVaildStatusByType(arg1_2))
	end

	return var0_2
end

function var0_0.GetGlobalBuffsByType(arg0_3)
	return getProxy(IslandProxy):GetIsland():GetGlobalBuffAgency():GetBuffsByType(arg0_3)
end

function var0_0.GetAllShipManangeBuffs(arg0_4, arg1_4)
	local var0_4 = {
		IslandBuffType.SHIP_MANAGE_SELL_PRICE,
		IslandBuffType.SHIP_MANAGE_SELL_NUM
	}
	local var1_4 = {}

	for iter0_4, iter1_4 in ipairs(var0_4) do
		local var2_4 = underscore.select(var0_0.GetShipBuffsByType({
			arg0_4
		}, iter1_4), function(arg0_5)
			return table.contains(arg0_5:GetBuffEffect()[1], arg1_4)
		end)

		var1_4 = table.mergeArray(var1_4, var2_4)
	end

	return var1_4
end

function var0_0.GetManangeSellPriceBuffs(arg0_6, arg1_6)
	local var0_6 = {
		IslandBuffType.SHIP_MANAGE_SELL_PRICE,
		IslandBuffType.GLOBAL_MANAGE_SELL_PRICE
	}
	local var1_6 = {}

	for iter0_6, iter1_6 in ipairs(var0_6) do
		local var2_6 = underscore.select(var0_0.GetAllBuffsByType(arg0_6, iter1_6), function(arg0_7)
			return table.contains(arg0_7:GetBuffEffect()[1], arg1_6)
		end)

		var1_6 = table.mergeArray(var1_6, var2_6)
	end

	return var1_6
end

function var0_0.GetManangeSellNumBuffs(arg0_8, arg1_8)
	local var0_8 = {
		IslandBuffType.SHIP_MANAGE_SELL_NUM,
		IslandBuffType.GLOBAL_MANAGE_SELL_NUM
	}
	local var1_8 = {}

	for iter0_8, iter1_8 in ipairs(var0_8) do
		local var2_8 = underscore.select(var0_0.GetAllBuffsByType(arg0_8, iter1_8), function(arg0_9)
			return table.contains(arg0_9:GetBuffEffect()[1], arg1_8)
		end)

		var1_8 = table.mergeArray(var1_8, var2_8)
	end

	return var1_8
end

return var0_0
