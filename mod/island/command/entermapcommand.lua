local var0_0 = class("EnterMapCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(21213, {
		island_id = var0_1.islandId,
		map_id = var0_1.mapId
	}, 21214, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(IslandProxy):SetSyncObjInitData(arg0_2.object_list)

			local var0_2 = arg0_1:IsSelf(var0_1.islandId)
			local var1_2 = var0_2 and getProxy(IslandProxy):GetIsland() or getProxy(IslandProxy):GetSharedIsland()

			var1_2:GetWildCollectAgency():InitGatherData(arg0_2, var0_1.islandId, var0_2)
			var1_2:GetVisitorAgency():InitMapVisitorList(var0_1.mapId)
			existCall(var1_1)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

function var0_0.IsSelf(arg0_3, arg1_3)
	return getProxy(PlayerProxy):getRawData().id == arg1_3
end

return var0_0
