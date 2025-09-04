local var0_0 = class("IslandSharedMapDescPage", import("Mod.Island.View.page.map.IslandBaseMapDescPage"))

function var0_0.OnShow(arg0_1, arg1_1)
	var0_0.super.OnShow(arg0_1, arg1_1)
	arg0_1:UpdateProductionList(arg1_1)
end

function var0_0.UpdateProductionList(arg0_2, arg1_2)
	local var0_2 = pg.island_map_details.get_id_list_by_belong_map[arg1_2]
	local var1_2 = arg0_2:GetIsland():GetAblityAgency()
	local var2_2 = _.select(var0_2, function(arg0_3)
		return var1_2:HasAbility(pg.island_map_details[arg0_3].ability_id)
	end)

	arg0_2.uiProductionList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			local var0_4 = var2_2[arg1_4 + 1]
			local var1_4 = pg.island_map_details[var0_4]

			GetImageSpriteFromAtlasAsync("island/IslandMapRes", var1_4.detail_icon, arg2_4)
			setText(arg2_4:Find("Text"), var1_4.name)
			setActive(arg2_4:Find("full"), false)
		end
	end)
	arg0_2.uiProductionList:align(#var2_2)
end

return var0_0
