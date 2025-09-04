local var0_0 = class("IslandSaveAgoraCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.list
	local var2_1 = var0_1.floorList
	local var3_1 = var0_1.tileList
	local var4_1 = getProxy(IslandProxy):GetIsland():GetAgoraAgency()
	local var5_1 = AgoraCalc.EncodeLayer(var2_1)
	local var6_1 = AgoraCalc.EncodeLayer(var3_1)
	local var7_1 = AgoraCalc.EncodePlaced(var1_1)
	local var8_1 = {
		placed_list = var7_1,
		floor_data = var5_1,
		tile_data = var6_1
	}

	pg.ConnectionMgr.GetInstance():Send(21307, {
		update_data = var8_1
	}, 21308, function(arg0_2)
		if arg0_2.result == 0 then
			var4_1:UpdatePlacedData(var8_1, true)
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_agora_save_success"))
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandAgoraSave())
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
