local var0_0 = class("IslandShipDressHelperMiniGameNew", import(".IslandShipDressHelperNew"))

function var0_0.SetShipId(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.super.SetShipId(arg0_1, arg1_1)

	if not arg3_1 then
		arg0_1.dataAfterRoleInit = {}

		for iter0_1, iter1_1 in ipairs(arg2_1) do
			local var0_1 = {
				id = iter1_1
			}

			var0_1.colorId = 0

			local var1_1 = pg.island_dress_template[iter1_1].type

			for iter2_1, iter3_1 in ipairs(pg.gameset.bar_not_display_dress_type.description) do
				if var1_1 ~= iter3_1 and var1_1 ~= var0_0.DressType.Flotage then
					arg0_1.dataAfterRoleInit[var1_1] = var0_1
				end
			end
		end
	end
end

return var0_0
