local var0_0 = class("IslandRecordLastPositionCommmand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.islandId
	local var2_1 = var0_1.mapId
	local var3_1 = var0_1.position
	local var4_1 = var0_1.rotation

	pg.ConnectionMgr.GetInstance():Send(21229, {
		island_id = var1_1,
		player_position = {
			map_id = var2_1,
			position = {
				x = var3_1.x,
				y = var3_1.y,
				z = var3_1.z
			},
			rotation = {
				x = var4_1.x,
				y = var4_1.y,
				z = var4_1.z
			}
		}
	})
end

return var0_0
