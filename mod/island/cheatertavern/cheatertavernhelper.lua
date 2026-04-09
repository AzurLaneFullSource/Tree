local var0_0 = class("CheaterTavernHelper")

function var0_0.GetModelDataByViewData(arg0_1)
	local var0_1 = pg.island_chara_template[arg0_1.ship_id].unit_id
	local var1_1 = arg0_1.skin_id or 0

	if var1_1 ~= 0 then
		if not pg.island_skin_template[var1_1] then
			warning(var1_1 .. "island_skin_template")
		end

		var0_1 = pg.island_skin_template[var1_1].model

		local var2_1 = arg0_1.color or 0

		if var2_1 ~= 0 then
			var0_1 = pg.island_skin_colordiff_template[var2_1].model
		end
	end

	local var3_1 = pg.island_unit_character[var0_1]

	if not var3_1 then
		warning(var1_1 .. "island_skin_template")
	end

	return {
		model = var3_1.model,
		animator = var3_1.animator,
		unitId = var0_1
	}
end

return var0_0
