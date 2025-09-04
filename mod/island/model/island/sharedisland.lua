local var0_0 = class("SharedIsland", import(".BaseIsland"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1.public_data)
	arg0_1:HandleAgora()

	arg0_1.mapID = pg.island_set.initial_visitor_scene.key_value_int

	arg0_1:SetSpawnPointId(pg.island_set.initial_visitor_spawn_point.key_value_int)
end

function var0_0.HandleAgora(arg0_2)
	local var0_2 = arg0_2:GetAgoraAgency()
	local var1_2 = {}

	for iter0_2, iter1_2 in ipairs(pg.island_furniture_template.all) do
		local var2_2 = pg.island_furniture_template[iter1_2]

		table.insert(var1_2, {
			id = iter1_2,
			count = var2_2.setNum
		})
	end

	local var3_2 = {
		furniture_list = var1_2
	}

	var0_2:InitPrivateData(var3_2)
end

return var0_0
