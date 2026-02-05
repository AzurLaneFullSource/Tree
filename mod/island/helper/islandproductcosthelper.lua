local var0_0 = class("IslandProductCostHelper")

function var0_0.GetReducePercentInPlace(arg0_1, arg1_1)
	local var0_1 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_1)
	local var1_1 = 0

	for iter0_1, iter1_1 in ipairs(var0_1:GetSkill():GetUnlockShipEffectIds()) do
		local var2_1 = pg.island_buff_template[iter1_1]

		if var2_1.buff_type == IslandBuffType.SHIP_PRODUCT_POWER_COST then
			local var3_1 = var2_1.type_use
			local var4_1 = var3_1[1]

			if underscore.any(var4_1, function(arg0_2)
				return arg0_2 == arg1_1
			end) then
				var1_1 = var1_1 + var3_1[2]
			end
		end
	end

	return var1_1 * 0.01
end

return var0_0
