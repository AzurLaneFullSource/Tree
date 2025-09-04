local var0_0 = class("IslandSaveAgoraThemeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.themeData.id
	local var2_1 = var0_1.themeData.name
	local var3_1 = var0_1.themeData.updateList
	local var4_1 = var0_1.themeData.floorList
	local var5_1 = var0_1.themeData.tileList
	local var6_1 = AgoraCalc.EncodePlaced(var3_1)
	local var7_1 = AgoraCalc.EncodeLayer(var4_1)
	local var8_1 = AgoraCalc.EncodeLayer(var5_1)
	local var9_1 = {
		id = var1_1,
		name = var2_1,
		placed_data = {
			placed_list = var6_1,
			floor_data = var7_1,
			tile_data = var8_1
		}
	}

	pg.ConnectionMgr.GetInstance():Send(21317, {
		theme = var9_1
	}, 21318, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(IslandProxy):GetIsland():GetAgoraAgency():AddTheme(IslandTheme.New(var9_1))
			arg0_1:sendNotification(GAME.ISLAND_SAVE_AGORA_THEME_DONE)
		end
	end)
end

return var0_0
